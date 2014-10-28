Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbaJ1H5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:57:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbaJ1DhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:37:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 021/146] x86,kvm,vmx: Preserve CR4 across VM entry
Date: Tue, 28 Oct 2014 11:32:43 +0800
Message-Id: <20141028033344.357049031@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -453,6 +453,7 @@ struct vcpu_vmx {
 		int           gs_ldt_reload_needed;
 		int           fs_reload_needed;
 		u64           msr_host_bndcfgs;
+		unsigned long vmcs_host_cr4;	/* May not match real cr4 */
 	} host_state;
 	struct {
 		int vm86_active;
@@ -4235,11 +4236,16 @@ static void vmx_set_constant_host_state(
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
@@ -7376,7 +7382,7 @@ static void atomic_switch_perf_msrs(stru
 static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long debugctlmsr;
+	unsigned long debugctlmsr, cr4;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!cpu_has_virtual_nmis() && vmx->soft_vnmi_blocked))
@@ -7397,6 +7403,12 @@ static void __noclone vmx_vcpu_run(struc
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


