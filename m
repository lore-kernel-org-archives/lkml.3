Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaBZPFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:05:47 -0500
Received: from relay.parallels.com ([195.214.232.42]:59776 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaBZPFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:05:46 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH -mm 12/12] slub: make sure all memcg caches have unique names on sysfs
Date: Wed, 26 Feb 2014 19:05:17 +0400
Message-ID: <c19e2143ba98d26f3898489bf6ab55ed3764c1a1.1393423762.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1393423762.git.vdavydov@parallels.com>
References: <cover.1393423762.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since memcg caches are now reparented on memcg offline, a memcg cache
can outlive its cgroup. If the memcg id is then reused for a new cgroup
with the same name, we can get cache name collision, which will result
in failures while trying to add a sysfs entry for a new cgroup's cache.
Let's fix this by appending the cache address to sysfs names of all
memcg caches so that they are guaranteed to have unique names.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
---
 mm/slub.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index d8b8659bfa64..cdeea794bba5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5234,7 +5234,18 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	}
 
 	s->kobj.kset = cache_kset(s);
-	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
+	/*
+	 * A memcg cache can outlive its cgroup. If the memcg id is then reused
+	 * for a new cgroup with the same name, we can get cache name
+	 * collision. To make sure all memcg caches have unique names on sysfs,
+	 * we append the cache address to its name.
+	 */
+	if (is_root_cache(s))
+		err = kobject_init_and_add(&s->kobj, &slab_ktype,
+					   NULL, "%s", name);
+	else
+		err = kobject_init_and_add(&s->kobj, &slab_ktype,
+					   NULL, "%s-%p", name, s);
 	if (err) {
 		kobject_put(&s->kobj);
 		return err;
-- 
1.7.10.4

