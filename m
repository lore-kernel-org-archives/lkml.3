Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaCJODt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:03:49 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:34480 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbaCJOCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:02:08 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@kernel.org
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 2/5] KVM: MMU: properly check last spte in fast_page_fault()
Date: Mon, 10 Mar 2014 22:01:46 +0800
Message-Id: <1394460109-3150-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031014-2000-0000-0000-00001019EED1
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
index f5704d9..046ef10 100644
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

