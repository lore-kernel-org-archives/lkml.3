Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaLOPHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:07:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38422 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaLOO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Moore <chris.moore@emulex.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 048/168] IB/isert: Adjust CQ size to HW limits
Date: Mon, 15 Dec 2014 14:25:02 +0000
Message-Id: <1418653622-21105-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 1e2c7ad50992..c83b77e4546f 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -228,12 +228,16 @@ isert_create_device_ib_res(struct isert_device *device)
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
 	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS &&
 	    dev_attr->device_cap_flags & IB_DEVICE_SIGNATURE_HANDOVER) {
@@ -275,7 +279,7 @@ isert_create_device_ib_res(struct isert_device *device)
 						isert_cq_rx_callback,
 						isert_cq_event_callback,
 						(void *)&cq_desc[i],
-						ISER_MAX_RX_CQ_LEN, i);
+						max_rx_cqe, i);
 		if (IS_ERR(device->dev_rx_cq[i])) {
 			ret = PTR_ERR(device->dev_rx_cq[i]);
 			device->dev_rx_cq[i] = NULL;
@@ -287,7 +291,7 @@ isert_create_device_ib_res(struct isert_device *device)
 						isert_cq_tx_callback,
 						isert_cq_event_callback,
 						(void *)&cq_desc[i],
-						ISER_MAX_TX_CQ_LEN, i);
+						max_tx_cqe, i);
 		if (IS_ERR(device->dev_tx_cq[i])) {
 			ret = PTR_ERR(device->dev_tx_cq[i]);
 			device->dev_tx_cq[i] = NULL;
-- 
2.1.3

