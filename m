Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbaCTJlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:41:36 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:55207 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaCTJlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:41:31 -0400
Subject: [PATCH 16/33] Writing to core file
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
Date: Thu, 20 Mar 2014 15:11:22 +0530
Message-ID: <20140320094122.14878.63919.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-8878-0000-0000-00000B6923D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writing the core details onto the corefile namely the ELF_HEADER, the
PROGRAM_HEADERS, the NOTES and the actual MEMORY.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |    5 ++++
 src/coredump.h |    1 +
 src/elf.c      |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/src/coredump.c b/src/coredump.c
index 5cccb7a..a6bcaae 100644
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -206,6 +206,9 @@ int do_coredump(int pid, char *core_file)
 	if (ret == -1)
 		goto cleanup;
 
+	/* Initialise core file name */
+	cp.corefile = core_file;
+
 	/* Do elf_dump */
 	if (cp.elf_class == ELFCLASS32)
 		ret = do_elf32_coredump(pid, &cp);
@@ -295,6 +298,8 @@ int main(int argc, char *argv[])
 
 		if (ret == -1)
 			gencore_log("Failed to create core file.\n");
+		else
+			fprintf(stdout, "Created core file.\n");
 	}
 
 	return ret;
diff --git a/src/coredump.h b/src/coredump.h
index a729f16..334d930 100644
--- a/src/coredump.h
+++ b/src/coredump.h
@@ -70,4 +70,5 @@ struct core_proc {
 	struct mem_note *notes;		/* Head of Notes */
 	void *shdrs;			/* Extra Program Headers */
 	void *phdrs;			/* Program Headers */
+	char *corefile;			/* Name of the core file */
 };
diff --git a/src/elf.c b/src/elf.c
index a101ddf..5b09596 100644
--- a/src/elf.c
+++ b/src/elf.c
@@ -716,6 +716,71 @@ static void update_offset(struct core_proc *cp)
 		cp_elf->e_shoff = data_offset;
 }
 
+/* Writing into corefile */
+static int write_to_core(int pid, struct core_proc *cp)
+{
+	FILE *fcore;
+	int i, ret;
+	unsigned char *mem_segs;
+	struct iovec local, remote;
+	struct mem_note *note = cp->notes;
+	Elf_Phdr *cp_phdrs;
+	Elf_Ehdr *cp_elf;
+
+	cp_elf = (Elf_Ehdr *)cp->elf_hdr;
+	cp_phdrs = (Elf_Phdr *)cp->phdrs;
+
+	/* Writing to File */
+	fcore = fopen(cp->corefile, "wb");
+	if (fcore == NULL) {
+		status = errno;
+		gencore_log("Could not open: %s.\n", cp->corefile);
+		return -1;
+	}
+
+	/* ELF HEADER */
+	fwrite(cp->elf_hdr, sizeof(Elf_Ehdr), 1, fcore);
+
+	/* PROGRAM HEAERS */
+	for (i = 0; i < cp->phdrs_count; i++)
+		fwrite(&cp_phdrs[i], sizeof(Elf_Phdr), 1, fcore);
+
+	/* NOTES */
+	while (note) {
+		fwrite(note->notebuf, note->size, 1, fcore);
+		note = note->next;
+	}
+
+	/* MEMORY */
+	for (i = 1; i < cp->phdrs_count; i++) {
+		mem_segs = malloc(cp_phdrs[i].p_filesz * sizeof(unsigned char));
+		local.iov_base = mem_segs;
+		local.iov_len = cp_phdrs[i].p_filesz;
+		remote.iov_base = (void *) cp_phdrs[i].p_vaddr;
+		remote.iov_len = cp_phdrs[i].p_filesz;
+		if ((cp_phdrs[i].p_flags & PF_R))
+			ret = process_vm_readv(pid, &local, 1, &remote, 1, 0);
+		if (ret == -1) {
+			status = errno;
+			gencore_log("Could not read memory from address: %llx.\n", cp_phdrs[i].p_vaddr);
+			fclose(fcore);
+			free(mem_segs);
+			return -1;
+		}
+
+		fseek(fcore, cp_phdrs[i].p_offset, SEEK_SET);
+		ret = fwrite(mem_segs, cp_phdrs[i].p_filesz, 1, fcore);
+		free(mem_segs);
+	}
+
+	/* Writing extra program headers if cp.phdrs_count > PN_XNUM */
+	if (cp->phdrs_count > PN_XNUM)
+		fwrite(cp->shdrs, sizeof(Elf_Shdr), 1, fcore);
+
+	fclose(fcore);
+	return 0;
+}
+
 int do_elf_coredump(int pid, struct core_proc *cp)
 {
 	int ret, i;
@@ -753,5 +818,10 @@ int do_elf_coredump(int pid, struct core_proc *cp)
 	/* Updating offset */
 	update_offset(cp);
 
+	/* Writing to core */
+	ret = write_to_core(pid, cp);
+	if (ret)
+		return -1;
+
 	return 0;
 }

