Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbaKSVq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:46:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562AbaKSVEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: [PATCH 3.14 075/122] vmcore: Remove "weak" from function declarations
Date: Wed, 19 Nov 2014 12:52:05 -0800
Message-Id: <20141119205211.297992039@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/crash_dump.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

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


