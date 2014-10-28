Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaJ1Dka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:40:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbaJ1DkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:40:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Cyril Bur <cyril.bur@au1.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 3.17 114/146] powerpc: Only set numa node information for present cpus at boottime
Date: Tue, 28 Oct 2014 11:34:16 +0800
Message-Id: <20141028033348.394403008@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhong <zhong@linux.vnet.ibm.com>

commit bc3c4327c92b9ceb9a6356ec64d1b2ab2dc851f9 upstream.

As Nish suggested, it makes more sense to init the numa node informatiion
for present cpus at boottime, which could also avoid WARN_ON(1) in
numa_setup_cpu().

With this change, we also need to change the smp_prepare_cpus() to set up
numa information only on present cpus.

For those possible, but not present cpus, their numa information
will be set up after they are started, as the original code did before commit
2fabf084b6ad.

Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Acked-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Tested-by: Cyril Bur <cyril.bur@au1.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/smp.c |   10 ++++++++--
 arch/powerpc/mm/numa.c    |    2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -379,8 +379,11 @@ void __init smp_prepare_cpus(unsigned in
 		/*
 		 * numa_node_id() works after this.
 		 */
-		set_cpu_numa_node(cpu, numa_cpu_lookup_table[cpu]);
-		set_cpu_numa_mem(cpu, local_memory_node(numa_cpu_lookup_table[cpu]));
+		if (cpu_present(cpu)) {
+			set_cpu_numa_node(cpu, numa_cpu_lookup_table[cpu]);
+			set_cpu_numa_mem(cpu,
+				local_memory_node(numa_cpu_lookup_table[cpu]));
+		}
 	}
 
 	cpumask_set_cpu(boot_cpuid, cpu_sibling_mask(boot_cpuid));
@@ -728,6 +731,9 @@ void start_secondary(void *unused)
 	}
 	traverse_core_siblings(cpu, true);
 
+	set_numa_node(numa_cpu_lookup_table[cpu]);
+	set_numa_mem(local_memory_node(numa_cpu_lookup_table[cpu]));
+
 	smp_wmb();
 	notify_cpu_starting(cpu);
 	set_cpu_online(cpu, true);
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1127,7 +1127,7 @@ void __init do_init_bootmem(void)
 	 * even before we online them, so that we can use cpu_to_{node,mem}
 	 * early in boot, cf. smp_prepare_cpus().
 	 */
-	for_each_possible_cpu(cpu) {
+	for_each_present_cpu(cpu) {
 		numa_setup_cpu((unsigned long)cpu);
 	}
 }


