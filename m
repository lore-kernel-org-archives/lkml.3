Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaLEXTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:19:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbaLEW4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Lehrer <lehrer@gmail.com>, Bart Van Assche <bvanassche@acm.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 51/73] srp-target: Retry when QP creation fails with ENOMEM
Date: Fri,  5 Dec 2014 14:44:57 -0800
Message-Id: <20141205224435.467133069@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit ab477c1ff5e0a744c072404bf7db51bfe1f05b6e upstream.

It is not guaranteed to that srp_sq_size is supported
by the HCA. So if we failed to create the QP with ENOMEM,
try with a smaller srp_sq_size. Keep it up until we hit
MIN_SRPT_SQ_SIZE, then fail the connection.

Reported-by: Mark Lehrer <lehrer@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2091,6 +2091,7 @@ static int srpt_create_ch_ib(struct srpt
 	if (!qp_init)
 		goto out;
 
+retry:
 	ch->cq = ib_create_cq(sdev->device, srpt_completion, NULL, ch,
 			      ch->rq_size + srp_sq_size, 0);
 	if (IS_ERR(ch->cq)) {
@@ -2114,6 +2115,13 @@ static int srpt_create_ch_ib(struct srpt
 	ch->qp = ib_create_qp(sdev->pd, qp_init);
 	if (IS_ERR(ch->qp)) {
 		ret = PTR_ERR(ch->qp);
+		if (ret == -ENOMEM) {
+			srp_sq_size /= 2;
+			if (srp_sq_size >= MIN_SRPT_SQ_SIZE) {
+				ib_destroy_cq(ch->cq);
+				goto retry;
+			}
+		}
 		printk(KERN_ERR "failed to create_qp ret= %d\n", ret);
 		goto err_destroy_cq;
 	}


