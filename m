Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421Ab3BMRpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:45:54 -0500
Received: from kanga.kvack.org ([205.233.56.17]:51648 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760176Ab3BMRpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:45:53 -0500
Date: Wed, 13 Feb 2013 12:45:52 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <koverstreet@google.com>
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] aio: correct calculation of available events
Message-ID: <20130213174551.GA19958@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the number of available events in the ring buffer is calculated,
the avail calculation is incorrect when head == tail.  This is harmless
in aio_read_events_ring(), but in free_ioctx() leads to the subsequent
WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr).  Correct this.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 24ba228..dc52b0c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -337,7 +337,8 @@ static void free_ioctx(struct kioctx *ctx)
 	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
 		wait_event(ctx->wait, head != ctx->shadow_tail);
 
-		avail = (head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - head;
+		avail = (head <= ctx->shadow_tail ?
+			 ctx->shadow_tail : ctx->nr) - head;
 
 		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
@@ -884,7 +885,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 		goto out;
 
 	while (ret < nr) {
-		long avail = (head < ctx->shadow_tail
+		long avail = (head <= ctx->shadow_tail
 			      ? ctx->shadow_tail : ctx->nr) - head;
 		struct io_event *ev;
 		struct page *page;
-- 
1.7.4.1


-- 
"Thought is the essence of where you are now."
