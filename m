Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab3GATcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:32:48 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:33037 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3GATco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:32:44 -0400
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH v6 4/5] s390/vmcore: Implement remap_oldmem_pfn_range for s390
Date: Mon,  1 Jul 2013 21:32:38 +0200
Message-Id: <1372707159-10425-5-git-send-email-holzheu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070119-1948-0000-0000-00000591ECAE
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
index bfb9cda..9769aa3 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -56,6 +56,32 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
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
1.8.2.2

