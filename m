Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab3EPMUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:20:18 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59226 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab3EPMSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:18:11 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v5 7/8] KVM: MMU: add tracepoint for kvm_mmu_invalidate_memslot_pages
Date: Thu, 16 May 2013 20:17:52 +0800
Message-Id: <1368706673-8530-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051612-8878-0000-0000-00000722DF9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is good for debug and development

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c      |    2 ++
 arch/x86/kvm/mmutrace.h |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 268b2ff..e12f431 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4300,6 +4300,8 @@ void kvm_mmu_invalidate_memslot_pages(struct kvm *kvm,
 
 	if (slot)
 		zap_invalid_pages(kvm);
+
+	trace_kvm_mmu_invalidate_memslot_pages(kvm, slot);
 	spin_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 697f466..8ef3e0e 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -276,6 +276,29 @@ TRACE_EVENT(
 		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
 	)
 );
+
+TRACE_EVENT(
+	kvm_mmu_invalidate_memslot_pages,
+	TP_PROTO(struct kvm *kvm, struct kvm_memory_slot *slot),
+	TP_ARGS(kvm, slot),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, mmu_valid_gen)
+		__field(unsigned int, mmu_used_pages)
+		__field(int, slot_id)
+	),
+
+	TP_fast_assign(
+		__entry->mmu_valid_gen = kvm->arch.mmu_valid_gen;
+		__entry->mmu_used_pages = kvm->arch.n_used_mmu_pages;
+		__entry->slot_id = slot ? slot->id : -1;
+	),
+
+	TP_printk("kvm-mmu-valid-gen %lx slot_id %d used_pages %x",
+		  __entry->mmu_valid_gen, __entry->slot_id,
+		  __entry->mmu_used_pages
+	)
+);
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.7.6

