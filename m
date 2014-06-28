Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbaF1Rxa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:53:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251AbaF1Rx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>
Subject: [PATCH 3.15 111/139] aio: fix aio request leak when events are reaped by userspace
Date: Sat, 28 Jun 2014 10:47:52 -0700
Message-Id: <20140628174610.481727437@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin LaHaise <bcrl@kvack.org>

commit f8567a3845ac05bb28f3c1b478ef752762bd39ef upstream.

The aio cleanups and optimizations by kmo that were merged into the 3.10
tree added a regression for userspace event reaping.  Specifically, the
reference counts are not decremented if the event is reaped in userspace,
leading to the application being unable to submit further aio requests.
This patch applies to 3.12+.  A separate backport is required for 3.10/3.11.
This issue was uncovered as part of CVE-2014-0206.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1021,6 +1021,7 @@ void aio_complete(struct kiocb *iocb, lo
 
 	/* everything turned out well, dispose of the aiocb. */
 	kiocb_free(iocb);
+	put_reqs_available(ctx, 1);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -1100,8 +1101,6 @@ static long aio_read_events_ring(struct
 	flush_dcache_page(ctx->ring_pages[0]);
 
 	pr_debug("%li  h%u t%u\n", ret, head, tail);
-
-	put_reqs_available(ctx, ret);
 out:
 	mutex_unlock(&ctx->ring_lock);
 


