Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaDUXBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 19:01:38 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:48648 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754743AbaDUXBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 19:01:32 -0400
Message-ID: <5355A349.50908@semaphore.gr>
Date: Tue, 22 Apr 2014 02:01:29 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: [PATCH v4 5/8] mfd: db8500-prcmu: Use cpufreq_for_each_entry macro
 for iteration
References: <534DB213.7080802@semaphore.gr>
In-Reply-To: <534DB213.7080802@semaphore.gr>
X-Forwarded-Message-Id: <534DB213.7080802@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq core now supports the cpufreq_for_each_entry macro helper
for iteration over the cpufreq_frequency_table, so use it.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/mfd/db8500-prcmu.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 7694e07..b11fdd6 100644
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
@@ -1886,23 +1885,21 @@ static void set_clock_rate(u8 clock, unsigned long rate)
 
 static int set_armss_rate(unsigned long rate)
 {
-	int i = 0;
+	struct cpufreq_frequency_table *pos;
 
 	/* cpufreq table frequencies is in KHz. */
 	rate = rate / 1000;
 
 	/* Find the corresponding arm opp from the cpufreq table. */
-	while (db8500_cpufreq_table[i].frequency != CPUFREQ_TABLE_END) {
-		if (db8500_cpufreq_table[i].frequency == rate)
+	cpufreq_for_each_entry(pos, db8500_cpufreq_table)
+		if (pos->frequency == rate)
 			break;
-		i++;
-	}
 
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
