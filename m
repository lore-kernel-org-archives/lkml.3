Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750931AbaENSF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:05:59 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:46114 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750741AbaENSF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:05:57 -0400
Message-ID: <5373B080.3050907@semaphore.gr>
Date: Wed, 14 May 2014 21:05:52 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] cpufreq: Break out early when frequency equals target_freq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many drivers keep frequencies in frequency table in ascending
or descending order. When governor tries to change to policy->min
or policy->max respectively then the cpufreq_frequency_table_target
could return on first iteration. This will save some iteration cycles.

So, break out early when a frequency in cpufreq_frequency_table
equals to target one.

Testing this during kernel compilation using ondemand governor
with a frequency table in ascending order, the
cpufreq_frequency_table_target returned early on the first
iteration at about 30% of times called.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/freq_table.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 8e518c6..1632981 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -137,9 +137,13 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 		i = pos - table;
 		if ((freq < policy->min) || (freq > policy->max))
 			continue;
+		if (freq == target_freq) {
+			optimal.driver_data = i;
+			break;
+		}
 		switch (relation) {
 		case CPUFREQ_RELATION_H:
-			if (freq <= target_freq) {
+			if (freq < target_freq) {
 				if (freq >= optimal.frequency) {
 					optimal.frequency = freq;
 					optimal.driver_data = i;
@@ -152,7 +156,7 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 			}
 			break;
 		case CPUFREQ_RELATION_L:
-			if (freq >= target_freq) {
+			if (freq > target_freq) {
 				if (freq <= optimal.frequency) {
 					optimal.frequency = freq;
 					optimal.driver_data = i;
-- 
1.9.0
