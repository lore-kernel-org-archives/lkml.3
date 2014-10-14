Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbaJNJ25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:28:57 -0400
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:58073
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752315AbaJNJ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:28:55 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <arnd@arndb.de>, <peter@hurleysoftware.com>,
        <linux-serial@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCHv4] serial: of-serial: fix up PM ops on no_console_suspend and port type
Date: Tue, 14 Oct 2014 16:42:26 +0800
Message-ID: <1413276146-20388-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(69596002)(68736004)(50986999)(62966002)(84676001)(85852003)(107046002)(95666004)(106466001)(104016003)(81156004)(105606002)(89996001)(20776003)(47776003)(120916001)(19580395003)(44976005)(31966008)(110136001)(6806004)(19580405001)(64706001)(33646002)(99396003)(2351001)(50466002)(92726001)(92566001)(104166001)(85306004)(86362001)(93916002)(48376002)(46102003)(80022003)(97736003)(87936001)(87286001)(229853001)(4396001)(88136002)(36756003)(77156001)(76482002)(50226001)(102836001)(26826002)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB479;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB479;
X-Forefront-PRVS: 03648EFF89
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
changes in v4:
 separate 8250 port suspend/resume from of_serial_suspend/resume.

changes in v3:
 fix up point reference and deference.

changes in v2:
 add switch selection on uart type.

 drivers/tty/serial/of_serial.c | 52 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 8bc2563..5281f8f 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -241,13 +241,48 @@ static int of_platform_serial_remove(struct platform_device *ofdev)
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
@@ -256,10 +291,13 @@ static int of_serial_resume(struct device *dev)
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

