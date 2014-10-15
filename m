Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaJOHGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:06:05 -0400
Received: from mail-by2on0124.outbound.protection.outlook.com ([207.46.100.124]:61437
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750775AbaJOHGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:06:03 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <peter@hurleysoftware.com>, <arnd@arndb.de>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCHv5] serial: of-serial: fix up PM ops on no_console_suspend and port type
Date: Wed, 15 Oct 2014 14:19:27 +0800
Message-ID: <1413353967-27866-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(99396003)(76482002)(87936001)(120916001)(46102003)(80022003)(87286001)(19580405001)(48376002)(69596002)(50226001)(4396001)(19580395003)(6806004)(44976005)(84676001)(50466002)(62966002)(68736004)(93916002)(102836001)(47776003)(85306004)(26826002)(92726001)(64706001)(104166001)(85852003)(86362001)(20776003)(81156004)(31966008)(97736003)(92566001)(21056001)(2351001)(106466001)(50986999)(89996001)(88136002)(229853001)(105606002)(104016003)(107046002)(36756003)(110136001)(33646002)(95666004)(77156001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB480;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB480;
X-Forefront-PRVS: 0365C0E14B
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes commit 2dea53bf57783f243c892e99c10c6921e956aa7e,
"serial: of-serial: add PM suspend/resume support", which disables
the uart clock on suspend, but also causes a hardware hang on register
access if no_console_suspend command line option is used.

Also, not every of_serial device is an 8250 port, so the serial8250
suspend/resume functions should only be applied to a real 8250 port.

Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
changes in v5: 
 add missing <linux/console.h> include.

changes in v4:
 separate 8250 port suspend/resume from of_serial_suspend/resume.

changes in v3:
 fix up point reference and deference.

changes in v2:
 add switch selection on uart type.

 drivers/tty/serial/of_serial.c | 53 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 8bc2563..9c64ad2 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -9,6 +9,7 @@
  *  2 of the License, or (at your option) any later version.
  *
  */
+#include <linux/console.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -241,13 +242,48 @@ static int of_platform_serial_remove(struct platform_device *ofdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int of_serial_suspend(struct device *dev)
+#ifdef CONFIG_SERIAL_8250
+static void of_serial_suspend_8250(struct of_serial_info *info)
 {
-	struct of_serial_info *info = dev_get_drvdata(dev);
+	struct uart_8250_port *port8250 = serial8250_get_port(info->line);
+	struct uart_port *port = &port8250->port;
 
 	serial8250_suspend_port(info->line);
-	if (info->clk)
+	if (info->clk && (!uart_console(port) || console_suspend_enabled))
 		clk_disable_unprepare(info->clk);
+}
+
+static void of_serial_resume_8250(struct of_serial_info *info)
+{
+	struct uart_8250_port *port8250 = serial8250_get_port(info->line);
+	struct uart_port *port = &port8250->port;
+
+	if (info->clk && (!uart_console(port) || console_suspend_enabled))
+		clk_prepare_enable(info->clk);
+
+	serial8250_resume_port(info->line);
+}
+#else
+static inline void of_serial_suspend_8250(struct of_serial_info *info)
+{
+}
+
+static inline void of_serial_resume_8250(struct of_serial_info *info)
+{
+}
+#endif
+
+static int of_serial_suspend(struct device *dev)
+{
+	struct of_serial_info *info = dev_get_drvdata(dev);
+
+	switch(info->type) {
+	case PORT_8250 ... PORT_MAX_8250:
+		of_serial_suspend_8250(info);
+		break;
+	default:
+		break;
+	}
 
 	return 0;
 }
@@ -256,10 +292,13 @@ static int of_serial_resume(struct device *dev)
 {
 	struct of_serial_info *info = dev_get_drvdata(dev);
 
-	if (info->clk)
-		clk_prepare_enable(info->clk);
-
-	serial8250_resume_port(info->line);
+	switch(info->type) {
+	case PORT_8250 ... PORT_MAX_8250:
+		of_serial_resume_8250(info);
+		break;
+	default:
+		break;
+	}
 
 	return 0;
 }
-- 
1.8.0

