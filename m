Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967357Ab3DRJfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:35:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43920 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967359Ab3DRJe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:34:59 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v4 4/8] vmcore: Add helper function vmcore_add()
To: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org
Cc: cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com
Date: Sat, 13 Apr 2013 09:21:28 +0900
Message-ID: <20130413002128.18245.77348.stgit@localhost6.localdomain6>
In-Reply-To: <20130413002000.18245.21513.stgit@localhost6.localdomain6>
References: <20130413002000.18245.21513.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Later patch will introduce a helper function, vmcore_add_per_unit, to
add memory chunks per a given size in vmcore_list. As a preparation
this patch introduces a helper function that adds a given memory chunk
in vmcore_list in a simple manner.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   44 ++++++++++++++++++++------------------------
 1 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 7e7c7ca..131d8fa 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -186,6 +186,20 @@ static struct vmcore* __init get_new_element(void)
 	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
 }
 
+static int __init vmcore_add(struct list_head *vc_list, u64 paddr, u64 size)
+{
+	struct vmcore *new;
+
+	new = get_new_element();
+	if (!new)
+		return -ENOMEM;
+	new->paddr = paddr;
+	new->size = size;
+	list_add_tail(&new->list, vc_list);
+
+	return 0;
+}
+
 static u64 __init get_vmcore_size_elf64(char *elfptr, size_t elfsz)
 {
 	int i;
@@ -236,7 +250,6 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
 		int j;
 		void *notes_section;
-		struct vmcore *new;
 		u64 offset, max_sz, sz, real_sz = 0;
 		if (phdr_ptr->p_type != PT_NOTE)
 			continue;
@@ -263,14 +276,11 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 		}
 
 		/* Add this contiguous chunk of notes section to vmcore list.*/
-		new = get_new_element();
-		if (!new) {
+		if (vmcore_add(vc_list, phdr_ptr->p_offset, real_sz)) {
 			kfree(notes_section);
 			return -ENOMEM;
 		}
-		new->paddr = phdr_ptr->p_offset;
-		new->size = real_sz;
-		list_add_tail(&new->list, vc_list);
+
 		phdr_sz += real_sz;
 		kfree(notes_section);
 	}
@@ -319,7 +329,6 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
 		int j;
 		void *notes_section;
-		struct vmcore *new;
 		u64 offset, max_sz, sz, real_sz = 0;
 		if (phdr_ptr->p_type != PT_NOTE)
 			continue;
@@ -346,14 +355,11 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 		}
 
 		/* Add this contiguous chunk of notes section to vmcore list.*/
-		new = get_new_element();
-		if (!new) {
+		if (vmcore_add(vc_list, phdr_ptr->p_offset, real_sz)) {
 			kfree(notes_section);
 			return -ENOMEM;
 		}
-		new->paddr = phdr_ptr->p_offset;
-		new->size = real_sz;
-		list_add_tail(&new->list, vc_list);
+
 		phdr_sz += real_sz;
 		kfree(notes_section);
 	}
@@ -396,7 +402,6 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr *phdr_ptr;
 	loff_t vmcore_off;
-	struct vmcore *new;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr)); /* PT_NOTE hdr */
@@ -409,12 +414,8 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
 			continue;
 
 		/* Add this contiguous chunk of memory to vmcore list.*/
-		new = get_new_element();
-		if (!new)
+		if (vmcore_add(vc_list, phdr_ptr->p_offset, phdr_ptr->p_memsz))
 			return -ENOMEM;
-		new->paddr = phdr_ptr->p_offset;
-		new->size = phdr_ptr->p_memsz;
-		list_add_tail(&new->list, vc_list);
 
 		/* Update the program header offset. */
 		phdr_ptr->p_offset = vmcore_off;
@@ -431,7 +432,6 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr *phdr_ptr;
 	loff_t vmcore_off;
-	struct vmcore *new;
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr)); /* PT_NOTE hdr */
@@ -444,12 +444,8 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 			continue;
 
 		/* Add this contiguous chunk of memory to vmcore list.*/
-		new = get_new_element();
-		if (!new)
+		if (vmcore_add(vc_list, phdr_ptr->p_offset, phdr_ptr->p_memsz))
 			return -ENOMEM;
-		new->paddr = phdr_ptr->p_offset;
-		new->size = phdr_ptr->p_memsz;
-		list_add_tail(&new->list, vc_list);
 
 		/* Update the program header offset */
 		phdr_ptr->p_offset = vmcore_off;

