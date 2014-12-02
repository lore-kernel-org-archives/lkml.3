Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137AbaLBT40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:56:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46507 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbaLBTU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:20:28 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nadav Amit <namit@cs.technion.ac.il>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 011/121] KVM: x86: Don't report guest userspace emulation error to userspace
Date: Tue,  2 Dec 2014 11:18:10 -0800
Message-Id: <1417548000-1794-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

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
Reference: CVE-2014-7842
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 450c5c5..1d6e92c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4894,7 +4894,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
 
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
-	if (!is_guest_mode(vcpu)) {
+	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
 		vcpu->run->internal.ndata = 0;
-- 
1.9.1

