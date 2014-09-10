Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaIJOYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:24:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbaIJOYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:24:41 -0400
Date: Wed, 10 Sep 2014 16:24:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
In-Reply-To: <20140910140759.GC31903@thunk.org>
Message-ID: <alpine.LNX.2.00.1409101613500.5523@pobox.suse.cz>
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz> <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org> <alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz> <20140910140759.GC31903@thunk.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Theodore Ts'o wrote:

> So I wouldn't be so sure that we don't have these sorts of bugs hiding
> somewhere; and it's extremely easy for them to sneak in.  That being
> said, I'm not in favor of making changes to kfree; I'd much rather
> depending on better testing and static checkers to fix them, since
> kfree *is* a hot path.

I of course have no objections to this check being added to whatever 
static checker, that would be very welcome improvement.

Still, I believe that kernel shouldn't be just ignoring kfree(ERR_PTR) 
happening. Would something like the below be more acceptable?



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers

Freeing if ERR_PTR is not covered by ZERO_OR_NULL_PTR() check already
present in kfree(), but it happens in the wild and has disastrous effects.

Issue a warning and don't proceed trying to free the memory if
CONFIG_DEBUG_SLAB is set.

Inspired by a9cfcd63e8d ("ext4: avoid trying to kfree an ERR_PTR pointer").

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 mm/slab.c | 6 ++++++
 mm/slob.c | 7 ++++++-
 mm/slub.c | 7 ++++++-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index a467b30..6f49d6b 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3612,6 +3612,12 @@ void kfree(const void *objp)
 
 	trace_kfree(_RET_IP_, objp);
 
+#ifdef CONFIG_DEBUG_SLAB
+	if (unlikely(IS_ERR(objp))) {
+			WARN(1, "trying to free ERR_PTR\n");
+			return;
+	}
+#endif
 	if (unlikely(ZERO_OR_NULL_PTR(objp)))
 		return;
 	local_irq_save(flags);
diff --git a/mm/slob.c b/mm/slob.c
index 21980e0..66422a0 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -488,7 +488,12 @@ void kfree(const void *block)
 	struct page *sp;
 
 	trace_kfree(_RET_IP_, block);
-
+#ifdef CONFIG_DEBUG_SLAB
+	if (unlikely(IS_ERR(block))) {
+		WARN(1, "trying to free ERR_PTR\n");
+		return;
+	}
+#endif
 	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
 	kmemleak_free(block);
diff --git a/mm/slub.c b/mm/slub.c
index 3e8afcc..21155ae 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3337,7 +3337,12 @@ void kfree(const void *x)
 	void *object = (void *)x;
 
 	trace_kfree(_RET_IP_, x);
-
+#ifdef CONFIG_DEBUG_SLAB
+	if (unlikely(IS_ERR(x))) {
+		WARN(1, "trying to free ERR_PTR\n");
+		return;
+	}
+#endif
 	if (unlikely(ZERO_OR_NULL_PTR(x)))
 		return;
 

-- 
Jiri Kosina
SUSE Labs
