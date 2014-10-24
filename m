Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaJXI3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:29:00 -0400
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:43616
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932845AbaJXI0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:26:46 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 25/29] nios2: Module support
Date: Fri, 24 Oct 2014 16:24:27 +0800
Message-ID: <1414139071-3818-26-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(22564002)(104166001)(44976005)(19580395003)(19580405001)(86362001)(93916002)(87936001)(68736004)(42186005)(6806004)(77096002)(47776003)(64706001)(102836001)(4396001)(50226001)(95666004)(88136002)(89996001)(20776003)(92726001)(85852003)(87286001)(2201001)(92566001)(107046002)(105596002)(229853001)(106466001)(31966008)(84676001)(33646002)(48376002)(50466002)(36756003)(76482002)(97736003)(77156001)(76176999)(50986999)(46102003)(99396003)(62966002)(85306004)(80022003)(120916001)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB211;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB211;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for loadable modules.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/kernel/module.c | 137 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)
 create mode 100644 arch/nios2/kernel/module.c

diff --git a/arch/nios2/kernel/module.c b/arch/nios2/kernel/module.c
new file mode 100644
index 0000000..aeebc7f
--- /dev/null
+++ b/arch/nios2/kernel/module.c
@@ -0,0 +1,137 @@
+/*
+ * Kernel module support for Nios II.
+ *
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *   Written by Wentao Xu <xuwentao@microtronix.com>
+ * Copyright (C) 2001, 2003 Rusty Russell
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License.  See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#include <linux/moduleloader.h>
+#include <linux/elf.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+
+#include <asm/pgtable.h>
+#include <asm/cacheflush.h>
+
+/*
+ * Modules should NOT be allocated with kmalloc for (obvious) reasons.
+ * But we do it for now to avoid relocation issues. CALL26/PCREL26 cannot reach
+ * from 0x80000000 (vmalloc area) to 0xc00000000 (kernel) (kmalloc returns
+ * addresses in 0xc0000000)
+ */
+void *module_alloc(unsigned long size)
+{
+	if (size == 0)
+		return NULL;
+	return kmalloc(size, GFP_KERNEL);
+}
+
+/* Free memory returned from module_alloc */
+void module_free(struct module *mod, void *module_region)
+{
+	kfree(module_region);
+}
+
+int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
+			unsigned int symindex, unsigned int relsec,
+			struct module *mod)
+{
+	unsigned int i;
+	Elf32_Rela *rela = (void *)sechdrs[relsec].sh_addr;
+
+	pr_debug("Applying relocate section %u to %u\n", relsec,
+		 sechdrs[relsec].sh_info);
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
+		/* This is where to make the change */
+		uint32_t word;
+		uint32_t *loc
+			= ((void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			   + rela[i].r_offset);
+		/* This is the symbol it is referring to.  Note that all
+		   undefined symbols have been resolved.  */
+		Elf32_Sym *sym
+			= ((Elf32_Sym *)sechdrs[symindex].sh_addr
+				+ ELF32_R_SYM(rela[i].r_info));
+		uint32_t v = sym->st_value + rela[i].r_addend;
+		pr_debug("reltype %d 0x%x name:<%s>\n",
+			ELF32_R_TYPE(rela[i].r_info),
+			rela[i].r_offset, strtab + sym->st_name);
+
+		switch (ELF32_R_TYPE(rela[i].r_info)) {
+		case R_NIOS2_NONE:
+			break;
+		case R_NIOS2_BFD_RELOC_32:
+			*loc += v;
+			break;
+		case R_NIOS2_PCREL16:
+			v -= (uint32_t)loc + 4;
+			if ((int32_t)v > 0x7fff ||
+				(int32_t)v < -(int32_t)0x8000) {
+				pr_err("module %s: relocation overflow\n",
+					mod->name);
+				return -ENOEXEC;
+			}
+			word = *loc;
+			*loc = ((((word >> 22) << 16) | (v & 0xffff)) << 6) |
+				(word & 0x3f);
+			break;
+		case R_NIOS2_CALL26:
+			if (v & 3) {
+				pr_err("module %s: dangerous relocation\n",
+					mod->name);
+				return -ENOEXEC;
+			}
+			if ((v >> 28) != ((uint32_t)loc >> 28)) {
+				pr_err("module %s: relocation overflow\n",
+					mod->name);
+				return -ENOEXEC;
+			}
+			*loc = (*loc & 0x3f) | ((v >> 2) << 6);
+			break;
+		case R_NIOS2_HI16:
+			word = *loc;
+			*loc = ((((word >> 22) << 16) |
+				((v >> 16) & 0xffff)) << 6) | (word & 0x3f);
+			break;
+		case R_NIOS2_LO16:
+			word = *loc;
+			*loc = ((((word >> 22) << 16) | (v & 0xffff)) << 6) |
+					(word & 0x3f);
+			break;
+		case R_NIOS2_HIADJ16:
+			{
+				Elf32_Addr word2;
+
+				word = *loc;
+				word2 = ((v >> 16) + ((v >> 15) & 1)) & 0xffff;
+				*loc = ((((word >> 22) << 16) | word2) << 6) |
+						(word & 0x3f);
+			}
+			break;
+
+		default:
+			pr_err("module %s: Unknown reloc: %u\n",
+				mod->name, ELF32_R_TYPE(rela[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+
+	return 0;
+}
+
+int module_finalize(const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs,
+			struct module *me)
+{
+	flush_cache_all();
+	return 0;
+}
-- 
1.8.2.1

