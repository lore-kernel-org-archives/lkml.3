Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbaGBGtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 02:49:36 -0400
Received: from fgwmail8.fujitsu.co.jp ([192.51.44.38]:32983 "EHLO
	fgwmail8.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaGBGte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 02:49:34 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2014 02:49:34 EDT
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53B3A991.2070502@jp.fujitsu.com>
Date: Wed, 2 Jul 2014 15:41:21 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
CC: <x86@kernel.org>, <toshi.kani@hp.com>, <imammedo@redhat.com>,
        <bp@alien8.de>, <huawei.libin@huawei.com>,
        <paul.gortmaker@windriver.com>, <linux-kernel@vger.kernel.org>,
        <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] x86,cpu-hotplug: clear llc_shared_mask at CPU hotplug
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

llc_shared_mask is not cleared even if cpu is offline or hot removed.
So when hot-plugging CPU, the mask has wrong value. The mask is used
by CSF schduler. So it breaks CFS scheduler.

Here is a example on my system.
My system has 4 sockets and each socket has 15 cores and HT is enabled.
In this case, each core of sockes is numbered as follows:

         | CPU#
Socket#0 | 0-14 , 60-74
Socket#1 | 15-29, 75-89
Socket#2 | 30-44, 90-104
Socket#3 | 45-59, 105-119

Then llc_shared_mask of CPU#30 has 0x3fff80000001fffc0000000.
It means that cache of Socket#2 is shared with CPU#30-44 and 90-104.

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
It means that cache of Socket#2 is shared with CPU#30-59 and 90-104.
So the mask has wrong value.

This patch fixes above problem by clearing llc_shared_mask bit of
offlined cpu.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 arch/x86/kernel/smpboot.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5492798..893cd2b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1279,6 +1279,7 @@ __init void prefill_possible_map(void)
 static void remove_siblinginfo(int cpu)
 {
 	int sibling;
+	int llc_shared;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);

 	for_each_cpu(sibling, cpu_core_mask(cpu)) {
@@ -1290,9 +1291,12 @@ static void remove_siblinginfo(int cpu)
 			cpu_data(sibling).booted_cores--;
 	}

+	for_each_cpu(llc_shared, cpu_llc_shared_mask(cpu))
+		cpumask_clear_cpu(cpu, cpu_llc_shared_mask(llc_shared));
 	for_each_cpu(sibling, cpu_sibling_mask(cpu))
 		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
 	cpumask_clear(cpu_sibling_mask(cpu));
+	cpumask_clear(cpu_llc_shared_mask(cpu));
 	cpumask_clear(cpu_core_mask(cpu));
 	c->phys_proc_id = 0;
 	c->cpu_core_id = 0;

