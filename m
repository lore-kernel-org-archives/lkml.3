Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab3E1Vof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:44:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59482 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971Ab3E1VVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 16/78] xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.
Date: Tue, 28 May 2013 14:19:25 -0700
Message-Id: <1369776027-17859-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 7f1fc268c47491fd5e63548f6415fc8604e13003 upstream.

If a user did:

	echo 0 > /sys/devices/system/cpu/cpu1/online
	echo 1 > /sys/devices/system/cpu/cpu1/online

we would (this a build with DEBUG enabled) get to:
smpboot: ++++++++++++++++++++=_---CPU UP  1
.. snip..
smpboot: Stack at about ffff880074c0ff44
smpboot: CPU1: has booted.

and hang. The RCU mechanism would kick in an try to IPI the CPU1
but the IPIs (and all other interrupts) would never arrive at the
CPU1. At first glance at least. A bit digging in the hypervisor
trace shows that (using xenanalyze):

[vla] d4v1 vec 243 injecting
   0.043163027 --|x d4v1 intr_window vec 243 src 5(vector) intr f3
]  0.043163639 --|x d4v1 vmentry cycles 1468
]  0.043164913 --|x d4v1 vmexit exit_reason PENDING_INTERRUPT eip ffffffff81673254
   0.043164913 --|x d4v1 inj_virq vec 243  real
  [vla] d4v1 vec 243 injecting
   0.043164913 --|x d4v1 intr_window vec 243 src 5(vector) intr f3
]  0.043165526 --|x d4v1 vmentry cycles 1472
]  0.043166800 --|x d4v1 vmexit exit_reason PENDING_INTERRUPT eip ffffffff81673254
   0.043166800 --|x d4v1 inj_virq vec 243  real
  [vla] d4v1 vec 243 injecting

there is a pending event (subsequent debugging shows it is the IPI
from the VCPU0 when smpboot.c on VCPU1 has done
"set_cpu_online(smp_processor_id(), true)") and the guest VCPU1 is
interrupted with the callback IPI (0xf3 aka 243) which ends up calling
__xen_evtchn_do_upcall.

The __xen_evtchn_do_upcall seems to do *something* but not acknowledge
the pending events. And the moment the guest does a 'cli' (that is the
ffffffff81673254 in the log above) the hypervisor is invoked again to
inject the IPI (0xf3) to tell the guest it has pending interrupts.
This repeats itself forever.

The culprit was the per_cpu(xen_vcpu, cpu) pointer. At the bootup
we set each per_cpu(xen_vcpu, cpu) to point to the
shared_info->vcpu_info[vcpu] but later on use the VCPUOP_register_vcpu_info
to register per-CPU  structures (xen_vcpu_setup).
This is used to allow events for more than 32 VCPUs and for performance
optimizations reasons.

When the user performs the VCPU hotplug we end up calling the
the xen_vcpu_setup once more. We make the hypercall which returns
-EINVAL as it does not allow multiple registration calls (and
already has re-assigned where the events are being set). We pick
the fallback case and set per_cpu(xen_vcpu, cpu) to point to the
shared_info->vcpu_info[vcpu] (which is a good fallback during bootup).
However the hypervisor is still setting events in the register
per-cpu structure (per_cpu(xen_vcpu_info, cpu)).

As such when the events are set by the hypervisor (such as timer one),
and when we iterate in __xen_evtchn_do_upcall we end up reading stale
events from the shared_info->vcpu_info[vcpu] instead of the
per_cpu(xen_vcpu_info, cpu) structures. Hence we never acknowledge the
events that the hypervisor has set and the hypervisor keeps on reminding
us to ack the events which we never do.

The fix is simple. Don't on the second time when xen_vcpu_setup is
called over-write the per_cpu(xen_vcpu, cpu) if it points to
per_cpu(xen_vcpu_info).

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/xen/enlighten.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 08c6511..e7b7c13 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -156,6 +156,21 @@ static void xen_vcpu_setup(int cpu)
 
 	BUG_ON(HYPERVISOR_shared_info == &xen_dummy_shared_info);
 
+	/*
+	 * This path is called twice on PVHVM - first during bootup via
+	 * smp_init -> xen_hvm_cpu_notify, and then if the VCPU is being
+	 * hotplugged: cpu_up -> xen_hvm_cpu_notify.
+	 * As we can only do the VCPUOP_register_vcpu_info once lets
+	 * not over-write its result.
+	 *
+	 * For PV it is called during restore (xen_vcpu_restore) and bootup
+	 * (xen_setup_vcpu_info_placement). The hotplug mechanism does not
+	 * use this function.
+	 */
+	if (xen_hvm_domain()) {
+		if (per_cpu(xen_vcpu, cpu) == &per_cpu(xen_vcpu_info, cpu))
+			return;
+	}
 	if (cpu < MAX_VIRT_CPUS)
 		per_cpu(xen_vcpu,cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 
-- 
1.8.1.2

