Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaLXIf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 03:35:58 -0500
Received: from mail-bn1on0131.outbound.protection.outlook.com ([157.56.110.131]:48864
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751689AbaLXIfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:35:51 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v5 01/21] clk: divider: Correct parent clk round rate if no bestdiv is normally found
Date: Wed, 24 Dec 2014 16:39:23 +0800
Message-ID: <1419410383-6359-2-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419410383-6359-1-git-send-email-Ying.Liu@freescale.com>
References: <1419410383-6359-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(92566001)(86362001)(105606002)(85426001)(19580395003)(47776003)(6806004)(20776003)(19580405001)(64706001)(48376002)(50466002)(575784001)(89996001)(87936001)(4396001)(110136001)(50226001)(229853001)(99396003)(107046002)(2351001)(77096005)(68736005)(36756003)(50986999)(31966008)(84676001)(120916001)(76176999)(77156002)(21056001)(46102003)(97736003)(104016003)(106466001)(2950100001)(62966003)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0636;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0636;
X-Forefront-PRVS: 04359FAD81
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2014 08:35:47.9838
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0636
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no best divider is normally found, we will try to use the maximum divider.
We should not set the parent clock rate to be 1Hz by force for being rounded.
Instead, we should take the maximum divider as a base and calculate a correct
parent clock rate for being rounded.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
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

