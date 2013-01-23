Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3AWKHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:07:30 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40108 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3AWKH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:07:28 -0500
Message-ID: <50FFB658.6040205@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 18:07:20 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 06/12] KVM: MMU: introduce a static table to map guest
 access to spte access
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
In-Reply-To: <50FFB5A1.5090708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012310-5140-0000-0000-000002AA5739
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes set_spte more clean and reduces branch prediction

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   37 ++++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 43b7e0c..a8a9c0e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -235,6 +235,29 @@ static inline u64 rsvd_bits(int s, int e)
 	return ((1ULL << (e - s + 1)) - 1) << s;
 }

+static u64 gaccess_to_spte_access[ACC_ALL + 1];
+static void build_access_table(void)
+{
+	int access;
+
+	for (access = 0; access < ACC_ALL + 1; access++) {
+		u64 spte_access = 0;
+
+		if (access & ACC_EXEC_MASK)
+			spte_access |= shadow_x_mask;
+		else
+			spte_access |= shadow_nx_mask;
+
+		if (access & ACC_USER_MASK)
+			spte_access |= shadow_user_mask;
+
+		if (access & ACC_WRITE_MASK)
+			spte_access |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
+
+		gaccess_to_spte_access[access] = spte_access;
+	}
+}
+
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 dirty_mask, u64 nx_mask, u64 x_mask)
 {
@@ -243,6 +266,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 	shadow_dirty_mask = dirty_mask;
 	shadow_nx_mask = nx_mask;
 	shadow_x_mask = x_mask;
+	build_access_table();
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);

@@ -2391,20 +2415,11 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (!speculative)
 		spte |= shadow_accessed_mask;

-	if (pte_access & ACC_EXEC_MASK)
-		spte |= shadow_x_mask;
-	else
-		spte |= shadow_nx_mask;
-
-	if (pte_access & ACC_USER_MASK)
-		spte |= shadow_user_mask;
-
-	if (pte_access & ACC_WRITE_MASK)
-		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
-
 	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;

+	spte |= gaccess_to_spte_access[pte_access];
+
 	if (tdp_enabled)
 		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));
-- 
1.7.7.6

