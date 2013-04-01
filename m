Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab3DAJ5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:57:10 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:43894 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758523Ab3DAJ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:57:04 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 2/6] KVM: MMU: store generation-number into mmio spte
Date: Mon,  1 Apr 2013 17:56:45 +0800
Message-Id: <1364810209-25954-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040109-4790-0000-0000-000007A63B8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store the generation-number into bit3 ~ bit11 and bit52 ~ bit61, totally
19 bits can be used, it should be enough for nearly all most common cases

In this patch, the generation-number is always 0, it will be changed in
the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   58 +++++++++++++++++++++++++++++++++++--------
 arch/x86/kvm/mmutrace.h    |   10 ++++---
 arch/x86/kvm/paging_tmpl.h |    3 +-
 3 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1ebca53..be4f733 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -197,15 +197,50 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
-static void mark_mmio_spte(u64 *sptep, u64 gfn, unsigned access)
+/*
+ * spte bits of bit 3 ~ bit 11 are used as low 9 bits of generation number,
+ * the bits of bits 52 ~ bit 61 are used as high 10 bits of generation
+ * number.
+ */
+#define MMIO_SPTE_GEN_LOW_SHIFT		3
+#define MMIO_SPTE_GEN_HIGH_SHIFT	52
+
+#define MMIO_GEN_LOW_SHIFT		9
+#define MMIO_GEN_LOW_MASK		((1 << MMIO_GEN_LOW_SHIFT) - 1)
+#define MMIO_MAX_GEN			((1 << 19) - 1)
+
+static u64 generation_mmio_spte_mask(unsigned int gen)
 {
-	struct kvm_mmu_page *sp =  page_header(__pa(sptep));
+	u64 mask;
+
+	WARN_ON(gen > MMIO_MAX_GEN);
+
+	mask = (gen & MMIO_GEN_LOW_MASK) << MMIO_SPTE_GEN_LOW_SHIFT;
+	mask |= ((u64)gen >> MMIO_GEN_LOW_SHIFT) << MMIO_SPTE_GEN_HIGH_SHIFT;
+	return mask;
+}
+
+static unsigned int get_mmio_spte_generation(u64 spte)
+{
+	unsigned int gen;
+
+	spte &= ~shadow_mmio_mask;
+
+	gen = (spte >> MMIO_SPTE_GEN_LOW_SHIFT) & MMIO_GEN_LOW_MASK;
+	gen |= (spte >> MMIO_SPTE_GEN_HIGH_SHIFT) << MMIO_GEN_LOW_SHIFT;
+	return gen;
+}
+
+static void mark_mmio_spte(struct kvm *kvm, u64 *sptep, u64 gfn,
+			   unsigned access)
+{
+	u64 mask = generation_mmio_spte_mask(0);
 
 	access &= ACC_WRITE_MASK | ACC_USER_MASK;
+	mask |= shadow_mmio_mask | access | gfn << PAGE_SHIFT;
 
-	sp->mmio_cached = true;
-	trace_mark_mmio_spte(sptep, gfn, access);
-	mmu_spte_set(sptep, shadow_mmio_mask | access | gfn << PAGE_SHIFT);
+	trace_mark_mmio_spte(sptep, gfn, access, 0);
+	mmu_spte_set(sptep, mask);
 }
 
 static bool is_mmio_spte(u64 spte)
@@ -223,10 +258,11 @@ static unsigned get_mmio_spte_access(u64 spte)
 	return (spte & ~shadow_mmio_mask) & ~PAGE_MASK;
 }
 
-static bool set_mmio_spte(u64 *sptep, gfn_t gfn, pfn_t pfn, unsigned access)
+static bool set_mmio_spte(struct kvm *kvm, u64 *sptep, gfn_t gfn,
+			  pfn_t pfn, unsigned access)
 {
 	if (unlikely(is_noslot_pfn(pfn))) {
-		mark_mmio_spte(sptep, gfn, access);
+		mark_mmio_spte(kvm, sptep, gfn, access);
 		return true;
 	}
 
@@ -2335,7 +2371,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	u64 spte;
 	int ret = 0;
 
-	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
+	if (set_mmio_spte(vcpu->kvm, sptep, gfn, pfn, pte_access))
 		return 0;
 
 	spte = PT_PRESENT_MASK;
@@ -3388,8 +3424,8 @@ static inline void protect_clean_gpte(unsigned *access, unsigned gpte)
 	*access &= mask;
 }
 
-static bool sync_mmio_spte(u64 *sptep, gfn_t gfn, unsigned access,
-			   int *nr_present)
+static bool sync_mmio_spte(struct kvm *kvm, u64 *sptep, gfn_t gfn,
+			   unsigned access, int *nr_present)
 {
 	if (unlikely(is_mmio_spte(*sptep))) {
 		if (gfn != get_mmio_spte_gfn(*sptep)) {
@@ -3398,7 +3434,7 @@ static bool sync_mmio_spte(u64 *sptep, gfn_t gfn, unsigned access,
 		}
 
 		(*nr_present)++;
-		mark_mmio_spte(sptep, gfn, access);
+		mark_mmio_spte(kvm, sptep, gfn, access);
 		return true;
 	}
 
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index b8f6172..f5b62a7 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -197,23 +197,25 @@ DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_prepare_zap_page,
 
 TRACE_EVENT(
 	mark_mmio_spte,
-	TP_PROTO(u64 *sptep, gfn_t gfn, unsigned access),
-	TP_ARGS(sptep, gfn, access),
+	TP_PROTO(u64 *sptep, gfn_t gfn, unsigned access, unsigned int gen),
+	TP_ARGS(sptep, gfn, access, gen),
 
 	TP_STRUCT__entry(
 		__field(void *, sptep)
 		__field(gfn_t, gfn)
 		__field(unsigned, access)
+		__field(unsigned int, gen)
 	),
 
 	TP_fast_assign(
 		__entry->sptep = sptep;
 		__entry->gfn = gfn;
 		__entry->access = access;
+		__entry->gen = gen;
 	),
 
-	TP_printk("sptep:%p gfn %llx access %x", __entry->sptep, __entry->gfn,
-		  __entry->access)
+	TP_printk("sptep:%p gfn %llx access %x gen %x", __entry->sptep,
+		  __entry->gfn, __entry->access, __entry->gen)
 );
 
 TRACE_EVENT(
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index af143f0..bddc5f6 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -791,7 +791,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		pte_access &= gpte_access(vcpu, gpte);
 		protect_clean_gpte(&pte_access, gpte);
 
-		if (sync_mmio_spte(&sp->spt[i], gfn, pte_access, &nr_present))
+		if (sync_mmio_spte(vcpu->kvm, &sp->spt[i], gfn, pte_access,
+		      &nr_present))
 			continue;
 
 		if (gfn != sp->gfns[i]) {
-- 
1.7.7.6

