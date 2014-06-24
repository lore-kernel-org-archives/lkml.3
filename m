Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaFXSB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:01:57 -0400
Received: from kanga.kvack.org ([205.233.56.17]:35017 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbaFXSBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:01:55 -0400
Date: Tue, 24 Jun 2014 14:01:54 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] aio: fix aio request leak when events are reaped by userspace
Message-ID: <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org>
References: <cover.1403632276.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1403632276.git.bcrl@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aio cleanups and optimizations by kmo that were merged into the 3.10
tree added a regression for userspace event reaping.  Specifically, the
reference counts are not decremented if the event is reaped in userspace,
leading to the application being unable to submit further aio requests.
This patch applies to 3.12+.  A separate backport is required for 3.10/3.11.
This issue was uncovered as part of CVE-2014-0206.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: stable@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
---
 fs/aio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 4f078c0..6a9c7e4 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1021,6 +1021,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
 	/* everything turned out well, dispose of the aiocb. */
 	kiocb_free(iocb);
+	put_reqs_available(ctx, 1);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -1100,8 +1101,6 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	flush_dcache_page(ctx->ring_pages[0]);
 
 	pr_debug("%li  h%u t%u\n", ret, head, tail);
-
-	put_reqs_available(ctx, ret);
 out:
 	mutex_unlock(&ctx->ring_lock);
 
-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
