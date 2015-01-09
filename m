Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbbAIR0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:26:17 -0500
Received: from sauhun.de ([89.238.76.85]:49553 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486AbbAIRWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:22:20 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Subject: [RFC 04/11] i2c: opal: make use of the new infrastructure for quirks
Date: Fri,  9 Jan 2015 18:21:34 +0100
Message-Id: <1420824103-24169-5-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-opal.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-opal.c b/drivers/i2c/busses/i2c-opal.c
index 16f90b1a7508..f463eae44bf2 100644
--- a/drivers/i2c/busses/i2c-opal.c
+++ b/drivers/i2c/busses/i2c-opal.c
@@ -104,17 +104,6 @@ static int i2c_opal_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 		req.buffer_ra = cpu_to_be64(__pa(msgs[0].buf));
 		break;
 	case 2:
-		/* For two messages, we basically support only simple
-		 * smbus transactions of a write plus a read. We might
-		 * want to allow also two writes but we'd have to bounce
-		 * the data into a single buffer.
-		 */
-		if ((msgs[0].flags & I2C_M_RD) || !(msgs[1].flags & I2C_M_RD))
-			return -EOPNOTSUPP;
-		if (msgs[0].len > 4)
-			return -EOPNOTSUPP;
-		if (msgs[0].addr != msgs[1].addr)
-			return -EOPNOTSUPP;
 		req.type = OPAL_I2C_SM_READ;
 		req.addr = cpu_to_be16(msgs[0].addr);
 		req.subaddr_sz = msgs[0].len;
@@ -210,6 +199,16 @@ static const struct i2c_algorithm i2c_opal_algo = {
 	.functionality	= i2c_opal_func,
 };
 
+/* For two messages, we basically support only simple
+ * smbus transactions of a write plus a read. We might
+ * want to allow also two writes but we'd have to bounce
+ * the data into a single buffer.
+ */
+static struct i2c_adapter_quirks i2c_opal_quirks = {
+	.flags = I2C_ADAPTER_QUIRK_COMB_WRITE_THEN_READ,
+	.max_comb_write_len = 4,
+};
+
 static int i2c_opal_probe(struct platform_device *pdev)
 {
 	struct i2c_adapter	*adapter;
@@ -232,6 +231,7 @@ static int i2c_opal_probe(struct platform_device *pdev)
 
 	adapter->algo = &i2c_opal_algo;
 	adapter->algo_data = (void *)(unsigned long)opal_id;
+	adapter->quirks = &i2c_opal_quirks;
 	adapter->dev.parent = &pdev->dev;
 	adapter->dev.of_node = of_node_get(pdev->dev.of_node);
 	pname = of_get_property(pdev->dev.of_node, "ibm,port-name", NULL);
-- 
2.1.3

