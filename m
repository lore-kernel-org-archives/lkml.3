Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979Ab3BMVwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:52:17 -0500
Received: from kanga.kvack.org ([205.233.56.17]:53950 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760837Ab3BMVwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:52:15 -0500
Date: Wed, 13 Feb 2013 16:52:14 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <koverstreet@google.com>
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] aio: only suppress events from cancelled kiocbs if free_ioctx() is in progress
Message-ID: <20130213215214.GA24582@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The io_cancel() syscall allows for cancellation of iocbs in flight to
generate a completion event.  The current behaviour of batch_complete_aio()
is to suppress all completion events.  Some types of asynchronous operations
cannot be cancelled synchronously, and must generate a completion event at
some point after the io_cancel() syscall.  Instead, only suppress
completion events during kioctx teardown by free_ioctx().

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 46f9dd0..1bcb818 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -81,6 +81,7 @@ struct kioctx {
 
 	/* sys_io_setup currently limits this to an unsigned int */
 	unsigned		max_reqs;
+	unsigned		dead;
 
 	unsigned long		mmap_base;
 	unsigned long		mmap_size;
@@ -311,6 +312,7 @@ static void free_ioctx(struct kioctx *ctx)
 	struct kiocb *req;
 	unsigned cpu, head, avail;
 
+	ctx->dead = 1;
 	spin_lock_irq(&ctx->ctx_lock);
 
 	while (!list_empty(&ctx->active_reqs)) {
@@ -749,7 +751,9 @@ void batch_complete_aio(struct batch_complete *batch)
 			n = rb_parent(n);
 		}
 
-		if (unlikely(xchg(&req->ki_cancel,
+		/* Suppress cancelled events if free_ioctx() is in progress. */
+		if (unlikely(req->ki_ctx->dead &&
+			     xchg(&req->ki_cancel,
 				  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {
 			/*
 			 * Can't use the percpu reqs_available here - could race
-- 
1.7.4.1


-- 
"Thought is the essence of where you are now."
