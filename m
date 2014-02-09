Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaBIK4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 05:56:21 -0500
Received: from relay.parallels.com ([195.214.232.42]:51664 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaBIK4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 05:56:20 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <gregkh@linuxfoundation.org>, <cl@linux-foundation.org>
CC: <penberg@kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH 2/2] slub: do not drop slab_mutex for sysfs_slab_add
Date: Sun, 9 Feb 2014 14:56:16 +0400
Message-ID: <ba4769896e7b5702679e4d7a7ab53dd5aa370e74.1391942582.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <ca22d856315916d3e8c74666da7079b9ae42e646.1391942582.git.vdavydov@parallels.com>
References: <ca22d856315916d3e8c74666da7079b9ae42e646.1391942582.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.24.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We release the slab_mutex while calling sysfs_slab_add from
__kmem_cache_create since commit 66c4c35c6bc5, because kobject_uevent
called by sysfs_slab_add might block waiting for the usermode helper to
exec, which would result in a deadlock if we took the slab_mutex while
executing it.

However, apart from complicating synchronization rules, releasing the
slab_mutex on kmem cache creation can result in a kmemcg-related race.
The point is that we check if the memcg cache exists before going to
__kmem_cache_create, but register the new cache in memcg subsys after
it. Since we can drop the mutex there, several threads can see that the
memcg cache does not exist and proceed to creating it, which is wrong.

Fortunately, recently kobject_uevent was patched to call the usermode
helper with the UMH_NO_WAIT flag, making the deadlock impossible.
Therefore there is no point in releasing the slab_mutex while calling
sysfs_slab_add, so let's simplify kmem_cache_create synchronization and
fix the kmemcg-race mentioned above by holding the slab_mutex during the
whole cache creation path.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slub.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 3d3a8a7a0f8c..0625fed32ce9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3231,8 +3231,9 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 
 	if (!rc) {
 		/*
-		 * We do the same lock strategy around sysfs_slab_add, see
-		 * __kmem_cache_create. Because this is pretty much the last
+		 * Since slab_attr_store may take the slab_mutex, we should
+		 * release the lock while removing the sysfs entry in order to
+		 * avoid a deadlock. Because this is pretty much the last
 		 * operation we do and the lock will be released shortly after
 		 * that in slab_common.c, we could just move sysfs_slab_remove
 		 * to a later point in common code. We should do that when we
@@ -3772,10 +3773,7 @@ int __kmem_cache_create(struct kmem_cache *s, unsigned long flags)
 		return 0;
 
 	memcg_propagate_slab_attrs(s);
-	mutex_unlock(&slab_mutex);
 	err = sysfs_slab_add(s);
-	mutex_lock(&slab_mutex);
-
 	if (err)
 		kmem_cache_close(s);
 
-- 
1.7.10.4

