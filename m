Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964877Ab3BMRqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:46:38 -0500
Received: from kanga.kvack.org ([205.233.56.17]:51698 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934405Ab3BMRqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:46:37 -0500
Date: Wed, 13 Feb 2013 12:46:36 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <koverstreet@google.com>
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] aio: fix kioctx not being freed after cancellation at exit time
Message-ID: <20130213174636.GA20008@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent changes overhauling fs/aio.c introduced a bug that results in the
kioctx not being freed when outstanding kiocbs are cancelled at exit_aio()
time.  Specifically, a kiocb that is cancelled has its completion events
discarded by batch_complete_aio(), which then fails to wake up the process
stuck in free_ioctx().  Fix this by adding a wake_up() in batch_complete_aio()
and modifying the wait_event() condition in free_ioctx() appropriately.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index dc52b0c..46f9dd0 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -335,7 +335,9 @@ static void free_ioctx(struct kioctx *ctx)
 	kunmap_atomic(ring);
 
 	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
-		wait_event(ctx->wait, head != ctx->shadow_tail);
+		wait_event(ctx->wait,
+			   (head != ctx->shadow_tail) ||
+			   (atomic_read(&ctx->reqs_available) != ctx->nr));
 
 		avail = (head <= ctx->shadow_tail ?
 			 ctx->shadow_tail : ctx->nr) - head;
@@ -754,6 +756,7 @@ void batch_complete_aio(struct batch_complete *batch)
 			 * with free_ioctx()
 			 */
 			atomic_inc(&req->ki_ctx->reqs_available);
+			wake_up(&req->ki_ctx->wait);
 			aio_put_req(req);
 			continue;
 		}
-- 
1.7.4.1


-- 
"Thought is the essence of where you are now."
