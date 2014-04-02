Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbaDBDaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 23:30:11 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:32824 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbaDBDaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 23:30:09 -0400
Message-ID: <533B8431.8090507@linux.vnet.ibm.com>
Date: Wed, 02 Apr 2014 11:29:53 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        benh@kernel.crashing.org, paulus@samba.org, nfont@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>,
        rcj@linux.vnet.ibm.com, jlarrew@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, alistair@popple.id.au
Subject: [PATCH] power, sched: stop updating inside arch_update_cpu_topology()
 when nothing to be update
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040203-9264-0000-0000-000005C11422
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the testing, we encounter below WARN followed by Oops:

	WARNING: at kernel/sched/core.c:6218
	...
	NIP [c000000000101660] .build_sched_domains+0x11d0/0x1200
	LR [c000000000101358] .build_sched_domains+0xec8/0x1200
	PACATMSCRATCH [800000000000f032]
	Call Trace:
	[c00000001b103850] [c000000000101358] .build_sched_domains+0xec8/0x1200
	[c00000001b1039a0] [c00000000010aad4] .partition_sched_domains+0x484/0x510
	[c00000001b103aa0] [c00000000016d0a8] .rebuild_sched_domains+0x68/0xa0
	[c00000001b103b30] [c00000000005cbf0] .topology_work_fn+0x10/0x30
	...
	Oops: Kernel access of bad area, sig: 11 [#1]
	...
	NIP [c00000000045c000] .__bitmap_weight+0x60/0xf0
	LR [c00000000010132c] .build_sched_domains+0xe9c/0x1200
	PACATMSCRATCH [8000000000029032]
	Call Trace:
	[c00000001b1037a0] [c000000000288ff4] .kmem_cache_alloc_node_trace+0x184/0x3a0
	[c00000001b103850] [c00000000010132c] .build_sched_domains+0xe9c/0x1200
	[c00000001b1039a0] [c00000000010aad4] .partition_sched_domains+0x484/0x510
	[c00000001b103aa0] [c00000000016d0a8] .rebuild_sched_domains+0x68/0xa0
	[c00000001b103b30] [c00000000005cbf0] .topology_work_fn+0x10/0x30
	...

This was caused by that 'sd->groups == NULL' after building groups, which
was caused by the empty 'sd->span'.

The cpu's domain contain nothing because the cpu was assigned to wrong
node inside arch_update_cpu_topology() by calling update_lookup_table()
with the uninitialized param, in the case when there is nothing to be
update.

Thus we should stop the updating in such cases, this patch will achieve
this and fix the issue.

CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Nathan Fontenot <nfont@linux.vnet.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Robert Jennings <rcj@linux.vnet.ibm.com>
CC: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Alistair Popple <alistair@popple.id.au>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 arch/powerpc/mm/numa.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 30a42e2..6757690 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1591,6 +1591,14 @@ int arch_update_cpu_topology(void)
 		cpu = cpu_last_thread_sibling(cpu);
 	}
 
+	/*
+	 * The 'cpu_associativity_changes_mask' could be cleared if
+	 * all the cpus it indicates won't change their node, in
+	 * which case the 'updated_cpus' will be empty.
+	 */
+	if (!cpumask_weight(&updated_cpus))
+		goto out;
+
 	stop_machine(update_cpu_topology, &updates[0], &updated_cpus);
 
 	/*
@@ -1612,6 +1620,7 @@ int arch_update_cpu_topology(void)
 		changed = 1;
 	}
 
+out:
 	kfree(updates);
 	return changed;
 }
-- 
1.7.9.5

