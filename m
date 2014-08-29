Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaH2Kbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:31:35 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33718 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaH2Kb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:31:29 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 1/3] KVM: do not bias the generation number in kvm_current_mmio_generation
Date: Fri, 29 Aug 2014 12:31:15 +0200
Message-Id: <1409308277-4021-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1409308277-4021-1-git-send-email-pbonzini@redhat.com>
References: <1409308277-4021-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next patch will give a meaning (a la seqcount) to the low bit of the
generation number.  Ensure that it matches between kvm->memslots->generation
and kvm_current_mmio_generation().

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c  | 7 +------
 virt/kvm/kvm_main.c | 7 +++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 931467881da7..323c3f5f5c84 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -236,12 +236,7 @@ static unsigned int get_mmio_spte_generation(u64 spte)
 
 static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
 {
-	/*
-	 * Init kvm generation close to MMIO_MAX_GEN to easily test the
-	 * code of handling generation number wrap-around.
-	 */
-	return (kvm_memslots(kvm)->generation +
-		      MMIO_MAX_GEN - 150) & MMIO_GEN_MASK;
+	return kvm_memslots(kvm)->generation & MMIO_GEN_MASK;
 }
 
 static void mark_mmio_spte(struct kvm *kvm, u64 *sptep, u64 gfn,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7176929a4cda..0bfdb673db26 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -477,6 +477,13 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	kvm->memslots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!kvm->memslots)
 		goto out_err_no_srcu;
+
+	/*
+	 * Init kvm generation close to the maximum to easily test the
+	 * code of handling generation number wrap-around.
+	 */
+	kvm->memslots->generation = -150;
+
 	kvm_init_memslots_id(kvm);
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
-- 
1.8.3.1


