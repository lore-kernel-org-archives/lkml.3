Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaDWCz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:55:59 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:26810
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755997AbaDWCz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:55:56 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
CC: Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 2/2] clocksource: fix clocksource_mmio_readX_down
Date: Wed, 23 Apr 2014 10:12:00 +0800
Message-ID: <1398219120-23029-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398219120-23029-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398219120-23029-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(87286001)(80976001)(92726001)(99396002)(4396001)(88136002)(62966002)(87936001)(76176999)(85852003)(50986999)(77156001)(74502001)(19580395003)(80022001)(89996001)(77982001)(86362001)(50466002)(93916002)(92566001)(50226001)(31966008)(36756003)(74662001)(19580405001)(83322001)(44976005)(81342001)(47776003)(20776003)(83072002)(48376002)(77096999)(2201001)(81542001)(6806004)(79102001)(46102001)(76482001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:az84smr01.freescale.net;FPR:EAD6D076.29E61C2C.79F12B40.A34AF441.20178;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 01901B3451
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some clocksource devices, for example, the registers are 32-bit, while
the lower 16-bit is used for timer counting(And reading the upper 16-bit
will return 0).

For example, when the counter value is 0x00001111, and then the
~readl_relaxed(to_mmio_clksrc(c)->reg) will return the value of 0xFFFFEEEE,
but it should be 0x0000EEEE.

So just using the c->mask to mask the unused bits.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/clocksource/mmio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
index 19a6b3f..1593ade 100644
--- a/drivers/clocksource/mmio.c
+++ b/drivers/clocksource/mmio.c
@@ -27,7 +27,7 @@ cycle_t clocksource_mmio_readl_up(struct clocksource *c)
 
 cycle_t clocksource_mmio_readl_down(struct clocksource *c)
 {
-	return ~(cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
+	return ~(cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 cycle_t clocksource_mmio_readw_up(struct clocksource *c)
@@ -37,7 +37,7 @@ cycle_t clocksource_mmio_readw_up(struct clocksource *c)
 
 cycle_t clocksource_mmio_readw_down(struct clocksource *c)
 {
-	return ~(cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
+	return ~(cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 /**
-- 
1.8.4

