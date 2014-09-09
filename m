Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaIIVZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:25:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaIIVZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:25:34 -0400
Date: Tue, 9 Sep 2014 23:25:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
Message-ID: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree() is happy to accept NULL pointer and does nothing in such case. 
It's reasonable to expect it to behave the same if ERR_PTR is passed to 
it.

Inspired by a9cfcd63e8d ("ext4: avoid trying to kfree an ERR_PTR 
pointer").

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 mm/slab.c | 2 +-
 mm/slob.c | 2 +-
 mm/slub.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index a467b30..1a256ac 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3612,7 +3612,7 @@ void kfree(const void *objp)
 
 	trace_kfree(_RET_IP_, objp);
 
-	if (unlikely(ZERO_OR_NULL_PTR(objp)))
+	if (unlikely(ZERO_OR_NULL_PTR(objp) || IS_ERR(objp)))
 		return;
 	local_irq_save(flags);
 	kfree_debugcheck(objp);
diff --git a/mm/slob.c b/mm/slob.c
index 21980e0..3abc42c 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -489,7 +489,7 @@ void kfree(const void *block)
 
 	trace_kfree(_RET_IP_, block);
 
-	if (unlikely(ZERO_OR_NULL_PTR(block)))
+	if (unlikely(ZERO_OR_NULL_PTR(block) || IS_ERR(objp)))
 		return;
 	kmemleak_free(block);
 
diff --git a/mm/slub.c b/mm/slub.c
index 3e8afcc..46d18ce 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3338,7 +3338,7 @@ void kfree(const void *x)
 
 	trace_kfree(_RET_IP_, x);
 
-	if (unlikely(ZERO_OR_NULL_PTR(x)))
+	if (unlikely(ZERO_OR_NULL_PTR(x) || IS_ERR(objp)))
 		return;
 
 	page = virt_to_head_page(x);

-- 
Jiri Kosina
SUSE Labs
