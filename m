Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaKCWhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:37:07 -0500
Received: from mail-bl2on0079.outbound.protection.outlook.com ([65.55.169.79]:20832
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751162AbaKCWhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:37:05 -0500
From: <dinguyen@opensource.altera.com>
To: <p.zabel@pengutronix.de>
CC: <dinh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCHv2] reset: add socfpga_reset_status
Date: Mon, 3 Nov 2014 16:33:05 -0600
Message-ID: <1415053985-10552-1-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CY1PR00CA0009.namprd00.prod.outlook.com (25.160.142.147) To
 CY1PR0301MB1196.namprd03.prod.outlook.com (25.160.165.27)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-Forefront-PRVS: 0384275935
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(69596002)(89996001)(120916001)(87976001)(110136001)(33646002)(19580395003)(21056001)(19580405001)(99396003)(4396001)(50226001)(53416004)(107046002)(42186005)(95666004)(229853001)(81156004)(97736003)(88136002)(2351001)(86152002)(106356001)(105586002)(104166001)(122386002)(93916002)(92726001)(20776003)(47776003)(66066001)(64706001)(62966003)(77156002)(77096003)(31966008)(101416001)(102836001)(50986999)(87286001)(40100003)(48376002)(46102003)(86362001)(92566001)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1196;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Populate the reset_status callback for SOCFPGA.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
v2: Remove spin_lock around readl
---
 drivers/reset/reset-socfpga.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/reset/reset-socfpga.c b/drivers/reset/reset-socfpga.c
index 79c32ca..39da5cb 100644
--- a/drivers/reset/reset-socfpga.c
+++ b/drivers/reset/reset-socfpga.c
@@ -76,9 +76,25 @@ static int socfpga_reset_deassert(struct reset_controller_dev *rcdev,
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
+	reg = readl(data->membase + OFFSET_MODRST + (bank * NR_BANKS));
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

