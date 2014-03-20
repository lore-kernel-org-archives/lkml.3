Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbaCTJtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:49:03 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:54640 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894AbaCTJlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:41:25 -0400
Subject: [PATCH 15/33] Updating Offset
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
Cc: amwang@redhat.com, procps@freelists.org, rdunlap@xenotime.net,
        james.hogan@imgtec.com, aravinda@linux.vnet.ibm.com, hch@lst.de,
        mhiramat@redhat.com, jeremy.fitzhardinge@citrix.com,
        xemul@parallels.com, d.hatayama@jp.fujitsu.com, coreutils@gnu.org,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        util-linux@vger.kernel.org, tarundsk@linux.vnet.ibm.com,
        vapier@gentoo.org, roland@hack.frob.com, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, suzuki@linux.vnet.ibm.com, andi@firstfloor.org,
        tj@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Date: Thu, 20 Mar 2014 15:11:17 +0530
Message-ID: <20140320094117.14878.54577.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-5564-0000-0000-00000C985D02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating offset throughout keeping in mind that they need to be PAGE ALIGNED.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/elf.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/src/elf.c b/src/elf.c
index a5a1feb..a101ddf 100644
--- a/src/elf.c
+++ b/src/elf.c
@@ -39,6 +39,8 @@
 
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
 
+#define ALIGN(addr, pagesize) (((addr) + (pagesize) - 1) & ~(pagesize - 1))
+
 /* Default alignment for program headers */
 #ifndef ELF_EXEC_PAGESIZE
 #define ELF_EXEC_PAGESIZE PAGESIZE
@@ -617,7 +619,6 @@ static int get_phdrs(int pid, struct core_proc *cp)
 	cp_phdrs[0].p_offset = 0;
 	cp_phdrs[0].p_vaddr = 0;
 	cp_phdrs[0].p_paddr = 0;
-	/* Will fill the size after filling notes */
 	cp_phdrs[0].p_filesz = 0;
 	cp_phdrs[0].p_memsz = 0;
 
@@ -671,6 +672,50 @@ static int get_phdrs(int pid, struct core_proc *cp)
 	return 0;
 }
 
+/* Updating the Offset */
+static void update_offset(struct core_proc *cp)
+{
+	Elf_Long data_offset = 0;
+	struct mem_note *note = cp->notes;
+	int i;
+	Elf_Phdr *cp_phdrs;
+	Elf_Ehdr *cp_elf;
+
+	cp_elf = (Elf_Ehdr *)cp->elf_hdr;
+	cp_phdrs = (Elf_Phdr *)cp->phdrs;
+
+	/* ELF HEADER */
+	data_offset += sizeof(Elf_Ehdr);
+
+	/* Program Headers */
+	data_offset += cp->phdrs_count * sizeof(Elf_Phdr);
+
+	/* Notes */
+	cp_phdrs[0].p_offset = data_offset;
+
+	/* Calucalating entire NOTES size */
+	while (note) {
+		data_offset += note->size;
+		note = note->next;
+	}
+
+	/* Filling PT_NOTE size */
+	cp_phdrs[0].p_filesz = data_offset - cp_phdrs[0].p_offset;
+
+	data_offset = ALIGN(data_offset, ELF_EXEC_PAGESIZE);
+
+	/* Populating offsets of Program Headers */
+	for (i = 1; i < cp->phdrs_count; i++) {
+		cp_phdrs[i].p_offset = data_offset;
+		data_offset += cp_phdrs[i].p_filesz;
+		data_offset = ALIGN(data_offset, ELF_EXEC_PAGESIZE);
+	}
+
+	/* Filling extra program header offset if phnum > PN_XNUM */
+	if (cp->phdrs_count > PN_XNUM)
+		cp_elf->e_shoff = data_offset;
+}
+
 int do_elf_coredump(int pid, struct core_proc *cp)
 {
 	int ret, i;
@@ -705,5 +750,8 @@ int do_elf_coredump(int pid, struct core_proc *cp)
 	if (ret)
 		return -1;
 
+	/* Updating offset */
+	update_offset(cp);
+
 	return 0;
 }

