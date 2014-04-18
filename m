Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaDRMof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:44:35 -0400
Received: from mail-by2on0119.outbound.protection.outlook.com ([207.46.100.119]:34071
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752726AbaDRMob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:44:31 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 24/28] nios2: Module support
Date: Fri, 18 Apr 2014 20:27:07 +0800
Message-ID: <1397824031-4892-21-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397824031-4892-1-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(22564002)(93916002)(97736001)(86362001)(46102001)(50466002)(80022001)(50986999)(80976001)(62966002)(81342001)(4396001)(50226001)(48376002)(81542001)(76176999)(2009001)(99396002)(83072002)(85852003)(76482001)(42186004)(74502001)(47776003)(20776003)(16796002)(77982001)(31966008)(74662001)(84676001)(87936001)(87286001)(77156001)(89996001)(88136002)(19580395003)(36756003)(6806004)(44976005)(19580405001)(83322001)(2201001)(92566001)(92726001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB047;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:EA497D4E.A7F0A659.3C3A97E.84D5CF31.203F1;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for loadable modules.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/kernel/module.c | 135 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 135 insertions(+)
 create mode 100644 arch/nios2/kernel/module.c

diff --git a/arch/nios2/kernel/module.c b/arch/nios2/kernel/module.c
new file mode 100644
index 0000000..360c53ab29f64f4e44c8cfe27f7176d793578569
--- /dev/null
+++ b/arch/nios2/kernel/module.c
@@ -0,0 +1,135 @@
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
+
+void module_arch_cleanup(struct module *mod)
+{
+}
-- 
1.8.3.2

