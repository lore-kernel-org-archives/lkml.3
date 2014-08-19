Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaHSUYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:24:09 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:38705
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751905AbaHSUYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:24:07 -0400
From: <atull@opensource.altera.com>
To: <wsa@the-dreams.de>, <baruch@tkos.co.il>,
        <mika.westerberg@linux.intel.com>
CC: <grant.likely@linaro.org>, <robh+dt@kernel.org>, <skuribay@pobox.com>,
        <Romain.Baeriswyl@abilis.com>, <rafael.j.wysocki@intel.com>,
        <alan@linux.intel.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH] i2c: designware: deduce speed mode from device tree setting
Date: Tue, 19 Aug 2014 15:18:49 -0500
Message-ID: <1408479529-24249-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CO1PR06CA034.namprd06.prod.outlook.com (10.242.160.24) To
 DM2PR03MB319.namprd03.prod.outlook.com (10.141.54.18)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009006)(6009001)(199003)(189002)(19580395003)(19580405001)(87286001)(87976001)(85852003)(83072002)(83322001)(4396001)(50226001)(79102001)(48376002)(69596002)(76482001)(46102001)(86152002)(62966002)(77982001)(92726001)(42186005)(92566001)(93916002)(99396002)(77156001)(77096002)(50466002)(86362001)(53416004)(101416001)(33646002)(50986999)(105586002)(106356001)(74662001)(64706001)(74502001)(102836001)(2201001)(95666004)(104166001)(31966008)(80022001)(89996001)(66066001)(47776003)(88136002)(21056001)(85306004)(229853001)(81542001)(81156004)(20776003)(107046002)(81342001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB319;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Use the documented, but unimplemented "clock-frequency"
Device Tree setting as a guide on whether to set the speed
mode bits in DW_IC_CON to standard or fast i2c mode.

Previously, the driver was hardwired to fast mode.  Default
to fast mode if the "clock-frequency" property is not present
for backwards compatiblity.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index bc87733..18cd3d9 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -122,7 +122,8 @@ static int dw_i2c_probe(struct platform_device *pdev)
 	struct dw_i2c_dev *dev;
 	struct i2c_adapter *adap;
 	struct resource *mem;
-	int irq, r;
+	int irq, r, ret, speed = DW_IC_CON_SPEED_FAST;
+	u32 bus_rate;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -167,6 +168,11 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		of_property_read_u32(pdev->dev.of_node,
 				     "i2c-scl-falling-time-ns",
 				     &dev->scl_falling_time);
+
+		ret = of_property_read_u32(pdev->dev.of_node,
+					   "clock-frequency", &bus_rate);
+		if (!ret && (bus_rate <= 100000))
+			speed = DW_IC_CON_SPEED_STD;
 	}
 
 	dev->functionality =
@@ -177,7 +183,7 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		I2C_FUNC_SMBUS_WORD_DATA |
 		I2C_FUNC_SMBUS_I2C_BLOCK;
 	dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
-		DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
+		DW_IC_CON_RESTART_EN | speed;
 
 	/* Try first if we can configure the device from ACPI */
 	r = dw_i2c_acpi_configure(pdev);
-- 
1.7.9.5

