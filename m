Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbaDHRY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:24:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:40370 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341AbaDHRYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:24:49 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@Citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org, keir@xen.org,
        jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [LINUX PATCH 2/2] xen/pvhvm: Support more than 32 VCPUs when migrating.
Date: Tue,  8 Apr 2014 13:25:50 -0400
Message-Id: <1396977950-8789-3-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1396977950-8789-1-git-send-email-konrad@kernel.org>
References: <1396859560.22845.4.camel@kazak.uk.xensource.com>
 <1396977950-8789-1-git-send-email-konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

When Xen migrates an HVM guest, by default its shared_info can
only hold up to 32 CPUs. As such the hypercall
VCPUOP_register_vcpu_info was introduced which allowed us to
setup per-page areas for VCPUs. This means we can boot PVHVM
guest with more than 32 VCPUs. During migration the per-cpu
structure is allocated freshly by the hypervisor (vcpu_info_mfn
is set to INVALID_MFN) so that the newly migrated guest
can make an VCPUOP_register_vcpu_info hypercall.

Unfortunatly we end up triggering this condition in Xen:
/* Run this command on yourself or on other offline VCPUS. */
 if ( (v != current) && !test_bit(_VPF_down, &v->pause_flags) )

which means we are unable to setup the per-cpu VCPU structures
for running vCPUS. The Linux PV code paths make this work by
iterating over every vCPU with:

 1) is target CPU up (VCPUOP_is_up hypercall?)
 2) if yes, then VCPUOP_down to pause it.
 3) VCPUOP_register_vcpu_info
 4) if it was down, then VCPUOP_up to bring it back up

But since VCPUOP_down, VCPUOP_is_up, and VCPUOP_up are
not allowed on HVM guests we can't do this. However with the
Xen commit "hvm: Support more than 32 VCPUS when migrating."
we can do this. As such first check if VCPUOP_is_up is actually
possible before trying this dance.

As most of this dance code is done already in 'xen_setup_vcpu'
lets make it callable on both PV and HVM. This means moving one
of the checks out to 'xen_setup_runstate_info'.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |   21 ++++++++++++++++-----
 arch/x86/xen/suspend.c   |    6 +-----
 arch/x86/xen/time.c      |    3 +++
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 201d09a..af8be96 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -236,12 +236,23 @@ static void xen_vcpu_setup(int cpu)
 void xen_vcpu_restore(void)
 {
 	int cpu;
+	bool vcpuops = true;
+	const struct cpumask *mask;
 
-	for_each_possible_cpu(cpu) {
+	mask = xen_pv_domain() ? cpu_possible_mask : cpu_online_mask;
+
+	/* Only Xen 4.5 and higher supports this. */
+	if (HYPERVISOR_vcpu_op(VCPUOP_is_up, smp_processor_id(), NULL) == -ENOSYS)
+		vcpuops = false;
+
+	for_each_cpu(cpu, mask) {
 		bool other_cpu = (cpu != smp_processor_id());
-		bool is_up = HYPERVISOR_vcpu_op(VCPUOP_is_up, cpu, NULL);
+		bool is_up = false;
+
+		if (vcpuops)
+			is_up = HYPERVISOR_vcpu_op(VCPUOP_is_up, cpu, NULL);
 
-		if (other_cpu && is_up &&
+		if (vcpuops && other_cpu && is_up &&
 		    HYPERVISOR_vcpu_op(VCPUOP_down, cpu, NULL))
 			BUG();
 
@@ -250,7 +261,7 @@ void xen_vcpu_restore(void)
 		if (have_vcpu_info_placement)
 			xen_vcpu_setup(cpu);
 
-		if (other_cpu && is_up &&
+		if (vcpuops && other_cpu && is_up &&
 		    HYPERVISOR_vcpu_op(VCPUOP_up, cpu, NULL))
 			BUG();
 	}
@@ -1751,7 +1762,7 @@ void __ref xen_hvm_init_shared_info(void)
 	for_each_online_cpu(cpu) {
 		/* Leave it to be NULL. */
 		if (cpu >= MAX_VIRT_CPUS)
-			continue;
+			per_cpu(xen_vcpu, cpu) = NULL; /* Triggers xen_vcpu_setup.*/
 		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 	}
 }
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 45329c8..6fb3298 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -33,11 +33,7 @@ void xen_arch_hvm_post_suspend(int suspend_cancelled)
 	xen_hvm_init_shared_info();
 	xen_callback_vector();
 	xen_unplug_emulated_devices();
-	if (xen_feature(XENFEAT_hvm_safe_pvclock)) {
-		for_each_online_cpu(cpu) {
-			xen_setup_runstate_info(cpu);
-		}
-	}
+	xen_vcpu_restore();
 #endif
 }
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 7b78f88..d4feb2e 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -105,6 +105,9 @@ void xen_setup_runstate_info(int cpu)
 {
 	struct vcpu_register_runstate_memory_area area;
 
+	if (xen_hvm_domain() && !(xen_feature(XENFEAT_hvm_safe_pvclock)))
+		return;
+
 	area.addr.v = &per_cpu(xen_runstate, cpu);
 
 	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
-- 
1.7.7.6

