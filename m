Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaHRJey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:34:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42733 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaHRJew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 060/137] slab_common: Do not check for duplicate slab names
Date: Mon, 18 Aug 2014 10:32:01 +0100
Message-Id: <1408354398-10226-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Lameter <cl@linux.com>

commit 3e374919b314f20e2a04f641ebc1093d758f66a4 upstream.

SLUB can alias multiple slab kmem_create_requests to one slab cache to save
memory and increase the cache hotness. As a result the name of the slab can be
stale. Only check the name for duplicates if we are in debug mode where we do
not merge multiple caches.

This fixes the following problem reported by Jonathan Brassow:

  The problem with kmem_cache* is this:

  *) Assume CONFIG_SLUB is set
  1) kmem_cache_create(name="foo-a")
  - creates new kmem_cache structure
  2) kmem_cache_create(name="foo-b")
  - If identical cache characteristics, it will be merged with the previously
    created cache associated with "foo-a".  The cache's refcount will be
    incremented and an alias will be created via sysfs_slab_alias().
  3) kmem_cache_destroy(<ptr>)
  - Attempting to destroy cache associated with "foo-a", but instead the
    refcount is simply decremented.  I don't even think the sysfs aliases are
    ever removed...
  4) kmem_cache_create(name="foo-a")
  - This FAILS because kmem_cache_sanity_check colides with the existing
    name ("foo-a") associated with the non-removed cache.

  This is a problem for RAID (specifically dm-raid) because the name used
  for the kmem_cache_create is ("raid%d-%p", level, mddev).  If the cache
  persists for long enough, the memory address of an old mddev will be
  reused for a new mddev - causing an identical formulation of the cache
  name.  Even though kmem_cache_destory had long ago been used to delete
  the old cache, the merging of caches has cause the name and cache of that
  old instance to be preserved and causes a colision (and thus failure) in
  kmem_cache_create().  I see this regularly in my testing.

Reported-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/slab_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 538bade6df7d..d43477196b22 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -55,6 +55,7 @@ static int kmem_cache_sanity_check(struct mem_cgroup *memcg, const char *name,
 			continue;
 		}
 
+#if !defined(CONFIG_SLUB) || !defined(CONFIG_SLUB_DEBUG_ON)
 		/*
 		 * For simplicity, we won't check this in the list of memcg
 		 * caches. We have control over memcg naming, and if there
@@ -68,6 +69,7 @@ static int kmem_cache_sanity_check(struct mem_cgroup *memcg, const char *name,
 			s = NULL;
 			return -EINVAL;
 		}
+#endif
 	}
 
 	WARN_ON(strchr(name, ' '));	/* It confuses parsers */
-- 
1.9.1

