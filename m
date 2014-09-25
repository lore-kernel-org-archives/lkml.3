Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaIYIg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:36:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:57318 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaIYIgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:36:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,595,1406617200"; 
   d="scan'208";a="596612049"
From: Lan Tianyu <tianyu.lan@intel.com>
To: peterz@infradead.org, mingo@kernel.org, rafael.j.wysocki@intel.com,
        srivatsa.bhat@linux.vnet.ibm.com, toshi.kani@hp.com,
        tianyu.lan@intel.com, ego@linux.vnet.ibm.com, ktkhai@parallels.com,
        laijs@cn.fujitsu.com, todd.e.brandt@linux.intel.com, srivatsa@mit.edu,
        fabf@skynet.be, viresh.kumar@linaro.org
Cc: akpm@linux-foundation.org, tipbot@zytor.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [RFC PATCH V2 2/3] X86/CPU: Initialize MTRR/PAT when each cpu is online during system resume.
Date: Thu, 25 Sep 2014 16:32:04 +0800
Message-Id: <1411633925-9018-3-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411633925-9018-1-git-send-email-tianyu.lan@intel.com>
References: <1411633925-9018-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDM Vol 3a section titled "MTRR considerations in MP systems" specifies
the need for synchronizing the logical cpu's while initializing/updating
MTRR.

Commit d0af9eed5a(x86, pat/mtrr: Rendezvous all the cpus for MTRR/PAT init)
delay the MTRR/PAT init for APs till all the logical cpu's come online and
the rendezvous process at the end of AP's bringup, will initialize the MTRR/PAT
for all AP's during boot and resume.

Currently, APs enabling are paralleled with resume devices during system resume
and the AP will be assigned with task before all APs' bringup. MTRR/PAT should
be initialized before running tasks. So this patch is to remove
set_mtrr_aps_delayed_init() for system resume and do the MTRR/PAT init when
the AP comes online just like dynamic single cpu online.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 kernel/cpu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 24c4889..30ffdd9 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -592,13 +592,10 @@ static int async_enable_nonboot_cpus(void *data)
 {
 	int cpu;
 
-	arch_enable_nonboot_cpus_begin();
-
 	for_each_cpu(cpu, frozen_cpus) {
 		_cpu_up_for_pm(cpu);
 	}
 
-	arch_enable_nonboot_cpus_end();
 	cpumask_clear(frozen_cpus);
 	cpu_maps_update_done();
 	return 0;
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

