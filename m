Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbaHZFv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:51:26 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:10271
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757031AbaHZFuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:50:20 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>
CC: <dongsheng.wang@freescale.com>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 2/5] Clocksource: Flextimer: Use internal clocksource read API.
Date: Tue, 26 Aug 2014 13:45:48 +0800
Message-ID: <1409031951-39021-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(4396001)(76482001)(85306004)(20776003)(80022001)(47776003)(76176999)(50226001)(64706001)(26826002)(81342001)(79102001)(77982001)(84676001)(21056001)(62966002)(83322001)(44976005)(97736001)(69596002)(19580395003)(6806004)(36756003)(68736004)(19580405001)(92726001)(77156001)(92566001)(50466002)(74662001)(31966008)(74502001)(93916002)(104166001)(575784001)(86362001)(89996001)(81542001)(88136002)(90102001)(95666004)(106466001)(50986999)(46102001)(105606002)(87286001)(229853001)(83072002)(85852003)(102836001)(81156004)(99396002)(107046002)(48376002)(87936001)(104016003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB179;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the Flextimer device will be implemented in BE mode on
LS1 SoC, and in LE mode on Vybrid, LS2 SoCs, so here we need
the endianness judgment before doing the mmio.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
 drivers/clocksource/fsl_ftm_timer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/fsl_ftm_timer.c b/drivers/clocksource/fsl_ftm_timer.c
index 13222c1..c4d23d0f 100644
--- a/drivers/clocksource/fsl_ftm_timer.c
+++ b/drivers/clocksource/fsl_ftm_timer.c
@@ -226,6 +226,11 @@ static int __init ftm_clockevent_init(unsigned long freq, int irq)
 	return 0;
 }
 
+static cycle_t ftm_clocksource_read_up(struct clocksource *c)
+{
+	return ftm_readl(clksrc_base + FTM_CNT) & 0xffff;
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
1.8.5

