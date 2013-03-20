Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934428Ab3CTIbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:31:00 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49590 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934367Ab3CTIa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:30:57 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 3/7] KVM: x86: introduce kvm_clear_all_gfn_page_info
Date: Wed, 20 Mar 2013 16:30:23 +0800
Message-Id: <1363768227-4782-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032008-5564-0000-0000-00000725859F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is used to reset the rmaps and page info of all guest page
which will be used in later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c       |   31 +++++++++++++++++++++++++++++++
 include/linux/kvm_host.h |    1 +
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0a7f67..87d27a8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6902,6 +6902,37 @@ memslot_set_lpage_disallowed(struct kvm_memory_slot *slot,
 	}
 }
 
+static void clear_memslot_page_info(struct kvm_memory_slot *slot)
+{
+	int i;
+
+	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
+		int lpages;
+		int level = i + 1;
+
+		lpages = gfn_to_index(slot->base_gfn + slot->npages - 1,
+				      slot->base_gfn, level) + 1;
+
+		memset(slot->arch.rmap[i], 0,
+		       lpages * sizeof(*slot->arch.rmap[i]));
+
+		if (i) {
+			memset(slot->arch.lpage_info[i - 1], 0,
+			       sizeof(*slot->arch.lpage_info[i - 1]));
+			memslot_set_lpage_disallowed(slot, slot->npages, i,
+						     lpages);
+		}
+	}
+}
+
+void kvm_clear_all_gfn_page_info(struct kvm *kvm)
+{
+	struct kvm_memory_slot *slot;
+
+	kvm_for_each_memslot(slot, kvm->memslots)
+		clear_memslot_page_info(slot);
+}
+
 int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
 {
 	int i;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0f4941a..1de9b79 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -491,6 +491,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			    struct kvm_userspace_memory_region *mem);
 void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont);
+void kvm_clear_all_gfn_page_info(struct kvm *kvm);
 int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
-- 
1.7.7.6

