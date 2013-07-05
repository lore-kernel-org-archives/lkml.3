Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3GEU4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 16:56:13 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:47711 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab3GEU4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:56:08 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Alexander Graf <agraf@suse.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH 2/4] PF: Move architecture specifics to the backends
Date: Fri,  5 Jul 2013 22:55:52 +0200
Message-Id: <1373057754-59225-3-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1373057754-59225-1-git-send-email-dingel@linux.vnet.ibm.com>
References: <1373057754-59225-1-git-send-email-dingel@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070520-6892-0000-0000-0000059C5AC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current common codes uses PAGE_OFFSET to indicate a bad host virtual address.
As this check won't work on architectures that don't map kernel and user memory
into the same address space (e.g. s390), it is moved into architcture specific
code.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
---
 arch/arm/include/asm/kvm_host.h     |  8 ++++++++
 arch/ia64/include/asm/kvm_host.h    |  3 +++
 arch/mips/include/asm/kvm_host.h    |  6 ++++++
 arch/powerpc/include/asm/kvm_host.h |  8 ++++++++
 arch/s390/include/asm/kvm_host.h    | 12 ++++++++++++
 arch/x86/include/asm/kvm_host.h     |  8 ++++++++
 include/linux/kvm_host.h            |  8 --------
 7 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 7d22517..557c2a1 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -74,6 +74,14 @@ struct kvm_arch {
 	struct vgic_dist	vgic;
 };
 
+#define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
+#define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
+
+static inline bool kvm_is_error_hva(unsigned long addr)
+{
+	return addr >= PAGE_OFFSET;
+}
+
 #define KVM_NR_MEM_OBJS     40
 
 /*
diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 989dd3f..d3afa6f 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -486,6 +486,9 @@ struct kvm_arch {
 	unsigned long irq_states[KVM_IOAPIC_NUM_PINS];
 };
 
+#define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
+#define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
+
 union cpuid3_t {
 	u64 value;
 	struct {
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 4d6fa0b..3a0a3f7 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -34,7 +34,13 @@
 #define KVM_NR_PAGE_SIZES	1
 #define KVM_PAGES_PER_HPAGE(x)	1
 
+#define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
+#define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
 
+static inline bool kvm_is_error_hva(unsigned long addr)
+{
+	return addr >= PAGE_OFFSET;
+}
 
 /* Special address that contains the comm page, used for reducing # of traps */
 #define KVM_GUEST_COMMPAGE_ADDR     0x0
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index af326cd..be5d7f4 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -273,6 +273,14 @@ struct kvm_arch {
 #endif
 };
 
+#define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
+#define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
+
+static inline bool kvm_is_error_hva(unsigned long addr)
+{
+	return addr >= PAGE_OFFSET;
+}
+
 /*
  * Struct for a virtual core.
  * Note: entry_exit_count combines an entry count in the bottom 8 bits
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 3238d40..1588882 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -274,6 +274,18 @@ struct kvm_arch{
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
 extern char sie_exit;
 #endif
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f87f7fc..07e8570 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -96,6 +96,14 @@
 
 #define ASYNC_PF_PER_VCPU 64
 
+#define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
+#define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
+
+static inline bool kvm_is_error_hva(unsigned long addr)
+{
+	return addr >= PAGE_OFFSET;
+}
+
 struct kvm_vcpu;
 struct kvm;
 struct kvm_async_pf;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a63d83e..210f493 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -85,14 +85,6 @@ static inline bool is_noslot_pfn(pfn_t pfn)
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
1.8.2.2

