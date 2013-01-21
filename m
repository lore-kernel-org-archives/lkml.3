Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3AUGjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:39:01 -0500
Received: from mga03.intel.com ([143.182.124.21]:39002 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab3AUGi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:38:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,504,1355126400"; 
   d="scan'208";a="193316346"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [RFC PATCH 4/5] clocksource: Enlarge the maxim time interval when configuring the scale and shift
Date: Mon, 21 Jan 2013 14:38:44 +0800
Message-Id: <1358750325-21217-5-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On our x86 platform, we see a failure case of calling clocksource_cyc2ns(),
which return a negative value. The reason is the time interval was large
(more than 1000 seconds), while its TSC frequency is 2GHz, so the following
fomular overflowed:
	((u64) cycles * mult) >> shift

So enlarge the time interval from 10 mins to 40 mins to fix the bug.

Another solution may be adding a "max_interval" in struct clocksource, and
use a default value (like current 10 minutes) when clocksource driver
doesn't set it.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 kernel/time/clocksource.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c958338..48fbfcb 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -663,7 +663,7 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 	 * Calc the maximum number of seconds which we can run before
 	 * wrapping around. For clocksources which have a mask > 32bit
 	 * we need to limit the max sleep time to have a good
-	 * conversion precision. 10 minutes is still a reasonable
+	 * conversion precision. 40 minutes is still a reasonable
 	 * amount. That results in a shift value of 24 for a
 	 * clocksource with mask >= 40bit and f >= 4GHz. That maps to
 	 * ~ 0.06ppm granularity for NTP. We apply the same 12.5%
@@ -674,8 +674,8 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 	do_div(sec, scale);
 	if (!sec)
 		sec = 1;
-	else if (sec > 600 && cs->mask > UINT_MAX)
-		sec = 600;
+	else if (sec > 2400 && cs->mask > UINT_MAX)
+		sec = 2400;
 
 	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
 			       NSEC_PER_SEC / scale, sec * scale);
-- 
1.7.9.5

