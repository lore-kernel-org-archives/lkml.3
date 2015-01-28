Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762550AbbA2Cjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:39:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47069 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbbA2Ci5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:57 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 098/139] x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit
Date: Wed, 28 Jan 2015 14:20:41 -0800
Message-Id: <1422483682-15393-99-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 29fa6825463c97e5157284db80107d1bfac5d77b upstream.

paravirt_enabled has the following effects:

 - Disables the F00F bug workaround warning.  There is no F00F bug
   workaround any more because Linux's standard IDT handling already
   works around the F00F bug, but the warning still exists.  This
   is only cosmetic, and, in any event, there is no such thing as
   KVM on a CPU with the F00F bug.

 - Disables 32-bit APM BIOS detection.  On a KVM paravirt system,
   there should be no APM BIOS anyway.

 - Disables tboot.  I think that the tboot code should check the
   CPUID hypervisor bit directly if it matters.

 - paravirt_enabled disables espfix32.  espfix32 should *not* be
   disabled under KVM paravirt.

The last point is the purpose of this patch.  It fixes a leak of the
high 16 bits of the kernel stack address on 32-bit KVM paravirt
guests.  Fixes CVE-2014-8134.

Suggested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/kvm.c      | 9 ++++++++-
 arch/x86/kernel/kvmclock.c | 1 -
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index f81cade..5b8eff1 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -280,7 +280,14 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 static void __init paravirt_ops_setup(void)
 {
 	pv_info.name = "KVM";
-	pv_info.paravirt_enabled = 1;
+
+	/*
+	 * KVM isn't paravirt in the sense of paravirt_enabled.  A KVM
+	 * guest kernel works like a bare metal kernel with additional
+	 * features, and paravirt_enabled is about features that are
+	 * missing.
+	 */
+	pv_info.paravirt_enabled = 0;
 
 	if (kvm_para_has_feature(KVM_FEATURE_NOP_IO_DELAY))
 		pv_cpu_ops.io_delay = kvm_io_delay;
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index e604109..c8e98cd 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -263,7 +263,6 @@ void __init kvmclock_init(void)
 #endif
 	kvm_get_preset_lpj();
 	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
-	pv_info.paravirt_enabled = 1;
 	pv_info.name = "KVM";
 
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
-- 
1.9.1

