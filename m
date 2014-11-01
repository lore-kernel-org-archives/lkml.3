Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaKAWxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:53:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60096 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495AbaKAWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:28 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paolo Bonzini" <pbonzini@redhat.com>,
        "Petr Matousek" <pmatouse@redhat.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        stable@vger.kernel.org, "Gleb Natapov" <gleb@kernel.org>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.43488917@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 097/102] x86,kvm,vmx: Preserve CR4 across VM entry
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2:
 - Adjust context
 - Add struct vcpu_vmx *vmx parameter to vmx_set_constant_host_state(), done
   upstream in commit a547c6db4d2f ("KVM: VMX: Enable acknowledge interupt
   on vmexit")]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/vmx.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -390,6 +390,7 @@ struct vcpu_vmx {
 		u16           fs_sel, gs_sel, ldt_sel;
 		int           gs_ldt_reload_needed;
 		int           fs_reload_needed;
+		unsigned long vmcs_host_cr4;	/* May not match real cr4 */
 	} host_state;
 	struct {
 		int vm86_active;
@@ -3631,16 +3632,21 @@ static void vmx_disable_intercept_for_ms
  * Note that host-state that does change is set elsewhere. E.g., host-state
  * that is set differently for each CPU is set in vmx_vcpu_load(), not here.
  */
-static void vmx_set_constant_host_state(void)
+static void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 {
 	u32 low32, high32;
 	unsigned long tmpl;
 	struct desc_ptr dt;
+	unsigned long cr4;
 
 	vmcs_writel(HOST_CR0, read_cr0() | X86_CR0_TS);  /* 22.2.3 */
-	vmcs_writel(HOST_CR4, read_cr4());  /* 22.2.3, 22.2.5 */
 	vmcs_writel(HOST_CR3, read_cr3());  /* 22.2.3  FIXME: shadow tables */
 
+	/* Save the most likely value for this task's CR4 in the VMCS. */
+	cr4 = read_cr4();
+	vmcs_writel(HOST_CR4, cr4);			/* 22.2.3, 22.2.5 */
+	vmx->host_state.vmcs_host_cr4 = cr4;
+
 	vmcs_write16(HOST_CS_SELECTOR, __KERNEL_CS);  /* 22.2.4 */
 	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 	vmcs_write16(HOST_ES_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
@@ -3762,7 +3768,7 @@ static int vmx_vcpu_setup(struct vcpu_vm
 
 	vmcs_write16(HOST_FS_SELECTOR, 0);            /* 22.2.4 */
 	vmcs_write16(HOST_GS_SELECTOR, 0);            /* 22.2.4 */
-	vmx_set_constant_host_state();
+	vmx_set_constant_host_state(vmx);
 #ifdef CONFIG_X86_64
 	rdmsrl(MSR_FS_BASE, a);
 	vmcs_writel(HOST_FS_BASE, a); /* 22.2.4 */
@@ -6172,6 +6178,7 @@ static void atomic_switch_perf_msrs(stru
 static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long cr4;
 
 	if (is_guest_mode(vcpu) && !vmx->nested.nested_run_pending) {
 		struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -6202,6 +6209,12 @@ static void __noclone vmx_vcpu_run(struc
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
@@ -6666,7 +6679,7 @@ static void prepare_vmcs02(struct kvm_vc
 	 * Other fields are different per CPU, and will be set later when
 	 * vmx_vcpu_load() is called, and when vmx_save_host_state() is called.
 	 */
-	vmx_set_constant_host_state();
+	vmx_set_constant_host_state(vmx);
 
 	/*
 	 * HOST_RSP is normally set correctly in vmx_vcpu_run() just before

