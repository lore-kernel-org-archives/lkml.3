Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161675Ab3DEL6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 07:58:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:14075 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161623Ab3DEL6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:58:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,414,1363158000"; 
   d="scan'208";a="312816039"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv3, RFC 25/34] x86-64, mm: proper alignment mappings with hugepages
Date: Fri,  5 Apr 2013 14:59:49 +0300
Message-Id: <1365163198-29726-26-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Make arch_get_unmapped_area() return unmapped area aligned to HPAGE_MASK
if the file mapping can have huge pages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kernel/sys_x86_64.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index dbded5a..d97ab40 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -15,6 +15,7 @@
 #include <linux/random.h>
 #include <linux/uaccess.h>
 #include <linux/elf.h>
+#include <linux/pagemap.h>
 
 #include <asm/ia32.h>
 #include <asm/syscalls.h>
@@ -34,6 +35,13 @@ static unsigned long get_align_mask(void)
 	return va_align.mask;
 }
 
+static inline unsigned long mapping_align_mask(struct address_space *mapping)
+{
+	if (mapping_can_have_hugepages(mapping))
+		return PAGE_MASK & ~HPAGE_MASK;
+	return get_align_mask();
+}
+
 unsigned long align_vdso_addr(unsigned long addr)
 {
 	unsigned long align_mask = get_align_mask();
@@ -135,7 +143,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.length = len;
 	info.low_limit = begin;
 	info.high_limit = end;
-	info.align_mask = filp ? get_align_mask() : 0;
+	info.align_mask = filp ? mapping_align_mask(filp->f_mapping) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }
@@ -174,7 +182,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	info.length = len;
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
-	info.align_mask = filp ? get_align_mask() : 0;
+	info.align_mask = filp ? mapping_align_mask(filp->f_mapping) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 	if (!(addr & ~PAGE_MASK))
-- 
1.7.10.4

