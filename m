Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3GJNAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:00:12 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:51299 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab3GJNAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:00:08 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Alexander Graf <agraf@suse.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH 2/4] PF: Make KVM_HVA_ERR_BAD usable on s390
Date: Wed, 10 Jul 2013 14:59:53 +0200
Message-Id: <1373461195-27628-3-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1373461195-27628-1-git-send-email-dingel@linux.vnet.ibm.com>
References: <1373461195-27628-1-git-send-email-dingel@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071012-5024-0000-0000-0000068CD908
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current common code uses PAGE_OFFSET to indicate a bad host virtual address.
As this check won't work on architectures that don't map kernel and user memory
into the same address space (e.g. s390), such architectures can now provide
there own KVM_HVA_ERR_BAD defines.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 8 ++++++++
 include/linux/kvm_host.h         | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 3238d40..cd30c3d 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -274,6 +274,14 @@ struct kvm_arch{
 	int css_support;
 };
 
+#define KVM_HVA_ERR_BAD		(-1UL)
+#define KVM_HVA_ERR_RO_BAD	(-1UL)
+
+static inline bool kvm_is_error_hva(unsigned long addr)
+{
+	return addr == KVM_HVA_ERR_BAD;
+}
+
 extern int sie64a(struct kvm_s390_sie_block *, u64 *);
 extern char sie_exit;
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a63d83e..92e8f64 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -85,6 +85,12 @@ static inline bool is_noslot_pfn(pfn_t pfn)
 	return pfn == KVM_PFN_NOSLOT;
 }
 
+/*
+ * architectures with KVM_HVA_ERR_BAD other than PAGE_OFFSET (e.g. s390)
+ * provide own defines and kvm_is_error_hva
+ */
+#ifndef KVM_HVA_ERR_BAD
+
 #define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
 #define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
 
@@ -93,6 +99,8 @@ static inline bool kvm_is_error_hva(unsigned long addr)
 	return addr >= PAGE_OFFSET;
 }
 
+#endif
+
 #define KVM_ERR_PTR_BAD_PAGE	(ERR_PTR(-ENOENT))
 
 static inline bool is_error_page(struct page *page)
-- 
1.8.2.2

