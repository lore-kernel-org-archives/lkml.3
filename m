Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaDQJF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:05:58 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50493 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbaDQJFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:05:49 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@kernel.org
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v5 2/5] KVM: MMU: properly check last spte in fast_page_fault()
Date: Thu, 17 Apr 2014 17:06:13 +0800
Message-Id: <1397725576-6617-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397725576-6617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1397725576-6617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041709-5490-0000-0000-0000056DDF02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using sp->role.level instead of @level since @level is not got from the
page table hierarchy

There is no issue in current code since the fast page fault currently only
fixes the fault caused by dirty-log that is always on the last level
(level = 1)

This patch makes the code more readable and avoids potential issue in the
further development

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 668ae59..6310704 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2802,9 +2802,9 @@ static bool page_fault_can_be_fast(u32 error_code)
 }
 
 static bool
-fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 spte)
+fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			u64 *sptep, u64 spte)
 {
-	struct kvm_mmu_page *sp = page_header(__pa(sptep));
 	gfn_t gfn;
 
 	WARN_ON(!sp->role.direct);
@@ -2830,6 +2830,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 			    u32 error_code)
 {
 	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_mmu_page *sp;
 	bool ret = false;
 	u64 spte = 0ull;
 
@@ -2853,7 +2854,8 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 		goto exit;
 	}
 
-	if (!is_last_spte(spte, level))
+	sp = page_header(__pa(iterator.sptep));
+	if (!is_last_spte(spte, sp->role.level))
 		goto exit;
 
 	/*
@@ -2879,7 +2881,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
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

