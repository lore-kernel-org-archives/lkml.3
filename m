Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaJOXSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 19:18:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37483 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaJOXSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 19:18:00 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pali.rohar@gmail.com
Subject: [PATCH] cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy
Date: Thu, 16 Oct 2014 01:16:51 +0200
Message-Id: <1413415011-31290-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code which changes policy to powersave changes also max_policy_pct based on
max_freq. Code which change max_perf_pct has upper limit base on value
max_policy_pct. When policy is changing from powersave back to performance
then max_policy_pct is not changed. Which means that changing max_perf_pct is
not possible to high values if max_freq was too low in powersave policy.

Test case:

$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
800000
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
3300000
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
performance
$ cat /sys/devices/system/cpu/intel_pstate/max_perf_pct
100

$ echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
$ echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
$ echo 20 > /sys/devices/system/cpu/intel_pstate/max_perf_pct

$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
powersave
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
800000
$ cat /sys/devices/system/cpu/intel_pstate/max_perf_pct
20

$ echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
$ echo 3300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
$ echo 100 > /sys/devices/system/cpu/intel_pstate/max_perf_pct

$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
performance
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
3300000
$ cat /sys/devices/system/cpu/intel_pstate/max_perf_pct
24

And now intel_pstate driver allows to set maximal value for max_perf_pct based
on max_policy_pct which is 24 for previous powersave max_freq 800000.

This patch will set default value for max_policy_pct when setting policy to
performance so it will allow to set also max value for max_perf_pct.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/cpufreq/intel_pstate.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 0668b38..7547ab5 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -714,6 +714,7 @@ static int intel_pstate_set_policy(struct cpufreq_policy *policy)
 	if (policy->policy == CPUFREQ_POLICY_PERFORMANCE) {
 		limits.min_perf_pct = 100;
 		limits.min_perf = int_tofp(1);
+		limits.max_policy_pct = 100;
 		limits.max_perf_pct = 100;
 		limits.max_perf = int_tofp(1);
 		limits.no_turbo = limits.turbo_disabled;
-- 
1.7.9.5

