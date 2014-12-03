Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaLCLzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:55:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbaLCL1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:13 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 057/101] vmcore: Remove "weak" from function declarations
Date: Wed,  3 Dec 2014 12:26:19 +0100
Message-Id: <c9813eda171c8e01f62f71623aff4b0fbe79106c.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/crash_dump.h | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 7032518f8542..60023e5d3169 100644
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
2.1.3

