Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3JDKfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:35:09 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56432 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab3JDKbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:31:49 -0400
Subject: [PATCH 08/19] elf_core_copy_extra_phdrs() for UML
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
Date: Fri, 04 Oct 2013 16:01:41 +0530
Message-ID: <20131004103141.1612.89888.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-3864-0000-0000-00000A61B5AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

elf_core_copy_extra_phdrs() for UML. Adapted from elf_core_write_extra_phdrs()

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 arch/x86/um/elfcore.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/x86/um/elfcore.c b/arch/x86/um/elfcore.c
index 6bb49b6..edecfce 100644
--- a/arch/x86/um/elfcore.c
+++ b/arch/x86/um/elfcore.c
@@ -41,6 +41,38 @@ int elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
 	return 1;
 }
 
+int elf_core_copy_extra_phdrs(char *bufp, loff_t offset, size_t *size,
+				unsigned long limit)
+{
+	if (vsyscall_ehdr) {
+		const struct elfhdr *const ehdrp =
+			(struct elfhdr *) vsyscall_ehdr;
+		const struct elf_phdr *const phdrp =
+			(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
+		struct elf_phdr *phdr = (struct elf_phdr *)bufp;
+		int i;
+		Elf32_Off ofs = 0;
+
+		for (i = 0; i < ehdrp->e_phnum; ++i) {
+			*size += sizeof(*phdr);
+			if (*size > limit)
+				return 0;
+
+			*phdr = phdrp[i];
+
+			if (phdr.p_type == PT_LOAD) {
+				ofs = phdr.p_offset = offset;
+				offset += phdr.p_filesz;
+			} else {
+				phdr.p_offset += ofs;
+			}
+			phdr.p_paddr = 0; /* match other core phdrs */
+			phdr++;
+		}
+	}
+	return 1;
+}  
+  
 int elf_core_write_extra_data(struct file *file, size_t *size,
 			      unsigned long limit)
 {

