Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaLFPSJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:18:09 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47733 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752178AbaLFPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Moore <Chris.Moore@Emulex.Com>,
        Chris Moore <chris.moore@Emulex.Com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 21/66] IB/isert: Adjust CQ size to HW limits
Date: Sat,  6 Dec 2014 16:07:13 +0100
Message-Id: <a202e873db134652f98074849d2299a01d390aa1.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Moore <Chris.Moore@Emulex.Com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 4c2b42bf6cde..7db40f85eeff 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -219,12 +219,16 @@ isert_create_device_ib_res(struct isert_device *device)
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
@@ -266,7 +270,7 @@ isert_create_device_ib_res(struct isert_device *device)
 						isert_cq_rx_callback,
 						isert_cq_event_callback,
 						(void *)&cq_desc[i],
-						ISER_MAX_RX_CQ_LEN, i);
+						max_rx_cqe, i);
 		if (IS_ERR(device->dev_rx_cq[i])) {
 			ret = PTR_ERR(device->dev_rx_cq[i]);
 			device->dev_rx_cq[i] = NULL;
@@ -278,7 +282,7 @@ isert_create_device_ib_res(struct isert_device *device)
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

