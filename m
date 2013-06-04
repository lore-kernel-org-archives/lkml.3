Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3FDXLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:11:55 -0400
Received: from 1wt.eu ([62.212.114.60]:35482 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab3FDWm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:27 -0400
Message-Id: <20130604172133.745672632@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 083/184] crypto: cryptd - disable softirqs in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 cryptd_queue_worker to prevent data corruption

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

commit 9efade1b3e981f5064f9db9ca971b4dc7557ae42 upstream.

cryptd_queue_worker attempts to prevent simultaneous accesses to crypto
workqueue by cryptd_enqueue_request using preempt_disable/preempt_enable.
However cryptd_enqueue_request might be called from softirq context,
so add local_bh_disable/local_bh_enable to prevent data corruption and
panics.

Bug report at http://marc.info/?l=linux-crypto-vger&m=134858649616319&w=2

v2:
 - Disable software interrupts instead of hardware interrupts

Reported-by: Gurucharan Shetty <gurucharan.shetty@gmail.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 crypto/cryptd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 3533582..9e1bf69 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -116,13 +116,18 @@ static void cryptd_queue_worker(struct work_struct *work)
 	struct crypto_async_request *req, *backlog;
 
 	cpu_queue = container_of(work, struct cryptd_cpu_queue, work);
-	/* Only handle one request at a time to avoid hogging crypto
-	 * workqueue. preempt_disable/enable is used to prevent
-	 * being preempted by cryptd_enqueue_request() */
+	/*
+	 * Only handle one request at a time to avoid hogging crypto workqueue.
+	 * preempt_disable/enable is used to prevent being preempted by
+	 * cryptd_enqueue_request(). local_bh_disable/enable is used to prevent
+	 * cryptd_enqueue_request() being accessed from software interrupts.
+	 */
+	local_bh_disable();
 	preempt_disable();
 	backlog = crypto_get_backlog(&cpu_queue->queue);
 	req = crypto_dequeue_request(&cpu_queue->queue);
 	preempt_enable();
+	local_bh_enable();
 
 	if (!req)
 		return;
-- 
1.7.12.2.21.g234cd45.dirty



