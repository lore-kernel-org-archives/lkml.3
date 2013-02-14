Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161028Ab3BNWf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:35:58 -0500
Received: from kanga.kvack.org ([205.233.56.17]:58208 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759164Ab3BNWf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:35:57 -0500
Date: Thu, 14 Feb 2013 17:35:56 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <koverstreet@google.com>
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] aio: v2: fix kioctx not being freed after cancellation at exit time
Message-ID: <20130214223556.GA10806@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This v2 patch replaces both "aio: fix kioctx not being freed after
cancellation at exit time" and "aio: only suppress events from cancelled
kiocbs if free_ioctx() is in progress".  Kent's feedback is indeed correct.

The recent changes overhauling fs/aio.c introduced a bug that results in the
kioctx not being freed when outstanding kiocbs are cancelled at exit_aio()
time.  Specifically, a kiocb that is cancelled has its completion events
discarded by batch_complete_aio(), which then fails to wake up the process
stuck in free_ioctx().  Fix this by removing the event suppression in
batch_complete_aio() and modify the wait_event() condition in free_ioctx()
appropriately.

This patch was tested with the cancel operation in the thread based code
posted yesterday.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index dc52b0c..6ea766c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -335,7 +335,9 @@ static void free_ioctx(struct kioctx *ctx)
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
-		wait_event(ctx->wait, head != ctx->shadow_tail);
+		wait_event(ctx->wait,
+			   (head != ctx->shadow_tail) ||
+			   (atomic_read(&ctx->reqs_available) >= ctr->nr));
 
 		avail = (head <= ctx->shadow_tail ?
 			 ctx->shadow_tail : ctx->nr) - head;
@@ -747,17 +749,6 @@ void batch_complete_aio(struct batch_complete *batch)
 			n = rb_parent(n);
 		}
 
-		if (unlikely(xchg(&req->ki_cancel,
-				  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
-			/*
-			 * Can't use the percpu reqs_available here - could race
-			 * with free_ioctx()
-			 */
-			atomic_inc(&req->ki_ctx->reqs_available);
-			aio_put_req(req);
-			continue;
-		}
-
 		if (unlikely(req->ki_eventfd != eventfd)) {
 			if (eventfd) {
 				/* Make event visible */
-- 
1.7.4.1


-- 
"Thought is the essence of where you are now."
