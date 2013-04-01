Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab3DAJ6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:58:02 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48117 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524Ab3DAJ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:57:08 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 5/6] KVM: MMU: add tracepoint for check_mmio_spte
Date: Mon,  1 Apr 2013 17:56:48 +0800
Message-Id: <1364810209-25954-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040109-5816-0000-0000-0000075CAC38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful for debug mmio spte invalidation

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c      |    9 +++++++--
 arch/x86/kvm/mmutrace.h |   24 ++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1020152..d314e21 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -279,8 +279,13 @@ static bool set_mmio_spte(struct kvm *kvm, u64 *sptep, gfn_t gfn,
 
 static bool check_mmio_spte(struct kvm *kvm, u64 spte)
 {
-	return get_mmio_spte_generation(spte) ==
-		      kvm_current_mmio_generation(kvm);
+	unsigned int kvm_gen, spte_gen;
+
+	kvm_gen = kvm_current_mmio_generation(kvm);
+	spte_gen = get_mmio_spte_generation(spte);
+
+	trace_check_mmio_spte(spte, kvm_gen, spte_gen);
+	return kvm_gen == spte_gen;
 }
 
 static inline u64 rsvd_bits(int s, int e)
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index f5b62a7..dac44ab 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -276,6 +276,30 @@ TRACE_EVENT(
 		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
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
1.7.7.6

