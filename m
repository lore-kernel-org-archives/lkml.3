Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbaJXP6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:58:04 -0400
Received: from mail-bn1on0070.outbound.protection.outlook.com ([157.56.110.70]:51568
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755889AbaJXP6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:58:02 -0400
From: <dinguyen@opensource.altera.com>
To: <p.zabel@pengutronix.de>
CC: <dinh.linux@gmail.com>, <s.trumtrar@pengutronix.de>,
        <atull@opensource.altera.com>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCH] reset: add socfpga_reset_status
Date: Fri, 24 Oct 2014 10:53:10 -0500
Message-ID: <1414165990-23958-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: SIXPR04CA017.apcprd04.prod.outlook.com (10.141.119.37) To
 BN3PR0301MB1185.namprd03.prod.outlook.com (25.160.156.147)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1185;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(85306004)(53416004)(81156004)(93916002)(86362001)(92566001)(50466002)(77096002)(62966002)(42186005)(69596002)(88136002)(19580395003)(33646002)(92726001)(110136001)(89996001)(66066001)(104166001)(102836001)(86152002)(105586002)(19580405001)(101416001)(31966008)(21056001)(20776003)(2351001)(106356001)(40100003)(107046002)(229853001)(97736003)(87286001)(50986999)(77156001)(4396001)(87976001)(47776003)(64706001)(48376002)(80022003)(46102003)(85852003)(99396003)(95666004)(76482002)(50226001)(122386002)(120916001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1185;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Populate the reset_status callback for SOCFPGA.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
 drivers/reset/reset-socfpga.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/reset/reset-socfpga.c b/drivers/reset/reset-socfpga.c
index 79c32ca..cd37849 100644
--- a/drivers/reset/reset-socfpga.c
+++ b/drivers/reset/reset-socfpga.c
@@ -76,9 +76,27 @@ static int socfpga_reset_deassert(struct reset_controller_dev *rcdev,
 	return 0;
 }
 
+static int socfpga_reset_status(struct reset_controller_dev *rcdev,
+				unsigned long id)
+{
+	struct socfpga_reset_data *data = container_of(rcdev,
+						struct socfpga_reset_data, rcdev);
+	int bank = id / BITS_PER_LONG;
+	int offset = id % BITS_PER_LONG;
+	unsigned long flags;
+	u32 reg;
+
+	spin_lock_irqsave(&data->lock, flags);
+	reg = readl(data->membase + OFFSET_MODRST + (bank * NR_BANKS));
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	return !(reg & BIT(offset));
+}
+
 static struct reset_control_ops socfpga_reset_ops = {
 	.assert		= socfpga_reset_assert,
 	.deassert	= socfpga_reset_deassert,
+	.status		= socfpga_reset_status,
 };
 
 static int socfpga_reset_probe(struct platform_device *pdev)
-- 
2.0.3

