Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaDXJ3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:29:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbaDXIzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bart Van Assche <bvanassche@acm.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 146/182] ib_srpt: Use correct ib_sg_dma primitives
Date: Thu, 24 Apr 2014 09:51:11 +0100
Message-Id: <1398329507-5911-147-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit b076808051f2c80d38e03fb2f1294f525c7a446d upstream.

The code was incorrectly using sg_dma_address() and
sg_dma_len() instead of ib_sg_dma_address() and
ib_sg_dma_len().

This prevents srpt from functioning with the
Intel HCA and indeed will corrupt memory
badly.

Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Tested-by: Vinod Kumar <vinod.kumar@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6c923c7..56f2cf7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1078,6 +1078,7 @@ static void srpt_unmap_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 				 struct srpt_send_ioctx *ioctx)
 {
+	struct ib_device *dev = ch->sport->sdev->device;
 	struct se_cmd *cmd;
 	struct scatterlist *sg, *sg_orig;
 	int sg_cnt;
@@ -1124,7 +1125,7 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 
 	db = ioctx->rbufs;
 	tsize = cmd->data_length;
-	dma_len = sg_dma_len(&sg[0]);
+	dma_len = ib_sg_dma_len(dev, &sg[0]);
 	riu = ioctx->rdma_ius;
 
 	/*
@@ -1155,7 +1156,8 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 					++j;
 					if (j < count) {
 						sg = sg_next(sg);
-						dma_len = sg_dma_len(sg);
+						dma_len = ib_sg_dma_len(
+								dev, sg);
 					}
 				}
 			} else {
@@ -1192,8 +1194,8 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 	tsize = cmd->data_length;
 	riu = ioctx->rdma_ius;
 	sg = sg_orig;
-	dma_len = sg_dma_len(&sg[0]);
-	dma_addr = sg_dma_address(&sg[0]);
+	dma_len = ib_sg_dma_len(dev, &sg[0]);
+	dma_addr = ib_sg_dma_address(dev, &sg[0]);
 
 	/* this second loop is really mapped sg_addres to rdma_iu->ib_sge */
 	for (i = 0, j = 0;
@@ -1216,8 +1218,10 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 					++j;
 					if (j < count) {
 						sg = sg_next(sg);
-						dma_len = sg_dma_len(sg);
-						dma_addr = sg_dma_address(sg);
+						dma_len = ib_sg_dma_len(
+								dev, sg);
+						dma_addr = ib_sg_dma_address(
+								dev, sg);
 					}
 				}
 			} else {
-- 
1.9.1

