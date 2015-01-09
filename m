Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbbAIRYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:24:48 -0500
Received: from sauhun.de ([89.238.76.85]:49556 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711AbbAIRWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:22:22 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Subject: [RFC 05/11] i2c: qup: make use of the new infrastructure for quirks
Date: Fri,  9 Jan 2015 18:21:35 +0100
Message-Id: <1420824103-24169-6-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-qup.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index 4dad23bdffbe..fdcbdab808e9 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -412,17 +412,6 @@ static int qup_i2c_read_one(struct qup_i2c_dev *qup, struct i2c_msg *msg)
 	unsigned long left;
 	int ret;
 
-	/*
-	 * The QUP block will issue a NACK and STOP on the bus when reaching
-	 * the end of the read, the length of the read is specified as one byte
-	 * which limits the possible read to 256 (QUP_READ_LIMIT) bytes.
-	 */
-	if (msg->len > QUP_READ_LIMIT) {
-		dev_err(qup->dev, "HW not capable of reads over %d bytes\n",
-			QUP_READ_LIMIT);
-		return -EINVAL;
-	}
-
 	qup->msg = msg;
 	qup->pos  = 0;
 
@@ -534,6 +523,15 @@ static const struct i2c_algorithm qup_i2c_algo = {
 	.functionality	= qup_i2c_func,
 };
 
+/*
+ * The QUP block will issue a NACK and STOP on the bus when reaching
+ * the end of the read, the length of the read is specified as one byte
+ * which limits the possible read to 256 (QUP_READ_LIMIT) bytes.
+ */
+static struct i2c_adapter_quirks qup_i2c_quirks = {
+	.max_read_len = QUP_READ_LIMIT,
+};
+
 static void qup_i2c_enable_clocks(struct qup_i2c_dev *qup)
 {
 	clk_prepare_enable(qup->clk);
@@ -670,6 +668,7 @@ static int qup_i2c_probe(struct platform_device *pdev)
 
 	i2c_set_adapdata(&qup->adap, qup);
 	qup->adap.algo = &qup_i2c_algo;
+	qup->adap.quirks = &qup_i2c_quirks;
 	qup->adap.dev.parent = qup->dev;
 	qup->adap.dev.of_node = pdev->dev.of_node;
 	strlcpy(qup->adap.name, "QUP I2C adapter", sizeof(qup->adap.name));
-- 
2.1.3

