Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3GIN5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:57:08 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:43015 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3GIN5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:57:04 -0400
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
Date: Tue,  9 Jul 2013 15:56:45 +0200
Message-Id: <1373378207-10451-3-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1373378207-10451-1-git-send-email-dingel@linux.vnet.ibm.com>
References: <1373378207-10451-1-git-send-email-dingel@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070913-2966-0000-0000-000008178E99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current common code uses PAGE_OFFSET to indicate a bad host virtual address.
As this check won't work on architectures that don't map kernel and user memory
into the same address space (e.g. s390), an additional implementation is made
available in the case that PAGE_OFFSET == 0.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a63d83e..f3c04e7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -85,6 +85,18 @@ static inline bool is_noslot_pfn(pfn_t pfn)
 	return pfn == KVM_PFN_NOSLOT;
 }
 
+#if (PAGE_OFFSET == 0)
+
+#define KVM_HVA_ERR_BAD		(-1UL)
+#define KVM_HVA_ERR_RO_BAD	(-1UL)
+
+static inline bool kvm_is_error_hva(unsigned long addr)
+{
+	return addr == KVM_HVA_ERR_BAD;
+}
+
+#else
+
 #define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
 #define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
 
@@ -93,6 +105,8 @@ static inline bool kvm_is_error_hva(unsigned long addr)
 	return addr >= PAGE_OFFSET;
 }
 
+#endif
+
 #define KVM_ERR_PTR_BAD_PAGE	(ERR_PTR(-ENOENT))
 
 static inline bool is_error_page(struct page *page)
-- 
1.8.2.2

