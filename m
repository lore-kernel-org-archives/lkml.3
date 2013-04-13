Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967514Ab3DRJgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:36:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36933 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967359Ab3DRJfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:35:07 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v4 5/8] vmcore: copy ELF note segments in the 2nd kernel per
 page vmcore objects
To: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org
Cc: cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com
Date: Sat, 13 Apr 2013 09:21:33 +0900
Message-ID: <20130413002133.18245.91528.stgit@localhost6.localdomain6>
In-Reply-To: <20130413002000.18245.21513.stgit@localhost6.localdomain6>
References: <20130413002000.18245.21513.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy ELF note segmnets in buffer on the 2nd kernel and the buffer is
allocated on page boundary for the purpose of mmap.

The reason why we don't allocate ELF note segments in the 1st kernel
(old memory) on page boundary is to keep backward compatibility for
old kernels, and one more reason is that if doing so, we waste not a
little memory due to round-up operation to fit the memory to page
boundary since most of the buffers are in per-cpu area.

ELF notes are per-cpu, so total size of ELF note segments increases
according to the number of CPUs. The current maximum number of CPUs on
x86_64 is 5192, and there's already system with 4192 CPUs in SGI,
where total size amounts to 1MB. This can be larger in the neare
futrue or possibly even now on another architecture. Thus, to avoid
the case where memory allocation for large block fails, we allocate
vmcore objects per pages.

Note that we cannot use remap_vmalloc_range here since the vma passed
to it as the first argument needs to cover a full range of memory. We
need to be able to specify where to map in pages, but we cannot do it
by remap_vmalloc_range.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 131d8fa..e27da40 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -200,7 +200,62 @@ static int __init vmcore_add(struct list_head *vc_list, u64 paddr, u64 size)
 	return 0;
 }
 
+struct vmcore_per_unit_state {
+	struct vmcore *last;
+	u64 pos;
+	u64 unit;
+	struct list_head *vc_list;
+};
+
+/*
+ * Assumptions:
+ * - given physical addresses are all exclusive; don't check exclusiveness.
+ */
+static int __init vmcore_add_per_unit(struct vmcore_per_unit_state *state,
+				      u64 paddr, u64 size)
+{
+	u64 offset = paddr, remaining_bytes = size;
+	int rc;
+
+	while (remaining_bytes > 0) {
+		u64 read_bytes;
+
+		BUG_ON(state->pos > state->unit);
+
+		if (!state->last || state->pos == state->unit) {
+			struct vmcore *new;
+
+			new = get_new_element();
+			if (!new)
+				return -ENOMEM;
+			new->flag = MEM_TYPE_CURRENT_KERNEL;
+			new->size = PAGE_SIZE;
+			new->buf = (char *)get_zeroed_page(GFP_KERNEL);
+			if (!new->buf) {
+				kfree(new);
+				return -ENOMEM;
+			}
+			list_add_tail(&new->list, state->vc_list);
+			state->last = new;
+			state->pos = 0;
+		}
+
+		read_bytes = min(remaining_bytes, state->unit - state->pos);
+
+		rc = read_from_oldmem(state->last->buf + state->pos, read_bytes,
+				      &offset, 0);
+		if (rc < 0)
+			return rc;
+
+		state->pos += read_bytes;
+		remaining_bytes -= read_bytes;
+	}
+
+	return 0;
+}
+
 static u64 __init get_vmcore_size_elf64(char *elfptr, size_t elfsz)
+
 {
 	int i;
 	u64 size;
@@ -244,6 +299,12 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	Elf64_Phdr phdr, *phdr_ptr;
 	Elf64_Nhdr *nhdr_ptr;
 	u64 phdr_sz = 0, note_off;
+	struct vmcore_per_unit_state state = {
+		.last = NULL,
+		.pos = 0,
+		.unit = PAGE_SIZE,
+		.vc_list = vc_list,
+	};
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
@@ -276,7 +337,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 		}
 
 		/* Add this contiguous chunk of notes section to vmcore list.*/
-		if (vmcore_add(vc_list, phdr_ptr->p_offset, real_sz)) {
+		if (vmcore_add_per_unit(&state, phdr_ptr->p_offset, real_sz)) {
 			kfree(notes_section);
 			return -ENOMEM;
 		}
@@ -323,6 +384,12 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 	Elf32_Phdr phdr, *phdr_ptr;
 	Elf32_Nhdr *nhdr_ptr;
 	u64 phdr_sz = 0, note_off;
+	struct vmcore_per_unit_state state = {
+		.last = NULL,
+		.pos = 0,
+		.unit = PAGE_SIZE,
+		.vc_list = vc_list,
+	};
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
@@ -355,7 +422,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 		}
 
 		/* Add this contiguous chunk of notes section to vmcore list.*/
-		if (vmcore_add(vc_list, phdr_ptr->p_offset, real_sz)) {
+		if (vmcore_add_per_unit(&state, phdr_ptr->p_offset, real_sz)) {
 			kfree(notes_section);
 			return -ENOMEM;
 		}

