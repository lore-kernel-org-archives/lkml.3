Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3JDKbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:31:47 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56414 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab3JDKbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:31:45 -0400
Subject: [PATCH 07/19] ia64 impelementation for elf_core_copy_extra_phdrs()
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
Date: Fri, 04 Oct 2013 16:01:35 +0530
Message-ID: <20131004103135.1612.79235.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-3864-0000-0000-00000A61B59B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

ia64 impelementation for elf_core_copy_extra_phdrs(). Adapted from
elf_core_write_extra_phdrs().

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 arch/ia64/kernel/elfcore.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/ia64/kernel/elfcore.c b/arch/ia64/kernel/elfcore.c
index bac1639..64c8acf 100644
--- a/arch/ia64/kernel/elfcore.c
+++ b/arch/ia64/kernel/elfcore.c
@@ -42,6 +42,40 @@ int elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
 	return 1;
 }
 
+int elf_core_copy_extra_phdrs(char *bufp, loff_t offset, size_t *size,
+				unsigned long limit)
+{
+	const struct elf_phdr *const gate_phdrs =
+		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
+	int i;
+	Elf64_Off ofs = 0;
+	struct elf_phdr *phdr = (struct elf_phdr *) bufp;
+
+	for (i = 0; i < GATE_EHDR->e_phnum; ++i) {
+		*size += sizeof(*phdr);
+		if (*size > limit)
+			return 0;
+
+		*phdr = gate_phdrs[i];
+
+		if (phdr->p_type == PT_LOAD) {
+			phdr->p_memsz = PAGE_ALIGN(phdr->p_memsz);
+			phdr->p_filesz = phdr->p_memsz;
+			if (ofs == 0) {
+				ofs = phdr->p_offset = *offset;
+				offset += phdr->p_filesz;
+			} else {
+				phdr->p_offset = ofs;
+			}
+		} else {
+			phdr->p_offset += ofs;
+		}
+		phdr->p_paddr = 0; /* match other core phdrs */
+		phdr++;
+	}
+	return 1;
+}
+
 int elf_core_write_extra_data(struct file *file, size_t *size,
 			      unsigned long limit)
 {

