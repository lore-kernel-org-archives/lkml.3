Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbaLBTX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:23:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46720 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbaLBTXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:23:54 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bart Van Assche <bvanassche@acm.org>, Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 092/121] srp-target: Retry when QP creation fails with ENOMEM
Date: Tue,  2 Dec 2014 11:19:31 -0800
Message-Id: <1417548000-1794-93-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index b4884ae..97309e4 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2091,6 +2091,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	if (!qp_init)
 		goto out;
 
+retry:
 	ch->cq = ib_create_cq(sdev->device, srpt_completion, NULL, ch,
 			      ch->rq_size + srp_sq_size, 0);
 	if (IS_ERR(ch->cq)) {
@@ -2114,6 +2115,13 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
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
-- 
1.9.1

