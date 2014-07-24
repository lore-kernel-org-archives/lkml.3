Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935031AbaGXJ7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:59:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55104 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934702AbaGXJss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vincent Minet <vincent@vincent-minet.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 099/128] intel_pstate: Set CPU number before accessing MSRs
Date: Thu, 24 Jul 2014 10:45:48 +0100
Message-Id: <1406195177-8656-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Minet <vincent@vincent-minet.net>

commit 179e8471673ce0249cd4ecda796008f7757e5bad upstream.

Ensure that cpu->cpu is set before writing MSR_IA32_PERF_CTL during CPU
initialization. Otherwise only cpu0 has its P-state set and all other
cores are left with their values unchanged.

In most cases, this is not too serious because the P-states will be set
correctly when the timer function is run.  But when the default governor
is set to performance, the per-CPU current_pstate stays the same forever
and no attempts are made to write the MSRs again.

Signed-off-by: Vincent Minet <vincent@vincent-minet.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ luis: backported to 3.11:
  - moved cpu->cpu up, instead of intel_pstate_get_cpu_pstates() down ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index e52e5420033a..96a4c6e4d526 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -550,6 +550,7 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
 
 	cpu = all_cpu_data[cpunum];
 
+	cpu->cpu = cpunum;
 	intel_pstate_get_cpu_pstates(cpu);
 	if (!cpu->pstate.current_pstate) {
 		all_cpu_data[cpunum] = NULL;
@@ -557,7 +558,6 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
 		return -ENODATA;
 	}
 
-	cpu->cpu = cpunum;
 	cpu->pstate_policy =
 		(struct pstate_adjust_policy *)id->driver_data;
 	init_timer_deferrable(&cpu->timer);
-- 
1.9.1

