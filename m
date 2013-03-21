Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508Ab3CUQor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:44:47 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59634 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934013Ab3CUQon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:44:43 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org
Cc: Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <koverstreet@google.com>,
        Josh Boyer <jwboyer@redhat.com>, Zach Brown <zab@redhat.com>
Subject: [PATCH 33/33] aio: fix kioctx not being freed after cancellation at exit time
Date: Thu, 21 Mar 2013 09:35:54 -0700
Message-Id: <1363883754-27966-34-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin LaHaise <bcrl@kvack.org>

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
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Zach Brown <zab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 4dbd240..d2c1a82 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -349,7 +349,9 @@ static void free_ioctx(struct kioctx *ctx)
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_available) < ctx->nr_events - 1) {
-		wait_event(ctx->wait, head != ctx->shadow_tail);
+		wait_event(ctx->wait,
+			   (head != ctx->shadow_tail) ||
+			   (atomic_read(&ctx->reqs_available) >= ctx->nr_events - 1));
 
 		avail = (head <= ctx->shadow_tail
 			 ? ctx->shadow_tail : ctx->nr_events) - head;
@@ -774,17 +776,6 @@ void batch_complete_aio(struct batch_complete *batch)
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
1.8.1.3

