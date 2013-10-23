Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab3JWFDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 01:03:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60314 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3JWFDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 01:03:00 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <526757E7.2000904@jp.fujitsu.com>
Date: Wed, 23 Oct 2013 14:00:23 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: [PATCH] x86, procfs: remove condition for show_cpuinfo_core()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show_cpuinfo_core() has displayed cpu core information only if the
number of threads per a whole cores is strictly larger than 1. But
this condition doesn't care about the number of sockets. This doesn't
cover, for example, the system with two logical cpus consisting of two
sockets and a single core on each socket.

However, this information is useful even if there's only 1 thread. So,
how to fix it here is to simply remove the condition, instead of
fixing the condition.

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


