Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab3D0DOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 23:14:06 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:51688 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab3D0DNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 23:13:34 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v4 3/6] KVM: MMU: introduce kvm_clear_all_lpage_info
Date: Sat, 27 Apr 2013 11:13:19 +0800
Message-Id: <1367032402-13729-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042703-8256-0000-0000-0000073D1129
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is used to reset the large page info of all guest pages
which will be used in later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   25 +++++++++++++++++++++++++
 arch/x86/kvm/x86.h |    2 ++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 52b4e97..8e4494c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6951,6 +6951,31 @@ static void memslot_set_lpage_disallowed(struct kvm_memory_slot *slot,
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
 int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
 {
 	int i;
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

