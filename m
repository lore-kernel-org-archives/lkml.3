Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423069Ab3FUOVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:21:55 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:38281 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423023Ab3FUOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:21:53 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com,
        Hugh Dickins <hughd@google.com>
Subject: [PATCH 3/8] perf,x86: add uvirt_to_phys_nmi helper function
Date: Fri, 21 Jun 2013 16:20:43 +0200
Message-Id: <1371824448-7306-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371824448-7306-1-git-send-email-eranian@google.com>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function to convert from a user level address to its
physical address. To be used by perf_events memory
access sampling feature.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/include/asm/uaccess.h |  1 +
 arch/x86/lib/usercopy.c        | 43 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 5ee2687..4c9a102 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -513,6 +513,7 @@ struct __large_struct { unsigned long buf[100]; };
 
 extern unsigned long
 copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
+extern phys_addr_t uvirt_to_phys_nmi(const void __user *address);
 extern __must_check long
 strncpy_from_user(char *dst, const char __user *src, long count);
 
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index 4f74d94..3f19023 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -47,3 +47,46 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	return len;
 }
 EXPORT_SYMBOL_GPL(copy_from_user_nmi);
+
+/*
+ * Best effort, NMI-safe GUP-fast-based user-virtual to physical translation.
+ *
+ * Does not really belong in "usercopy.c", but kept here for comparison with
+ * copy_from_user_nmi() above.
+ *
+ * __get_user_pages_fast() may fail at awkward moments e.g. while transparent
+ * hugepage is being split.  And at present it happens to SetPageReferenced():
+ * not really a problem when this is used for profiling pages which are being
+ * referenced, but should be fixed if this were to be used any more widely.
+ *
+ * At time of writing, __get_user_pages_fast() is supported by mips, s390, sh
+ * and x86 (with a weak fallback returning 0 on other architectures): we have
+ * not established whether it is NMI-safe on any other architecture than x86.
+ */
+phys_addr_t uvirt_to_phys_nmi(const void __user *address)
+{
+	unsigned long vaddr = (unsigned long)address;
+	phys_addr_t paddr = vaddr & ~PAGE_MASK;
+	struct page *page;
+
+	if (!current->mm)
+		return -1;
+
+	if (__range_not_ok(address, 1, TASK_SIZE))
+		return -1;
+
+	if (!__get_user_pages_fast(vaddr, 1, 0, &page))
+		return -1;
+
+	paddr += (phys_addr_t)page_to_pfn(page) << PAGE_SHIFT;
+
+	/*
+	 * If called under NMI, this put_page(page) cannot be its final
+	 * put_page (which would indeed be problematic): a racing munmap
+	 * on another CPU cannot free the page until it has flushed TLB
+	 * on our CPU, and that must wait for us to leave NMI.
+	 */
+	put_page(page);
+
+	return paddr;
+}
-- 
1.8.1.2

