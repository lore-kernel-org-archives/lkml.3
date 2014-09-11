Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaIKFg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 01:36:59 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:58644 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752239AbaIKFg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 01:36:56 -0400
X-IronPort-AV: E=Sophos;i="5.04,504,1406563200"; 
   d="scan'208";a="35792873"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v5 3/7] kvm: Make init_rmode_identity_map() return 0 on success.
Date: Thu, 11 Sep 2014 13:38:02 +0800
Message-ID: <1410413886-32213-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In init_rmode_identity_map(), there two variables indicating the return
value, r and ret, and it return 0 on error, 1 on success. The function
is only called by vmx_create_vcpu(), and r is redundant.

This patch removes the redundant variable r, and make init_rmode_identity_map()
return 0 on success, -errno on failure.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 953d529..63c4c3e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3939,45 +3939,42 @@ out:
 
 static int init_rmode_identity_map(struct kvm *kvm)
 {
-	int i, idx, r, ret = 0;
+	int i, idx, ret = 0;
 	pfn_t identity_map_pfn;
 	u32 tmp;
 
 	if (!enable_ept)
-		return 1;
+		return 0;
 
 	/* Protect kvm->arch.ept_identity_pagetable_done. */
 	mutex_lock(&kvm->slots_lock);
 
-	if (likely(kvm->arch.ept_identity_pagetable_done)) {
-		ret = 1;
+	if (likely(kvm->arch.ept_identity_pagetable_done))
 		goto out2;
-	}
 
 	identity_map_pfn = kvm->arch.ept_identity_map_addr >> PAGE_SHIFT;
 
-	r = alloc_identity_pagetable(kvm);
-	if (r)
+	ret = alloc_identity_pagetable(kvm);
+	if (ret)
 		goto out2;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
-	if (r < 0)
+	ret = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
+	if (ret)
 		goto out;
 	/* Set up identity-mapping pagetable for EPT in real mode */
 	for (i = 0; i < PT32_ENT_PER_PAGE; i++) {
 		tmp = (i << 22) + (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |
 			_PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_PSE);
-		r = kvm_write_guest_page(kvm, identity_map_pfn,
+		ret = kvm_write_guest_page(kvm, identity_map_pfn,
 				&tmp, i * sizeof(tmp), sizeof(tmp));
-		if (r < 0)
+		if (ret)
 			goto out;
 	}
 	kvm->arch.ept_identity_pagetable_done = true;
-	ret = 1;
+
 out:
 	srcu_read_unlock(&kvm->srcu, idx);
-
 out2:
 	mutex_unlock(&kvm->slots_lock);
 	return ret;
@@ -7645,7 +7642,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 			kvm->arch.ept_identity_map_addr =
 				VMX_EPT_IDENTITY_PAGETABLE_ADDR;
 		err = -ENOMEM;
-		if (!init_rmode_identity_map(kvm))
+		if (init_rmode_identity_map(kvm))
 			goto free_vmcs;
 	}
 
-- 
1.8.3.1

