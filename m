Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965412AbbA1E0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:26:46 -0500
Received: from mail.kernel.org ([198.145.29.136]:41558 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965327AbbA1E0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:26:43 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 176/177] x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit
Date: Wed, 28 Jan 2015 12:10:34 +0800
Message-Id: <1422418236-12852-267-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/kernel/kvm.c      | 9 ++++++++-
 arch/x86/kernel/kvmclock.c | 1 -
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index e554e5a..226f284 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -258,7 +258,14 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
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
index f8492da..5e3f91b 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -212,7 +212,6 @@ void __init kvmclock_init(void)
 #endif
 	kvm_get_preset_lpj();
 	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
-	pv_info.paravirt_enabled = 1;
 	pv_info.name = "KVM";
 
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
-- 
1.9.1

