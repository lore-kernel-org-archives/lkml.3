Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab3E1D4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52524 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758849Ab3E1DyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Brian King" <brking@linux.vnet.ibm.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.815592986@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [33/94] powerpc/pseries: Fix partition migration hang in
 stop_topology_update
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit 444080d13d05dc38d07dd3bf751d38bce7ab7c72 upstream.

This fixes a hang that was observed during live partition migration.
Since stop_topology_update must not be called from an interrupt
context, call it earlier in the migration process. The hang observed
can be seen below:

WARNING: at kernel/timer.c:1011
Modules linked in: ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filter ip6_tables x_tables ipv6 fuse loop ibmveth sg ext3 jbd mbcache raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid10 raid1 raid0 scsi_dh_alua scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc dm_round_robin dm_multipath scsi_dh sd_mod crc_t10dif ibmvfc scsi_transport_fc scsi_tgt scsi_mod dm_snapshot dm_mod
NIP: c0000000000c52d8 LR: c00000000004be28 CTR: 0000000000000000
REGS: c00000005ffd77d0 TRAP: 0700   Not tainted  (3.2.0-git-00001-g07d106d)
MSR: 8000000000021032 <ME,CE,IR,DR>  CR: 48000084  XER: 00000001
CFAR: c00000000004be20
TASK = c00000005ec78860[0] 'swapper/3' THREAD: c00000005ec98000 CPU: 3
GPR00: 0000000000000001 c00000005ffd7a50 c000000000fbbc98 c000000000ec8340
GPR04: 00000000282a0020 0000000000000000 0000000000004000 0000000000000101
GPR08: 0000000000000012 c00000005ffd4000 0000000000000020 c000000000f3ba88
GPR12: 0000000000000000 c000000007f40900 0000000000000001 0000000000000004
GPR16: 0000000000000001 0000000000000000 0000000000000000 c000000001022310
GPR20: 0000000000000001 0000000000000000 0000000000200200 c000000001029e14
GPR24: 0000000000000000 0000000000000001 0000000000000040 c00000003f74bc80
GPR28: c00000003f74bc84 c000000000f38038 c000000000f16b58 c000000000ec8340
NIP [c0000000000c52d8] .del_timer_sync+0x28/0x60
LR [c00000000004be28] .stop_topology_update+0x20/0x38
Call Trace:
[c00000005ffd7a50] [c00000005ec78860] 0xc00000005ec78860 (unreliable)
[c00000005ffd7ad0] [c00000000004be28] .stop_topology_update+0x20/0x38
[c00000005ffd7b40] [c000000000028378] .__rtas_suspend_last_cpu+0x58/0x260
[c00000005ffd7bf0] [c0000000000fa230] .generic_smp_call_function_interrupt+0x160/0x358
[c00000005ffd7cf0] [c000000000036ec8] .smp_ipi_demux+0x88/0x100
[c00000005ffd7d80] [c00000000005c154] .icp_hv_ipi_action+0x5c/0x80
[c00000005ffd7e00] [c00000000012a088] .handle_irq_event_percpu+0x100/0x318
[c00000005ffd7f00] [c00000000012e774] .handle_percpu_irq+0x84/0xd0
[c00000005ffd7f90] [c000000000022ba8] .call_handle_irq+0x1c/0x2c
[c00000005ec9ba20] [c00000000001157c] .do_IRQ+0x22c/0x2a8
[c00000005ec9bae0] [c0000000000054bc] hardware_interrupt_entry+0x18/0x1c
Exception: 501 at .cpu_idle+0x194/0x2f8
    LR = .cpu_idle+0x194/0x2f8
[c00000005ec9bdd0] [c000000000017e58] .cpu_idle+0x188/0x2f8 (unreliable)
[c00000005ec9be90] [c00000000067ec18] .start_secondary+0x3e4/0x524
[c00000005ec9bf90] [c0000000000093e8] .start_secondary_prolog+0x10/0x14
Instruction dump:
ebe1fff8 4e800020 fbe1fff8 7c0802a6 f8010010 7c7f1b78 f821ff81 78290464
80090014 5400019e 7c0000d0 78000fe0 <0b000000> 4800000c 7c210b78 7c421378

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/rtas.c               |    5 +++--
 arch/powerpc/platforms/pseries/suspend.c |    6 +++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -716,7 +716,6 @@ static int __rtas_suspend_last_cpu(struc
 	int cpu;
 
 	slb_set_size(SLB_MIN_SIZE);
-	stop_topology_update();
 	printk(KERN_DEBUG "calling ibm,suspend-me on cpu %i\n", smp_processor_id());
 
 	while (rc == H_MULTI_THREADS_ACTIVE && !atomic_read(&data->done) &&
@@ -732,7 +731,6 @@ static int __rtas_suspend_last_cpu(struc
 		rc = atomic_read(&data->error);
 
 	atomic_set(&data->error, rc);
-	start_topology_update();
 	pSeries_coalesce_init();
 
 	if (wake_when_done) {
@@ -846,6 +844,7 @@ int rtas_ibm_suspend_me(struct rtas_args
 	atomic_set(&data.error, 0);
 	data.token = rtas_token("ibm,suspend-me");
 	data.complete = &done;
+	stop_topology_update();
 
 	/* Call function on all CPUs.  One of us will make the
 	 * rtas call
@@ -858,6 +857,8 @@ int rtas_ibm_suspend_me(struct rtas_args
 	if (atomic_read(&data.error) != 0)
 		printk(KERN_ERR "Error doing global join\n");
 
+	start_topology_update();
+
 	return atomic_read(&data.error);
 }
 #else /* CONFIG_PPC_PSERIES */
--- a/arch/powerpc/platforms/pseries/suspend.c
+++ b/arch/powerpc/platforms/pseries/suspend.c
@@ -24,6 +24,7 @@
 #include <asm/machdep.h>
 #include <asm/mmu.h>
 #include <asm/rtas.h>
+#include <asm/topology.h>
 
 static u64 stream_id;
 static struct sys_device suspend_sysdev;
@@ -138,8 +139,11 @@ static ssize_t store_hibernate(struct sy
 			ssleep(1);
 	} while (rc == -EAGAIN);
 
-	if (!rc)
+	if (!rc) {
+		stop_topology_update();
 		rc = pm_suspend(PM_SUSPEND_MEM);
+		start_topology_update();
+	}
 
 	stream_id = 0;
 

