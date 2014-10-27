Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaJ0Tc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:32:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52355 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaJ0S5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 009/105] KVM: do not bias the generation number in kvm_current_mmio_generation
Date: Mon, 27 Oct 2014 11:55:44 -0700
Message-Id: <1414436240-13879-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 00f034a12fdd81210d58116326d92780aac5c238 upstream.

The next patch will give a meaning (a la seqcount) to the low bit of the
generation number.  Ensure that it matches between kvm->memslots->generation
and kvm_current_mmio_generation().

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/mmu.c  | 7 +------
 virt/kvm/kvm_main.c | 7 +++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e50425d..0fefcd4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -235,12 +235,7 @@ static unsigned int get_mmio_spte_generation(u64 spte)
 
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
index 4f588bc..5c6b84c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -468,6 +468,13 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	kvm->memslots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!kvm->memslots)
 		goto out_err_nosrcu;
+
+	/*
+	 * Init kvm generation close to the maximum to easily test the
+	 * code of handling generation number wrap-around.
+	 */
+	kvm->memslots->generation = -150;
+
 	kvm_init_memslots_id(kvm);
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_nosrcu;
-- 
1.9.1

