Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3BEH2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:28:14 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:39144 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3BEH2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:28:12 -0500
Message-ID: <5110B482.7060102@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2013 15:28:02 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 3/3] KVM: MMU: cleanup __direct_map
References: <5110B41D.3090605@linux.vnet.ibm.com>
In-Reply-To: <5110B41D.3090605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020507-5816-0000-0000-0000068D539C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use link_shadow_page to link the sp to the spte in __direct_map

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2112c1b..8041454 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1961,9 +1961,9 @@ static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
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

@@ -2607,11 +2607,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
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

