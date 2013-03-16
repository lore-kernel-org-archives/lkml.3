Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541Ab3CSCas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:30:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47046 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933377Ab3CSCap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:30:45 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v3 08/21] vmcore: copy non page-size aligned head and tail
 pages in 2nd kernel
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Date: Sat, 16 Mar 2013 13:01:32 +0900
Message-ID: <20130316040132.15064.42257.stgit@localhost6.localdomain6>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to mmap() requirement, we need to copy pages not starting or
ending with page-size aligned address in 2nd kernel and to map them to
user-space.

For example, see the map below:

    00000000-00010000 : reserved
    00010000-0009f800 : System RAM
    0009f800-000a0000 : reserved

where the System RAM ends with 0x9f800 that is not page-size
aligned. This map is divided into two parts:

    00010000-0009f000
    0009f000-0009f800

and the first one is kept in old memory and the 2nd one is copied into
buffer on 2nd kernel.

This kind of non-page-size-aligned area can always occur since any
part of System RAM can be converted into reserved area at runtime.

If not doing copying like this and if remapping non page-size aligned
pages on old memory directly, mmap() had to export memory which is not
dump target to user-space. In the above example this is reserved
0x9f800-0xa0000.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |  192 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 172 insertions(+), 20 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index dd9769d..766e75f 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -472,11 +472,10 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
 						size_t elfsz,
 						struct list_head *vc_list)
 {
-	int i;
+	int i, rc;
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr *phdr_ptr;
 	loff_t vmcore_off;
-	struct vmcore *new;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
@@ -486,20 +485,97 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
 						  PAGE_SIZE);
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
+		u64 start, end, rest;
+
 		if (phdr_ptr->p_type != PT_LOAD)
 			continue;
 
-		/* Add this contiguous chunk of memory to vmcore list.*/
-		new = get_new_element();
-		if (!new)
-			return -ENOMEM;
-		new->paddr = phdr_ptr->p_offset;
-		new->size = phdr_ptr->p_memsz;
-		list_add_tail(&new->list, vc_list);
+		start = phdr_ptr->p_offset;
+		end = phdr_ptr->p_offset + phdr_ptr->p_memsz;
+		rest = phdr_ptr->p_memsz;
+
+		if (start & ~PAGE_MASK) {
+			u64 paddr, len;
+			char *buf;
+			struct vmcore *new;
+
+			paddr = start;
+			len = min(roundup(start,PAGE_SIZE), end) - start;
+
+			buf = (char *)get_zeroed_page(GFP_KERNEL);
+			if (!buf)
+				return -ENOMEM;
+			rc = read_from_oldmem(buf + (start & ~PAGE_MASK), len,
+					      &paddr, 0);
+			if (rc < 0) {
+				free_pages((unsigned long)buf, 0);
+				return rc;
+			}
+
+			new = get_new_element();
+			if (!new) {
+				free_pages((unsigned long)buf, 0);
+				return -ENOMEM;
+			}
+			new->flag |= MEM_TYPE_CURRENT_KERNEL;
+			new->size = PAGE_SIZE;
+			new->buf = buf;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= len;
+		}
+
+		if (rest > 0 &&
+		    roundup(start, PAGE_SIZE) < rounddown(end, PAGE_SIZE)) {
+			u64 paddr, len;
+			struct vmcore *new;
+
+			paddr = roundup(start, PAGE_SIZE);
+			len =rounddown(end,PAGE_SIZE)-roundup(start,PAGE_SIZE);
+
+			new = get_new_element();
+			if (!new)
+				return -ENOMEM;
+			new->paddr = paddr;
+			new->size = len;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= len;
+		}
+
+		if (rest > 0) {
+			u64 paddr, len;
+			char *buf;
+			struct vmcore *new;
+
+			paddr = rounddown(end, PAGE_SIZE);
+			len = end - rounddown(end, PAGE_SIZE);
+
+			buf = (char *)get_zeroed_page(GFP_KERNEL);
+			if (!buf)
+				return -ENOMEM;
+			rc = read_from_oldmem(buf, len, &paddr, 0);
+			if (rc < 0) {
+				free_pages((unsigned long)buf, 0);
+				return rc;
+			}
+
+			new = get_new_element();
+			if (!new) {
+				free_pages((unsigned long)buf, 0);
+				return -ENOMEM;
+			}
+			new->flag |= MEM_TYPE_CURRENT_KERNEL;
+			new->size = PAGE_SIZE;
+			new->buf = buf;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= len;
+		}
 
 		/* Update the program header offset. */
 		phdr_ptr->p_offset = vmcore_off;
-		vmcore_off = vmcore_off + phdr_ptr->p_memsz;
+		vmcore_off +=roundup(end,PAGE_SIZE)-rounddown(start,PAGE_SIZE);
 	}
 	return 0;
 }
@@ -508,11 +584,10 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 						size_t elfsz,
 						struct list_head *vc_list)
 {
-	int i;
+	int i, rc;
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr *phdr_ptr;
 	loff_t vmcore_off;
-	struct vmcore *new;
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
@@ -522,20 +597,97 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 						 PAGE_SIZE);
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
+		u64 start, end, rest;
+
 		if (phdr_ptr->p_type != PT_LOAD)
 			continue;
 
-		/* Add this contiguous chunk of memory to vmcore list.*/
-		new = get_new_element();
-		if (!new)
-			return -ENOMEM;
-		new->paddr = phdr_ptr->p_offset;
-		new->size = phdr_ptr->p_memsz;
-		list_add_tail(&new->list, vc_list);
+		start = phdr_ptr->p_offset;
+		end = phdr_ptr->p_offset + phdr_ptr->p_memsz;
+		rest = phdr_ptr->p_memsz;
+
+		if (start & ~PAGE_MASK) {
+			u64 paddr, len;
+			char *buf;
+			struct vmcore *new;
+
+			paddr = start;
+			len = min(roundup(start,PAGE_SIZE), end) - start;
+
+			buf = (char *)get_zeroed_page(GFP_KERNEL);
+			if (!buf)
+				return -ENOMEM;
+			rc = read_from_oldmem(buf + (start & ~PAGE_MASK), len,
+					      &paddr, 0);
+			if (rc < 0) {
+				free_pages((unsigned long)buf, 0);
+				return rc;
+			}
+
+			new = get_new_element();
+			if (!new) {
+				free_pages((unsigned long)buf, 0);
+				return -ENOMEM;
+			}
+			new->flag |= MEM_TYPE_CURRENT_KERNEL;
+			new->size = PAGE_SIZE;
+			new->buf = buf;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= len;
+		}
+
+		if (rest > 0 &&
+		    roundup(start, PAGE_SIZE) < rounddown(end, PAGE_SIZE)) {
+			u64 paddr, len;
+			struct vmcore *new;
+
+			paddr = roundup(start, PAGE_SIZE);
+			len =rounddown(end,PAGE_SIZE)-roundup(start,PAGE_SIZE);
+
+			new = get_new_element();
+			if (!new)
+				return -ENOMEM;
+			new->paddr = paddr;
+			new->size = len;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= len;
+		}
+
+		if (rest > 0) {
+			u64 paddr, len;
+			char *buf;
+			struct vmcore *new;
+
+			paddr = rounddown(end, PAGE_SIZE);
+			len = end - rounddown(end, PAGE_SIZE);
+
+			buf = (char *)get_zeroed_page(GFP_KERNEL);
+			if (!buf)
+				return -ENOMEM;
+			rc = read_from_oldmem(buf, len, &paddr, 0);
+			if (rc < 0) {
+				free_pages((unsigned long)buf, 0);
+				return rc;
+			}
+
+			new = get_new_element();
+			if (!new) {
+				free_pages((unsigned long)buf, 0);
+				return -ENOMEM;
+			}
+			new->flag |= MEM_TYPE_CURRENT_KERNEL;
+			new->size = PAGE_SIZE;
+			new->buf = buf;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= len;
+		}
 
 		/* Update the program header offset */
 		phdr_ptr->p_offset = vmcore_off;
-		vmcore_off = vmcore_off + phdr_ptr->p_memsz;
+		vmcore_off +=roundup(end,PAGE_SIZE)-rounddown(start,PAGE_SIZE);
 	}
 	return 0;
 }

