Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaBTHWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:22:39 -0500
Received: from relay.parallels.com ([195.214.232.42]:45679 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaBTHWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:22:23 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <mhocko@suse.cz>, <akpm@linux-foundation.org>
CC: <rientjes@google.com>, <penberg@kernel.org>, <cl@linux.com>,
        <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH -mm v3 7/7] slub: rework sysfs layout for memcg caches
Date: Thu, 20 Feb 2014 11:22:09 +0400
Message-ID: <1b08ce85e8e4e85856784732217db9dff4172e25.1392879001.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1392879001.git.vdavydov@parallels.com>
References: <cover.1392879001.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we try to arrange sysfs entries for memcg caches in the same
manner as for global caches. Apart from turning /sys/kernel/slab into a
mess when there are a lot of kmem-active memcgs created, it actually
does not work properly - we won't create more than one link to a memcg
cache in case its parent is merged with another cache. For instance, if
A is a root cache merged with another root cache B, we will have the
following sysfs setup:

  X
  A -> X
  B -> X

where X is some unique id (see create_unique_id()). Now if memcgs M and
N start to allocate from cache A (or B, which is the same), we will get:

  X
  X:M
  X:N
  A -> X
  B -> X
  A:M -> X:M
  A:N -> X:N

Since B is an alias for A, we won't get entries B:M and B:N, which is
confusing.

It is more logical to have entries for memcg caches under the
corresponding root cache's sysfs directory. This would allow us to keep
sysfs layout clean, and avoid such inconsistencies like one described
above.

This patch does the trick. It creates a "cgroup" kset in each root cache
kobject to keep its children caches there.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/slub_def.h |    3 +++
 mm/slub.c                |   26 +++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index f56bfa9e4526..f2f7398848cf 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -87,6 +87,9 @@ struct kmem_cache {
 #ifdef CONFIG_MEMCG_KMEM
 	struct memcg_cache_params *memcg_params;
 	int max_attr_size; /* for propagation, maximum size of a stored attr */
+#ifdef CONFIG_SYSFS
+	struct kset *memcg_kset;
+#endif
 #endif
 
 #ifdef CONFIG_NUMA
diff --git a/mm/slub.c b/mm/slub.c
index cac2ff7fd68c..4a10126fec3a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5138,6 +5138,15 @@ static const struct kset_uevent_ops slab_uevent_ops = {
 
 static struct kset *slab_kset;
 
+static inline struct kset *cache_kset(struct kmem_cache *s)
+{
+#ifdef CONFIG_MEMCG_KMEM
+	if (!is_root_cache(s))
+		return s->memcg_params->root_cache->memcg_kset;
+#endif
+	return slab_kset;
+}
+
 #define ID_STR_LENGTH 64
 
 /* Create a unique string id for a slab cache:
@@ -5203,7 +5212,7 @@ static int sysfs_slab_add(struct kmem_cache *s)
 		name = create_unique_id(s);
 	}
 
-	s->kobj.kset = slab_kset;
+	s->kobj.kset = cache_kset(s);
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
 	if (err) {
 		kobject_put(&s->kobj);
@@ -5216,6 +5225,18 @@ static int sysfs_slab_add(struct kmem_cache *s)
 		kobject_put(&s->kobj);
 		return err;
 	}
+
+#ifdef CONFIG_MEMCG_KMEM
+	if (is_root_cache(s)) {
+		s->memcg_kset = kset_create_and_add("cgroup", NULL, &s->kobj);
+		if (!s->memcg_kset) {
+			kobject_del(&s->kobj);
+			kobject_put(&s->kobj);
+			return -ENOMEM;
+		}
+	}
+#endif
+
 	kobject_uevent(&s->kobj, KOBJ_ADD);
 	if (!unmergeable) {
 		/* Setup first alias */
@@ -5234,6 +5255,9 @@ static void sysfs_slab_remove(struct kmem_cache *s)
 		 */
 		return;
 
+#ifdef CONFIG_MEMCG_KMEM
+	kset_unregister(s->memcg_kset);
+#endif
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
 	kobject_put(&s->kobj);
-- 
1.7.10.4

