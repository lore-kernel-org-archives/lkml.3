Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaLCLnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:43:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbaLCL1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 068/101] KVM: x86: Don't report guest userspace emulation error to userspace
Date: Wed,  3 Dec 2014 12:26:30 +0100
Message-Id: <7e1ebf020aff9b3e4c0d52e8ace6e3278e8f8762.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <namit@cs.technion.ac.il>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a2b9e6c1a35afcc0973acb72e591c714e78885ff upstream.

Commit fc3a9157d314 ("KVM: X86: Don't report L2 emulation failures to
user-space") disabled the reporting of L2 (nested guest) emulation failures to
userspace due to race-condition between a vmexit and the instruction emulator.
The same rational applies also to userspace applications that are permitted by
the guest OS to access MMIO area or perform PIO.

This patch extends the current behavior - of injecting a #UD instead of
reporting it to userspace - also for guest userspace code.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 590fd966b37a..790551bc4f15 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4871,7 +4871,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
 
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
-	if (!is_guest_mode(vcpu)) {
+	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
 		vcpu->run->internal.ndata = 0;
-- 
2.1.3

