Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3CEHFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:05:10 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50346 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3CEHFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:05:07 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v2 02/20] vmcore: rearrange program headers without assuming
 consequtive PT_NOTE entries
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 02 Mar 2013 17:35:59 +0900
Message-ID: <20130302083559.31252.60341.stgit@localhost6.localdomain6>
In-Reply-To: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code assumes all PT_NOTE headers are placed at the beginning
of program header table and they are consequtive. But the assumption
could be broken by future changes on either kexec-tools or the 1st
kernel. This patch removes the assumption and rearranges program
headers as the following conditions are satisfied:

- PT_NOTE entry is unique at the first entry,

- the order of program headers are unchanged during this
  rearrangement, only their positions are changed in positive
  direction.

- unused part that occurs in the bottom of program headers are filled
  with 0.

Also, this patch adds one exceptional case where the number of PT_NOTE
entries is somehow 0. Then, immediately go out of the function.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   92 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 74 insertions(+), 18 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index abf4f01..b5c9e33 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -251,8 +251,7 @@ static u64 __init get_vmcore_size_elf32(char *elfptr)
 static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 						struct list_head *vc_list)
 {
-	int i, nr_ptnote=0, rc=0;
-	char *tmp;
+	int i, j, nr_ptnote=0, i_ptnote, rc=0;
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr phdr, *phdr_ptr;
 	Elf64_Nhdr *nhdr_ptr;
@@ -302,6 +301,39 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 		kfree(notes_section);
 	}
 
+	if (nr_ptnote == 0)
+		goto out;
+
+	phdr_ptr = (Elf64_Phdr *)(elfptr + ehdr_ptr->e_phoff);
+
+	/* Remove unwanted PT_NOTE program headers. */
+
+        /* - 1st pass shifts non-PT_NOTE entries until the first
+	     PT_NOTE entry. */
+	i_ptnote = -1;
+	for (i = 0; i < ehdr_ptr->e_phnum; ++i) {
+		if (phdr_ptr[i].p_type == PT_NOTE) {
+			i_ptnote = i;
+			break;
+		}
+	}
+	BUG_ON(i_ptnote == -1); /* impossible case since nr_ptnote > 0. */
+	memmove(phdr_ptr + 1, phdr_ptr,	i_ptnote * sizeof(Elf64_Phdr));
+
+	/* - 2nd pass moves the remaining non-PT_NOTE entries under
+	     the first PT_NOTE entry. */
+	for (i = j = i_ptnote + 1; i < ehdr_ptr->e_phnum; i++) {
+		if (phdr_ptr[i].p_type != PT_NOTE) {
+			memmove(phdr_ptr + j, phdr_ptr + i,
+				sizeof(Elf64_Phdr));
+			j++;
+		}
+	}
+
+	/* - Finally, fill unused part with 0. */
+	memset(phdr_ptr + ehdr_ptr->e_phnum - (nr_ptnote - 1), 0,
+	       (nr_ptnote - 1) * sizeof(Elf64_Phdr));
+
 	/* Prepare merged PT_NOTE program header. */
 	phdr.p_type    = PT_NOTE;
 	phdr.p_flags   = 0;
@@ -313,18 +345,14 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	phdr.p_align   = 0;
 
 	/* Add merged PT_NOTE program header*/
-	tmp = elfptr + ehdr_ptr->e_phoff;
-	memcpy(tmp, &phdr, sizeof(phdr));
-	tmp += sizeof(phdr);
+	memcpy(phdr_ptr, &phdr, sizeof(Elf64_Phdr));
 
-	/* Remove unwanted PT_NOTE program headers. */
-	i = (nr_ptnote - 1) * sizeof(Elf64_Phdr);
-	*elfsz = *elfsz - i;
-	memmove(tmp, tmp+i, ((*elfsz)-ehdr_ptr->e_phoff-sizeof(Elf64_Phdr)));
+	*elfsz = *elfsz - (nr_ptnote - 1) * sizeof(Elf64_Phdr);
 
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
 
+out:
 	return 0;
 }
 
@@ -332,8 +360,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 						struct list_head *vc_list)
 {
-	int i, nr_ptnote=0, rc=0;
-	char *tmp;
+	int i, j, nr_ptnote=0, i_ptnote, rc=0;
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr phdr, *phdr_ptr;
 	Elf32_Nhdr *nhdr_ptr;
@@ -383,6 +410,39 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 		kfree(notes_section);
 	}
 
+	if (nr_ptnote == 0)
+		goto out;
+
+	phdr_ptr = (Elf32_Phdr *)(elfptr + ehdr_ptr->e_phoff);
+
+	/* Remove unwanted PT_NOTE program headers. */
+
+	/* - 1st pass shifts non-PT_NOTE entries until the first
+	     PT_NOTE entry. */
+	i_ptnote = -1;
+	for (i = 0; i < ehdr_ptr->e_phnum; ++i) {
+		if (phdr_ptr[i].p_type == PT_NOTE) {
+			i_ptnote = i;
+			break;
+		}
+	}
+	BUG_ON(i_ptnote == -1); /* impossible case since nr_ptnote > 0. */
+	memmove(phdr_ptr + 1, phdr_ptr, i_ptnote * sizeof(Elf32_Phdr));
+
+	/* - 2nd pass moves the remaining non-PT_NOTE entries under
+	     the first PT_NOTE entry. */
+	for (i = j = i_ptnote + 1; i < ehdr_ptr->e_phnum; i++) {
+		if (phdr_ptr[i].p_type != PT_NOTE) {
+			memmove(phdr_ptr + j, phdr_ptr + i,
+				sizeof(Elf32_Phdr));
+			j++;
+		}
+	}
+
+	/* - Finally, fill unused part with 0. */
+	memset(phdr_ptr + ehdr_ptr->e_phnum - (nr_ptnote - 1), 0,
+	       (nr_ptnote - 1) * sizeof(Elf32_Phdr));
+
 	/* Prepare merged PT_NOTE program header. */
 	phdr.p_type    = PT_NOTE;
 	phdr.p_flags   = 0;
@@ -394,18 +454,14 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 	phdr.p_align   = 0;
 
 	/* Add merged PT_NOTE program header*/
-	tmp = elfptr + ehdr_ptr->e_phoff;
-	memcpy(tmp, &phdr, sizeof(phdr));
-	tmp += sizeof(phdr);
+	memcpy(phdr_ptr, &phdr, sizeof(Elf32_Phdr));
 
-	/* Remove unwanted PT_NOTE program headers. */
-	i = (nr_ptnote - 1) * sizeof(Elf32_Phdr);
-	*elfsz = *elfsz - i;
-	memmove(tmp, tmp+i, ((*elfsz)-ehdr_ptr->e_phoff-sizeof(Elf32_Phdr)));
+	*elfsz = *elfsz - (nr_ptnote - 1) * sizeof(Elf32_Phdr);
 
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
 
+out:
 	return 0;
 }
 

