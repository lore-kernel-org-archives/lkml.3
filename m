Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3JDKdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:33:02 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:32892 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3JDKdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:33:00 -0400
Subject: [PATCH 16/19] Generate the data sections for ELF Core
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@in.ibm.com>
Cc: amwang@redhat.com, rdunlap@xenotime.net, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
        suzuki@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com,
        adobriyan@gmail.com, tarundsk@linux.vnet.ibm.com, vapier@gentoo.org,
        roland@hack.frob.com, tj@kernel.org, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Date: Fri, 04 Oct 2013 16:02:39 +0530
Message-ID: <20131004103239.1612.31930.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-5490-0000-0000-000004429170
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

Generate the "data" for the memory regions. Also write down the section header
if we have, number of phdrs > PN_XNUM.

The vma areas are read, page by page using access_process_vm() without an
mmap_sem. If there are active threads, then we may miss a vma if it is removed
while we are doing the read.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N. Mavinakayanahalli <ananth@in.ibm.com>
---
 fs/proc/gencore-elf.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 2 deletions(-)

diff --git a/fs/proc/gencore-elf.c b/fs/proc/gencore-elf.c
index efd1722..244e5bb 100644
--- a/fs/proc/gencore-elf.c
+++ b/fs/proc/gencore-elf.c
@@ -314,10 +314,29 @@ static int create_elf_header(struct core_proc *cp)
 	return 0;
 }
 
+/*
+ * Verify if the fpos asked for in read is valid.
+ * Returns the phdr corresponding to offset, else NULL.
+ */
+static struct elf_phdr *get_pos_elfphdr(struct core_proc *cp, loff_t pos)
+{
+	struct elfhdr *elf_hdr = (struct elfhdr *)cp->elf_buf;
+	struct elf_phdr *phdr = (struct elf_phdr*)(cp->elf_buf + elf_hdr->e_phoff);
+	int i;
+
+	for (i = 0; i < cp->nphdrs; i++, phdr++) {
+		unsigned long end = phdr->p_offset + phdr->p_filesz;
+		if ((pos >= phdr->p_offset) && (pos < end) && phdr->p_filesz)
+			return phdr;
+	}
+	return NULL;
+}
+
 ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
 				size_t buflen, loff_t *fpos)
 {
-	ssize_t ret = 0;
+	ssize_t ret = 0, acc = 0;
+	struct elfhdr *elf_hdr = (struct elfhdr *)cp->elf_buf;
 
 	if (!cp->notes_size) {
 		if (!collect_notes(cp)) {
@@ -349,13 +368,80 @@ ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
 			goto out;
 		} else {
 			ret = bcp;
+			acc = bcp;
 			*fpos += bcp;
 			buflen -= bcp;
 			buffer += bcp;
 		}
 	}
+
 	if (*fpos > cp->size)
-		goto out;
+		goto done;
+
+	/*
+	 * Read from the vma segments
+	 * a. verify if the *fpos is within a phdr
+	 * b. Use access_process_vm() to get data page by page
+	 * c. copy_to_user into user buffer
+	 */
+
+	while (buflen) {
+		size_t bufsz, offset, bytes;
+		char *readbuf;
+		struct elf_phdr *phdr = get_pos_elfphdr(cp, *fpos);
+
+		if (!phdr)
+			break;
+
+		bufsz = (buflen > PAGE_SIZE) ? PAGE_SIZE : buflen;
+		readbuf = kmalloc(bufsz, GFP_KERNEL);
+		if (!readbuf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		offset = *fpos - phdr->p_offset;
+		bytes = access_process_vm(cp->task, (phdr->p_vaddr + offset),
+							readbuf, bufsz, 0);	 		
+		if (!bytes) {
+			ret = -EIO;
+			goto out;
+		}
+		if (copy_to_user(buffer, readbuf, bytes)) {
+			ret = -EFAULT;
+			kfree(readbuf);
+			goto out;
+		} else
+			acc += bytes;
+
+		kfree(readbuf);
+		buflen -= bytes;
+		buffer += bytes;
+		*fpos += bytes;
+	}
+
+	/* Fill extnum section header if present */
+	if (buflen &&
+		elf_hdr->e_shoff &&
+		(*fpos >= elf_hdr->e_shoff) &&
+		(*fpos < (elf_hdr->e_shoff + sizeof(struct elf_shdr)))) {
+
+		off_t offset = *fpos - elf_hdr->e_shoff;
+		size_t shdrsz = sizeof(struct elf_shdr) - offset;
+
+		shdrsz = (buflen < shdrsz) ? buflen : shdrsz;
+		if (copy_to_user(buffer, ((char *)cp->shdr) + offset, shdrsz)) {
+			ret = -EFAULT;
+			goto out;
+		} else {
+			acc += shdrsz;
+			buflen -= shdrsz;
+			buffer += shdrsz;
+		}
+	}
+ 
+done:
+	ret = acc;
   
 out:
 	return ret;

