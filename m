Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaL3DaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 22:30:01 -0500
Received: from mail-bn1bn0104.outbound.protection.outlook.com ([157.56.110.104]:14160
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751455AbaL3D37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 22:29:59 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v7 01/21] clk: divider: Correct parent clk round rate if no bestdiv is normally found
Date: Tue, 30 Dec 2014 11:33:51 +0800
Message-ID: <1419910451-15268-2-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419910451-15268-1-git-send-email-Ying.Liu@freescale.com>
References: <1419910451-15268-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(229853001)(20776003)(68736005)(97736003)(84676001)(46102003)(87936001)(575784001)(19580395003)(6806004)(104016003)(50986999)(76176999)(77156002)(92566001)(77096005)(106466001)(64706001)(62966003)(86362001)(47776003)(48376002)(21056001)(31966008)(4396001)(36756003)(50466002)(107046002)(99396003)(105606002)(89996001)(50226001)(120916001)(2950100001)(19580405001)(110136001)(2351001)(85426001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0627;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0627;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0627;
X-Forefront-PRVS: 04410E544A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0627;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2014 03:29:56.4382
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0627
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no best divider is normally found, we will try to use the maximum divider.
We should not set the parent clock rate to be 1Hz by force for being rounded.
Instead, we should take the maximum divider as a base and calculate a correct
parent clock rate for being rounded.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v6->v7:
 * None.

v5->v6:
 * None.

v4->v5:
 * None.

v3->v4:
 * None.

v2->v3:
 * None.

v1->v2:
 * None.

 drivers/clk/clk-divider.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index c0a842b..f641d4b 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -311,7 +311,8 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 
 	if (!bestdiv) {
 		bestdiv = _get_maxdiv(divider);
-		*best_parent_rate = __clk_round_rate(__clk_get_parent(hw->clk), 1);
+		*best_parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
+						MULT_ROUND_UP(rate, bestdiv));
 	}
 
 	return bestdiv;
-- 
2.1.0

