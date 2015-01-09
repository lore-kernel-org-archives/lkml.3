Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbbAIRW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:22:26 -0500
Received: from sauhun.de ([89.238.76.85]:49569 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456AbbAIRWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:22:24 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wolfram Sang <wsa@the-dreams.de>, Jochen Friedrich <jochen@scram.de>,
        linux-kernel@vger.kernel.org
Subject: [RFC 06/11] i2c: cpm: make use of the new infrastructure for quirks
Date: Fri,  9 Jan 2015 18:21:36 +0100
Message-Id: <1420824103-24169-7-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-cpm.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
index 2d466538b2e2..714bdc837769 100644
--- a/drivers/i2c/busses/i2c-cpm.c
+++ b/drivers/i2c/busses/i2c-cpm.c
@@ -308,22 +308,12 @@ static int cpm_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	struct i2c_reg __iomem *i2c_reg = cpm->i2c_reg;
 	struct i2c_ram __iomem *i2c_ram = cpm->i2c_ram;
 	struct i2c_msg *pmsg;
-	int ret, i;
+	int ret;
 	int tptr;
 	int rptr;
 	cbd_t __iomem *tbdf;
 	cbd_t __iomem *rbdf;
 
-	if (num > CPM_MAXBD)
-		return -EINVAL;
-
-	/* Check if we have any oversized READ requests */
-	for (i = 0; i < num; i++) {
-		pmsg = &msgs[i];
-		if (pmsg->len >= CPM_MAX_READ)
-			return -EINVAL;
-	}
-
 	/* Reset to use first buffer */
 	out_be16(&i2c_ram->rbptr, in_be16(&i2c_ram->rbase));
 	out_be16(&i2c_ram->tbptr, in_be16(&i2c_ram->tbase));
@@ -424,10 +414,18 @@ static const struct i2c_algorithm cpm_i2c_algo = {
 	.functionality = cpm_i2c_func,
 };
 
+/* CPM_MAX_READ is also limiting writes according to the code! */
+static struct i2c_adapter_quirks cpm_i2c_quirks = {
+	.max_num_msgs = CPM_MAXBD,
+	.max_read_len = CPM_MAX_READ,
+	.max_write_len = CPM_MAX_READ,
+};
+
 static const struct i2c_adapter cpm_ops = {
 	.owner		= THIS_MODULE,
 	.name		= "i2c-cpm",
 	.algo		= &cpm_i2c_algo,
+	.quirks		= &cpm_i2c_quirks,
 };
 
 static int cpm_i2c_setup(struct cpm_i2c *cpm)
-- 
2.1.3

