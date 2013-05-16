Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab3EPVNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:13:32 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:54518 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab3EPVN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:13:27 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v6 7/7] KVM: MMU: add tracepoint for kvm_mmu_invalidate_all_pages
Date: Fri, 17 May 2013 05:13:02 +0800
Message-Id: <1368738782-18649-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051621-8878-0000-0000-000007248E47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is good for debug and development

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c      |    1 +
 arch/x86/kvm/mmutrace.h |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 89b51dc..2c512e8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4276,6 +4276,7 @@ restart:
 void kvm_mmu_invalidate_all_pages(struct kvm *kvm, bool zap_obsolete_pages)
 {
 	spin_lock(&kvm->mmu_lock);
+	trace_kvm_mmu_invalidate_all_pages(kvm, zap_obsolete_pages);
 	kvm->arch.mmu_valid_gen++;
 
 	/*
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 697f466..e13d253 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -276,6 +276,29 @@ TRACE_EVENT(
 		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
 	)
 );
+
+TRACE_EVENT(
+	kvm_mmu_invalidate_all_pages,
+	TP_PROTO(struct kvm *kvm, bool zap_obsolete_pages),
+	TP_ARGS(kvm, zap_obsolete_pages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, mmu_valid_gen)
+		__field(unsigned int, mmu_used_pages)
+		__field(bool, zap_obsolete_pages)
+	),
+
+	TP_fast_assign(
+		__entry->mmu_valid_gen = kvm->arch.mmu_valid_gen;
+		__entry->mmu_used_pages = kvm->arch.n_used_mmu_pages;
+		__entry->zap_obsolete_pages = zap_obsolete_pages;
+	),
+
+	TP_printk("kvm-mmu-valid-gen %lx zap_obsolete_pages %d "
+		  "used_pages %x", __entry->mmu_valid_gen,
+		  __entry->zap_obsolete_pages, __entry->mmu_used_pages
+	)
+);
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.7.6

