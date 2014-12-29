Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaL2BTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:19:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33125 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbaL2BMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paolo Bonzini" <pbonzini@redhat.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Andy Lutomirski" <luto@amacapital.net>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.377803922@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 12/27] x86, kvm: Clear paravirt_enabled on KVM guests
 for espfix32's benefit
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/kvm.c      | 9 ++++++++-
 arch/x86/kernel/kvmclock.c | 1 -
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -419,7 +419,14 @@ static void kvm_leave_lazy_mmu(void)
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
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -203,7 +203,6 @@ void __init kvmclock_init(void)
 #endif
 	kvm_get_preset_lpj();
 	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
-	pv_info.paravirt_enabled = 1;
 	pv_info.name = "KVM";
 
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))

