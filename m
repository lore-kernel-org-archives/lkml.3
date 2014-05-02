Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaEBNnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:43:17 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52188 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751995AbaEBNlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:41:49 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/6] mm: Update the kmemleak stack trace for mempool allocations
Date: Fri,  2 May 2014 14:41:08 +0100
Message-Id: <1399038070-1540-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com>
References: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When mempool_alloc() returns an existing pool object, kmemleak_alloc()
is no longer called and the stack trace corresponds to the original
object allocation. This patch updates the kmemleak allocation stack
trace for such objects to make it more useful for debugging.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/mempool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/mempool.c b/mm/mempool.c
index 905434f18c97..e7c4be024f1a 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -10,6 +10,7 @@
 
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/kmemleak.h>
 #include <linux/export.h>
 #include <linux/mempool.h>
 #include <linux/blkdev.h>
@@ -220,6 +221,11 @@ repeat_alloc:
 		spin_unlock_irqrestore(&pool->lock, flags);
 		/* paired with rmb in mempool_free(), read comment there */
 		smp_wmb();
+		/*
+		 * Update the allocation stack trace as this is more useful
+		 * for debugging.
+		 */
+		kmemleak_update_trace(element);
 		return element;
 	}
 
