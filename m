Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3EPMSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:18:22 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:41459 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab3EPMSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:18:11 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v5 4/8] KVM: x86: use the fast way to invalidate all pages
Date: Thu, 16 May 2013 20:17:49 +0800
Message-Id: <1368706673-8530-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051612-2000-0000-0000-00000C23D84D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace kvm_mmu_zap_all by kvm_mmu_invalidate_memslot_pages except on
the path of mmu_notifier->release() which will be fixed in
the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d885418..c2dd732 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5528,7 +5528,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 	 * to ensure that the updated hypercall appears atomically across all
 	 * VCPUs.
 	 */
-	kvm_mmu_zap_all(vcpu->kvm);
+	kvm_mmu_invalidate_memslot_pages(vcpu->kvm, NULL);
 
 	kvm_x86_ops->patch_hypercall(vcpu, instruction);
 
@@ -7079,7 +7079,7 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
-	kvm_arch_flush_shadow_all(kvm);
+	kvm_mmu_invalidate_memslot_pages(kvm, slot);
 }
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
-- 
1.7.7.6

