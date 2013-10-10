Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3JJSaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:30:03 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:62552 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab3JJSaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:30:00 -0400
From: Matias Bjorling <m@bjorling.me>
To: willy@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        Matias Bjorling <m@bjorling.me>
Subject: [PATCH 1/2] NVMe: Refactor doorbell
Date: Thu, 10 Oct 2013 20:29:46 +0200
Message-Id: <1381429787-4146-2-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381429787-4146-1-git-send-email-m@bjorling.me>
References: <1381429787-4146-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The doorbell code is repeated various places. Refactor it into its own function
for clarity.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 drivers/block/nvme-core.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index da52092..1e940e8 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -242,6 +242,13 @@ void put_nvmeq(struct nvme_queue *nvmeq)
 	put_cpu();
 }
 
+static inline void nvme_ring_doorbell(struct nvme_queue *nvmeq)
+{
+	if (++nvmeq->sq_tail == nvmeq->q_depth)
+		nvmeq->sq_tail = 0;
+	writel(nvmeq->sq_tail, nvmeq->q_db);
+}
+
 /**
  * nvme_submit_cmd() - Copy a command into a queue and ring the doorbell
  * @nvmeq: The queue to use
@@ -252,14 +259,10 @@ void put_nvmeq(struct nvme_queue *nvmeq)
 static int nvme_submit_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd)
 {
 	unsigned long flags;
-	u16 tail;
+
 	spin_lock_irqsave(&nvmeq->q_lock, flags);
-	tail = nvmeq->sq_tail;
-	memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
-	if (++tail == nvmeq->q_depth)
-		tail = 0;
-	writel(tail, nvmeq->q_db);
-	nvmeq->sq_tail = tail;
+	memcpy(&nvmeq->sq_cmds[nvmeq->sqtail], cmd, sizeof(*cmd));
+	nvme_ring_doorbell(nvmeq);
 	spin_unlock_irqrestore(&nvmeq->q_lock, flags);
 
 	return 0;
@@ -619,9 +622,7 @@ static int nvme_submit_discard(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	cmnd->dsm.nr = 0;
 	cmnd->dsm.attributes = cpu_to_le32(NVME_DSMGMT_AD);
 
-	if (++nvmeq->sq_tail == nvmeq->q_depth)
-		nvmeq->sq_tail = 0;
-	writel(nvmeq->sq_tail, nvmeq->q_db);
+	nvme_ring_doorbell(nvmeq);
 
 	return 0;
 }
@@ -636,9 +637,7 @@ static int nvme_submit_flush(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	cmnd->common.command_id = cmdid;
 	cmnd->common.nsid = cpu_to_le32(ns->ns_id);
 
-	if (++nvmeq->sq_tail == nvmeq->q_depth)
-		nvmeq->sq_tail = 0;
-	writel(nvmeq->sq_tail, nvmeq->q_db);
+	nvme_ring_doorbell(nvmeq);
 
 	return 0;
 }
@@ -729,9 +728,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	cmnd->rw.dsmgmt = cpu_to_le32(dsmgmt);
 
 	nvme_start_io_acct(bio);
-	if (++nvmeq->sq_tail == nvmeq->q_depth)
-		nvmeq->sq_tail = 0;
-	writel(nvmeq->sq_tail, nvmeq->q_db);
+	nvme_ring_doorbell(nvmeq);
 
 	return 0;
 
-- 
1.8.1.2

