Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaEHH4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:56:48 -0400
Received: from smtp39.i.mail.ru ([94.100.177.99]:41385 "EHLO smtp39.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbaEHH4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:56:46 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/4] w1: mxc_w1: Optimize mxc_w1_ds2_reset_bus()
Date: Thu,  8 May 2014 11:56:38 +0400
Message-Id: <1399535800-19335-2-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399535800-19335-1-git-send-email-shc_work@mail.ru>
References: <1399535800-19335-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the i.MX reference manual, the reset procedure and
"presence" pulse takes 511 and 512 us, respectively. Measurement for
i.MX27 is about 1100 us. There is no need to wait Reset+Presence
more than this time.
This patch optimizes mxc_w1_ds2_reset_bus() function to use proper
value for delay after w1 bus reset. Nevertheless, a small margin for
the timeout has been added for the case if clock frequency is inaccurate.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/w1/masters/mxc_w1.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index a5df5e8..0d05abe 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -15,16 +15,13 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
 
-/* According to the mx27 Datasheet the reset procedure should take up to about
- * 1350us. We set the timeout to 500*100us = 50ms for sure */
-#define MXC_W1_RESET_TIMEOUT 500
-
 /*
  * MXC W1 Register offsets
  */
@@ -49,24 +46,25 @@ struct mxc_w1_device {
  */
 static u8 mxc_w1_ds2_reset_bus(void *data)
 {
-	u8 reg_val;
-	unsigned int timeout_cnt = 0;
 	struct mxc_w1_device *dev = data;
+	unsigned long timeout;
 
-	writeb(MXC_W1_CONTROL_RPP, (dev->regs + MXC_W1_CONTROL));
+	writeb(MXC_W1_CONTROL_RPP, dev->regs + MXC_W1_CONTROL);
 
-	while (1) {
-		reg_val = readb(dev->regs + MXC_W1_CONTROL);
+	/* Wait for reset sequence 511+512us, use 1500us for sure */
+	timeout = jiffies + usecs_to_jiffies(1500);
 
-		if (!(reg_val & MXC_W1_CONTROL_RPP) ||
-		    timeout_cnt > MXC_W1_RESET_TIMEOUT)
-			break;
-		else
-			timeout_cnt++;
+	udelay(511 + 512);
 
-		udelay(100);
-	}
-	return !(reg_val & MXC_W1_CONTROL_PST);
+	do {
+		u8 ctrl = readb(dev->regs + MXC_W1_CONTROL);
+
+		/* PST bit is valid after the RPP bit is self-cleared */
+		if (!(ctrl & MXC_W1_CONTROL_RPP))
+			return !(ctrl & MXC_W1_CONTROL_PST);
+	} while (time_is_after_jiffies(timeout));
+
+	return 1;
 }
 
 /*
-- 
1.8.3.2

