Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaIEFxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 01:53:53 -0400
Received: from mail-by2on0120.outbound.protection.outlook.com ([207.46.100.120]:27728
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750781AbaIEFxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 01:53:50 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 1/4] Clocksource: Flextimer: Use internal clocksource read API.
Date: Fri, 5 Sep 2014 13:02:17 +0800
Message-ID: <1409893340-30027-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1409893340-30027-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409893340-30027-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019016)(6009001)(189002)(199003)(44976005)(62966002)(76176999)(102836001)(6806004)(50986999)(83322001)(21056001)(85306004)(97736001)(31966008)(74662001)(19580395003)(74502001)(99396002)(19580405001)(90102001)(36756003)(64706001)(47776003)(46102001)(79102001)(50466002)(85852003)(80022001)(83072002)(104166001)(86362001)(89996001)(87286001)(229853001)(20776003)(48376002)(77982001)(26826002)(87936001)(4396001)(50226001)(76482001)(84676001)(92726001)(104016003)(68736004)(93916002)(92566001)(81342001)(81542001)(77156001)(88136002)(95666004)(107046002)(106466001)(105606002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0616;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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

Since the Flextimer device will be implemented in BE mode on
LS1 SoC, and in LE mode on Vybrid, LS2 SoCs, so here we need
the endianness judgment before doing the mmio.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/clocksource/fsl_ftm_timer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/fsl_ftm_timer.c b/drivers/clocksource/fsl_ftm_timer.c
index 454227d..9c6e935 100644
--- a/drivers/clocksource/fsl_ftm_timer.c
+++ b/drivers/clocksource/fsl_ftm_timer.c
@@ -226,6 +226,11 @@ static int __init ftm_clockevent_init(unsigned long freq, int irq)
 	return 0;
 }
 
+static cycle_t ftm_clocksource_read_up(struct clocksource *c)
+{
+	return ftm_readl(priv->clksrc_base + FTM_CNT) & 0xffff;
+}
+
 static int __init ftm_clocksource_init(unsigned long freq)
 {
 	int err;
@@ -238,7 +243,7 @@ static int __init ftm_clocksource_init(unsigned long freq)
 	sched_clock_register(ftm_read_sched_clock, 16, freq / (1 << priv->ps));
 	err = clocksource_mmio_init(priv->clksrc_base + FTM_CNT, "fsl-ftm",
 				    freq / (1 << priv->ps), 300, 16,
-				    clocksource_mmio_readl_up);
+				    ftm_clocksource_read_up);
 	if (err) {
 		pr_err("ftm: init clock source mmio failed: %d\n", err);
 		return err;
-- 
2.1.0.27.g96db324

