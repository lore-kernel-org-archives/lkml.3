Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab3BCBWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:22:17 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49153 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3BCBWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:13 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 29/62] infiniband/ocrdma: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:30 -0800
Message-Id: <1359854463-2538-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Roland Dreier <roland@purestorage.com>
Cc: linux-rdma@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index c4e0131..48928c8 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -51,18 +51,6 @@ static DEFINE_IDR(ocrdma_dev_id);
 
 static union ib_gid ocrdma_zero_sgid;
 
-static int ocrdma_get_instance(void)
-{
-	int instance = 0;
-
-	/* Assign an unused number */
-	if (!idr_pre_get(&ocrdma_dev_id, GFP_KERNEL))
-		return -1;
-	if (idr_get_new(&ocrdma_dev_id, NULL, &instance))
-		return -1;
-	return instance;
-}
-
 void ocrdma_get_guid(struct ocrdma_dev *dev, u8 *guid)
 {
 	u8 mac_addr[6];
@@ -416,7 +404,7 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 		goto idr_err;
 
 	memcpy(&dev->nic_info, dev_info, sizeof(*dev_info));
-	dev->id = ocrdma_get_instance();
+	dev->id = idr_alloc(&ocrdma_dev_id, NULL, 0, 0, GFP_KERNEL);
 	if (dev->id < 0)
 		goto idr_err;
 
-- 
1.8.1

