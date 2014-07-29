Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaG2JY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:24:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:50328 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbaG2JY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:24:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,755,1400050800"; 
   d="scan'208";a="568822416"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org, Zhang Yang <yang.z.zhang@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v4] x86, hotplug: fix llc shared map unreleased during cpu hotplug
Date: Tue, 29 Jul 2014 17:24:43 +0800
Message-Id: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
IP: [..] find_busiest_group
PGD 5a9d5067 PUD 13067 PMD 0
Oops: 0000 [#3] SMP
[...]
Call Trace:
load_balance
? _raw_spin_unlock_irqrestore
idle_balance
__schedule
schedule
schedule_timeout
? lock_timer_base
schedule_timeout_uninterruptible
msleep
lock_device_hotplug_sysfs
online_store
dev_attr_store
sysfs_write_file
vfs_write
SyS_write
system_call_fastpath

Last level cache shared map is built during cpu up and build sched domain 
routine takes advantage of it to setup sched domain cpu topology, however, 
llc shared map is unreleased during cpu disable which lead to invalid sched 
domain cpu topology. This patch fix it by release llc shared map correctly
during cpu disable.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v1 -> v2:
 * fix subject line
v2 -> v3:
 * simplify backtrace 

 arch/x86/kernel/smpboot.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5492798..0134ec7 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1292,6 +1292,9 @@ static void remove_siblinginfo(int cpu)
 
 	for_each_cpu(sibling, cpu_sibling_mask(cpu))
 		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
+	for_each_cpu(sibling, cpu_llc_shared_mask(cpu))
+		cpumask_clear_cpu(cpu, cpu_llc_shared_mask(sibling));
+	cpumask_clear(cpu_llc_shared_mask(cpu));
 	cpumask_clear(cpu_sibling_mask(cpu));
 	cpumask_clear(cpu_core_mask(cpu));
 	c->phys_proc_id = 0;
-- 
1.9.1

