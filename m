Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaEHT5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:57:44 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:40336 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbaEHT5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:57:43 -0400
X-Google-Original-From: dirk.j.brandewie@intel.com
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: rjw@rjwysocki.net, dirk.brandewie@gmail.com,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 2/5] intel_pstate: remove setting P state to MAX on init
Date: Thu,  8 May 2014 12:57:24 -0700
Message-Id: <1399579047-5792-3-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Setting the P state of the core to max at init time is a hold over
from early implementation of intel_pstate where intel_pstate disabled
cpufreq and loaded VERY early in the boot sequence.  This was to
ensure that intel_pstate did not affect boot time. This in not needed
now that intel_pstate is a cpufreq driver.

Removing this covers the case where a CPU has gone through a manual
CPU offline/online cycle and the P state is set to MAX on init and the
CPU immediately goes idle.  Due to HW coordination the P state request
on the idle CPU will drag all cores to MAX P state until the load is
reevaluated when to core goes non-idle.

Reported-by: Patrick Marlier <patrick.marlier@gmail.com>

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 39c4f85..eab8ccf 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -554,12 +554,7 @@ static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 
 	if (pstate_funcs.get_vid)
 		pstate_funcs.get_vid(cpu);
-
-	/*
-	 * goto max pstate so we don't slow up boot if we are built-in if we are
-	 * a module we will take care of it during normal operation
-	 */
-	intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
+	intel_pstate_set_pstate(cpu, cpu->pstate.min_pstate);
 }
 
 static inline void intel_pstate_calc_busy(struct cpudata *cpu,
@@ -704,11 +699,6 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
 	cpu = all_cpu_data[cpunum];
 
 	intel_pstate_get_cpu_pstates(cpu);
-	if (!cpu->pstate.current_pstate) {
-		all_cpu_data[cpunum] = NULL;
-		kfree(cpu);
-		return -ENODATA;
-	}
 
 	cpu->cpu = cpunum;
 
@@ -719,7 +709,6 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
 	cpu->timer.expires = jiffies + HZ/100;
 	intel_pstate_busy_pid_reset(cpu);
 	intel_pstate_sample(cpu);
-	intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
 
 	add_timer_on(&cpu->timer, cpunum);
 
-- 
1.9.0

