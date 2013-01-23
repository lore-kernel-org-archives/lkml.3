Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3AWKEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:04:33 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:39819 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3AWKE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:04:28 -0500
Message-ID: <50FFB5A1.5090708@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 18:04:17 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 01/12] KVM: MMU: lazily drop large spte
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012310-5140-0000-0000-000002AA5686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not drop large spte until it can be insteaded by small pages so that
the guest can happliy read memory through it

The idea is from Avi:
| As I mentioned before, write-protecting a large spte is a good idea,
| since it moves some work from protect-time to fault-time, so it reduces
| jitter.  This removes the need for the return value.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9f628f7..0f90269 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1105,7 +1105,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)

 /*
  * Write-protect on the specified @sptep, @pt_protect indicates whether
- * spte writ-protection is caused by protecting shadow page table.
+ * spte write-protection is caused by protecting shadow page table.
  * @flush indicates whether tlb need be flushed.
  *
  * Note: write protection is difference between drity logging and spte
@@ -1114,31 +1114,23 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
  *   its dirty bitmap is properly set.
  * - for spte protection, the spte can be writable only after unsync-ing
  *   shadow page.
- *
- * Return true if the spte is dropped.
  */
-static bool
+static void
 spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
 {
 	u64 spte = *sptep;

 	if (!is_writable_pte(spte) &&
 	      !(pt_protect && spte_is_locklessly_modifiable(spte)))
-		return false;
+		return;

 	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);

-	if (__drop_large_spte(kvm, sptep)) {
-		*flush |= true;
-		return true;
-	}
-
 	if (pt_protect)
 		spte &= ~SPTE_MMU_WRITEABLE;
 	spte = spte & ~PT_WRITABLE_MASK;

 	*flush |= mmu_spte_update(sptep, spte);
-	return false;
 }

 static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
@@ -1150,11 +1142,8 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,

 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
 		BUG_ON(!(*sptep & PT_PRESENT_MASK));
-		if (spte_write_protect(kvm, sptep, &flush, pt_protect)) {
-			sptep = rmap_get_first(*rmapp, &iter);
-			continue;
-		}

+		spte_write_protect(kvm, sptep, &flush, pt_protect);
 		sptep = rmap_get_next(&iter);
 	}

@@ -2611,6 +2600,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			break;
 		}

+		drop_large_spte(vcpu, iterator.sptep);
+
 		if (!is_shadow_present_pte(*iterator.sptep)) {
 			u64 base_addr = iterator.addr;

-- 
1.7.7.6

