Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbaGOIsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:48:45 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:33833
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757894AbaGOIse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:48:34 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v2 24/29] nios2: Module support
Date: Tue, 15 Jul 2014 16:45:51 +0800
Message-ID: <1405413956-2772-25-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405413956-2772-1-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(22564002)(84676001)(79102001)(229853001)(86362001)(85852003)(93916002)(76482001)(77156001)(99396002)(46102001)(87286001)(68736004)(77982001)(102836001)(36756003)(4396001)(92726001)(19580405001)(83322001)(81542001)(105596002)(31966008)(74662001)(89996001)(64706001)(107046002)(74502001)(77096002)(2201001)(47776003)(81342001)(62966002)(50226001)(20776003)(106466001)(42186005)(80022001)(85306003)(92566001)(44976005)(19580395003)(87936001)(95666004)(83072002)(21056001)(97736001)(76176999)(50986999)(104166001)(6806004)(88136002)(48376002)(33646002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB044;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
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
index 0000000..360c53a
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
1.8.2.1

