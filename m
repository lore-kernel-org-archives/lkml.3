Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaIWJm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:42:28 -0400
Received: from mail-by2on0136.outbound.protection.outlook.com ([207.46.100.136]:47840
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754466AbaIWJm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:42:26 -0400
X-Greylist: delayed 890 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 05:42:26 EDT
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <arnd@arndb.de>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCH] serial: of-serial: add PM suspend/resume support
Date: Tue, 23 Sep 2014 16:34:12 +0800
Message-ID: <1411461252-8730-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(2351001)(92726001)(106466001)(92566001)(90102001)(26826002)(102836001)(229853001)(50466002)(76482002)(95666004)(97736003)(36756003)(107046002)(50226001)(10300001)(104016003)(4396001)(93916002)(62966002)(21056001)(64706001)(105606002)(79102003)(80022003)(81342003)(83322001)(50986999)(85852003)(74662003)(81542003)(46102003)(77982003)(110136001)(99396002)(77156001)(68736004)(31966008)(44976005)(89996001)(19580405001)(33646002)(83072002)(88136002)(85306004)(20776003)(74502003)(84676001)(86362001)(87936001)(120916001)(19580395003)(6806004)(48376002)(47776003)(104166001)(87286001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB473;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB473;
X-Forefront-PRVS: 0343AC1D30
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds PM suspend/resume support for the of-serial driver
to provide power management support on devices attatched to it.

Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
 drivers/tty/serial/of_serial.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 27981e2..8bc2563 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -240,6 +240,32 @@ static int of_platform_serial_remove(struct platform_device *ofdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int of_serial_suspend(struct device *dev)
+{
+	struct of_serial_info *info = dev_get_drvdata(dev);
+
+	serial8250_suspend_port(info->line);
+	if (info->clk)
+		clk_disable_unprepare(info->clk);
+
+	return 0;
+}
+
+static int of_serial_resume(struct device *dev)
+{
+	struct of_serial_info *info = dev_get_drvdata(dev);
+
+	if (info->clk)
+		clk_prepare_enable(info->clk);
+
+	serial8250_resume_port(info->line);
+
+	return 0;
+}
+#endif
+static SIMPLE_DEV_PM_OPS(of_serial_pm_ops, of_serial_suspend, of_serial_resume);
+
 /*
  * A few common types, add more as needed.
  */
@@ -271,6 +297,7 @@ static struct platform_driver of_platform_serial_driver = {
 		.name = "of_serial",
 		.owner = THIS_MODULE,
 		.of_match_table = of_platform_serial_table,
+		.pm = &of_serial_pm_ops,
 	},
 	.probe = of_platform_serial_probe,
 	.remove = of_platform_serial_remove,
-- 
1.8.0

