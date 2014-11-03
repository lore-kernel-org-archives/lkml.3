Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaKCKzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:55:16 -0500
Received: from mail-by2on0077.outbound.protection.outlook.com ([207.46.100.77]:16224
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752590AbaKCKzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:55:10 -0500
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v6 25/29] nios2: Module support
Date: Mon, 3 Nov 2014 18:52:21 +0800
Message-ID: <1415011945-3297-26-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415011945-3297-1-git-send-email-lftan@altera.com>
References: <1415011945-3297-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(22564002)(87286001)(31966008)(33646002)(84676001)(102836001)(42186005)(19580405001)(6806004)(62966003)(44976005)(68736004)(92566001)(2201001)(4396001)(97736003)(93916002)(50226001)(92726001)(86362001)(19580395003)(46102003)(88136002)(50466002)(89996001)(87936001)(105596002)(50986999)(76176999)(64706001)(120916001)(47776003)(99396003)(20776003)(21056001)(48376002)(104166001)(229853001)(107046002)(106466001)(36756003)(77156002)(95666004)(77096003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB595;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB595;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for loadable modules.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/kernel/module.c | 138 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)
 create mode 100644 arch/nios2/kernel/module.c

diff --git a/arch/nios2/kernel/module.c b/arch/nios2/kernel/module.c
new file mode 100644
index 0000000..cc924a3
--- /dev/null
+++ b/arch/nios2/kernel/module.c
@@ -0,0 +1,138 @@
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
+
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

