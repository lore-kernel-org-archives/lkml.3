Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbaF1S75 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:59:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbaF1Rsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Mateusz Guzik <mguzik@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>
Subject: [PATCH 3.10 60/77] aio: fix aio request leak when events are reaped by userspace
Date: Sat, 28 Jun 2014 10:46:53 -0700
Message-Id: <20140628174524.718572909@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -310,7 +310,6 @@ static void free_ioctx(struct kioctx *ct
 
 		avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
 
-		atomic_sub(avail, &ctx->reqs_active);
 		head += avail;
 		head %= ctx->nr_events;
 	}
@@ -678,6 +677,7 @@ void aio_complete(struct kiocb *iocb, lo
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	aio_put_req(iocb);
+	atomic_dec(&ctx->reqs_active);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -755,8 +755,6 @@ static long aio_read_events_ring(struct
 	flush_dcache_page(ctx->ring_pages[0]);
 
 	pr_debug("%li  h%u t%u\n", ret, head, ctx->tail);
-
-	atomic_sub(ret, &ctx->reqs_active);
 out:
 	mutex_unlock(&ctx->ring_lock);
 


