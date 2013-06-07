Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3FGIv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:51:58 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39905 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab3FGIvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:51:52 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 5/6] KVM: MMU: add tracepoint for check_mmio_spte
Date: Fri,  7 Jun 2013 16:51:27 +0800
Message-Id: <1370595088-3315-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060708-9264-0000-0000-000003E49DE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful for debug mmio spte invalidation

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c      |  9 +++++++--
 arch/x86/kvm/mmutrace.h | 24 ++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bdc95bc..1fd2c05 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -281,8 +281,13 @@ static bool set_mmio_spte(struct kvm *kvm, u64 *sptep, gfn_t gfn,
 
 static bool check_mmio_spte(struct kvm *kvm, u64 spte)
 {
-	return likely(get_mmio_spte_generation(spte) ==
-			kvm_current_mmio_generation(kvm));
+	unsigned int kvm_gen, spte_gen;
+
+	kvm_gen = kvm_current_mmio_generation(kvm);
+	spte_gen = get_mmio_spte_generation(spte);
+
+	trace_check_mmio_spte(spte, kvm_gen, spte_gen);
+	return likely(kvm_gen == spte_gen);
 }
 
 static inline u64 rsvd_bits(int s, int e)
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index ad24757..9d2e0ff 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -298,6 +298,30 @@ TRACE_EVENT(
 		  __entry->mmu_valid_gen, __entry->mmu_used_pages
 	)
 );
+
+
+TRACE_EVENT(
+	check_mmio_spte,
+	TP_PROTO(u64 spte, unsigned int kvm_gen, unsigned int spte_gen),
+	TP_ARGS(spte, kvm_gen, spte_gen),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, kvm_gen)
+		__field(unsigned int, spte_gen)
+		__field(u64, spte)
+	),
+
+	TP_fast_assign(
+		__entry->kvm_gen = kvm_gen;
+		__entry->spte_gen = spte_gen;
+		__entry->spte = spte;
+	),
+
+	TP_printk("spte %llx kvm_gen %x spte-gen %x valid %d", __entry->spte,
+		  __entry->kvm_gen, __entry->spte_gen,
+		  __entry->kvm_gen == __entry->spte_gen
+	)
+);
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.8.1.4

