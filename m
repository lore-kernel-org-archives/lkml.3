Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaKKMBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:01:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57288 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbaKKLJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 041/170] cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy
Date: Tue, 11 Nov 2014 11:06:40 +0000
Message-Id: <1415704129-12709-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>

commit 36b4bed5cd8f6e17019fa7d380e0836872c7b367 upstream.

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
Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 86631cb6f7de..738f5c85b5ca 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -742,6 +742,7 @@ static int intel_pstate_set_policy(struct cpufreq_policy *policy)
 	if (policy->policy == CPUFREQ_POLICY_PERFORMANCE) {
 		limits.min_perf_pct = 100;
 		limits.min_perf = int_tofp(1);
+		limits.max_policy_pct = 100;
 		limits.max_perf_pct = 100;
 		limits.max_perf = int_tofp(1);
 		limits.no_turbo = limits.turbo_disabled;
-- 
2.1.0

