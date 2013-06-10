Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3FJMEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 08:04:46 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:50651 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3FJMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 08:03:58 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH 2/4] PF: Move architecture specifics to the backends
Date: Mon, 10 Jun 2013 14:03:46 +0200
Message-Id: <1370865828-2053-3-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1370865828-2053-1-git-send-email-dingel@linux.vnet.ibm.com>
References: <1370865828-2053-1-git-send-email-dingel@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061012-0542-0000-0000-0000057F3F4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current common code use PAGE_OFFSET to indicate a bad host virtual address.
This works for x86 but not necessarily on other architectures. So the check
is moved into architecture specific code.

Todo:
 - apply to other architectures when applicable

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 12 ++++++++++++
 arch/x86/include/asm/kvm_host.h  |  8 ++++++++
 include/linux/kvm_host.h         |  8 --------
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index deb1990..e014bba 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -277,6 +277,18 @@ struct kvm_arch{
 	int css_support;
 };
 
+#define KVM_HVA_ERR_BAD		(-1UL)
+#define KVM_HVA_ERR_RO_BAD	(-1UL)
+
+static inline bool kvm_is_error_hva(unsigned long addr)
+{
+	/*
+	 * on s390, this check is not needed as kernel and user memory
+	 * is not mapped into the same address space
+	 */
+	return false;
+}
+
 extern int sie64a(struct kvm_s390_sie_block *, u64 *);
 extern unsigned long sie_exit_addr;
 #endif
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4979778..5ed7c83 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -94,6 +94,14 @@
 
 #define ASYNC_PF_PER_VCPU 64
 
+#define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
+#define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
+
+static inline bool kvm_is_error_hva(unsigned long addr)
+{
+	return addr >= PAGE_OFFSET;
+}
+
 extern raw_spinlock_t kvm_lock;
 extern struct list_head vm_list;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c139582..9bd29ef 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -84,14 +84,6 @@ static inline bool is_noslot_pfn(pfn_t pfn)
 	return pfn == KVM_PFN_NOSLOT;
 }
 
-#define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
-#define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
-
-static inline bool kvm_is_error_hva(unsigned long addr)
-{
-	return addr >= PAGE_OFFSET;
-}
-
 #define KVM_ERR_PTR_BAD_PAGE	(ERR_PTR(-ENOENT))
 
 static inline bool is_error_page(struct page *page)
-- 
1.8.1.6

