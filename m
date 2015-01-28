Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965295AbbA1EZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:25:58 -0500
Received: from mail.kernel.org ([198.145.29.136]:41263 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965279AbbA1EZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:54 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 161/177] srp-target: Retry when QP creation fails with ENOMEM
Date: Wed, 28 Jan 2015 12:10:19 +0800
Message-Id: <1422418236-12852-252-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit ab477c1ff5e0a744c072404bf7db51bfe1f05b6e upstream.

It is not guaranteed to that srp_sq_size is supported
by the HCA. So if we failed to create the QP with ENOMEM,
try with a smaller srp_sq_size. Keep it up until we hit
MIN_SRPT_SQ_SIZE, then fail the connection.

Reported-by: Mark Lehrer <lehrer@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index ff0b71a..6bd8e81 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2146,6 +2146,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	if (!qp_init)
 		goto out;
 
+retry:
 	ch->cq = ib_create_cq(sdev->device, srpt_completion, NULL, ch,
 			      ch->rq_size + srp_sq_size, 0);
 	if (IS_ERR(ch->cq)) {
@@ -2169,6 +2170,13 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
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

