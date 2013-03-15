Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3COPaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:30:04 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:56199 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab3COPaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:30:01 -0400
Message-ID: <51433E43.60900@linux.vnet.ibm.com>
Date: Fri, 15 Mar 2013 23:29:07 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/5] KVM: MMU: store generation-number into mmio spte
References: <51433D98.4050605@linux.vnet.ibm.com>
In-Reply-To: <51433D98.4050605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031515-8878-0000-0000-0000064C4FA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store the generation-number into bit3 ~ bit11 and bit52 ~ bit61, totally
19 bits can be used, it should be enough for nearly all most common cases

In this patch, the generation-number is always 0, it will be changed in
the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   57 +++++++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/mmutrace.h    |   10 ++++---
 arch/x86/kvm/paging_tmpl.h |    3 +-
 3 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index fdacabb..13626f4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -197,12 +197,50 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);

-static void mark_mmio_spte(u64 *sptep, u64 gfn, unsigned access)
+/*
+ * spte bits of bit 3 ~ bit 11 are used as low 9 bits of
+ * generation, the bits of bits 52 ~ bit 61 are used as
+ * high 12 bits of generation.
+ */
+#define MMIO_SPTE_GEN_LOW_SHIFT	3
+#define MMO_SPTE_GEN_HIGH_SHIFT	52
+
+#define GEN_LOW_SHIFT	9
+#define GEN_LOW_MASK	((1 << GEN_LOW_SHIFT) - 1)
+#define MAX_GEN		((1 << 19) - 1)
+
+static u64 generation_mmio_spte_mask(unsigned int gen)
 {
+	u64 mask;
+
+	WARN_ON(gen > MAX_GEN);
+
+	mask = (gen & GEN_LOW_MASK) << MMIO_SPTE_GEN_LOW_SHIFT;
+	mask |= ((u64)gen >> GEN_LOW_SHIFT) << MMO_SPTE_GEN_HIGH_SHIFT;
+	return mask;
+}
+
+static unsigned int get_mmio_spte_generation(u64 spte)
+{
+	unsigned int gen;
+
+	spte &= ~shadow_mmio_mask;
+
+	gen = (spte >> MMIO_SPTE_GEN_LOW_SHIFT) & GEN_LOW_MASK;
+	gen |= (spte >> MMO_SPTE_GEN_HIGH_SHIFT) << GEN_LOW_SHIFT;
+	return gen;
+}
+
+static void mark_mmio_spte(struct kvm *kvm, u64 *sptep, u64 gfn,
+			   unsigned access)
+{
+	u64 mask = generation_mmio_spte_mask(0);
+
 	access &= ACC_WRITE_MASK | ACC_USER_MASK;
+	mask |= shadow_mmio_mask | access | gfn << PAGE_SHIFT;

-	trace_mark_mmio_spte(sptep, gfn, access);
-	mmu_spte_set(sptep, shadow_mmio_mask | access | gfn << PAGE_SHIFT);
+	trace_mark_mmio_spte(sptep, gfn, access, 0);
+	mmu_spte_set(sptep, mask);
 }

 static bool is_mmio_spte(u64 spte)
@@ -220,10 +258,11 @@ static unsigned get_mmio_spte_access(u64 spte)
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

@@ -2327,7 +2366,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	u64 spte;
 	int ret = 0;

-	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
+	if (set_mmio_spte(vcpu->kvm, sptep, gfn, pfn, pte_access))
 		return 0;

 	spte = PT_PRESENT_MASK;
@@ -3386,8 +3425,8 @@ static inline void protect_clean_gpte(unsigned *access, unsigned gpte)
 	*access &= mask;
 }

-static bool sync_mmio_spte(u64 *sptep, gfn_t gfn, unsigned access,
-			   int *nr_present)
+static bool sync_mmio_spte(struct kvm *kvm, u64 *sptep, gfn_t gfn,
+			   unsigned access, int *nr_present)
 {
 	if (unlikely(is_mmio_spte(*sptep))) {
 		if (gfn != get_mmio_spte_gfn(*sptep)) {
@@ -3396,7 +3435,7 @@ static bool sync_mmio_spte(u64 *sptep, gfn_t gfn, unsigned access,
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
index 105dd5b..2c48e5f 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -792,7 +792,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		pte_access &= gpte_access(vcpu, gpte);
 		protect_clean_gpte(&pte_access, gpte);

-		if (sync_mmio_spte(&sp->spt[i], gfn, pte_access, &nr_present))
+		if (sync_mmio_spte(vcpu->kvm, &sp->spt[i], gfn, pte_access,
+		      &nr_present))
 			continue;

 		if (gfn != sp->gfns[i]) {
-- 
1.7.7.6

