Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbaKMKgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:36:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30669 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaKMKgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:36:21 -0500
Date: Thu, 13 Nov 2014 13:36:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 2/2 -next] mfd: dln2: a couple endian fixes
Message-ID: <20141113103607.GB17038@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse catches a couple endian bugs.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Not tested.

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index 3101e5e..babf7b6 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -437,6 +437,7 @@ static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
 	struct device *dev = &dln2->interface->dev;
 	const unsigned long timeout = DLN2_USB_TIMEOUT * HZ / 1000;
 	struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[handle];
+	int size;
 
 	spin_lock(&dln2->disconnect_lock);
 	if (!dln2->disconnect)
@@ -476,8 +477,9 @@ static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
 
 	/* if we got here we know that the response header has been checked */
 	rsp = rxc->urb->transfer_buffer;
+	size = le16_to_cpu(rsp->hdr.size);
 
-	if (rsp->hdr.size < sizeof(*rsp)) {
+	if (size < sizeof(*rsp)) {
 		ret = -EPROTO;
 		goto out_free_rx_slot;
 	}
@@ -494,8 +496,8 @@ static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
 		goto out_free_rx_slot;
 	}
 
-	if (*ibuf_len > rsp->hdr.size - sizeof(*rsp))
-		*ibuf_len = rsp->hdr.size - sizeof(*rsp);
+	if (*ibuf_len > size - sizeof(*rsp))
+		*ibuf_len = size - sizeof(*rsp);
 
 	memcpy(ibuf, rsp + 1, *ibuf_len);
 
