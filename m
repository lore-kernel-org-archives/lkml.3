Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934961AbaGRNMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:12:17 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17620 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934818AbaGRNMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:12:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vincent Minet <vincent@vincent-minet.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 155/170] intel_pstate: Set CPU number before accessing MSRs
Date: Fri, 18 Jul 2014 14:12:40 +0200
Message-Id: <c3a3f8463085292962a244908e56e7266c23974c.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Minet <vincent@vincent-minet.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/cpufreq/intel_pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index d5dc567efd96..f033fadb58e6 100644
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
2.0.0

