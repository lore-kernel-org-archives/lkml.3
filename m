Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab3CME6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 00:58:05 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:59383 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab3CME6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 00:58:01 -0400
Message-ID: <51400751.3070006@linux.vnet.ibm.com>
Date: Wed, 13 Mar 2013 12:57:53 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/6] KVM: x86: introduce kvm_clear_all_gfn_page_info
References: <514006AC.2020904@linux.vnet.ibm.com>
In-Reply-To: <514006AC.2020904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031304-3568-0000-0000-00000347E292
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
index 2cf3722..3cb7685 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6881,6 +6881,37 @@ memslot_set_lpage_disallowed(struct kvm_memory_slot *slot,
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
index 9fa13eb..449126f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -490,6 +490,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			    struct kvm_userspace_memory_region *mem);
 void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont);
+void kvm_clear_all_gfn_page_info(struct kvm *kvm);
 int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
-- 
1.7.7.6

