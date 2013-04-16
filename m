Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3DPGjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:39:23 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:33676 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab3DPGjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:39:21 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 11/15] KVM: MMU: introduce kvm_clear_all_lpage_info
Date: Tue, 16 Apr 2013 14:32:49 +0800
Message-Id: <1366093973-2617-12-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
x-cbid: 13041606-3568-0000-0000-000003702C04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is used to reset the large page info of all guest page
which will be used in later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   25 +++++++++++++++++++++++++
 arch/x86/kvm/x86.h |    2 ++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c5bb2c..fc4956c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6909,6 +6909,31 @@ static void memslot_set_lpage_disallowed(struct kvm_memory_slot *slot,
 	}
 }
 
+static void clear_memslot_lpage_info(struct kvm_memory_slot *slot)
+{
+	int i;
+
+	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
+		int lpages;
+		int level = i + 1;
+
+		lpages = gfn_to_index(slot->base_gfn + slot->npages - 1,
+				      slot->base_gfn, level) + 1;
+
+		memset(slot->arch.lpage_info[i - 1], 0,
+		       sizeof(*slot->arch.lpage_info[i - 1]));
+		memslot_set_lpage_disallowed(slot, slot->npages, i, lpages);
+	}
+}
+
+void kvm_clear_all_lpage_info(struct kvm *kvm)
+{
+	struct kvm_memory_slot *slot;
+
+	kvm_for_each_memslot(slot, kvm->memslots)
+		clear_memslot_lpage_info(slot);
+}
+
 static int kvm_arch_create_memslot(struct kvm_memory_slot *slot)
 {
 	unsigned long npages = slot->npages;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e224f7a..beae540 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -108,6 +108,8 @@ static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	return false;
 }
 
+void kvm_clear_all_lpage_info(struct kvm *kvm);
+
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 int kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
-- 
1.7.7.6

