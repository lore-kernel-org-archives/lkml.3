Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab3EXNIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 09:08:16 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:58070 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3EXNIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 09:08:14 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH 2/2] s390/kdump/mmap: Implement arch_oldmem_remap_pfn_range() for s390
Date: Fri, 24 May 2013 15:08:09 +0200
Message-Id: <1369400889-11064-3-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052413-3548-0000-0000-0000057CA38D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Willeke <willeke@de.ibm.com>

This patch introduced the S390 specific way to map pages from oldmem.
The memory area below OLDMEM_SIZE is mapped with offset OLDMEM_BASE.
The other old memory is mapped directly.

Signed-off-by: Jan Willeke <willeke@de.ibm.com>
Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/kernel/crash_dump.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index f703d91..f524eb2 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -51,6 +51,33 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 }
 
 /*
+ * Remap "oldmem"
+ *
+ * For the kdump reserved memory this functions performs a swap operation:
+ * [0 - OLDMEM_SIZE] is mapped to [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]
+ */
+int arch_oldmem_remap_pfn_range(struct vm_area_struct *vma, unsigned long from,
+				unsigned long pfn, unsigned long size,
+				pgprot_t prot)
+{
+	unsigned long size_old;
+	int rc;
+
+	if (pfn < OLDMEM_SIZE >> PAGE_SHIFT) {
+		size_old = min(size, OLDMEM_SIZE - (pfn << PAGE_SHIFT));
+		rc = remap_pfn_range(vma, from,
+				     pfn + (OLDMEM_BASE >> PAGE_SHIFT),
+				     size_old, prot);
+		if (rc || size == size_old)
+			return rc;
+		size -= size_old;
+		from += size_old;
+		pfn += size_old >> PAGE_SHIFT;
+	}
+	return remap_pfn_range(vma, from, pfn, size, prot);
+}
+
+/*
  * Copy memory from old kernel
  */
 int copy_from_oldmem(void *dest, void *src, size_t count)
-- 
1.8.1.6

