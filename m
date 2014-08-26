Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbaHZFua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:50:30 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:3800
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757155AbaHZFu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:50:27 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>
CC: <dongsheng.wang@freescale.com>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 5/5] Clocksource: Flextimer: Use Macro for clock source selection.
Date: Tue, 26 Aug 2014 13:45:51 +0800
Message-ID: <1409031951-39021-6-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(69596002)(19580405001)(77156001)(26826002)(92726001)(229853001)(104166001)(50466002)(106466001)(93916002)(107046002)(84676001)(6806004)(81542001)(44976005)(64706001)(31966008)(92566001)(48376002)(76176999)(95666004)(47776003)(74502001)(4396001)(83072002)(104016003)(102836001)(79102001)(85852003)(20776003)(76482001)(88136002)(87936001)(83322001)(90102001)(46102001)(80022001)(77982001)(105606002)(62966002)(74662001)(81342001)(36756003)(99396002)(50986999)(87286001)(97736001)(50226001)(81156004)(89996001)(85306004)(19580395003)(86362001)(68736004)(21056001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB178;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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

FTM source clock is selectable:
Source clock can be the system clock, the fixed frequency clock,
or an external clock.
Fixed frequency clock is an additional clock input to allow the
selection of an on chip clock source other than the system clock.
Selecting external clock connects FTM clock to a chip level input
pin therefore allowing to synchronize the FTM counter with an off
chip clock source

Clock Source Selection:
Selects one of the three FTM counter clock sources.

00 No clock selected. This in effect disables the FTM counter.
01 System clock
---
10 Fixed frequency clock
11 External clock

These two will be useful for the alarm on LS1 platform in late future,
the system clock's frequency is too high to get a long delay timer when
go to sleep, so the fixed or external clock could be used instead.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
Cc: Wang Dongsheng <dongsheng.wang@freescale.com>
---
 drivers/clocksource/fsl_ftm_timer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/fsl_ftm_timer.c b/drivers/clocksource/fsl_ftm_timer.c
index 974890e..3935ba2 100644
--- a/drivers/clocksource/fsl_ftm_timer.c
+++ b/drivers/clocksource/fsl_ftm_timer.c
@@ -21,6 +21,8 @@
 #include <linux/slab.h>
 
 #define FTM_SC		0x00
+#define FTM_SC_CLKS_NON		0
+#define FTM_SC_CLKS_SYS		1
 #define FTM_SC_CLK_SHIFT	3
 #define FTM_SC_CLK_MASK	(0x3 << FTM_SC_CLK_SHIFT)
 #define FTM_SC_CLK(c)	((c) << FTM_SC_CLK_SHIFT)
@@ -67,7 +69,7 @@ static inline void ftm_counter_enable(void __iomem *base)
 	/* select and enable counter clock source */
 	val = ftm_readl(base + FTM_SC);
 	val &= ~(FTM_SC_PS_MASK | FTM_SC_CLK_MASK);
-	val |= priv->ps | FTM_SC_CLK(1);
+	val |= priv->ps | FTM_SC_CLK(FTM_SC_CLKS_SYS);
 	ftm_writel(val, base + FTM_SC);
 }
 
@@ -77,7 +79,8 @@ static inline void ftm_counter_disable(void __iomem *base)
 
 	/* disable counter clock source */
 	val = ftm_readl(base + FTM_SC);
-	val &= ~(FTM_SC_PS_MASK | FTM_SC_CLK_MASK);
+	val &= ~(FTM_SC_CLK_MASK);
+	val |= FTM_SC_CLK(FTM_SC_CLKS_NON);
 	ftm_writel(val, base + FTM_SC);
 }
 
-- 
1.8.5

