Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3CKGhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:37:32 -0400
Received: from ozlabs.org ([203.10.76.45]:56909 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab3CKGha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:37:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-next@vger.kernel.org
Subject: Re: [RFC -next] linux/linkage.h: fix symbol prefix handling
In-Reply-To: <5139AC39.90805@imgtec.com>
References: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com> <87sj46wyf2.fsf@rustcorp.com.au> <5139AC39.90805@imgtec.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 11 Mar 2013 17:05:17 +1030
Message-ID: <874ngiwije.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Hogan <james.hogan@imgtec.com> writes:

> Hi Rusty,
>
> On 08/03/13 00:03, Rusty Russell wrote:
>> James Hogan <james.hogan@imgtec.com> writes:
>>> Also the definition of SYMBOL_PREFIX in <linux/kernel.h> is removed as
>>> it conflicts, isn't used anywhere, and is defined as a string so differs
>>> from the assembly definition.
>> 
>> So now, if CONFIG_SYMBOL_PREFIX, SYMBOL_PREFIX is defined on the cmdline
>> as a string.  Otherwise it's empty (not the empty string?):
>
> No, SYMBOL_PREFIX is now defined as a non-string, same as asm files

Ah, I misread this.  It's stripping the quotes, not adding them:

_sym_flags = -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))

> Does that make sense? It's all a bit messy unfortunately (hence RFC).

Yes, let's clear it up once and for all.  Does this work?

CONFIG_SYMBOL_PREFIX: cleanup.

We have CONFIG_SYMBOL_PREFIX, which three archs define to the string
"_".  But Al Viro broke this in "consolidate cond_syscall and
SYSCALL_ALIAS declarations", and he's not the first to do so.

Using CONFIG_SYMBOL_PREFIX is awkward, since we usually just want to
prefix it so something.  So various places define helpers which are
defined to nothing if CONFIG_SYMBOL_PREFIX isn't set:

1) include/asm-generic/unistd.h defines __SYMBOL_PREFIX.
2) include/asm-generic/vmlinux.lds.h defines VMLINUX_SYMBOL(sym)
3) include/linux/export.h defines MODULE_SYMBOL_PREFIX.
4) include/linux/kernel.h defines SYMBOL_PREFIX (which differs from #7)
5) kernel/modsign_certificate.S defines ASM_SYMBOL(sym)
6) scripts/modpost.c defines MODULE_SYMBOL_PREFIX
7) scripts/Makefile.lib defines SYMBOL_PREFIX on the commandline if
   CONFIG_SYMBOL_PREFIX is set, so that we have a non-string version
   for pasting.

(arch/h8300/include/asm/linkage.h defines SYMBOL_NAME(), too).

Let's solve this properly:
1) No more generic prefix, just CONFIG_SYMBOL_PREFIX_UNDERSCORE.
2) Make linux/export.h usable from asm.
3) Define VMLINUX_SYMBOL, VMLINUX_SYMBOL_NAME and VMLINUX_SYMBOL_PREFIX_STR.
4) Make everyone use them.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/Makefile b/Makefile
index 5bd9f77..b2e3e1b 100644
--- a/Makefile
+++ b/Makefile
@@ -1398,7 +1398,7 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files))
 # Run depmod only if we have System.map and depmod is executable
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
       cmd_depmod = $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPMOD) \
-                   $(KERNELRELEASE) "$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))"
+                   $(KERNELRELEASE) "$(patsubst y,_,$(CONFIG_SYMBOL_PREFIX_UNDERSCORE))"
 
 # Create temporary dir for module support files
 # clean it up only when building all modules
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 600494c..cd0f7c7 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -1,6 +1,5 @@
-config SYMBOL_PREFIX
-	string
-	default "_"
+config SYMBOL_PREFIX_UNDERSCORE
+	def_bool y
 
 config MMU
 	def_bool n
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index ae8551e..ec9924d 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -13,9 +13,8 @@ config H8300
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
 
-config SYMBOL_PREFIX
-	string
-	default "_"
+config SYMBOL_PREFIX_UNDERSCORE
+	def_bool y
 
 config MMU
 	bool
diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index afc8973..e8719b4 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -1,6 +1,5 @@
-config SYMBOL_PREFIX
-	string
-	default "_"
+config SYMBOL_PREFIX_UNDERSCORE
+	def_bool y
 
 config METAG
 	def_bool y
diff --git a/drivers/mtd/chips/gen_probe.c b/drivers/mtd/chips/gen_probe.c
index 3b9a284..00d20ad 100644
--- a/drivers/mtd/chips/gen_probe.c
+++ b/drivers/mtd/chips/gen_probe.c
@@ -204,14 +204,14 @@ static inline struct mtd_info *cfi_cmdset_unknown(struct map_info *map,
 	struct cfi_private *cfi = map->fldrv_priv;
 	__u16 type = primary?cfi->cfiq->P_ID:cfi->cfiq->A_ID;
 #ifdef CONFIG_MODULES
-	char probename[16+sizeof(MODULE_SYMBOL_PREFIX)];
+	char probename[16+sizeof(VMLINUX_SYMBOL_PREFIX_STR)];
 	cfi_cmdset_fn_t *probe_function;
 
-	sprintf(probename, MODULE_SYMBOL_PREFIX "cfi_cmdset_%4.4X", type);
+	sprintf(probename, VMLINUX_SYMBOL_PREFIX_STR "cfi_cmdset_%4.4X", type);
 
 	probe_function = __symbol_get(probename);
 	if (!probe_function) {
-		request_module(probename + sizeof(MODULE_SYMBOL_PREFIX) - 1);
+		request_module(probename + sizeof(VMLINUX_SYMBOL_PREFIX_STR)-1);
 		probe_function = __symbol_get(probename);
 	}
 
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 4077b5d..80122d4 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -1,4 +1,5 @@
 #include <uapi/asm-generic/unistd.h>
+#include <linux/export.h>
 
 /*
  * These are required system calls, we should
@@ -17,12 +18,7 @@
  * but it doesn't work on all toolchains, so we just do it by hand
  */
 #ifndef cond_syscall
-#ifdef CONFIG_SYMBOL_PREFIX
-#define __SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
-#else
-#define __SYMBOL_PREFIX
-#endif
-#define cond_syscall(x) asm(".weak\t" __SYMBOL_PREFIX #x "\n\t" \
-			    ".set\t" __SYMBOL_PREFIX #x "," \
-			    __SYMBOL_PREFIX "sys_ni_syscall")
+#define cond_syscall(x) asm(".weak\t" SYMBOL_NAME_STR(x) "\n\t"	\
+			    ".set\t" SYMBOL_NAME_STR(x) ","	\
+			    SYMBOL_NAME_STR(sys_ni_syscall))
 #endif
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index afa12c7..eb58d2d 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -52,13 +52,7 @@
 #define LOAD_OFFSET 0
 #endif
 
-#ifndef SYMBOL_PREFIX
-#define VMLINUX_SYMBOL(sym) sym
-#else
-#define PASTE2(x,y) x##y
-#define PASTE(x,y) PASTE2(x,y)
-#define VMLINUX_SYMBOL(sym) PASTE(SYMBOL_PREFIX, sym)
-#endif
+#include <linux/export.h>
 
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
diff --git a/include/linux/export.h b/include/linux/export.h
index 696c0f4..c3c1cfc 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -7,15 +7,27 @@
  *
  * If you feel the need to add #include <linux/foo.h> to this file
  * then you are doing something wrong and should go away silently.
+ *
+ * If you think the above arrogance just encourages more people to add
+ * random crap to this file, you're not alone.
  */
 
 /* Some toolchains use a `_' prefix for all user symbols. */
-#ifdef CONFIG_SYMBOL_PREFIX
-#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
+#ifdef CONFIG_SYMBOL_PREFIX_UNDERSCORE
+#define __VMLINUX_SYMBOL(x) _##x
+#define __VMLINUX_SYMBOL_STR(x) "_" #x
+#define VMLINUX_SYMBOL_PREFIX_STR "_"
 #else
-#define MODULE_SYMBOL_PREFIX ""
+#define __VMLINUX_SYMBOL(x) x
+#define __VMLINUX_SYMBOL_STR(x) #x
+#define VMLINUX_SYMBOL_PREFIX_STR ""
 #endif
 
+/* Indirect, so macros are expanded before pasting. */
+#define VMLINUX_SYMBOL(x) __VMLINUX_SYMBOL(x)
+#define VMLINUX_SYMBOL_STR(x) __VMLINUX_SYMBOL_STR(x)
+
+#ifndef __ASSEMBLY__
 struct kernel_symbol
 {
 	unsigned long value;
@@ -51,7 +63,7 @@ extern struct module __this_module;
 	__CRC_SYMBOL(sym, sec)					\
 	static const char __kstrtab_##sym[]			\
 	__attribute__((section("__ksymtab_strings"), aligned(1))) \
-	= MODULE_SYMBOL_PREFIX #sym;				\
+	= VMLINUX_SYMBOL_STR(sym);				\
 	static const struct kernel_symbol __ksymtab_##sym	\
 	__used							\
 	__attribute__((section("___ksymtab" sec "+" #sym), unused))	\
@@ -85,5 +97,6 @@ extern struct module __this_module;
 #define EXPORT_UNUSED_SYMBOL_GPL(sym)
 
 #endif /* CONFIG_MODULES */
+#endif /* !__ASSEMBLY__ */
 
 #endif /* _LINUX_EXPORT_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 80d3687..e13e992 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -723,13 +723,6 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
-/* This helps us to avoid #ifdef CONFIG_SYMBOL_PREFIX */
-#ifdef CONFIG_SYMBOL_PREFIX
-#define SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
-#else
-#define SYMBOL_PREFIX ""
-#endif
-
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
diff --git a/include/linux/module.h b/include/linux/module.h
index ead1b57..46f1ea0 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -190,7 +190,7 @@ extern int modules_disabled; /* for sysctl */
 /* Get/put a kernel symbol (calls must be symmetric) */
 void *__symbol_get(const char *symbol);
 void *__symbol_get_gpl(const char *symbol);
-#define symbol_get(x) ((typeof(&x))(__symbol_get(MODULE_SYMBOL_PREFIX #x)))
+#define symbol_get(x) ((typeof(&x))(__symbol_get(VMLINUX_SYMBOL_STR(x))))
 
 /* modules using other modules: kdb wants to see this. */
 struct module_use {
@@ -453,7 +453,7 @@ extern void __module_put_and_exit(struct module *mod, long code)
 #ifdef CONFIG_MODULE_UNLOAD
 unsigned long module_refcount(struct module *mod);
 void __symbol_put(const char *symbol);
-#define symbol_put(x) __symbol_put(MODULE_SYMBOL_PREFIX #x)
+#define symbol_put(x) __symbol_put(VMLINUX_SYMBOL_STR(x))
 void symbol_put_addr(void *addr);
 
 /* Sometimes we know we already have a refcount, and it's easier not
diff --git a/kernel/modsign_certificate.S b/kernel/modsign_certificate.S
index 246b4c6..4a9a86d 100644
--- a/kernel/modsign_certificate.S
+++ b/kernel/modsign_certificate.S
@@ -1,15 +1,8 @@
-/* SYMBOL_PREFIX defined on commandline from CONFIG_SYMBOL_PREFIX */
-#ifndef SYMBOL_PREFIX
-#define ASM_SYMBOL(sym) sym
-#else
-#define PASTE2(x,y) x##y
-#define PASTE(x,y) PASTE2(x,y)
-#define ASM_SYMBOL(sym) PASTE(SYMBOL_PREFIX, sym)
-#endif
+#include <linux/export.h>
 
 #define GLOBAL(name)	\
-	.globl ASM_SYMBOL(name);	\
-	ASM_SYMBOL(name):
+	.globl VMLINUX_SYMBOL(name);	\
+	VMLINUX_SYMBOL(name):
 
 	.section ".init.data","aw"
 
diff --git a/kernel/module.c b/kernel/module.c
index 0925c9a..cfd4a3f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1209,7 +1209,7 @@ static inline int check_modstruct_version(Elf_Shdr *sechdrs,
 
 	/* Since this should be found in kernel (which can't be removed),
 	 * no locking is necessary. */
-	if (!find_symbol(MODULE_SYMBOL_PREFIX "module_layout", NULL,
+	if (!find_symbol(VMLINUX_SYMBOL_STR(module_layout), NULL,
 			 &crc, true, false))
 		BUG();
 	return check_version(sechdrs, versindex, "module_layout", mod, crc,
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 07125e6..a373a1f 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -119,13 +119,6 @@ _c_flags += $(if $(patsubst n%,, \
 		$(CFLAGS_GCOV))
 endif
 
-ifdef CONFIG_SYMBOL_PREFIX
-_sym_flags = -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
-_cpp_flags += $(_sym_flags)
-_a_flags += $(_sym_flags)
-endif
-
-
 # If building the kernel in a separate objtree expand all occurrences
 # of -Idir to -I$(srctree)/dir except for absolute paths (starting with '/').
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 3d569d6..d767681 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -74,9 +74,8 @@ kallsyms()
 	info KSYM ${2}
 	local kallsymopt;
 
-	if [ -n "${CONFIG_SYMBOL_PREFIX}" ]; then
-		kallsymopt="${kallsymopt} \
-			    --symbol-prefix=${CONFIG_SYMBOL_PREFIX}"
+	if [ -n "${CONFIG_SYMBOL_PREFIX_UNDERSCORE}" ]; then
+		kallsymopt="${kallsymopt} --symbol-prefix=_"
 	fi
 
 	if [ -n "${CONFIG_KALLSYMS_ALL}" ]; then
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 78b30c1..6985021 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -18,14 +18,7 @@
 #include "modpost.h"
 #include "../../include/generated/autoconf.h"
 #include "../../include/linux/license.h"
-
-/* Some toolchains use a `_' prefix for all user symbols. */
-#ifdef CONFIG_SYMBOL_PREFIX
-#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
-#else
-#define MODULE_SYMBOL_PREFIX ""
-#endif
-
+#include "../../include/linux/export.h"
 
 /* Are we using CONFIG_MODVERSIONS? */
 int modversions = 0;
@@ -562,7 +555,7 @@ static void parse_elf_finish(struct elf_info *info)
 static int ignore_undef_symbol(struct elf_info *info, const char *symname)
 {
 	/* ignore __this_module, it will be resolved shortly */
-	if (strcmp(symname, MODULE_SYMBOL_PREFIX "__this_module") == 0)
+	if (strcmp(symname, VMLINUX_SYMBOL_STR(__this_module)) == 0)
 		return 1;
 	/* ignore global offset table */
 	if (strcmp(symname, "_GLOBAL_OFFSET_TABLE_") == 0)
@@ -583,8 +576,8 @@ static int ignore_undef_symbol(struct elf_info *info, const char *symname)
 	return 0;
 }
 
-#define CRC_PFX     MODULE_SYMBOL_PREFIX "__crc_"
-#define KSYMTAB_PFX MODULE_SYMBOL_PREFIX "__ksymtab_"
+#define CRC_PFX     VMLINUX_SYMBOL_STR(__crc_)
+#define KSYMTAB_PFX VMLINUX_SYMBOL_STR(__ksymtab_)
 
 static void handle_modversions(struct module *mod, struct elf_info *info,
 			       Elf_Sym *sym, const char *symname)
@@ -637,11 +630,11 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
 		}
 #endif
 
-		if (memcmp(symname, MODULE_SYMBOL_PREFIX,
-			   strlen(MODULE_SYMBOL_PREFIX)) == 0) {
+		if (memcmp(symname, VMLINUX_SYMBOL_PREFIX_STR,
+			   strlen(VMLINUX_SYMBOL_PREFIX_STR)) == 0) {
 			mod->unres =
 			  alloc_symbol(symname +
-			               strlen(MODULE_SYMBOL_PREFIX),
+			               strlen(VMLINUX_SYMBOL_PREFIX_STR),
 			               ELF_ST_BIND(sym->st_info) == STB_WEAK,
 			               mod->unres);
 		}
@@ -652,9 +645,9 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
 			sym_add_exported(symname + strlen(KSYMTAB_PFX), mod,
 					export);
 		}
-		if (strcmp(symname, MODULE_SYMBOL_PREFIX "init_module") == 0)
+		if (strcmp(symname, VMLINUX_SYMBOL_STR(init_module)) == 0)
 			mod->has_init = 1;
-		if (strcmp(symname, MODULE_SYMBOL_PREFIX "cleanup_module") == 0)
+		if (strcmp(symname, VMLINUX_SYMBOL_STR(cleanup_module)) == 0)
 			mod->has_cleanup = 1;
 		break;
 	}
