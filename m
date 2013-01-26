Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab3AZB4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:56:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab3AZB4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:56:18 -0500
Date: Fri, 25 Jan 2013 17:56:02 -0800
From: tip-bot for Dave Hansen <dave@linux.vnet.ibm.com>
Message-ID: <tip-5dfd486c4750c9278c63fa96e6e85bdd2fb58e9d@git.kernel.org>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, mtosatti@redhat.com, dave@linux.vnet.ibm.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        riel@redhat.com, dave@linux.vnet.ibm.com, mtosatti@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20130122212435.4905663F@kernel.stglabs.ibm.com>
References: <20130122212435.4905663F@kernel.stglabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, kvm: Fix kvm's use of __pa() on percpu areas
Git-Commit-ID: 5dfd486c4750c9278c63fa96e6e85bdd2fb58e9d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 17:56:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dfd486c4750c9278c63fa96e6e85bdd2fb58e9d
Gitweb:     http://git.kernel.org/tip/5dfd486c4750c9278c63fa96e6e85bdd2fb58e9d
Author:     Dave Hansen <dave@linux.vnet.ibm.com>
AuthorDate: Tue, 22 Jan 2013 13:24:35 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 25 Jan 2013 16:34:55 -0800

x86, kvm: Fix kvm's use of __pa() on percpu areas

In short, it is illegal to call __pa() on an address holding
a percpu variable.  This replaces those __pa() calls with
slow_virt_to_phys().  All of the cases in this patch are
in boot time (or CPU hotplug time at worst) code, so the
slow pagetable walking in slow_virt_to_phys() is not expected
to have a performance impact.

The times when this actually matters are pretty obscure
(certain 32-bit NUMA systems), but it _does_ happen.  It is
important to keep KVM guests working on these systems because
the real hardware is getting harder and harder to find.

This bug manifested first by me seeing a plain hang at boot
after this message:

	CPU 0 irqstacks, hard=f3018000 soft=f301a000

or, sometimes, it would actually make it out to the console:

[    0.000000] BUG: unable to handle kernel paging request at ffffffff

I eventually traced it down to the KVM async pagefault code.
This can be worked around by disabling that code either at
compile-time, or on the kernel command-line.

The kvm async pagefault code was injecting page faults in
to the guest which the guest misinterpreted because its
"reason" was not being properly sent from the host.

The guest passes a physical address of an per-cpu async page
fault structure via an MSR to the host.  Since __pa() is
broken on percpu data, the physical address it sent was
bascially bogus and the host went scribbling on random data.
The guest never saw the real reason for the page fault (it
was injected by the host), assumed that the kernel had taken
a _real_ page fault, and panic()'d.  The behavior varied,
though, depending on what got corrupted by the bad write.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20130122212435.4905663F@kernel.stglabs.ibm.com
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/kvm.c      | 9 +++++----
 arch/x86/kernel/kvmclock.c | 4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 9c2bd8b..aa7e58b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -297,9 +297,9 @@ static void kvm_register_steal_time(void)
 
 	memset(st, 0, sizeof(*st));
 
-	wrmsrl(MSR_KVM_STEAL_TIME, (__pa(st) | KVM_MSR_ENABLED));
+	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
 	printk(KERN_INFO "kvm-stealtime: cpu %d, msr %lx\n",
-		cpu, __pa(st));
+		cpu, slow_virt_to_phys(st));
 }
 
 static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
@@ -324,7 +324,7 @@ void __cpuinit kvm_guest_cpu_init(void)
 		return;
 
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) && kvmapf) {
-		u64 pa = __pa(&__get_cpu_var(apf_reason));
+		u64 pa = slow_virt_to_phys(&__get_cpu_var(apf_reason));
 
 #ifdef CONFIG_PREEMPT
 		pa |= KVM_ASYNC_PF_SEND_ALWAYS;
@@ -340,7 +340,8 @@ void __cpuinit kvm_guest_cpu_init(void)
 		/* Size alignment is implied but just to make it explicit. */
 		BUILD_BUG_ON(__alignof__(kvm_apic_eoi) < 4);
 		__get_cpu_var(kvm_apic_eoi) = 0;
-		pa = __pa(&__get_cpu_var(kvm_apic_eoi)) | KVM_MSR_ENABLED;
+		pa = slow_virt_to_phys(&__get_cpu_var(kvm_apic_eoi))
+			| KVM_MSR_ENABLED;
 		wrmsrl(MSR_KVM_PV_EOI_EN, pa);
 	}
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 220a360..9f966dc 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -162,8 +162,8 @@ int kvm_register_clock(char *txt)
 	int low, high, ret;
 	struct pvclock_vcpu_time_info *src = &hv_clock[cpu].pvti;
 
-	low = (int)__pa(src) | 1;
-	high = ((u64)__pa(src) >> 32);
+	low = (int)slow_virt_to_phys(src) | 1;
+	high = ((u64)slow_virt_to_phys(src) >> 32);
 	ret = native_write_msr_safe(msr_kvm_system_time, low, high);
 	printk(KERN_INFO "kvm-clock: cpu %d, msr %x:%x, %s\n",
 	       cpu, high, low, txt);
