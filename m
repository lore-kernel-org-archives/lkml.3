Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3KOWFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:05:41 -0500
Received: from mout.gmx.net ([212.227.17.22]:50015 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab3KOWFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:05:33 -0500
Date: Fri, 15 Nov 2013 23:05:29 +0100
From: Helge Deller <deller@gmx.de>
To: Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] aio: fix D-cache aliasing issues
Message-ID: <20131115220529.GA3160@ls3530.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:QEGQpSHiQu672/idkoFpa5IuyTANU+SSrUpebIYpu0uTXCvp8q2
 KxPDQ04PzO/tGNeIpbAVbTTeIT7vFy7mW8GwM8/qTytyvgzh6N1iGS3nv7qyvBafZa9gIx7
 in9Ws/AbyDhVnkcBdY6DP6/SEDG7eES2dh8klLxlzHhgWBAzJTNmYP2cS64uGJ0MxF4LdFN
 tskjP5DgQwc0vlGD71JZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a user page mapping is released via kunmap*() functions, the D-cache needs
to be flushed via flush_dcache_page() to avoid D-cache aliasing issues.

This patch fixes aio on the parisc platform (and probably others).

Signed-off-by: Helge Deller <deller@gmx.de>
To: Benjamin LaHaise <bcrl@kvack.org>
To: linux-aio@kvack.org
Cc: stable@vger.kernel.org    # 3.12+

diff --git a/fs/aio.c b/fs/aio.c
index 823efcb..2181821 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -514,6 +514,7 @@ static void free_ioctx(struct work_struct *work)
 		atomic_add(avail, &ctx->reqs_available);
 		ring->head = ring->tail;
 		kunmap_atomic(ring);
+		flush_dcache_page(ctx->ring_pages[0]);
 
 		if (atomic_read(&ctx->reqs_available) >= ctx->nr_events - 1)
 			break;
@@ -568,6 +569,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 					ring = kmap_atomic(ctx->ring_pages[0]);
 					ring->id = ctx->id;
 					kunmap_atomic(ring);
+					flush_dcache_page(ctx->ring_pages[0]);
 					return 0;
 				}
 
@@ -1032,6 +1034,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	head = ring->head;
 	tail = ring->tail;
 	kunmap_atomic(ring);
+	flush_dcache_page(ctx->ring_pages[0]);
 
 	pr_debug("h%u t%u m%u\n", head, tail, ctx->nr_events);
 

