Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3AMPtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 10:49:53 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49564 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3AMPtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 10:49:52 -0500
Message-ID: <50F2D773.2070301@linux.vnet.ibm.com>
Date: Sun, 13 Jan 2013 23:49:07 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 3/3] KVM: x86: improve reexecute_instruction
References: <50F2D64C.4030804@linux.vnet.ibm.com>
In-Reply-To: <50F2D64C.4030804@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011315-9264-0000-0000-000002FC7BCE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current reexecute_instruction can not well detect the failed instruction
emulation. It allows guest to retry all the instructions except it accesses
on error pfn

For example, some cases are nested-write-protect - if the page we want to
write is used as PDE but it chains to itself. Under this case, we should
stop the emulation and report the case to userspace

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    7 +++++++
 arch/x86/kvm/paging_tmpl.h      |   27 ++++++++++++++++++++-------
 arch/x86/kvm/x86.c              |   22 ++++++++++++++++++----
 3 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c431b33..d6ab8d2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -502,6 +502,13 @@ struct kvm_vcpu_arch {
 		u64 msr_val;
 		struct gfn_to_hva_cache data;
 	} pv_eoi;
+
+	/*
+	 * Indicate whether the access faults on its page table in guest
+	 * which is set when fix page fault and used to detect unhandeable
+	 * instruction.
+	 */
+	bool write_fault_to_shadow_pgtable;
 };

 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 3d1a352..ca69dcc 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -497,26 +497,34 @@ out_gpte_changed:
  * created when kvm establishes shadow page table that stop kvm using large
  * page size. Do it early can avoid unnecessary #PF and emulation.
  *
+ * @write_fault_to_shadow_pgtable will return true if the fault gfn is
+ * currently used as its page table.
+ *
  * Note: the PDPT page table is not checked for PAE-32 bit guest. It is ok
  * since the PDPT is always shadowed, that means, we can not use large page
  * size to map the gfn which is used as PDPT.
  */
 static bool
 FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
-			      struct guest_walker *walker, int user_fault)
+			      struct guest_walker *walker, int user_fault,
+			      bool *write_fault_to_shadow_pgtable)
 {
 	int level;
 	gfn_t mask = ~(KVM_PAGES_PER_HPAGE(walker->level) - 1);
+	bool self_changed = false;

 	if (!(walker->pte_access & ACC_WRITE_MASK ||
 	      (!is_write_protection(vcpu) && !user_fault)))
 		return false;

-	for (level = walker->level; level <= walker->max_level; level++)
-		if (!((walker->gfn ^ walker->table_gfn[level - 1]) & mask))
-			return true;
+	for (level = walker->level; level <= walker->max_level; level++) {
+		gfn_t gfn = walker->gfn ^ walker->table_gfn[level - 1];
+
+		self_changed |= !(gfn & mask);
+		*write_fault_to_shadow_pgtable |= !gfn;
+	}

-	return false;
+	return self_changed;
 }

 /*
@@ -544,7 +552,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	int level = PT_PAGE_TABLE_LEVEL;
 	int force_pt_level;
 	unsigned long mmu_seq;
-	bool map_writable;
+	bool map_writable, is_self_change_mapping;

 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);

@@ -572,9 +580,14 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 		return 0;
 	}

+	vcpu->arch.write_fault_to_shadow_pgtable = false;
+
+	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
+	      &walker, user_fault, &vcpu->arch.write_fault_to_shadow_pgtable);
+
 	if (walker.level >= PT_DIRECTORY_LEVEL)
 		force_pt_level = mapping_level_dirty_bitmap(vcpu, walker.gfn)
-		   || FNAME(is_self_change_mapping)(vcpu, &walker, user_fault);
+		   || is_self_change_mapping;
 	else
 		force_pt_level = 1;
 	if (!force_pt_level) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f13e03..139a5f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4753,7 +4753,8 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
 	return r;
 }

-static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2)
+static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
+				  bool write_fault_to_shadow_pgtable)
 {
 	gpa_t gpa = cr2;
 	pfn_t pfn;
@@ -4810,7 +4811,13 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2)
 	 * guest to let CPU execute the instruction.
 	 */
 	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
-	return true;
+
+	/*
+	 * If the access faults on its page table, it can not
+	 * be fixed by unprotecting shadow page and it should
+	 * be reported to userspace.
+	 */
+	return !write_fault_to_shadow_pgtable;
 }

 static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
@@ -4869,7 +4876,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 	int r;
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	bool writeback = true;
+	bool write_fault_to_spt = vcpu->arch.write_fault_to_shadow_pgtable;

+	/*
+	 * Clear write_fault_to_shadow_pgtable here to ensure it is
+	 * never reused.
+	 */
+	vcpu->arch.write_fault_to_shadow_pgtable = false;
 	kvm_clear_exception_queue(vcpu);

 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
@@ -4888,7 +4901,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		if (r != EMULATION_OK)  {
 			if (emulation_type & EMULTYPE_TRAP_UD)
 				return EMULATE_FAIL;
-			if (reexecute_instruction(vcpu, cr2))
+			if (reexecute_instruction(vcpu, cr2,
+						  write_fault_to_spt))
 				return EMULATE_DONE;
 			if (emulation_type & EMULTYPE_SKIP)
 				return EMULATE_FAIL;
@@ -4918,7 +4932,7 @@ restart:
 		return EMULATE_DONE;

 	if (r == EMULATION_FAILED) {
-		if (reexecute_instruction(vcpu, cr2))
+		if (reexecute_instruction(vcpu, cr2, write_fault_to_spt))
 			return EMULATE_DONE;

 		return handle_emulation_failure(vcpu);
-- 
1.7.7.6

