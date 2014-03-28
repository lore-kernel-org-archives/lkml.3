Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaC1RgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:36:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaC1RbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.13 37/46] KVM: x86: handle invalid root_hpa everywhere
Date: Fri, 28 Mar 2014 10:32:21 -0700
Message-Id: <20140328173139.705997067@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 37f6a4e237303549c8676dfe1fd1991ceab512eb upstream.

Rom Freiman <rom@stratoscale.com> notes other code paths vulnerable to
bug fixed by 989c6b34f6a9480e397b.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu.c         |    9 +++++++++
 arch/x86/kvm/paging_tmpl.h |    8 ++++++++
 2 files changed, 17 insertions(+)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2832,6 +2832,9 @@ static bool fast_page_fault(struct kvm_v
 	bool ret = false;
 	u64 spte = 0ull;
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		return false;
+
 	if (!page_fault_can_be_fast(error_code))
 		return false;
 
@@ -3227,6 +3230,9 @@ static u64 walk_shadow_page_get_mmio_spt
 	struct kvm_shadow_walk_iterator iterator;
 	u64 spte = 0ull;
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		return spte;
+
 	walk_shadow_page_lockless_begin(vcpu);
 	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte)
 		if (!is_shadow_present_pte(spte))
@@ -4513,6 +4519,9 @@ int kvm_mmu_get_spte_hierarchy(struct kv
 	u64 spte;
 	int nr_sptes = 0;
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		return nr_sptes;
+
 	walk_shadow_page_lockless_begin(vcpu);
 	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
 		sptes[iterator.level-1] = spte;
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -569,6 +569,9 @@ static int FNAME(fetch)(struct kvm_vcpu
 	if (FNAME(gpte_changed)(vcpu, gw, top_level))
 		goto out_gpte_changed;
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		goto out_gpte_changed;
+
 	for (shadow_walk_init(&it, vcpu, addr);
 	     shadow_walk_okay(&it) && it.level > gw->level;
 	     shadow_walk_next(&it)) {
@@ -820,6 +823,11 @@ static void FNAME(invlpg)(struct kvm_vcp
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


