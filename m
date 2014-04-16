Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaDPKyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:54:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51637 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbaDPKcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 08/46] powernow-k6: reorder frequencies
Date: Wed, 16 Apr 2014 11:31:24 +0100
Message-Id: <1397644322-13905-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 22c73795b101597051924556dce019385a1e2fa0 upstream.

This patch reorders reported frequencies from the highest to the lowest,
just like in other frequency drivers.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/powernow-k6.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 656c135..396f357 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -37,17 +37,20 @@ MODULE_PARM_DESC(bus_frequency, "Bus frequency in kHz");
 
 /* Clock ratio multiplied by 10 - see table 27 in AMD#23446 */
 static struct cpufreq_frequency_table clock_ratio[] = {
-	{45,  /* 000 -> 4.5x */ 0},
+	{60,  /* 110 -> 6.0x */ 0},
+	{55,  /* 011 -> 5.5x */ 0},
 	{50,  /* 001 -> 5.0x */ 0},
+	{45,  /* 000 -> 4.5x */ 0},
 	{40,  /* 010 -> 4.0x */ 0},
-	{55,  /* 011 -> 5.5x */ 0},
-	{20,  /* 100 -> 2.0x */ 0},
-	{30,  /* 101 -> 3.0x */ 0},
-	{60,  /* 110 -> 6.0x */ 0},
 	{35,  /* 111 -> 3.5x */ 0},
+	{30,  /* 101 -> 3.0x */ 0},
+	{20,  /* 100 -> 2.0x */ 0},
 	{0, CPUFREQ_TABLE_END}
 };
 
+static const u8 index_to_register[8] = { 6, 3, 1, 0, 2, 7, 5, 4 };
+static const u8 register_to_index[8] = { 3, 2, 4, 1, 7, 6, 0, 5 };
+
 static const struct {
 	unsigned freq;
 	unsigned mult;
@@ -91,7 +94,7 @@ static int powernow_k6_get_cpu_multiplier(void)
 
 	local_irq_enable();
 
-	return clock_ratio[(invalue >> 5)&7].driver_data;
+	return clock_ratio[register_to_index[(invalue >> 5)&7]].driver_data;
 }
 
 static void powernow_k6_set_cpu_multiplier(unsigned int best_i)
@@ -111,7 +114,7 @@ static void powernow_k6_set_cpu_multiplier(unsigned int best_i)
 	write_cr0(cr0 | X86_CR0_CD);
 	wbinvd();
 
-	outvalue = (1<<12) | (1<<10) | (1<<9) | (best_i<<5);
+	outvalue = (1<<12) | (1<<10) | (1<<9) | (index_to_register[best_i]<<5);
 
 	msrval = POWERNOW_IOPORT + 0x1;
 	wrmsr(MSR_K6_EPMR, msrval, 0); /* enable the PowerNow port */
-- 
1.9.1

