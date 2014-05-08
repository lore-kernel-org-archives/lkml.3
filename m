Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaEHH5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:57:33 -0400
Received: from smtp39.i.mail.ru ([94.100.177.99]:41444 "EHLO smtp39.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbaEHH4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:56:47 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 4/4] w1: mxc_w1: Optimize mxc_w1_ds2_touch_bit()
Date: Thu,  8 May 2014 11:56:40 +0400
Message-Id: <1399535800-19335-4-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399535800-19335-1-git-send-email-shc_work@mail.ru>
References: <1399535800-19335-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the i.MX reference manual, the read/write bit operations
takes from 60 us to 120 us.
This patch optimizes mxc_w1_ds2_touch_bit() function to use proper
value for such delay. Nevertheless, a small margin for the timeout has
been added for the case if clock frequency is inaccurate.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/w1/masters/mxc_w1.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 741d2bb4..da3d0f0 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -75,22 +75,25 @@ static u8 mxc_w1_ds2_reset_bus(void *data)
  */
 static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 {
-	struct mxc_w1_device *mdev = data;
-	void __iomem *ctrl_addr = mdev->regs + MXC_W1_CONTROL;
-	unsigned int timeout_cnt = 400; /* Takes max. 120us according to
-					 * datasheet.
-					 */
+	struct mxc_w1_device *dev = data;
+	unsigned long timeout;
+
+	writeb(MXC_W1_CONTROL_WR(bit), dev->regs + MXC_W1_CONTROL);
+
+	/* Wait for read/write bit (60us, Max 120us), use 200us for sure */
+	timeout = jiffies + usecs_to_jiffies(200);
 
-	writeb(MXC_W1_CONTROL_WR(bit), ctrl_addr);
+	udelay(60);
 
-	while (timeout_cnt--) {
-		if (!(readb(ctrl_addr) & MXC_W1_CONTROL_WR(bit)))
-			break;
+	do {
+		u8 ctrl = readb(dev->regs + MXC_W1_CONTROL);
 
-		udelay(1);
-	}
+		/* RDST bit is valid after the WR1/RD bit is self-cleared */
+		if (!(ctrl & MXC_W1_CONTROL_WR(bit)))
+			return !!(ctrl & MXC_W1_CONTROL_RDST);
+	} while (time_is_after_jiffies(timeout));
 
-	return !!(readb(ctrl_addr) & MXC_W1_CONTROL_RDST);
+	return 0;
 }
 
 static int mxc_w1_probe(struct platform_device *pdev)
-- 
1.8.3.2

