Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbaGXMHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:07:09 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:41841 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaGXMHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:07:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArUIABX20FOERCABjGdsb2JhbABZg2BXSLJ5gQuUWAsWhzOBDRYQAQEBJz2EMVKBUYhCuViGbo9LHYQwBYpjqF1p
X-IPAS-Result: ArUIABX20FOERCABjGdsb2JhbABZg2BXSLJ5gQuUWAsWhzOBDRYQAQEBJz2EMVKBUYhCuViGbo9LHYQwBYpjqF1p
X-IronPort-AV: E=Sophos;i="5.01,723,1400014800"; 
   d="scan'208";a="116775742"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, nadav.amit@gmail.com,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH] KVM: x86: Assertions to check no overrun in MSR lists
Date: Thu, 24 Jul 2014 15:06:56 +0300
Message-Id: <1406203616-5579-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no check whether shared MSRs list overrun the allocated size
which can results in bugs. In addition there is no check that vmx->guest_msrs
has sufficient space to accommodate all the VMX msrs.  This patch adds the
assertions.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/vmx.c | 2 ++
 arch/x86/kvm/x86.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7534a9f..286a931 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7585,6 +7585,8 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 		goto free_vcpu;
 
 	vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	BUILD_BUG_ON(PAGE_SIZE / sizeof(struct shared_msr_entry) < NR_VMX_MSR);
+
 	err = -ENOMEM;
 	if (!vmx->guest_msrs) {
 		goto uninit_vcpu;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f750b69..f5cd7876 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -212,6 +212,7 @@ static void shared_msr_update(unsigned slot, u32 msr)
 
 void kvm_define_shared_msr(unsigned slot, u32 msr)
 {
+	BUG_ON(slot >= KVM_NR_SHARED_MSRS);
 	if (slot >= shared_msrs_global.nr)
 		shared_msrs_global.nr = slot + 1;
 	shared_msrs_global.msrs[slot] = msr;
-- 
1.9.1

