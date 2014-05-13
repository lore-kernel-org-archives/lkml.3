Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbaEMJza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:55:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60853 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760088AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 072/182] ib_srpt: Use correct ib_sg_dma primitives
Date: Tue, 13 May 2014 11:27:04 +0200
Message-Id: <e9bca980e0f85decd1322294394efadfc211cb84.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6c923c7039a1..56f2cf790779 100644
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
1.9.3

