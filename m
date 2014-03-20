Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbaCTJl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:41:27 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:59501 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146AbaCTJlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:41:19 -0400
Subject: [PATCH 14/33] Populating Program Headers
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
Date: Thu, 20 Mar 2014 15:11:05 +0530
Message-ID: <20140320094105.14878.82749.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-5490-0000-0000-000005364AB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populates the program headers using memory maps linked list which was
populated in patch 5. The source, size and permissions of the maps are
found out and filled respectively.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |    6 +++
 src/coredump.h |    2 +
 src/elf.c      |  108 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/elf32.c    |    2 +
 src/elf64.c    |    1 +
 5 files changed, 119 insertions(+)

diff --git a/src/coredump.c b/src/coredump.c
index 0fd6343e..5cccb7a 100644
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -231,6 +231,12 @@ cleanup:
 	if (cp.notes)
 		free_notes(cp.notes);
 
+	if (cp.phdrs)
+		free(cp.phdrs);
+
+	if (cp.phdrs_count)
+		free(cp.shdrs);
+
 	errno = status;
 
 	return ret;
diff --git a/src/coredump.h b/src/coredump.h
index dce6292..a729f16 100644
--- a/src/coredump.h
+++ b/src/coredump.h
@@ -68,4 +68,6 @@ struct core_proc {
 	int elf_class;			/* Elf class of the process */
 	void *elf_hdr;			/* Stores the ELF_header */
 	struct mem_note *notes;		/* Head of Notes */
+	void *shdrs;			/* Extra Program Headers */
+	void *phdrs;			/* Program Headers */
 };
diff --git a/src/elf.c b/src/elf.c
index 62dc5a9..a5a1feb 100644
--- a/src/elf.c
+++ b/src/elf.c
@@ -39,6 +39,11 @@
 
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
 
+/* Default alignment for program headers */
+#ifndef ELF_EXEC_PAGESIZE
+#define ELF_EXEC_PAGESIZE PAGESIZE
+#endif
+
 /* Appending the note to the list */
 static void append_note(struct mem_note *new_note, struct core_proc *cp)
 {
@@ -110,6 +115,26 @@ static int add_note(const char *name, int type, unsigned int data_sz, void *data
 	return 0;
 }
 
+/*
+ * Reads first few bytes of the address specified and checks if it is
+ * an ELF by checking the magic number.
+ */
+static int get_elf_hdr_vaddr(int pid, Elf_Ehdr *elf, Elf_Addr addr)
+{
+	int ret;
+	struct iovec local, remote;
+
+	local.iov_base = elf;
+	local.iov_len = sizeof(Elf_Ehdr);
+	remote.iov_base = (void *)addr;
+	remote.iov_len = sizeof(Elf_Ehdr);
+	ret = process_vm_readv(pid, &local, 1, &remote, 1, 0);
+	if (ret == -1)
+		return -1;
+
+	return check_elf_hdr(elf->e_ident);
+}
+
 /* Fetchs ELF header of the executable */
 static int get_elf_hdr_exe_file(int pid, Elf_Ehdr *elf)
 {
@@ -568,6 +593,84 @@ static int fetch_thread_notes(struct core_proc *cp)
 	return 0;
 }
 
+/* Populate Program headers */
+static int get_phdrs(int pid, struct core_proc *cp)
+{
+	int n;
+	struct maps *map = cp->vmas;
+	Elf_Ehdr elf;
+	Elf_Phdr *cp_phdrs;
+	Elf_Shdr *cp_shdrs;
+	Elf_Ehdr *cp_elf;
+	cp_elf = (Elf_Ehdr *)cp->elf_hdr;
+
+	cp->phdrs = calloc(cp->phdrs_count, sizeof(Elf_Phdr));
+	if (!cp->phdrs) {
+		status = errno;
+		gencore_log("Could not allocate memory for Program headers.\n");
+		return -1;
+	}
+
+	cp_phdrs = (Elf_Phdr *)cp->phdrs;
+
+	cp_phdrs[0].p_type = PT_NOTE;
+	cp_phdrs[0].p_offset = 0;
+	cp_phdrs[0].p_vaddr = 0;
+	cp_phdrs[0].p_paddr = 0;
+	/* Will fill the size after filling notes */
+	cp_phdrs[0].p_filesz = 0;
+	cp_phdrs[0].p_memsz = 0;
+
+	n = 1;
+
+	while (map) {
+
+		/* Filling the Program Header Values */
+		cp_phdrs[n].p_type = PT_LOAD;
+		cp_phdrs[n].p_offset = 0;
+		cp_phdrs[n].p_vaddr = map->src;
+		cp_phdrs[n].p_paddr = 0;
+		cp_phdrs[n].p_flags = 0;
+		if (map->r == 'r')
+			cp_phdrs[n].p_flags |= PF_R;
+		if (map->w == 'w')
+			cp_phdrs[n].p_flags |= PF_W;
+		if (map->x == 'x')
+			cp_phdrs[n].p_flags |= PF_X;
+
+		cp_phdrs[n].p_memsz = map->dst - map->src;
+
+		if (!(cp_phdrs[n].p_flags & PF_R))
+			cp_phdrs[n].p_filesz = 0;
+		else if (map->inode &&
+			get_elf_hdr_vaddr(pid, &elf, cp_phdrs[n].p_vaddr) == 0)
+			cp_phdrs[n].p_filesz = ELF_EXEC_PAGESIZE;
+		else
+			cp_phdrs[n].p_filesz = cp_phdrs[n].p_memsz;
+		
+		cp_phdrs[n].p_align = ELF_EXEC_PAGESIZE;
+
+		n++;
+		map = map->next;
+	}
+
+	if (cp->phdrs_count > PN_XNUM) {
+		cp->shdrs = malloc(sizeof(Elf_Shdr));
+		if (!cp->shdrs) {
+			status = errno;
+			gencore_log("Could not allocate memory for Extra Program headers.\n");
+			return -1;
+		}
+		cp_shdrs = (Elf_Shdr *)cp->shdrs;
+		cp_shdrs->sh_type = SHT_NULL;
+		cp_shdrs->sh_size = cp_elf->e_shnum;
+		cp_shdrs->sh_link = cp_elf->e_shstrndx;
+		cp_shdrs->sh_info = cp->phdrs_count;
+	}
+
+	return 0;
+}
+
 int do_elf_coredump(int pid, struct core_proc *cp)
 {
 	int ret, i;
@@ -597,5 +700,10 @@ int do_elf_coredump(int pid, struct core_proc *cp)
 	if (ret)
 		return -1;
 
+	/* Get Program headers */
+	ret = get_phdrs(pid, cp);
+	if (ret)
+		return -1;
+
 	return 0;
 }
diff --git a/src/elf32.c b/src/elf32.c
index 8ec287b..daf9940 100644
--- a/src/elf32.c
+++ b/src/elf32.c
@@ -38,4 +38,6 @@
 #define Elf_Long int
 #define Elf_prstatus compat_elf_prstatus
 
+#define Elf_Addr Elf32_Addr
+
 #include "elf.c"
diff --git a/src/elf64.c b/src/elf64.c
index 780e2d4..651f218 100644
--- a/src/elf64.c
+++ b/src/elf64.c
@@ -37,5 +37,6 @@
 #define Elf_prpsinfo elf_prpsinfo
 #define Elf_Long long
 #define Elf_prstatus elf_prstatus
+#define Elf_Addr Elf64_Addr
 
 #include "elf.c"

