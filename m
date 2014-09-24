Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaIXIiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:38:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:19422 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbaIXIiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:38:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="604533819"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
        Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v7] sched: fix llc shared map unreleased during cpu hotplug
Date: Wed, 24 Sep 2014 16:38:05 +0800
Message-Id: <1411547885-48165-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
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

This bug can be triggered by hot add and remove large number of xen
domain0's vcpus repeatly.

Last level cache shared map is built during cpu up and build sched domain 
routine takes advantage of it to setup sched domain cpu topology, however, 
llc shared map is unreleased during cpu disable which lead to invalid sched 
domain cpu topology. This patch fix it by release llc shared map correctly
during cpu disable.

Yasuaki also reported this can happen on their real hardware. 
https://lkml.org/lkml/2014/7/22/1018

His case is here.
==
Here is a example on my system.
My system has 4 sockets and each socket has 15 cores and HT is enabled.
In this case, each core of sockes is numbered as follows:

          | CPU#
Socket#0 | 0-14 , 60-74
Socket#1 | 15-29, 75-89
Socket#2 | 30-44, 90-104
Socket#3 | 45-59, 105-119
Then llc_shared_mask of CPU#30 has 0x3fff80000001fffc0000000.
It means that last level cache of Socket#2 is shared with
CPU#30-44 and 90-104.
When hot-removing socket#2 and #3, each core of sockets is numbered
as follows:

          | CPU#
Socket#0 | 0-14 , 60-74
Socket#1 | 15-29, 75-89
But llc_shared_mask is not cleared. So llc_shared_mask of CPU#30 remains
having 0x3fff80000001fffc0000000.
After that, when hot-adding socket#2 and #3, each core of sockets is
numbered as follows:

          | CPU#
Socket#0 | 0-14 , 60-74
Socket#1 | 15-29, 75-89
Socket#2 | 30-59
Socket#3 | 90-119
Then llc_shared_mask of CPU#30 becomes 0x3fff8000fffffffc0000000.
It means that last level cache of Socket#2 is shared with CPU#30-59
and 90-104. So the mask has wrong value.

Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: Linn Crosetto <linn@hp.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v6 -> v7:
 * cleanup changelog
v5 -> v6:
 * add the real-hardware reports to the changelog
v4 -> v5:
 * add the description when the bug can occur
v3 -> v4:
 * simplify backtrace
v2 -> v3:
 * simplify backtrace 
v1 -> v2:
 * fix subject line

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

