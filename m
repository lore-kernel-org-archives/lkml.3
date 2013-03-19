Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3CSPam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:30:42 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:47142 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab3CSPak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:30:40 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH] x86: correctly initialize the CS base on reset
Date: Tue, 19 Mar 2013 16:30:26 +0100
Message-Id: <1363707026-19351-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CS base was initialized to 0 on VMX (wrong, but usually overridden
by userspace before starting) or 0xf0000 on SVM.  The correct value is
0xffff0000, and VMX is able to emulate it now, so use it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 8 +-------
 arch/x86/kvm/vmx.c | 1 +
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7219a40..7a46c1f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1131,17 +1131,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 	init_seg(&save->gs);
 
 	save->cs.selector = 0xf000;
+	save->cs.base = 0xffff0000;
 	/* Executable/Readable Code Segment */
 	save->cs.attrib = SVM_SELECTOR_READ_MASK | SVM_SELECTOR_P_MASK |
 		SVM_SELECTOR_S_MASK | SVM_SELECTOR_CODE_MASK;
 	save->cs.limit = 0xffff;
-	/*
-	 * cs.base should really be 0xffff0000, but vmx can't handle that, so
-	 * be consistent with it.
-	 *
-	 * Replace when we have real mode working for vmx.
-	 */
-	save->cs.base = 0xf0000;
 
 	save->gdtr.limit = 0xffff;
 	save->idtr.limit = 0xffff;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4a0bafe..c75c25d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4133,6 +4133,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	seg_setup(VCPU_SREG_CS);
 	vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
+	vmcs_write32(GUEST_CS_BASE, 0xffff0000);
 
 	seg_setup(VCPU_SREG_DS);
 	seg_setup(VCPU_SREG_ES);
-- 
1.8.1.4

