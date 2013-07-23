Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302Ab3GWPtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:49:01 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:34444 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933230Ab3GWPsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:48:06 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH v8 4/6] s390/vmcore: Implement remap_oldmem_pfn_range for s390
Date: Tue, 23 Jul 2013 17:47:57 +0200
Message-Id: <1374594479-64671-5-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1374594479-64671-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1374594479-64671-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072315-0542-0000-0000-000005E2E589
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Willeke <willeke@de.ibm.com>

This patch introduces the s390 specific way to map pages from oldmem.
The memory area below OLDMEM_SIZE is mapped with offset OLDMEM_BASE.
The other old memory is mapped directly.

Signed-off-by: Jan Willeke <willeke@de.ibm.com>
Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/kernel/crash_dump.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index 0c9a897..3e77615 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -99,6 +99,32 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 }
 
 /*
+ * Remap "oldmem"
+ *
+ * For the kdump reserved memory this functions performs a swap operation:
+ * [0 - OLDMEM_SIZE] is mapped to [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]
+ */
+int remap_oldmem_pfn_range(struct vm_area_struct *vma, unsigned long from,
+			   unsigned long pfn, unsigned long size, pgprot_t prot)
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
1.8.2.3

