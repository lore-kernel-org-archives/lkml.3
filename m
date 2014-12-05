Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaLEX3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:29:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaLEW4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Moore <chris.moore@emulex.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 21/73] IB/isert: Adjust CQ size to HW limits
Date: Fri,  5 Dec 2014 14:44:27 -0800
Message-Id: <20141205224434.571104661@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -220,12 +220,16 @@ isert_create_device_ib_res(struct isert_
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
 		device->use_fastreg = 1;
@@ -261,7 +265,7 @@ isert_create_device_ib_res(struct isert_
 						isert_cq_rx_callback,
 						isert_cq_event_callback,
 						(void *)&cq_desc[i],
-						ISER_MAX_RX_CQ_LEN, i);
+						max_rx_cqe, i);
 		if (IS_ERR(device->dev_rx_cq[i])) {
 			ret = PTR_ERR(device->dev_rx_cq[i]);
 			device->dev_rx_cq[i] = NULL;
@@ -273,7 +277,7 @@ isert_create_device_ib_res(struct isert_
 						isert_cq_tx_callback,
 						isert_cq_event_callback,
 						(void *)&cq_desc[i],
-						ISER_MAX_TX_CQ_LEN, i);
+						max_tx_cqe, i);
 		if (IS_ERR(device->dev_tx_cq[i])) {
 			ret = PTR_ERR(device->dev_tx_cq[i]);
 			device->dev_tx_cq[i] = NULL;


