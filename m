Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbaDNVKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:10:22 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54772 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754766AbaDNVKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:10:19 -0400
Message-ID: <534C4EB8.9080704@semaphore.gr>
Date: Tue, 15 Apr 2014 00:10:16 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/20] mfd: db8500-prcmu: Use cpufreq_for_each_entry macro
 for iteration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq core supports the cpufreq_for_each_entry macro helper
for iteration over the cpufreq_frequency_table, so use it.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/mfd/db8500-prcmu.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 7694e07..3429e4f 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1734,18 +1734,17 @@ static struct cpufreq_frequency_table db8500_cpufreq_table[] = {
 
 static long round_armss_rate(unsigned long rate)
 {
+	struct cpufreq_frequency_table *pos;
 	long freq = 0;
-	int i = 0;
 
 	/* cpufreq table frequencies is in KHz. */
 	rate = rate / 1000;
 
 	/* Find the corresponding arm opp from the cpufreq table. */
-	while (db8500_cpufreq_table[i].frequency != CPUFREQ_TABLE_END) {
-		freq = db8500_cpufreq_table[i].frequency;
+	cpufreq_for_each_entry(pos, db8500_cpufreq_table) {
+		freq = pos->frequency;
 		if (freq == rate)
 			break;
-		i++;
 	}
 
 	/* Return the last valid value, even if a match was not found. */
@@ -1886,23 +1885,22 @@ static void set_clock_rate(u8 clock, unsigned long rate)
 
 static int set_armss_rate(unsigned long rate)
 {
-	int i = 0;
+	struct cpufreq_frequency_table *pos;
 
 	/* cpufreq table frequencies is in KHz. */
 	rate = rate / 1000;
 
 	/* Find the corresponding arm opp from the cpufreq table. */
-	while (db8500_cpufreq_table[i].frequency != CPUFREQ_TABLE_END) {
-		if (db8500_cpufreq_table[i].frequency == rate)
+	cpufreq_for_each_entry(pos, db8500_cpufreq_table) {
+		if (pos->frequency == rate)
 			break;
-		i++;
 	}
 
-	if (db8500_cpufreq_table[i].frequency != rate)
+	if (pos->frequency != rate)
 		return -EINVAL;
 
 	/* Set the new arm opp. */
-	return db8500_prcmu_set_arm_opp(db8500_cpufreq_table[i].driver_data);
+	return db8500_prcmu_set_arm_opp(pos->driver_data);
 }
 
 static int set_plldsi_rate(unsigned long rate)
-- 
1.9.0
