Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab3JBO4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:56:40 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64983 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3JBO4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:56:37 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 3/7] KVM: mmu: unify destroy_kvm_mmu with kvm_mmu_unload
Date: Wed,  2 Oct 2013 16:56:12 +0200
Message-Id: <1380725776-14948-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
References: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They do the same thing, and destroy_kvm_mmu can be confused with
kvm_mmu_destroy.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index dff856c..d318d42 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3861,18 +3861,11 @@ static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 		return init_kvm_softmmu(vcpu);
 }
 
-static void destroy_kvm_mmu(struct kvm_vcpu *vcpu)
+int kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
-	if (VALID_PAGE(vcpu->arch.mmu.root_hpa)) {
-		mmu_free_roots(vcpu);
-		WARN_ON(VALID_PAGE(vcpu->arch.mmu.root_hpa));
-	}
-}
 
-int kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
-{
-	destroy_kvm_mmu(vcpu);
+	kvm_mmu_unload(vcpu);
 	return init_kvm_mmu(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
@@ -3898,6 +3891,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_load);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
 	mmu_free_roots(vcpu);
+	WARN_ON(VALID_PAGE(vcpu->arch.mmu.root_hpa));
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
@@ -4548,7 +4542,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
 
-	destroy_kvm_mmu(vcpu);
+	kvm_mmu_unload(vcpu);
 	free_mmu_pages(vcpu);
 	mmu_free_memory_caches(vcpu);
 }
-- 
1.8.3.1


