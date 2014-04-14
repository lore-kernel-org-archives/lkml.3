Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaDNVJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:09:33 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54750 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755598AbaDNVJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:09:29 -0400
Message-ID: <534C4E86.4060304@semaphore.gr>
Date: Tue, 15 Apr 2014 00:09:26 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/20] cpufreq: longhaul: Use cpufreq_for_each_entry macro
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
 drivers/cpufreq/longhaul.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index d00e5d1..6de99c4 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -528,6 +528,7 @@ static int longhaul_get_ranges(void)
 
 static void longhaul_setup_voltagescaling(void)
 {
+	struct cpufreq_frequency_table *freq;
 	union msr_longhaul longhaul;
 	struct mV_pos minvid, maxvid, vid;
 	unsigned int j, speed, pos, kHz_step, numvscales;
@@ -606,18 +607,16 @@ static void longhaul_setup_voltagescaling(void)
 	/* Calculate kHz for one voltage step */
 	kHz_step = (highest_speed - min_vid_speed) / numvscales;
 
-	j = 0;
-	while (longhaul_table[j].frequency != CPUFREQ_TABLE_END) {
-		speed = longhaul_table[j].frequency;
+	cpufreq_for_each_entry(freq, longhaul_table) {
+		speed = freq->frequency;
 		if (speed > min_vid_speed)
 			pos = (speed - min_vid_speed) / kHz_step + minvid.pos;
 		else
 			pos = minvid.pos;
-		longhaul_table[j].driver_data |= mV_vrm_table[pos] << 8;
+		freq->driver_data |= mV_vrm_table[pos] << 8;
 		vid = vrm_mV_table[mV_vrm_table[pos]];
-		printk(KERN_INFO PFX "f: %d kHz, index: %d, vid: %d mV\n",
-				speed, j, vid.mV);
-		j++;
+		printk(KERN_INFO PFX "f: %d kHz, index: %lu, vid: %d mV\n",
+				speed, freq - longhaul_table, vid.mV);
 	}
 
 	can_scale_voltage = 1;
-- 
1.9.0
