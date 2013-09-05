Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935684Ab3IEK3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:29:44 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:51788 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965127Ab3IEK3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:29:38 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 02/15] KVM: MMU: properly check last spte in fast_page_fault()
Date: Thu,  5 Sep 2013 18:29:05 +0800
Message-Id: <1378376958-27252-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090510-2674-0000-0000-00000A86A5BA
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

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7714fd8..869f1db 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2804,9 +2804,9 @@ static bool page_fault_can_be_fast(u32 error_code)
 }
 
 static bool
-fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 spte)
+fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			u64 *sptep, u64 spte)
 {
-	struct kvm_mmu_page *sp = page_header(__pa(sptep));
 	gfn_t gfn;
 
 	WARN_ON(!sp->role.direct);
@@ -2832,6 +2832,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 			    u32 error_code)
 {
 	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_mmu_page *sp;
 	bool ret = false;
 	u64 spte = 0ull;
 
@@ -2852,7 +2853,8 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 		goto exit;
 	}
 
-	if (!is_last_spte(spte, level))
+	sp = page_header(__pa(iterator.sptep));
+	if (!is_last_spte(spte, sp->role.level))
 		goto exit;
 
 	/*
@@ -2878,7 +2880,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
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

