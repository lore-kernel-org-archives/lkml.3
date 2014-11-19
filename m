Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbaKSVk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:40:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211AbaKSVOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.14 093/122] KVM: x86: Dont report guest userspace emulation error to userspace
Date: Wed, 19 Nov 2014 12:52:23 -0800
Message-Id: <20141119205211.915143085@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4911,7 +4911,7 @@ static int handle_emulation_failure(stru
 
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
-	if (!is_guest_mode(vcpu)) {
+	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
 		vcpu->run->internal.ndata = 0;


