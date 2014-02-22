Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaBVHaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 02:30:14 -0500
Received: from smtp21.mail.ru ([94.100.176.174]:42517 "EHLO smtp21.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaBVHaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 02:30:08 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 4/4] w1: mxc_w1: Enable driver compilation with COMPILE_TEST
Date: Sat, 22 Feb 2014 11:29:51 +0400
Message-Id: <1393054191-8623-4-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393054191-8623-1-git-send-email-shc_work@mail.ru>
References: <1393054191-8623-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps increasing build testing coverage.
To do this, __raw_{read,write}b() functions was be replaced with
simple {read,write}b() variants.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/w1/masters/Kconfig  |  2 +-
 drivers/w1/masters/mxc_w1.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 6ffe120..1708b23 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -36,7 +36,7 @@ config W1_MASTER_DS2482
 
 config W1_MASTER_MXC
 	tristate "Freescale MXC 1-wire busmaster"
-	depends on ARCH_MXC
+	depends on ARCH_MXC || COMPILE_TEST
 	help
 	  Say Y here to enable MXC 1-wire host
 
diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 8e3de6a..67b067a 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -53,10 +53,10 @@ static u8 mxc_w1_ds2_reset_bus(void *data)
 	unsigned int timeout_cnt = 0;
 	struct mxc_w1_device *dev = data;
 
-	__raw_writeb(MXC_W1_CONTROL_RPP, (dev->regs + MXC_W1_CONTROL));
+	writeb(MXC_W1_CONTROL_RPP, (dev->regs + MXC_W1_CONTROL));
 
 	while (1) {
-		reg_val = __raw_readb(dev->regs + MXC_W1_CONTROL);
+		reg_val = readb(dev->regs + MXC_W1_CONTROL);
 
 		if (!(reg_val & MXC_W1_CONTROL_RPP) ||
 		    timeout_cnt > MXC_W1_RESET_TIMEOUT)
@@ -82,16 +82,16 @@ static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 					 * datasheet.
 					 */
 
-	__raw_writeb(MXC_W1_CONTROL_WR(bit), ctrl_addr);
+	writeb(MXC_W1_CONTROL_WR(bit), ctrl_addr);
 
 	while (timeout_cnt--) {
-		if (!(__raw_readb(ctrl_addr) & MXC_W1_CONTROL_WR(bit)))
+		if (!(readb(ctrl_addr) & MXC_W1_CONTROL_WR(bit)))
 			break;
 
 		udelay(1);
 	}
 
-	return !!(__raw_readb(ctrl_addr) & MXC_W1_CONTROL_RDST);
+	return !!(readb(ctrl_addr) & MXC_W1_CONTROL_RDST);
 }
 
 static int mxc_w1_probe(struct platform_device *pdev)
@@ -131,7 +131,7 @@ static int mxc_w1_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	__raw_writeb(clkdiv - 1, mdev->regs + MXC_W1_TIME_DIVIDER);
+	writeb(clkdiv - 1, mdev->regs + MXC_W1_TIME_DIVIDER);
 
 	mdev->bus_master.data = mdev;
 	mdev->bus_master.reset_bus = mxc_w1_ds2_reset_bus;
-- 
1.8.3.2

