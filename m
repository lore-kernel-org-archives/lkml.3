Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbaBEUGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:06:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:55142 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaBEUGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:39 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 126/213] crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent data corruption
Date: Wed, 5 Feb 2014 15:01:21 -0500
Message-ID: <1391630568-49251-127-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 crypto/cryptd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index ef71318976c7..6e241640219d 100644
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
1.8.5.2

