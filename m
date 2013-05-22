Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab3EVT4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:56:24 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:60351 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab3EVT4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:56:22 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v7 07/11] KVM: MMU: add tracepoint for kvm_mmu_invalidate_all_pages
Date: Thu, 23 May 2013 03:55:56 +0800
Message-Id: <1369252560-11611-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052219-5140-0000-0000-000003402A14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is good for debug and development

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c      |    1 +
 arch/x86/kvm/mmutrace.h |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c010ace..3a3e6c5 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4245,6 +4245,7 @@ restart:
 void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm)
 {
 	spin_lock(&kvm->mmu_lock);
+	trace_kvm_mmu_invalidate_zap_all_pages(kvm);
 	kvm->arch.mmu_valid_gen++;
 
 	kvm_zap_obsolete_pages(kvm);
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 697f466..eb444dd 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -276,6 +276,26 @@ TRACE_EVENT(
 		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
 	)
 );
+
+TRACE_EVENT(
+	kvm_mmu_invalidate_zap_all_pages,
+	TP_PROTO(struct kvm *kvm),
+	TP_ARGS(kvm),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, mmu_valid_gen)
+		__field(unsigned int, mmu_used_pages)
+	),
+
+	TP_fast_assign(
+		__entry->mmu_valid_gen = kvm->arch.mmu_valid_gen;
+		__entry->mmu_used_pages = kvm->arch.n_used_mmu_pages;
+	),
+
+	TP_printk("kvm-mmu-valid-gen %lx used_pages %x",
+		  __entry->mmu_valid_gen, __entry->mmu_used_pages
+	)
+);
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.7.6

