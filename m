Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492Ab3BMQOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:14:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:59793 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934460Ab3BMQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:14:11 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 08/12] FIX [1/2] slub: Do not dereference NULL pointer in node_match
Date: Wed, 13 Feb 2013 17:13:47 +0100
Message-Id: <1360772031-27186-9-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360772031-27186-1-git-send-email-bigeasy@linutronix.de>
References: <1360772031-27186-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

The variables accessed in slab_alloc are volatile and therefore
the page pointer passed to node_match can be NULL. The processing
of data in slab_alloc is tentative until either the cmpxhchg
succeeds or the __slab_alloc slowpath is invoked. Both are
able to perform the same allocation from the freelist.

Check for the NULL pointer in node_match.

A false positive will lead to a retry of the loop in __slab_alloc.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bigeasy@linutronix: replace page with c->page]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 71de9b5..fbf6810 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2058,7 +2058,7 @@ static void flush_all(struct kmem_cache *s)
 static inline int node_match(struct kmem_cache_cpu *c, int node)
 {
 #ifdef CONFIG_NUMA
-	if (node != NUMA_NO_NODE && c->node != node)
+	if (!c->page || (node != NUMA_NO_NODE && c->node != node))
 		return 0;
 #endif
 	return 1;
-- 
1.7.10.4

