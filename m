Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3G3NC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:02:27 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58186 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3G3NCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:02:22 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 02/12] KVM: MMU: properly check last spte in fast_page_fault()
Date: Tue, 30 Jul 2013 21:02:00 +0800
Message-Id: <1375189330-24066-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073012-1618-0000-0000-0000045E8BA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using sp->role.level instead of @level since @level is not got from the
page table hierarchy

There is no issue in current code since the fast page fault only fixes the
fault caused by dirty-log, that means no large spte points to the dirty logged
page

The patch makes the code more readable and avoid potential issue in the further
development

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a731c0b..cf163ca 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2830,9 +2830,9 @@ static bool page_fault_can_be_fast(u32 error_code)
 }
 
 static bool
-fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 spte)
+fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			u64 *sptep, u64 spte)
 {
-	struct kvm_mmu_page *sp = page_header(__pa(sptep));
 	gfn_t gfn;
 
 	WARN_ON(!sp->role.direct);
@@ -2858,6 +2858,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 			    u32 error_code)
 {
 	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_mmu_page *sp;
 	bool ret = false;
 	u64 spte = 0ull;
 
@@ -2878,7 +2879,8 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 		goto exit;
 	}
 
-	if (!is_last_spte(spte, level))
+	sp = page_header(__pa(iterator.sptep));
+	if (!is_last_spte(spte, sp->role.level))
 		goto exit;
 
 	/*
@@ -2904,7 +2906,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 	 * the gfn is not stable for indirect shadow page.
 	 * See Documentation/virtual/kvm/locking.txt to get more detail.
 	 */
-	ret = fast_pf_fix_direct_spte(vcpu, iterator.sptep, spte);
+	ret = fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte);
 exit:
 	trace_fast_page_fault(vcpu, gva, error_code, iterator.sptep,
 			      spte, ret);
-- 
1.8.1.4

