Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3FWNsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 09:48:10 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46939 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3FWNsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 09:48:06 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 29/45] kvm/vmx: Use get/put_online_cpus_atomic() to prevent
 CPU offline
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, sbw@mit.edu, fweisbec@gmail.com,
        zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org
Date: Sun, 23 Jun 2013 19:14:27 +0530
Message-ID: <20130623134423.19094.90107.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com>
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062313-0260-0000-0000-0000033402C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able
to depend on disabling preemption to prevent CPUs from going offline
from under us.

Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going
offline, while invoking from atomic context.

Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kvm/vmx.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 260a919..4e1e966 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -26,6 +26,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/sched.h>
+#include <linux/cpu.h>
 #include <linux/moduleparam.h>
 #include <linux/mod_devicetable.h>
 #include <linux/ftrace_event.h>
@@ -7164,12 +7165,12 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (!vmm_exclusive)
 		kvm_cpu_vmxoff();
 
-	cpu = get_cpu();
+	cpu = get_online_cpus_atomic();
 	vmx_vcpu_load(&vmx->vcpu, cpu);
 	vmx->vcpu.cpu = cpu;
 	err = vmx_vcpu_setup(vmx);
 	vmx_vcpu_put(&vmx->vcpu);
-	put_cpu();
+	put_online_cpus_atomic();
 	if (err)
 		goto free_vmcs;
 	if (vm_need_virtualize_apic_accesses(kvm)) {
@@ -7706,12 +7707,12 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 
 	vmx->nested.vmcs01_tsc_offset = vmcs_read64(TSC_OFFSET);
 
-	cpu = get_cpu();
+	cpu = get_online_cpus_atomic();
 	vmx->loaded_vmcs = vmcs02;
 	vmx_vcpu_put(vcpu);
 	vmx_vcpu_load(vcpu, cpu);
 	vcpu->cpu = cpu;
-	put_cpu();
+	put_online_cpus_atomic();
 
 	vmx_segment_cache_clear(vmx);
 
@@ -8023,12 +8024,12 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu)
 	leave_guest_mode(vcpu);
 	prepare_vmcs12(vcpu, vmcs12);
 
-	cpu = get_cpu();
+	cpu = get_online_cpus_atomic();
 	vmx->loaded_vmcs = &vmx->vmcs01;
 	vmx_vcpu_put(vcpu);
 	vmx_vcpu_load(vcpu, cpu);
 	vcpu->cpu = cpu;
-	put_cpu();
+	put_online_cpus_atomic();
 
 	vmx_segment_cache_clear(vmx);
 

