Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbaKROqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:46:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbaKROKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:02 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 130/206] cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy
Date: Tue, 18 Nov 2014 15:08:05 +0100
Message-Id: <0d29536419e8608288753527f09c2e27ce03b7a3.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/cpufreq/intel_pstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index f033fadb58e6..132a9139c19f 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -600,6 +600,7 @@ static int intel_pstate_set_policy(struct cpufreq_policy *policy)
 	if (policy->policy == CPUFREQ_POLICY_PERFORMANCE) {
 		limits.min_perf_pct = 100;
 		limits.min_perf = int_tofp(1);
+		limits.max_policy_pct = 100;
 		limits.max_perf_pct = 100;
 		limits.max_perf = int_tofp(1);
 		limits.no_turbo = 0;
-- 
2.1.3

