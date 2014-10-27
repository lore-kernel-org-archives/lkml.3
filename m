Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaJ0TDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:03:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52667 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaJ0TDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>, Petr Matousek <pmatouse@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 104/105] x86,kvm,vmx: Preserve CR4 across VM entry
Date: Mon, 27 Oct 2014 11:57:19 -0700
Message-Id: <1414436240-13879-105-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit d974baa398f34393db76be45f7d4d04fbdbb4a0a upstream.

CR4 isn't constant; at least the TSD and PCE bits can vary.

TBH, treating CR0 and CR3 as constant scares me a bit, too, but it looks
like it's correct.

This adds a branch and a read from cr4 to each vm entry.  Because it is
extremely likely that consecutive entries into the same vcpu will have
the same host cr4 value, this fixes up the vmcs instead of restoring cr4
after the fact.  A subsequent patch will add a kernel-wide cr4 shadow,
reducing the overhead in the common case to just two memory reads and a
branch.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/vmx.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 31c3e8b..c11b1ad 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -439,6 +439,7 @@ struct vcpu_vmx {
 #endif
 		int           gs_ldt_reload_needed;
 		int           fs_reload_needed;
+		unsigned long vmcs_host_cr4;	/* May not match real cr4 */
 	} host_state;
 	struct {
 		int vm86_active;
@@ -4131,11 +4132,16 @@ static void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	u32 low32, high32;
 	unsigned long tmpl;
 	struct desc_ptr dt;
+	unsigned long cr4;
 
 	vmcs_writel(HOST_CR0, read_cr0() & ~X86_CR0_TS);  /* 22.2.3 */
-	vmcs_writel(HOST_CR4, read_cr4());  /* 22.2.3, 22.2.5 */
 	vmcs_writel(HOST_CR3, read_cr3());  /* 22.2.3  FIXME: shadow tables */
 
+	/* Save the most likely value for this task's CR4 in the VMCS. */
+	cr4 = read_cr4();
+	vmcs_writel(HOST_CR4, cr4);			/* 22.2.3, 22.2.5 */
+	vmx->host_state.vmcs_host_cr4 = cr4;
+
 	vmcs_write16(HOST_CS_SELECTOR, __KERNEL_CS);  /* 22.2.4 */
 #ifdef CONFIG_X86_64
 	/*
@@ -7140,7 +7146,7 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long debugctlmsr;
+	unsigned long debugctlmsr, cr4;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!cpu_has_virtual_nmis() && vmx->soft_vnmi_blocked))
@@ -7161,6 +7167,12 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty))
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 
+	cr4 = read_cr4();
+	if (unlikely(cr4 != vmx->host_state.vmcs_host_cr4)) {
+		vmcs_writel(HOST_CR4, cr4);
+		vmx->host_state.vmcs_host_cr4 = cr4;
+	}
+
 	/* When single-stepping over STI and MOV SS, we must clear the
 	 * corresponding interruptibility bits in the guest state. Otherwise
 	 * vmentry fails as it then expects bit 14 (BS) in pending debug
-- 
1.9.1

