Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3DPGgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:36:17 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:43740 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab3DPGfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:35:30 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 13/15] KVM: x86: use the fast way to invalid all pages
Date: Tue, 16 Apr 2013 14:32:51 +0800
Message-Id: <1366093973-2617-14-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-8256-0000-0000-00000716870D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace kvm_mmu_zap_all by kvm_mmu_invalid_all_pages except on
the path of mmu_notifier->release() which will be replaced in
the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6dbb80c..6e7c85b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5465,7 +5465,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 	 * to ensure that the updated hypercall appears atomically across all
 	 * VCPUs.
 	 */
-	kvm_mmu_zap_all(vcpu->kvm);
+	kvm_mmu_invalid_memslot_pages(vcpu->kvm, NULL);
 
 	kvm_x86_ops->patch_hypercall(vcpu, instruction);
 
@@ -7062,7 +7062,7 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
-	kvm_arch_flush_shadow_all(kvm);
+	kvm_mmu_invalid_memslot_pages(kvm, slot);
 }
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
-- 
1.7.7.6

