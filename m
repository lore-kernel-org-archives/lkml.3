Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaAXVPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 16:15:35 -0500
Received: from relay.parallels.com ([195.214.232.42]:50546 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbaAXVPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 16:15:34 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH] slab: fix wrong retval on kmem_cache_create_memcg error path
Date: Sat, 25 Jan 2014 01:15:26 +0400
Message-ID: <1390598126-4332-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>

On kmem_cache_create_memcg() error path we set 'err', but leave 's' (the
new cache ptr) undefined. The latter can be NULL if we could not
allocate the cache, or pointing to a freed area if we failed somewhere
later while trying to initialize it. Initially we checked 'err'
immediately before exiting the function and returned NULL if it was set
ignoring the value of 's':

    out_unlock:
        ...
        if (err) {
            ...
            return NULL;
        }
        return s;

Recently this check was, in fact, broken by commit f717eb3abb5e ("slab:
do not panic if we fail to create memcg cache"), which turned it to:

    out_unlock:
        ...
        if (err && !memcg) {
            ...
            return NULL;
        }
        return s;

As a result, if we are failing creating a cache for a memcg, we will
skip the check and return 's' that can contain crap. Let's fix it by
assuring that on error path there are always two conditions satisfied at
the same time, err != 0 and s == NULL, by explicitly zeroing 's' after
freeing it on error path.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
---
 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 8e40321..499b53c 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -249,7 +249,6 @@ out_unlock:
 				name, err);
 			dump_stack();
 		}
-		return NULL;
 	}
 	return s;
 
@@ -257,6 +256,7 @@ out_free_cache:
 	memcg_free_cache_params(s);
 	kfree(s->name);
 	kmem_cache_free(kmem_cache, s);
+	s = NULL;
 	goto out_unlock;
 }
 
-- 
1.7.10.4

