Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab3FCWam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:30:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14464 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759613Ab3FCWaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:30:09 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ivTb1gIpj38A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1FE0iQJa9vwA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=Ku4giSwJSw0A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221203.009074193@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, <stable@kernel.org>
Subject: [63/65] i2c: designware: always clear interrupts before enabling them
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0063-i2c-designware-always-clear-interrupts-before-enabli.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 2a2d95e9d6d29e726cc294b65391917ed2e32bf4 ]

If the I2C bus is put to a low power state by an ACPI method it might pull
the SDA line low (as its power is removed). Once the bus is put to full
power state again, the SDA line is pulled back to high. This transition
looks like a STOP condition from the controller point-of-view which sets
STOP detected bit in its status register causing the driver to fail
subsequent transfers.

Fix this by always clearing all interrupts before we start a transfer.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/i2c/busses/i2c-designware-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 37b1221..534fc13 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -360,7 +360,8 @@ static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
 	/* Enable the adapter */
 	dw_writel(dev, 1, DW_IC_ENABLE);
 
-	/* Enable interrupts */
+	/* Clear and enable interrupts */
+	i2c_dw_clear_int(dev);
 	dw_writel(dev, DW_IC_INTR_DEFAULT_MASK, DW_IC_INTR_MASK);
 }
 
-- 
1.7.10.4


