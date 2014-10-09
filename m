Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbaJIDDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 23:03:31 -0400
Received: from mail-bl2on0060.outbound.protection.outlook.com ([65.55.169.60]:55641
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754314AbaJIDDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 23:03:22 -0400
From: <dinguyen@opensource.altera.com>
To: <p.zabel@pengutronix.de>
CC: <dinh.linux@gmail.com>, <s.trumtrar@pengutronix.de>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <atull@opensource.altera.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCH] reset: socfpga: use arch_initcall for early initialization
Date: Wed, 8 Oct 2014 21:44:06 -0500
Message-ID: <1412822646-11257-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0064.namprd08.prod.outlook.com (10.141.200.44) To
 DM2PR0301MB1200.namprd03.prod.outlook.com (25.160.217.15)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1200;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(86362001)(64706001)(92726001)(120916001)(80022003)(97736003)(46102003)(101416001)(19580395003)(85306004)(4396001)(2351001)(69596002)(107046002)(53416004)(50226001)(99396003)(93916002)(50466002)(19580405001)(66066001)(48376002)(81156004)(86152002)(95666004)(105586002)(122386002)(106356001)(40100002)(50986999)(76482002)(77096002)(104166001)(47776003)(92566001)(229853001)(20776003)(89996001)(87286001)(88136002)(87976001)(21056001)(77156001)(42186005)(31966008)(110136001)(85852003)(33646002)(102836001)(62966002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1200;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

There are certain drivers that are required to get loaded very early using
arch_initcall. An example of such a driver is the SOCFPGA's FPGA bridge driver.
This driver has to get loaded early because it needs to enable FPGA components
that are connected to the bridge.

This FPGA bridge driver will using the reset controller API to toggle it's
reset bits, thus, it needs the reset driver to be loaded as early as possible
in order for it to get used properly.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
 drivers/reset/reset-socfpga.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/reset-socfpga.c b/drivers/reset/reset-socfpga.c
index 79c32ca..a5e8d37 100644
--- a/drivers/reset/reset-socfpga.c
+++ b/drivers/reset/reset-socfpga.c
@@ -139,7 +139,20 @@ static struct platform_driver socfpga_reset_driver = {
 		.of_match_table	= socfpga_reset_dt_ids,
 	},
 };
-module_platform_driver(socfpga_reset_driver);
+
+static int __init socfpga_reset_init(void)
+{
+	return platform_driver_probe(&socfpga_reset_driver,
+					socfpga_reset_probe);
+}
+
+static void __exit socfpga_reset_exit(void)
+{
+	platform_driver_unregister(&socfpga_reset_driver);
+}
+
+arch_initcall(socfpga_reset_init);
+module_exit(socfpga_reset_exit);
 
 MODULE_AUTHOR("Steffen Trumtrar <s.trumtrar@pengutronix.de");
 MODULE_DESCRIPTION("Socfpga Reset Controller Driver");
-- 
2.0.3

