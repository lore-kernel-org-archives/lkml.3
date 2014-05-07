Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaEGXvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:51:15 -0400
Received: from mail-ob0-f201.google.com ([209.85.214.201]:36109 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaEGXvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:51:14 -0400
From: Doug Anderson <dianders@chromium.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: John Stultz <john.stultz@linaro.org>,
        David Riley <davidriley@chromium.org>,
        Will Deacon <Will.Deacon@arm.com>, olof@lixom.net,
        Sonny Rao <sonnyrao@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] init: Don't decrease loops_per_jiffy when a CPU comes up
Date: Wed,  7 May 2014 16:50:51 -0700
Message-Id: <1399506651-20031-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loops_per_jiffy count continues to be updated as each CPU is
brought up.  This causes problems when we've got an HMP system and
different CPUs have different loops per jiffy.  On exynos 542x
systems, for instance, the A7s will have significantly lower loops per
jiffy than their big brothers.

We should always set the loops_per_jiffy the first time through, then
use the max.

One could argue that complex HMP systems should really be completely
ignoring the global loops_per_jiffy variable anyway.  That's probably
why nobody has fixed this before.  With that argument you could say
that while this change isn't incorrect, it's a bit misguided.  Still,
it doesn't hurt and provides a better fallback than we had without
this.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 init/calibrate.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 520702d..073bf9b 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -265,40 +265,44 @@ unsigned long __attribute__((weak)) calibrate_delay_is_known(void)
 void calibrate_delay(void)
 {
 	unsigned long lpj;
-	static bool printed;
+	static bool already_ran;
 	int this_cpu = smp_processor_id();
 
 	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
 		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
-		if (!printed)
+		if (!already_ran)
 			pr_info("Calibrating delay loop (skipped) "
 				"already calibrated this CPU");
 	} else if (preset_lpj) {
 		lpj = preset_lpj;
-		if (!printed)
+		if (!already_ran)
 			pr_info("Calibrating delay loop (skipped) "
 				"preset value.. ");
-	} else if ((!printed) && lpj_fine) {
+	} else if ((!already_ran) && lpj_fine) {
 		lpj = lpj_fine;
 		pr_info("Calibrating delay loop (skipped), "
 			"value calculated using timer frequency.. ");
 	} else if ((lpj = calibrate_delay_is_known())) {
 		;
 	} else if ((lpj = calibrate_delay_direct()) != 0) {
-		if (!printed)
+		if (!already_ran)
 			pr_info("Calibrating delay using timer "
 				"specific routine.. ");
 	} else {
-		if (!printed)
+		if (!already_ran)
 			pr_info("Calibrating delay loop... ");
 		lpj = calibrate_delay_converge();
 	}
 	per_cpu(cpu_loops_per_jiffy, this_cpu) = lpj;
-	if (!printed)
+	if (!already_ran) {
 		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
 			lpj/(500000/HZ),
 			(lpj/(5000/HZ)) % 100, lpj);
 
-	loops_per_jiffy = lpj;
-	printed = true;
+		loops_per_jiffy = lpj;
+	} else {
+		loops_per_jiffy = max(loops_per_jiffy, lpj);
+	}
+
+	already_ran = true;
 }
-- 
1.9.1.423.g4596e3a

