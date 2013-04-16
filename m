Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab3DPGf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:35:56 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56529 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab3DPGfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:35:30 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 14/15] KVM: move srcu_read_lock/srcu_read_unlock to arch-specified code
Date: Tue, 16 Apr 2013 14:32:52 +0800
Message-Id: <1366093973-2617-15-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-2674-0000-0000-0000089D0B21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move srcu_read_lock/srcu_read_unlock in kvm_mmu_notifier_release
to kvm_arch_flush_shadow_all since we will hold slot-lock instead
of srcu

Only ARM, POWERPC and x86 are using mmu-notify and
kvm_arch_flush_shadow_all on ARM and POWERPC does nothing, so we
only need to modify the code on x86

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c  |    4 ++++
 virt/kvm/kvm_main.c |    3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6e7c85b..d3dd0d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7056,7 +7056,11 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
 	kvm_mmu_zap_all(kvm);
+	srcu_read_unlock(&kvm->srcu, idx);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index acc9f30..f48eef9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -418,11 +418,8 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 				     struct mm_struct *mm)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int idx;
 
-	idx = srcu_read_lock(&kvm->srcu);
 	kvm_arch_flush_shadow_all(kvm);
-	srcu_read_unlock(&kvm->srcu, idx);
 }
 
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
-- 
1.7.7.6

