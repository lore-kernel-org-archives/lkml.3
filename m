Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaDALWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:22:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaDALTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:19:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 141/144] KVM: x86: handle invalid root_hpa everywhere
Date: Tue,  1 Apr 2014 12:15:45 +0100
Message-Id: <1396350948-29910-142-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 37f6a4e237303549c8676dfe1fd1991ceab512eb upstream.

Rom Freiman <rom@stratoscale.com> notes other code paths vulnerable to
bug fixed by 989c6b34f6a9480e397b.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/mmu.c         | 9 +++++++++
 arch/x86/kvm/paging_tmpl.h | 8 ++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5239897..d320a6b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2864,6 +2864,9 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 	bool ret = false;
 	u64 spte = 0ull;
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		return false;
+
 	if (!page_fault_can_be_fast(vcpu, error_code))
 		return false;
 
@@ -3258,6 +3261,9 @@ static u64 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr)
 	struct kvm_shadow_walk_iterator iterator;
 	u64 spte = 0ull;
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		return spte;
+
 	walk_shadow_page_lockless_begin(vcpu);
 	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte)
 		if (!is_shadow_present_pte(spte))
@@ -4528,6 +4534,9 @@ int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
 	u64 spte;
 	int nr_sptes = 0;
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		return nr_sptes;
+
 	walk_shadow_page_lockless_begin(vcpu);
 	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
 		sptes[iterator.level-1] = spte;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7769699..6b10d66 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -423,6 +423,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (FNAME(gpte_changed)(vcpu, gw, top_level))
 		goto out_gpte_changed;
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		goto out_gpte_changed;
+
 	for (shadow_walk_init(&it, vcpu, addr);
 	     shadow_walk_okay(&it) && it.level > gw->level;
 	     shadow_walk_next(&it)) {
@@ -674,6 +677,11 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 	 */
 	mmu_topup_memory_caches(vcpu);
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa)) {
+		WARN_ON(1);
+		return;
+	}
+
 	spin_lock(&vcpu->kvm->mmu_lock);
 	for_each_shadow_entry(vcpu, gva, iterator) {
 		level = iterator.level;
-- 
1.9.1

