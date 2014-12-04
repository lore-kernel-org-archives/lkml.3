Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbaLDP6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:58:45 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43012 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbaLDP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:57:37 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 7/9] kvm: x86: handle XSAVES vmcs and vmexit
Date: Thu,  4 Dec 2014 16:57:12 +0100
Message-Id: <1417708634-24333-8-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <wanpeng.li@linux.intel.com>

Initialize the XSS exit bitmap.  It is zero so there should be no XSAVES
or XRSTORS exits.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/vmx.h      |  2 ++
 arch/x86/include/uapi/asm/vmx.h |  6 +++++-
 arch/x86/kvm/vmx.c              | 21 +++++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 08dc770bd340..45afaee9555c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -160,6 +160,8 @@ enum vmcs_field {
 	EOI_EXIT_BITMAP3_HIGH           = 0x00002023,
 	VMREAD_BITMAP                   = 0x00002026,
 	VMWRITE_BITMAP                  = 0x00002028,
+	XSS_EXIT_BITMAP                 = 0x0000202C,
+	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
 	VMCS_LINK_POINTER               = 0x00002800,
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 990a2fe1588d..b813bf9da1e2 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -72,6 +72,8 @@
 #define EXIT_REASON_XSETBV              55
 #define EXIT_REASON_APIC_WRITE          56
 #define EXIT_REASON_INVPCID             58
+#define EXIT_REASON_XSAVES              63
+#define EXIT_REASON_XRSTORS             64
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -116,6 +118,8 @@
 	{ EXIT_REASON_INVALID_STATE,         "INVALID_STATE" }, \
 	{ EXIT_REASON_INVD,                  "INVD" }, \
 	{ EXIT_REASON_INVVPID,               "INVVPID" }, \
-	{ EXIT_REASON_INVPCID,               "INVPCID" }
+	{ EXIT_REASON_INVPCID,               "INVPCID" }, \
+	{ EXIT_REASON_XSAVES,                "XSAVES" }, \
+	{ EXIT_REASON_XRSTORS,               "XRSTORS" }
 
 #endif /* _UAPIVMX_H */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index dd4fa461454a..88048c72b6b1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -761,6 +761,7 @@ static u64 construct_eptp(unsigned long root_hpa);
 static void kvm_cpu_vmxon(u64 addr);
 static void kvm_cpu_vmxoff(void);
 static bool vmx_mpx_supported(void);
+static bool vmx_xsaves_supported(void);
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
 static void vmx_set_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
@@ -4337,6 +4338,7 @@ static void ept_set_mmio_spte_mask(void)
 	kvm_mmu_set_mmio_spte_mask((0x3ull << 62) | 0x6ull);
 }
 
+#define VMX_XSS_EXIT_BITMAP 0
 /*
  * Sets up the vmcs for emulated real mode.
  */
@@ -4446,6 +4448,9 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
 	set_cr4_guest_host_mask(vmx);
 
+	if (vmx_xsaves_supported())
+		vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
+
 	return 0;
 }
 
@@ -5334,6 +5339,20 @@ static int handle_xsetbv(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_xsaves(struct kvm_vcpu *vcpu)
+{
+	skip_emulated_instruction(vcpu);
+	WARN(1, "this should never happen\n");
+	return 1;
+}
+
+static int handle_xrstors(struct kvm_vcpu *vcpu)
+{
+	skip_emulated_instruction(vcpu);
+	WARN(1, "this should never happen\n");
+	return 1;
+}
+
 static int handle_apic_access(struct kvm_vcpu *vcpu)
 {
 	if (likely(fasteoi)) {
@@ -6951,6 +6970,8 @@ static int (*const kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_monitor,
 	[EXIT_REASON_INVEPT]                  = handle_invept,
 	[EXIT_REASON_INVVPID]                 = handle_invvpid,
+	[EXIT_REASON_XSAVES]                  = handle_xsaves,
+	[EXIT_REASON_XRSTORS]                 = handle_xrstors,
 };
 
 static const int kvm_vmx_max_exit_handlers =
-- 
1.8.3.1


