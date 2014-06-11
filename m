Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaFKJWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:22:04 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:25670
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750751AbaFKJWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:22:02 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] clocksource: arch_arm_timer: Fix timecounter initialization
Date: Wed, 11 Jun 2014 16:37:41 +0800
Message-ID: <1402475861-15354-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(81542001)(50226001)(4396001)(26826002)(50466002)(31966008)(74502001)(50986999)(19580405001)(46102001)(83072002)(104166001)(44976005)(19580395003)(21056001)(97736001)(88136002)(104016001)(64706001)(36756003)(20776003)(102836001)(77096999)(47776003)(74662001)(89996001)(68736004)(79102001)(99396002)(80022001)(81342001)(48376002)(87286001)(77156001)(86362001)(93916002)(92726001)(92566001)(2201001)(87936001)(84676001)(83322001)(62966002)(85852003)(77982001)(76482001)(6806004);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB508;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0239D46DB6
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The third parameter(u64 start_tstamp) of timecounter_init() should
be the start time by ns, not a cycle counter.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/clocksource/arm_arch_timer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 5163ec1..6c3cfd8 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -426,7 +426,7 @@ struct timecounter *arch_timer_get_timecounter(void)
 
 static void __init arch_counter_register(unsigned type)
 {
-	u64 start_count;
+	u64 start_count, start_ns;
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_CP15_TIMER)
@@ -438,7 +438,8 @@ static void __init arch_counter_register(unsigned type)
 	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
 	cyclecounter.mult = clocksource_counter.mult;
 	cyclecounter.shift = clocksource_counter.shift;
-	timecounter_init(&timecounter, &cyclecounter, start_count);
+	start_ns = cyclecounter_cyc2ns(&cyclecounter, start_count);
+	timecounter_init(&timecounter, &cyclecounter, start_ns);
 
 	/* 56 bits minimum, so we assume worst case rollover */
 	sched_clock_register(arch_timer_read_counter, 56, arch_timer_rate);
-- 
1.8.5

