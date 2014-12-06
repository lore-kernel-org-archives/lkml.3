Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaLFPLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:11:52 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47765 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752242AbaLFPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 50/66] srp-target: Retry when QP creation fails with ENOMEM
Date: Sat,  6 Dec 2014 16:07:42 +0100
Message-Id: <090ec5fef8c36ce8cac294eddaaacf1a1cb9e56e.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ab477c1ff5e0a744c072404bf7db51bfe1f05b6e upstream.

It is not guaranteed to that srp_sq_size is supported
by the HCA. So if we failed to create the QP with ENOMEM,
try with a smaller srp_sq_size. Keep it up until we hit
MIN_SRPT_SQ_SIZE, then fail the connection.

Reported-by: Mark Lehrer <lehrer@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 56f2cf790779..1ed08cc2e190 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2101,6 +2101,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	if (!qp_init)
 		goto out;
 
+retry:
 	ch->cq = ib_create_cq(sdev->device, srpt_completion, NULL, ch,
 			      ch->rq_size + srp_sq_size, 0);
 	if (IS_ERR(ch->cq)) {
@@ -2124,6 +2125,13 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
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
2.1.3

