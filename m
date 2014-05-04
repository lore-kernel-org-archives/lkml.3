Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaEDPsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:48:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbaEDPm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Vinod Kumar <vinod.kumar@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.4 25/43] ib_srpt: Use correct ib_sg_dma primitives
Date: Sun,  4 May 2014 11:42:19 -0400
Message-Id: <20140504154227.688367474@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1078,6 +1078,7 @@ static void srpt_unmap_sg_to_ib_sge(stru
 static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 				 struct srpt_send_ioctx *ioctx)
 {
+	struct ib_device *dev = ch->sport->sdev->device;
 	struct se_cmd *cmd;
 	struct scatterlist *sg, *sg_orig;
 	int sg_cnt;
@@ -1125,7 +1126,7 @@ static int srpt_map_sg_to_ib_sge(struct
 
 	db = ioctx->rbufs;
 	tsize = cmd->data_length;
-	dma_len = sg_dma_len(&sg[0]);
+	dma_len = ib_sg_dma_len(dev, &sg[0]);
 	riu = ioctx->rdma_ius;
 
 	/*
@@ -1156,7 +1157,8 @@ static int srpt_map_sg_to_ib_sge(struct
 					++j;
 					if (j < count) {
 						sg = sg_next(sg);
-						dma_len = sg_dma_len(sg);
+						dma_len = ib_sg_dma_len(
+								dev, sg);
 					}
 				}
 			} else {
@@ -1193,8 +1195,8 @@ static int srpt_map_sg_to_ib_sge(struct
 	tsize = cmd->data_length;
 	riu = ioctx->rdma_ius;
 	sg = sg_orig;
-	dma_len = sg_dma_len(&sg[0]);
-	dma_addr = sg_dma_address(&sg[0]);
+	dma_len = ib_sg_dma_len(dev, &sg[0]);
+	dma_addr = ib_sg_dma_address(dev, &sg[0]);
 
 	/* this second loop is really mapped sg_addres to rdma_iu->ib_sge */
 	for (i = 0, j = 0;
@@ -1217,8 +1219,10 @@ static int srpt_map_sg_to_ib_sge(struct
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


