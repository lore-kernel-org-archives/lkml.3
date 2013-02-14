Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691Ab3BNKNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:13:41 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48742 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab3BNKMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:12:51 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 12/13] vmcore: copy non page-size aligned head and tail pages
 in 2nd kernel
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 19:12:48 +0900
Message-ID: <20130214101248.22466.53004.stgit@localhost6.localdomain6>
In-Reply-To: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
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

    00000000-0001ffff : reserved
    00010000-0009f7ff : System RAM
    0009f800-0009ffff : reserved

where the System RAM ends with 0x9f800 that is not page-size
aligned. This map is divided into two parts:

    00010000-0009dfff
    0009f000-0009f7ff

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

 fs/proc/vmcore.c |   97 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 87 insertions(+), 10 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 2968e5a..99f5673 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -446,11 +446,10 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
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
 	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr)); /* PT_NOTE hdr */
@@ -460,20 +459,98 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
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
+			new->type = VMCORE_2ND_KERNEL;
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
+			new->type = VMCORE_OLD_MEMORY;
+			new->paddr = paddr;
+			new->size = len;
+			list_add_tail(&new->list, vc_list);
+
+			rest -= new->size;
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
+			new->type = VMCORE_2ND_KERNEL;
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

