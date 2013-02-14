Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144Ab3BNKMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:12:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46812 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3BNKMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:12:34 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 09/13] vmcore: copy ELF note segments in buffer on 2nd kernel
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 19:12:32 +0900
Message-ID: <20130214101232.22466.44026.stgit@localhost6.localdomain6>
In-Reply-To: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Objects exported from ELF note segments are in fact located apart from
each other on old memory. But on /proc/vmcore they are exported as a
single ELF note segment. To satisfy mmap()'s page-size boundary
requirement, copy them in a page-size aligned buffer allocated by
__get_free_pages() on 2nd kernel and remap the buffer to user-space.

The buffer for ELF note segments is added to vmcore_list as the object
of VMCORE_2ND_KERNEL type.

Copy of ELF note segments is done in two pass: first pass tries to
calculate real total size of ELF note segments, and then 2nd pass
copies the segment data into the buffer of the real total size.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   78 +++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 59 insertions(+), 19 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 3aedb52..ccf0dc5 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -230,27 +230,25 @@ static u64 __init get_vmcore_size_elf32(char *elfptr)
 	return size;
 }
 
-/* Merges all the PT_NOTE headers into one. */
-static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
-						struct list_head *vc_list)
+static int __init parse_note_segments_elf64(char *elfptr, int *nr_ptnote,
+					    u64 *phdr_sz, char *notebuf)
 {
-	int i, nr_ptnote=0, rc=0;
-	char *tmp;
+	int i, rc=0;
+	loff_t notebuf_off = 0;
 	Elf64_Ehdr *ehdr_ptr;
-	Elf64_Phdr phdr, *phdr_ptr;
 	Elf64_Nhdr *nhdr_ptr;
-	u64 phdr_sz = 0, note_off;
+	Elf64_Phdr *phdr_ptr;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
 		int j;
 		void *notes_section;
-		struct vmcore *new;
 		u64 offset, max_sz, sz, real_sz = 0;
 		if (phdr_ptr->p_type != PT_NOTE)
 			continue;
-		nr_ptnote++;
+		if (nr_ptnote)
+			*nr_ptnote = *nr_ptnote + 1;
 		max_sz = phdr_ptr->p_memsz;
 		offset = phdr_ptr->p_offset;
 		notes_section = kmalloc(max_sz, GFP_KERNEL);
@@ -271,20 +269,51 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 			real_sz += sz;
 			nhdr_ptr = (Elf64_Nhdr*)((char*)nhdr_ptr + sz);
 		}
-
-		/* Add this contiguous chunk of notes section to vmcore list.*/
-		new = get_new_element();
-		if (!new) {
-			kfree(notes_section);
-			return -ENOMEM;
+		if (phdr_sz)
+			*phdr_sz += real_sz;
+		if (notebuf) {
+			memcpy(notebuf + notebuf_off, notes_section, real_sz);
+			notebuf_off += real_sz;
 		}
-		new->paddr = phdr_ptr->p_offset;
-		new->size = real_sz;
-		list_add_tail(&new->list, vc_list);
-		phdr_sz += real_sz;
 		kfree(notes_section);
 	}
 
+	return 0;
+}
+
+/* Merges all the PT_NOTE headers into one. */
+static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
+						struct list_head *vc_list)
+{
+	int i, nr_ptnote, rc=0;
+	char *tmp, *notebuf;
+	Elf64_Ehdr *ehdr_ptr;
+	Elf64_Phdr phdr;
+	u64 phdr_sz, note_off, notebuf_sz;
+	struct vmcore *new;
+
+	ehdr_ptr = (Elf64_Ehdr *)elfptr;
+
+	/* The 1st pass calculates real size of ELF note segments. */
+	nr_ptnote = 0;
+	phdr_sz = 0;
+	rc = parse_note_segments_elf64(elfptr, &nr_ptnote, &phdr_sz, NULL);
+	if (rc < 0)
+		return rc;
+
+	/* The 2nd pass copies the ELF note segments into the buffer
+	 * of the exact size. */
+	notebuf_sz = roundup(phdr_sz, PAGE_SIZE);
+	notebuf = (char *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					    get_order(notebuf_sz));
+	if (!notebuf)
+		return -ENOMEM;
+	rc = parse_note_segments_elf64(elfptr, NULL, NULL, notebuf);
+	if (rc < 0) {
+		free_pages((unsigned long)notebuf, get_order(notebuf_sz));
+		return rc;
+	}
+
 	/* Prepare merged PT_NOTE program header. */
 	phdr.p_type    = PT_NOTE;
 	phdr.p_flags   = 0;
@@ -315,6 +344,17 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 
 	*elfsz = roundup(*elfsz, PAGE_SIZE);
 
+	/* Add the merged unique ELF note segments in vmcore_list. */
+	new = get_new_element();
+	if (!new) {
+		free_pages((unsigned long)notebuf, get_order(notebuf_sz));
+		return -ENOMEM;
+	}
+	new->type = VMCORE_2ND_KERNEL;
+	new->buf = notebuf;
+	new->size = notebuf_sz;
+	list_add_tail(&new->list, vc_list);
+
 	return 0;
 }
 

