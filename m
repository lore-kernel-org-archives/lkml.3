Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbaCZDLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 23:11:24 -0400
Received: from [65.55.88.12] ([65.55.88.12]:49504 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755327AbaCZDKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 23:10:48 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchd2iz8275ch1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <wim@iguana.be>, <w.sang@pengutronix.de>, <linux-watchdog@vger.kernel.org>,
        <linux@roeck-us.net>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 2/2] watchdog: imx2_wdt: Add big-endian support
Date: Wed, 26 Mar 2014 10:21:40 +0800
Message-ID: <1395800500-22655-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1395800500-22655-1-git-send-email-Li.Xiubo@freescale.com>
References: <1395800500-22655-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the platforms that this IP driver now supports:
SoC        CPU        Watchdog     Need 'big-endian'?
------------------------------------------------------
Vybird     little     little       No
LS1        little     big          Yes
LS2        little     little       No
IMX+       little     little       No

So for the LS1 SoCs, we need to do the big endianness converting.

And this will also support the following case, for example:
SoC        CPU        Watchdog     Need 'big-endian'?
------------------------------------------------------
PowerPC    big        big          Yes

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/imx2_wdt.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 1795922..32f8874 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -30,6 +30,7 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/timer.h>
 #include <linux/uaccess.h>
@@ -64,9 +65,26 @@ static struct {
 	void __iomem *base;
 	unsigned timeout;
 	unsigned long status;
+	bool big_endian;
 	struct timer_list timer;	/* Pings the watchdog when closed */
 } imx2_wdt;
 
+static inline u16 imx2_wdt_readw(void __iomem *addr)
+{
+	if (imx2_wdt.big_endian)
+		return ioread16be(addr);
+	else
+		return ioread16(addr);
+}
+
+static inline void imx2_wdt_writew(u16 val, void __iomem *addr)
+{
+	if (imx2_wdt.big_endian)
+		iowrite16be(val, addr);
+	else
+		iowrite16(val, addr);
+}
+
 static struct miscdevice imx2_wdt_miscdev;
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
@@ -87,7 +105,7 @@ static const struct watchdog_info imx2_wdt_info = {
 
 static inline void imx2_wdt_setup(void)
 {
-	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
+	u16 val = imx2_wdt_readw(imx2_wdt.base + IMX2_WDT_WCR);
 
 	/* Suspend timer in low power mode, write once-only */
 	val |= IMX2_WDT_WCR_WDZST;
@@ -100,17 +118,17 @@ static inline void imx2_wdt_setup(void)
 	/* Set the watchdog's Time-Out value */
 	val |= WDOG_SEC_TO_COUNT(imx2_wdt.timeout);
 
-	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
+	imx2_wdt_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
 
 	/* enable the watchdog */
 	val |= IMX2_WDT_WCR_WDE;
-	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
+	imx2_wdt_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
 }
 
 static inline void imx2_wdt_ping(void)
 {
-	__raw_writew(IMX2_WDT_SEQ1, imx2_wdt.base + IMX2_WDT_WSR);
-	__raw_writew(IMX2_WDT_SEQ2, imx2_wdt.base + IMX2_WDT_WSR);
+	imx2_wdt_writew(IMX2_WDT_SEQ1, imx2_wdt.base + IMX2_WDT_WSR);
+	imx2_wdt_writew(IMX2_WDT_SEQ2, imx2_wdt.base + IMX2_WDT_WSR);
 }
 
 static void imx2_wdt_timer_ping(unsigned long arg)
@@ -143,12 +161,12 @@ static void imx2_wdt_stop(void)
 
 static void imx2_wdt_set_timeout(int new_timeout)
 {
-	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
+	u16 val = imx2_wdt_readw(imx2_wdt.base + IMX2_WDT_WCR);
 
 	/* set the new timeout value in the WSR */
 	val &= ~IMX2_WDT_WCR_WT;
 	val |= WDOG_SEC_TO_COUNT(new_timeout);
-	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
+	imx2_wdt_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
 }
 
 static int imx2_wdt_open(struct inode *inode, struct file *file)
@@ -192,7 +210,7 @@ static long imx2_wdt_ioctl(struct file *file, unsigned int cmd,
 		return put_user(0, p);
 
 	case WDIOC_GETBOOTSTATUS:
-		val = __raw_readw(imx2_wdt.base + IMX2_WDT_WRSR);
+		val = imx2_wdt_readw(imx2_wdt.base + IMX2_WDT_WRSR);
 		new_value = val & IMX2_WDT_WRSR_TOUT ? WDIOF_CARDRESET : 0;
 		return put_user(new_value, p);
 
@@ -257,8 +275,12 @@ static struct miscdevice imx2_wdt_miscdev = {
 
 static int __init imx2_wdt_probe(struct platform_device *pdev)
 {
-	int ret;
+	struct device_node *np = pdev->dev.of_node;
 	struct resource *res;
+	int ret;
+
+	if (np)
+		imx2_wdt.big_endian = of_property_read_bool(np, "big-endian");
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	imx2_wdt.base = devm_ioremap_resource(&pdev->dev, res);
-- 
1.8.4


