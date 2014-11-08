Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaKHCZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 21:25:26 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53274 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaKHCZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 21:25:24 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86, kvm, vmx: Always use LOAD_IA32_EFER if available
Date: Fri,  7 Nov 2014 18:25:18 -0800
Message-Id: <32d96cddbe65b897151b95a0e0f8326e404646f8.1415413387.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least on Sandy Bridge, letting the CPU switch IA32_EFER is much
faster than switching it manually.

I benchmarked this using the vmexit kvm-unit-test (single run, but
GOAL multiplied by 5 to do more iterations):

Test                                  Before      After    Change
cpuid                                   2000       1932    -3.40%
vmcall                                  1914       1817    -5.07%
mov_from_cr8                              13         13     0.00%
mov_to_cr8                                19         19     0.00%
inl_from_pmtimer                       19164      10619   -44.59%
inl_from_qemu                          15662      10302   -34.22%
inl_from_kernel                         3916       3802    -2.91%
outl_to_kernel                          2230       2194    -1.61%
mov_dr                                   172        176     2.33%
ipi                                (skipped)  (skipped)
ipi+halt                           (skipped)  (skipped)
ple-round-robin                           13         13     0.00%
wr_tsc_adjust_msr                       1920       1845    -3.91%
rd_tsc_adjust_msr                       1892       1814    -4.12%
mmio-no-eventfd:pci-mem                16394      11165   -31.90%
mmio-wildcard-eventfd:pci-mem           4607       4645     0.82%
mmio-datamatch-eventfd:pci-mem          4601       4610     0.20%
portio-no-eventfd:pci-io               11507       7942   -30.98%
portio-wildcard-eventfd:pci-io          2239       2225    -0.63%
portio-datamatch-eventfd:pci-io         2250       2234    -0.71%

I haven't explicitly computed the significance of these numbers,
but this isn't subtle.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kvm/vmx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3e556c68351b..e72b9660e51c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1659,8 +1659,14 @@ static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
 	vmx->guest_msrs[efer_offset].mask = ~ignore_bits;
 
 	clear_atomic_switch_msr(vmx, MSR_EFER);
-	/* On ept, can't emulate nx, and must switch nx atomically */
-	if (enable_ept && ((vmx->vcpu.arch.efer ^ host_efer) & EFER_NX)) {
+
+	/*
+	 * On EPT, we can't emulate NX, so we must switch EFER atomically.
+	 * On CPUs that support "load IA32_EFER", always switch EFER
+	 * atomically, since it's faster than switching it manually.
+	 */
+	if (cpu_has_load_ia32_efer ||
+	    (enable_ept && ((vmx->vcpu.arch.efer ^ host_efer) & EFER_NX))) {
 		guest_efer = vmx->vcpu.arch.efer;
 		if (!(guest_efer & EFER_LMA))
 			guest_efer &= ~EFER_LME;
-- 
1.9.3

