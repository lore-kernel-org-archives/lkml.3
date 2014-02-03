Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaBCXoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:44:04 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52869 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaBCXoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:44:02 -0500
Date: Mon, 3 Feb 2014 15:44:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [patch for-3.14] mm, slub: list_lock may not be held in some
 circumstances
In-Reply-To: <20140203234105.GA10614@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1402031542280.7643@chino.kir.corp.google.com>
References: <52EFF658.2080001@lwfinger.net> <alpine.DEB.2.02.1402031236250.7898@chino.kir.corp.google.com> <52F0215B.5040209@lwfinger.net> <20140203234105.GA10614@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c65c1877bd68 ("slub: use lockdep_assert_held") incorrectly required 
that add_full() and remove_full() hold n->list_lock.  The lock is only 
taken when kmem_cache_debug(s), since that's the only time it actually 
does anything.

Require that the lock only be taken under such a condition.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1004,21 +1004,19 @@ static inline void slab_free_hook(struct kmem_cache *s, void *x)
 static void add_full(struct kmem_cache *s,
 	struct kmem_cache_node *n, struct page *page)
 {
-	lockdep_assert_held(&n->list_lock);
-
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
+	lockdep_assert_held(&n->list_lock);
 	list_add(&page->lru, &n->full);
 }
 
 static void remove_full(struct kmem_cache *s, struct kmem_cache_node *n, struct page *page)
 {
-	lockdep_assert_held(&n->list_lock);
-
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
+	lockdep_assert_held(&n->list_lock);
 	list_del(&page->lru);
 }
 
