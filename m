Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaFDXzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:55:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbaFDXXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick Marlier <patrick.marlier@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 211/228] intel_pstate: remove setting P state to MAX on init
Date: Wed,  4 Jun 2014 16:24:00 -0700
Message-Id: <20140604232354.827268316@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit d40a63c45b506b0681918d7c62a15cc9d48c8681 upstream.

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
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -555,12 +555,7 @@ static void intel_pstate_get_cpu_pstates
 
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
@@ -706,11 +701,6 @@ static int intel_pstate_init_cpu(unsigne
 	cpu = all_cpu_data[cpunum];
 
 	intel_pstate_get_cpu_pstates(cpu);
-	if (!cpu->pstate.current_pstate) {
-		all_cpu_data[cpunum] = NULL;
-		kfree(cpu);
-		return -ENODATA;
-	}
 
 	cpu->cpu = cpunum;
 
@@ -721,7 +711,6 @@ static int intel_pstate_init_cpu(unsigne
 	cpu->timer.expires = jiffies + HZ/100;
 	intel_pstate_busy_pid_reset(cpu);
 	intel_pstate_sample(cpu);
-	intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
 
 	add_timer_on(&cpu->timer, cpunum);
 


