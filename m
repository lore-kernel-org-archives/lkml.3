Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaJIKKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:10:50 -0400
Received: from mail-bl2on0148.outbound.protection.outlook.com ([65.55.169.148]:35064
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750942AbaJIKKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:10:42 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <arnd@arndb.de>, <linux-serial@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        Joseph Lo <josephl@nvidia.com>
Subject: [PATCH] serial: of-serial: fix up PM ops on no_console_suspend
Date: Thu, 9 Oct 2014 17:10:52 +0800
Message-ID: <1412845852-26157-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(81156004)(87936001)(85852003)(106466001)(89996001)(99396003)(87286001)(105606002)(88136002)(4396001)(50226001)(80022003)(46102003)(97736003)(47776003)(21056001)(20776003)(36756003)(77156001)(62966002)(33646002)(64706001)(110136001)(104016003)(85306004)(86362001)(93916002)(229853001)(2351001)(107046002)(104166001)(50466002)(26826002)(120916001)(6806004)(95666004)(19580395003)(44976005)(84676001)(92566001)(92726001)(50986999)(76482002)(69596002)(31966008)(102836001)(19580405001)(68736004)(48376002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB471;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB471;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0359162B6D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandatorily disabling the uart clock will cause register access
hung on "no_console_suspend". This patch add condition check on
it and only disable the clock with console_suspend_enabled true.

Signed-off-by: Joseph Lo <josephl@nvidia.com>
Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
 drivers/tty/serial/of_serial.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 8bc2563..a765399 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -246,7 +246,7 @@ static int of_serial_suspend(struct device *dev)
 	struct of_serial_info *info = dev_get_drvdata(dev);
 
 	serial8250_suspend_port(info->line);
-	if (info->clk)
+	if (info->clk && console_suspend_enabled)
 		clk_disable_unprepare(info->clk);
 
 	return 0;
@@ -256,7 +256,7 @@ static int of_serial_resume(struct device *dev)
 {
 	struct of_serial_info *info = dev_get_drvdata(dev);
 
-	if (info->clk)
+	if (info->clk && console_suspend_enabled)
 		clk_prepare_enable(info->clk);
 
 	serial8250_resume_port(info->line);
-- 
1.8.0

