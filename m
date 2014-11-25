Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaKYKrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:47:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59242 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaKYKnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 245/254] vmcore: Remove "weak" from function declarations
Date: Tue, 25 Nov 2014 10:39:55 +0000
Message-Id: <1416912004-5928-246-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 5ab03ac5aaa1f032e071f1b3dc433b7839359c03 upstream.

For the following functions:

  elfcorehdr_alloc()
  elfcorehdr_free()
  elfcorehdr_read()
  elfcorehdr_read_notes()
  remap_oldmem_pfn_range()

fs/proc/vmcore.c provides default definitions explicitly marked "weak".
arch/s390 provides its own definitions intended to override the default
ones, but the "weak" attribute on the declarations applied to the s390
definitions as well, so the linker chose one based on link order (see
10629d711ed7 ("PCI: Remove __weak annotation from pcibios_get_phb_of_node
decl")).

Remove the "weak" attribute from the declarations so we always prefer a
non-weak definition over the weak one, independent of link order.

Fixes: be8a8d069e50 ("vmcore: introduce ELF header in new memory feature")
Fixes: 9cb218131de1 ("vmcore: introduce remap_oldmem_pfn_range()")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
CC: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/crash_dump.h | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 72ab536ad3de..3849fce7ecfe 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -14,14 +14,13 @@
 extern unsigned long long elfcorehdr_addr;
 extern unsigned long long elfcorehdr_size;
 
-extern int __weak elfcorehdr_alloc(unsigned long long *addr,
-				   unsigned long long *size);
-extern void __weak elfcorehdr_free(unsigned long long addr);
-extern ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos);
-extern ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
-extern int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
-					 unsigned long from, unsigned long pfn,
-					 unsigned long size, pgprot_t prot);
+extern int elfcorehdr_alloc(unsigned long long *addr, unsigned long long *size);
+extern void elfcorehdr_free(unsigned long long addr);
+extern ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos);
+extern ssize_t elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
+extern int remap_oldmem_pfn_range(struct vm_area_struct *vma,
+				  unsigned long from, unsigned long pfn,
+				  unsigned long size, pgprot_t prot);
 
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
-- 
2.1.0

