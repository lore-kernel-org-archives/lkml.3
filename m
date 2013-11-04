Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3KDRQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:16:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38248 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3KDRQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:16:31 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5277D644.4090707@jp.fujitsu.com>
Date: Tue, 05 Nov 2013 02:15:48 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [RESEND][PATCH] x86, procfs: always print MP information in /proc/cpuinfo
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show_cpuinfo_core() has displayed cpu core information only if the
number of threads per a whole cores is strictly larger than 1.

However, this condition doesn't care about the number of sockets. For
example, this condition doesn't hold on the system with two logical
cpus consisting of two sockets and a single core on each socket.

I don't know whether or not there are processors in real world by
which such configurations are possible, but at least on vitual machine
environments, such configuration can occur, typically when no explicit
SMP information is provided in advance.

For example, on qemu/KVM, SMP information is specified via -smp
command-line option, more specifically, its syntax is:

  -smp n[,cores=cores][,threads=threads][,sockets=sockets][,maxcpus=maxcpus]

If this is not specified, qemu tells configuration with n-sockets,
1-core and 1-thread to the guest machine, on which guest, MP
information is not displayed in /proc/cpuinfo.

I saw this situation on VMWare guest environment, too.

To fix this issue, this patch simply removes the condition because
this information is useful even if there's only 1 thread.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/proc.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index aee6317..06fe3ed 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -11,15 +11,12 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 			      unsigned int cpu)
 {
 #ifdef CONFIG_SMP
-	if (c->x86_max_cores * smp_num_siblings > 1) {
-		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
-		seq_printf(m, "siblings\t: %d\n",
-			   cpumask_weight(cpu_core_mask(cpu)));
-		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
-		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
-		seq_printf(m, "apicid\t\t: %d\n", c->apicid);
-		seq_printf(m, "initial apicid\t: %d\n", c->initial_apicid);
-	}
+	seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
+	seq_printf(m, "siblings\t: %d\n", cpumask_weight(cpu_core_mask(cpu)));
+	seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
+	seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
+	seq_printf(m, "apicid\t\t: %d\n", c->apicid);
+	seq_printf(m, "initial apicid\t: %d\n", c->initial_apicid);
 #endif
 }
 
-- 
1.8.3.1

-- 
Thanks.
HATAYAMA, Daisuke

