Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab3AWKIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:08:36 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48568 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3AWKId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:08:33 -0500
Message-ID: <50FFB697.7030307@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 18:08:23 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 08/12] KVM: MMU: cleanup __direct_map
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
In-Reply-To: <50FFB5A1.5090708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012310-6102-0000-0000-000002E7D237
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use link_shadow_page to link the sp to the spte in __direct_map

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c0bb7cf..7d7eb4a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1984,9 +1984,9 @@ static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
 {
 	u64 spte;

-	spte = __pa(sp->spt)
-		| PT_PRESENT_MASK | PT_ACCESSED_MASK
-		| PT_WRITABLE_MASK | PT_USER_MASK;
+	spte = __pa(sp->spt) | PT_PRESENT_MASK | PT_WRITABLE_MASK |
+	       shadow_user_mask | shadow_x_mask | shadow_accessed_mask;
+
 	mmu_spte_set(sptep, spte);
 }

@@ -2626,11 +2626,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 					      iterator.level - 1,
 					      1, ACC_ALL, iterator.sptep);

-			mmu_spte_set(iterator.sptep,
-				     __pa(sp->spt)
-				     | PT_PRESENT_MASK | PT_WRITABLE_MASK
-				     | shadow_user_mask | shadow_x_mask
-				     | shadow_accessed_mask);
+			link_shadow_page(iterator.sptep, sp);
 		}
 	}
 	return emulate;
-- 
1.7.7.6

