Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab3EWFZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 01:25:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52810 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3EWFZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 01:25:38 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v8 7/9] vmcore: Allow user process to remap ELF note segment
 buffer
To: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org
Cc: cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Date: Thu, 23 May 2013 14:25:36 +0900
Message-ID: <20130523052536.13864.67507.stgit@localhost6.localdomain6>
In-Reply-To: <20130523052421.13864.83978.stgit@localhost6.localdomain6>
References: <20130523052421.13864.83978.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now ELF note segment has been copied in the buffer on vmalloc
memory. To allow user process to remap the ELF note segment buffer
with remap_vmalloc_page, the corresponding VM area object has to have
VM_USERMAP flag set.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 937709d..9de4d91 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -375,6 +375,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	Elf64_Ehdr *ehdr_ptr;
 	Elf64_Phdr phdr;
 	u64 phdr_sz = 0, note_off;
+	struct vm_struct *vm;
 
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 
@@ -391,6 +392,12 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	if (!*notes_buf)
 		return -ENOMEM;
 
+	/* Allow users to remap ELF note segment buffer on vmalloc
+	 * memory using remap_vmalloc_range. */
+	vm = find_vm_area(*notes_buf);
+	BUG_ON(!vm);
+	vm->flags |= VM_USERMAP;
+
 	rc = copy_notes_elf64(ehdr_ptr, *notes_buf);
 	if (rc < 0)
 		return rc;
@@ -554,6 +561,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 	Elf32_Ehdr *ehdr_ptr;
 	Elf32_Phdr phdr;
 	u64 phdr_sz = 0, note_off;
+	struct vm_struct *vm;
 
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 
@@ -570,6 +578,12 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 	if (!*notes_buf)
 		return -ENOMEM;
 
+	/* Allow users to remap ELF note segment buffer on vmalloc
+	 * memory using remap_vmalloc_range. */
+	vm = find_vm_area(*notes_buf);
+	BUG_ON(!vm);
+	vm->flags |= VM_USERMAP;
+
 	rc = copy_notes_elf32(ehdr_ptr, *notes_buf);
 	if (rc < 0)
 		return rc;

