Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030616AbaGCJZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:25:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52703 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030596AbaGCJZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 194/198] aio: fix aio request leak when events are reaped by userspace
Date: Thu,  3 Jul 2014 10:20:37 +0100
Message-Id: <1404379241-8590-195-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin LaHaise <bcrl@kvack.org>

commit f8567a3845ac05bb28f3c1b478ef752762bd39ef upstream.

The aio cleanups and optimizations by kmo that were merged into the 3.10
tree added a regression for userspace event reaping.  Specifically, the
reference counts are not decremented if the event is reaped in userspace,
leading to the application being unable to submit further aio requests.
This patch applies to 3.12+.  A separate backport is required for 3.10/3.11.
This issue was uncovered as part of CVE-2014-0206.

[jmoyer@redhat.com: backported to 3.10]
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/aio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 975a5d5810a9..48f02745b876 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -312,7 +312,6 @@ static void free_ioctx(struct kioctx *ctx)
 
 		avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
 
-		atomic_sub(avail, &ctx->reqs_active);
 		head += avail;
 		head %= ctx->nr_events;
 	}
@@ -680,6 +679,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	aio_put_req(iocb);
+	atomic_dec(&ctx->reqs_active);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -757,8 +757,6 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	flush_dcache_page(ctx->ring_pages[0]);
 
 	pr_debug("%li  h%u t%u\n", ret, head, ctx->tail);
-
-	atomic_sub(ret, &ctx->reqs_active);
 out:
 	mutex_unlock(&ctx->ring_lock);
 
-- 
1.9.1

