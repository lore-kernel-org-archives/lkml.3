Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3JIO52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:57:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34450 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753797Ab3JIO51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:57:27 -0400
From: Will Deacon <will.deacon@arm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: [PATCH] init: calibrate: don't print out bogomips value on boot
Date: Wed,  9 Oct 2013 15:57:20 +0100
Message-Id: <1381330640-32735-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BogoMIPs is a confusing concept to the ill-informed, so allow
architectures to print it only if they find it worthwhile. The delay
calibration code should stick to lpj and avoid trying to draw any
correlation with BogoMIPs, which may be a fixed value derived from a
timer frequency independent of the CPU clock speed.

Acked-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

This is mostly cosmetic, but we've killed bogomips from the cpuinfo
on ARM and arm64, so this would be the final nail on the coffin...

 init/calibrate.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 520702d..eabc2ca 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -135,13 +135,13 @@ static unsigned long calibrate_delay_direct(void)
 		if ((measured_times[max] - estimate) <
 				(estimate - measured_times[min])) {
 			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
-					"min bogoMips estimate %d = %lu\n",
+					"min delay estimate %d = %lu\n",
 				min, measured_times[min]);
 			measured_times[min] = 0;
 			min = max;
 		} else {
 			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
-					"max bogoMips estimate %d = %lu\n",
+					"max delay estimate %d = %lu\n",
 				max, measured_times[max]);
 			measured_times[max] = 0;
 			max = min;
@@ -295,9 +295,7 @@ void calibrate_delay(void)
 	}
 	per_cpu(cpu_loops_per_jiffy, this_cpu) = lpj;
 	if (!printed)
-		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
-			lpj/(500000/HZ),
-			(lpj/(5000/HZ)) % 100, lpj);
+		pr_cont("lpj=%lu\n", lpj);
 
 	loops_per_jiffy = lpj;
 	printed = true;
-- 
1.8.2.2

