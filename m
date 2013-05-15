Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab3EOJG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:06:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51912 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab3EOJGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:06:23 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v6 7/8] vmcore: calculate vmcore file size from buffer size
 and total size of vmcore objects
To: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org
Cc: cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Date: Wed, 15 May 2013 18:06:20 +0900
Message-ID: <20130515090620.28109.68803.stgit@localhost6.localdomain6>
In-Reply-To: <20130515090507.28109.28956.stgit@localhost6.localdomain6>
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patches newly added holes before each chunk of memory and
the holes need to be count in vmcore file size. There are two ways to
count file size in such a way:

1) supporse m as a poitner to the last vmcore object in vmcore_list.
, then file size is (m->offset + m->size), or

2) calculate sum of size of buffers for ELF header, program headers,
ELF note segments and objects in vmcore_list.

Although 1) is more direct and simpler than 2), 2) seems better in
that it reflects internal object structure of /proc/vmcore. Thus, this
patch changes get_vmcore_size_elf{64, 32} so that it calculates size
in the way of 2).

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---

 fs/proc/vmcore.c |   40 ++++++++++++++++++----------------------
 1 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 4e121fda..7f2041c 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -210,36 +210,28 @@ static struct vmcore* __init get_new_element(void)
 	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
 }
 
-static u64 __init get_vmcore_size_elf64(char *elfptr, size_t elfsz)
+static u64 __init get_vmcore_size_elf64(size_t elfsz, size_t elfnotesegsz,
+					struct list_head *vc_list)
 {
-	int i;
 	u64 size;
-	Elf64_Ehdr *ehdr_ptr;
-	Elf64_Phdr *phdr_ptr;
+	struct vmcore *m;
 
-	ehdr_ptr = (Elf64_Ehdr *)elfptr;
-	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
-	size = elfsz;
-	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
-		size += phdr_ptr->p_memsz;
-		phdr_ptr++;
+	size = elfsz + elfnotesegsz;
+	list_for_each_entry(m, vc_list, list) {
+		size += m->size;
 	}
 	return size;
 }
 
-static u64 __init get_vmcore_size_elf32(char *elfptr, size_t elfsz)
+static u64 __init get_vmcore_size_elf32(size_t elfsz, size_t elfnotesegsz,
+					struct list_head *vc_list)
 {
-	int i;
 	u64 size;
-	Elf32_Ehdr *ehdr_ptr;
-	Elf32_Phdr *phdr_ptr;
+	struct vmcore *m;
 
-	ehdr_ptr = (Elf32_Ehdr *)elfptr;
-	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
-	size = elfsz;
-	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
-		size += phdr_ptr->p_memsz;
-		phdr_ptr++;
+	size = elfsz + elfnotesegsz;
+	list_for_each_entry(m, vc_list, list) {
+		size += m->size;
 	}
 	return size;
 }
@@ -795,14 +787,18 @@ static int __init parse_crash_elf_headers(void)
 			return rc;
 
 		/* Determine vmcore size. */
-		vmcore_size = get_vmcore_size_elf64(elfcorebuf, elfcorebuf_sz);
+		vmcore_size = get_vmcore_size_elf64(elfcorebuf_sz,
+						    elfnotes_sz,
+						    &vmcore_list);
 	} else if (e_ident[EI_CLASS] == ELFCLASS32) {
 		rc = parse_crash_elf32_headers();
 		if (rc)
 			return rc;
 
 		/* Determine vmcore size. */
-		vmcore_size = get_vmcore_size_elf32(elfcorebuf, elfcorebuf_sz);
+		vmcore_size = get_vmcore_size_elf32(elfcorebuf_sz,
+						    elfnotes_sz,
+						    &vmcore_list);
 	} else {
 		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;

