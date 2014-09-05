Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaIEGJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:09:44 -0400
Received: from mail-bn1bbn0109.outbound.protection.outlook.com ([157.56.111.109]:3777
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751999AbaIEGJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:09:36 -0400
X-Greylist: delayed 940 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 02:09:36 EDT
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 4/4] Clocksource: Flextimer: Fix counter clock prescaler calculation.
Date: Fri, 5 Sep 2014 13:02:20 +0800
Message-ID: <1409893340-30027-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1409893340-30027-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409893340-30027-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019016)(6009001)(189002)(199003)(36756003)(50986999)(93916002)(104016003)(90102001)(84676001)(83322001)(97736001)(62966002)(81342001)(575784001)(48376002)(86362001)(76176999)(21056001)(81542001)(80022001)(92726001)(92566001)(4396001)(20776003)(79102001)(19580405001)(47776003)(83072002)(31966008)(87936001)(44976005)(6806004)(104166001)(107046002)(74502001)(50226001)(95666004)(85852003)(50466002)(64706001)(85306004)(99396002)(68736004)(105606002)(102836001)(77156001)(88136002)(74662001)(89996001)(229853001)(76482001)(19580395003)(46102001)(87286001)(77982001)(26826002)(106466001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0610;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0325F6C77B
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old code will use the uncorrect clock prescaler after the
loop and the 'ps' must minus one after the loop.

This patch will use new style of this loop and will fix this bug
at the same time.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/clocksource/fsl_ftm_timer.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/fsl_ftm_timer.c b/drivers/clocksource/fsl_ftm_timer.c
index c0ce603..2b0983d 100644
--- a/drivers/clocksource/fsl_ftm_timer.c
+++ b/drivers/clocksource/fsl_ftm_timer.c
@@ -300,16 +300,15 @@ static unsigned long __init ftm_clk_init(struct device_node *np)
 
 static int __init ftm_calc_closest_round_cyc(unsigned long freq)
 {
-	priv->ps = 0;
+	int div;
 
 	/* The counter register is only using the lower 16 bits, and
 	 * if the 'freq' value is to big here, then the periodic_cyc
 	 * may exceed 0xFFFF.
 	 */
-	do {
-		priv->periodic_cyc = DIV_ROUND_CLOSEST(freq,
-						HZ * (1 << priv->ps++));
-	} while (priv->periodic_cyc > 0xFFFF);
+	for (priv->ps = 0, priv->periodic_cyc = ~0UL, div = HZ;
+	     priv->periodic_cyc > 0xffff; priv->ps++, div *= 2)
+		priv->periodic_cyc = DIV_ROUND_CLOSEST(freq, div);
 
 	if (priv->ps > FTM_PS_MAX) {
 		pr_err("ftm: the prescaler is %lu > %d\n",
-- 
2.1.0.27.g96db324

