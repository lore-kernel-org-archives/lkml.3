Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaJMKBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:01:19 -0400
Received: from [157.56.110.106] ([157.56.110.106]:2567 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752937AbaJMKBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:01:16 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <josephl@nvidia.com>, <arnd@arndb.de>, <linux-serial@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCHv3] serial: of-serial: fix up PM ops on no_console_suspend and port type
Date: Mon, 13 Oct 2014 17:14:27 +0800
Message-ID: <1413191667-10949-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(36756003)(120916001)(20776003)(76482002)(95666004)(85306004)(2351001)(77156001)(104166001)(97736003)(46102003)(105606002)(81156004)(80022003)(106466001)(50986999)(107046002)(47776003)(110136001)(229853001)(26826002)(99396003)(50226001)(69596002)(68736004)(84676001)(64706001)(19580405001)(19580395003)(62966002)(4396001)(102836001)(6806004)(44976005)(89996001)(85852003)(92566001)(93916002)(50466002)(86362001)(31966008)(33646002)(104016003)(21056001)(87286001)(48376002)(88136002)(92726001)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB467;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB467;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03630A6A4A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB099;
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
changes in v3:
 fix up point reference and deference.

changes in v2:
 add switch selection on uart type.

 drivers/tty/serial/of_serial.c | 42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 8bc2563..9d747a7 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -245,9 +245,24 @@ static int of_serial_suspend(struct device *dev)
 {
 	struct of_serial_info *info = dev_get_drvdata(dev);
 
-	serial8250_suspend_port(info->line);
-	if (info->clk)
-		clk_disable_unprepare(info->clk);
+	switch(info->type) {
+#ifdef CONFIG_SERIAL_8250
+	case PORT_8250 ... PORT_MAX_8250:
+	{
+		struct uart_8250_port *port8250;
+		port8250 = serial8250_get_port(info->line);
+
+		serial8250_suspend_port(info->line);
+		if (info->clk &&
+		    (!uart_console(&port8250->port) ||
+		    (uart_console(&port8250->port) && console_suspend_enabled)))
+			clk_disable_unprepare(info->clk);
+		break;
+	}
+#endif
+	default:
+		break;
+	}
 
 	return 0;
 }
@@ -256,10 +271,25 @@ static int of_serial_resume(struct device *dev)
 {
 	struct of_serial_info *info = dev_get_drvdata(dev);
 
-	if (info->clk)
-		clk_prepare_enable(info->clk);
+	switch(info->type) {
+#ifdef CONFIG_SERIAL_8250
+	case PORT_8250 ... PORT_MAX_8250:
+	{
+		struct uart_8250_port *port8250;
+		port8250 = serial8250_get_port(info->line);
+
+		if (info->clk &&
+		    (!uart_console(&port8250->port) ||
+		    (uart_console(&port8250->port) && console_suspend_enabled)))
+			clk_prepare_enable(info->clk);
 
-	serial8250_resume_port(info->line);
+		serial8250_resume_port(info->line);
+		break;
+	}
+#endif
+	default:
+		break;
+	}
 
 	return 0;
 }
-- 
1.8.0

