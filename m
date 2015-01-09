Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbbAIKyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:54:50 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44511 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757395AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Paolo Bonzini <pbonzini@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 39/78] x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit
Date: Fri,  9 Jan 2015 11:31:48 +0100
Message-Id: <a82297838bb23d83795661c55a6b9494c05ac68d.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/kvm.c      | 9 ++++++++-
 arch/x86/kernel/kvmclock.c | 1 -
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index f022c54a79a4..e72593338df6 100644
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
index 1570e0741344..23457e5f0f4f 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -262,7 +262,6 @@ void __init kvmclock_init(void)
 #endif
 	kvm_get_preset_lpj();
 	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
-	pv_info.paravirt_enabled = 1;
 	pv_info.name = "KVM";
 
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
-- 
2.2.1

