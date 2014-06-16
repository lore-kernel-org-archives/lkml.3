Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaFPFwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 01:52:32 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:46381
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751103AbaFPFwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 01:52:31 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <sboyd@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2] clocksource: arch_arm_timer: Fix timecounter initialization
Date: Mon, 16 Jun 2014 13:08:38 +0800
Message-ID: <1402895318-26217-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(104166001)(74662001)(92566001)(21056001)(104016001)(68736004)(44976005)(2201001)(84676001)(19580405001)(92726001)(26826002)(74502001)(87936001)(50466002)(19580395003)(86362001)(77982001)(64706001)(6806004)(93916002)(83322001)(89996001)(85852003)(62966002)(87286001)(50226001)(4396001)(76482001)(77156001)(80022001)(20776003)(81542001)(102836001)(79102001)(81342001)(83072002)(50986999)(31966008)(99396002)(36756003)(48376002)(85306003)(88136002)(47776003)(97736001)(46102001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB509;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0244637DEA
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The third parameter(u64 start_tstamp) of timecounter_init() should
be the start time by ns, not a cycle counter.

Here just set it to zero.

Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/clocksource/arm_arch_timer.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 5163ec1..b29a810 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -426,19 +426,16 @@ struct timecounter *arch_timer_get_timecounter(void)
 
 static void __init arch_counter_register(unsigned type)
 {
-	u64 start_count;
-
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_CP15_TIMER)
 		arch_timer_read_counter = arch_counter_get_cntvct;
 	else
 		arch_timer_read_counter = arch_counter_get_cntvct_mem;
 
-	start_count = arch_timer_read_counter();
 	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
 	cyclecounter.mult = clocksource_counter.mult;
 	cyclecounter.shift = clocksource_counter.shift;
-	timecounter_init(&timecounter, &cyclecounter, start_count);
+	timecounter_init(&timecounter, &cyclecounter, 0);
 
 	/* 56 bits minimum, so we assume worst case rollover */
 	sched_clock_register(arch_timer_read_counter, 56, arch_timer_rate);
-- 
1.8.5

