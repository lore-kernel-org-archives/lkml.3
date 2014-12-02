Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694AbaLBT00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:26:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46920 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933662AbaLBT0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Moore <chris.moore@emulex.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 117/121] IB/isert: Adjust CQ size to HW limits
Date: Tue,  2 Dec 2014 11:19:56 -0800
Message-Id: <1417548000-1794-118-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Moore <Chris.Moore@Emulex.Com>

commit b1a5ad006b34ded9dc7ec64988deba1b3ecad367 upstream.

isert has an issue of trying to create a CQ with more CQEs than are
supported by the hardware, that currently results in failures during
isert_device creation during first session login.

This is the isert version of the patch that Minh Tran submitted for
iser, and is simple a workaround required to function with existing
ocrdma hardware.

Signed-off-by: Chris Moore <chris.moore@emulex.com>
Reviewied-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 39e5824..5502c7f 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -223,12 +223,16 @@ isert_create_device_ib_res(struct isert_device *device)
 	struct isert_cq_desc *cq_desc;
 	struct ib_device_attr *dev_attr;
 	int ret = 0, i, j;
+	int max_rx_cqe, max_tx_cqe;
 
 	dev_attr = &device->dev_attr;
 	ret = isert_query_device(ib_dev, dev_attr);
 	if (ret)
 		return ret;
 
+	max_rx_cqe = min(ISER_MAX_RX_CQ_LEN, dev_attr->max_cqe);
+	max_tx_cqe = min(ISER_MAX_TX_CQ_LEN, dev_attr->max_cqe);
+
 	/* asign function handlers */
 	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
 		device->use_frwr = 1;
@@ -270,7 +274,7 @@ isert_create_device_ib_res(struct isert_device *device)
 						isert_cq_rx_callback,
 						isert_cq_event_callback,
 						(void *)&cq_desc[i],
-						ISER_MAX_RX_CQ_LEN, i);
+						max_rx_cqe, i);
 		if (IS_ERR(device->dev_rx_cq[i])) {
 			ret = PTR_ERR(device->dev_rx_cq[i]);
 			device->dev_rx_cq[i] = NULL;
@@ -282,7 +286,7 @@ isert_create_device_ib_res(struct isert_device *device)
 						isert_cq_tx_callback,
 						isert_cq_event_callback,
 						(void *)&cq_desc[i],
-						ISER_MAX_TX_CQ_LEN, i);
+						max_tx_cqe, i);
 		if (IS_ERR(device->dev_tx_cq[i])) {
 			ret = PTR_ERR(device->dev_tx_cq[i]);
 			device->dev_tx_cq[i] = NULL;
-- 
1.9.1

