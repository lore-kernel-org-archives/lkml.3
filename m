Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaJORGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:06:36 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:56696 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaJORGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:06:33 -0400
Subject: [PATCH v1 07/10] vmcore: Remove "weak" from function declarations
To: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 11:06:31 -0600
Message-ID: <20141015170631.4063.50854.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
CC: Michael Holzheu <holzheu@linux.vnet.ibm.com>
CC: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/crash_dump.h |   15 +++++++--------
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

