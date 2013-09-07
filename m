Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060Ab3IGQfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 12:35:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49153 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3IGQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 12:35:15 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] cpufreq: Fix wrong time unit conversion
Date: Sat,  7 Sep 2013 18:35:08 +0200
Message-Id: <1378571708-27825-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The time spent by a CPU under a given frequency is stored in jiffies unit
in the cpu var cpufreq_stats_table->time_in_state[i], i being the index of
the frequency.

This is what is displayed in the following file on the right column:

     cat /sys/devices/system/cpu/cpuX/cpufreq/stats/time_in_state
     2301000 19835820
     2300000 3172
     [...]

Now cpufreq converts this jiffies unit delta to clock_t before returning it
to the user as in the above file. And that conversion is achieved using the API
cputime64_to_clock_t().

Although it accidentally works on traditional tick based cputime accounting, where
cputime_t maps directly to jiffies, it doesn't work with other types of cputime
accounting such as CONFIG_VIRT_CPU_ACCOUNTING_* where cputime_t can map to nsecs
or any granularity preffered by the architecture.

For example we get a buggy zero delta on full dyntick configurations:

     cat /sys/devices/system/cpu/cpuX/cpufreq/stats/time_in_state
     2301000 0
     2300000 0
     [...]

Fix this with using the proper jiffies_64_t to clock_t conversion.

Reported-by: Carsten Emde <C.Emde@osadl.org>
Tested-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Carsten Emde <C.Emde@osadl.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Clark Williams <williams@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 drivers/cpufreq/cpufreq_stats.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index d37568c..10e6138 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -81,7 +81,7 @@ static ssize_t show_time_in_state(struct cpufreq_policy *policy, char *buf)
 	for (i = 0; i < stat->state_num; i++) {
 		len += sprintf(buf + len, "%u %llu\n", stat->freq_table[i],
 			(unsigned long long)
-			cputime64_to_clock_t(stat->time_in_state[i]));
+			jiffies_64_to_clock_t(stat->time_in_state[i]));
 	}
 	return len;
 }
-- 
1.7.5.4

