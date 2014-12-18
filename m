Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaLRHHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 02:07:53 -0500
Received: from mail-bn1bn0109.outbound.protection.outlook.com ([157.56.110.109]:29120
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751113AbaLRHHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 02:07:51 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 01/14] clk: divider: Correct parent clk round rate if no bestdiv is normally found
Date: Thu, 18 Dec 2014 15:11:23 +0800
Message-ID: <1418886696-11636-2-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
References: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(107046002)(20776003)(6806004)(2351001)(99396003)(85426001)(64706001)(92566001)(50226001)(2950100001)(48376002)(106466001)(68736005)(110136001)(50466002)(62966003)(87936001)(104016003)(19580405001)(89996001)(77096005)(4396001)(50986999)(77156002)(229853001)(31966008)(47776003)(120916001)(21056001)(86362001)(76176999)(19580395003)(97736003)(575784001)(36756003)(84676001)(46102003)(105606002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0636;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0636;
X-Forefront-PRVS: 042957ACD7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no best divider is normally found, we will try to use the maximum divider.
We should not set the parent clock rate to be 1Hz by force for being rounded.
Instead, we should take the maximum divider as a base and calculate a correct
parent clock rate for being rounded.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
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

