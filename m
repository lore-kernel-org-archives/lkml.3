Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab3CYSxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:53:40 -0400
Received: from relay2.sgi.com ([192.48.179.30]:52043 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932959Ab3CYSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:50:09 -0400
Message-Id: <20130325185007.910454619@gulag1.americas.sgi.com>
References: <20130325185007.321022858@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Mar 2013 13:50:11 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Stehle <vincent.stehle@laposte.net>,
        Andrei Warkentin <andrey.warkentin@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH 04/15] KDB: allow KDB modules to be external modules
Content-Disposition: inline; filename=kdb-allow-ext-modules.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since KDB modules are not built within the Linux kernel build domain,
symbols needed by them must be available in a header file that is
accessible.  This patch moves the significant routines used by KDB
modules to the external kdb.h header file.

Cc: Vincent Stehle <vincent.stehle@laposte.net>
Cc: Andrei Warkentin <andrey.warkentin@gmail.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/kdb.h            |   89 +++++++++++++++++++++++++++++++++++++++++
 kernel/debug/debug_core.h      |    1 
 kernel/debug/kdb/kdb_private.h |   79 ------------------------------------
 3 files changed, 89 insertions(+), 80 deletions(-)

--- linux.orig/include/linux/kdb.h
+++ linux/include/linux/kdb.h
@@ -25,6 +25,7 @@ typedef int (*kdb_func_t)(int, const cha
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/atomic.h>
+#include <linux/hardirq.h>
 
 #define KDB_POLL_FUNC_MAX	5
 extern int kdb_poll_idx;
@@ -148,6 +149,93 @@ extern int kdb_register(char *, kdb_func
 extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
 			       short, kdb_repeat_t);
 extern int kdb_unregister(char *);
+
+/*
+ * Exported Symbols for kernel loadable modules to use.
+ *
+ * (All of these need to be within an #ifdef CONFIG_KGDB_KDB domain)
+ */
+extern int kdb_parse(const char *cmdstr);
+extern int kdb_getarea_size(void *, unsigned long, size_t);
+extern int kdb_putarea_size(unsigned long, void *, size_t);
+
+/*
+ * Like get_user and put_user, kdb_getarea and kdb_putarea take variable
+ * names, not pointers.  The underlying *_size functions take pointers.
+ */
+#define kdb_getarea(x, addr) kdb_getarea_size(&(x), addr, sizeof((x)))
+#define kdb_putarea(addr, x) kdb_putarea_size(addr, &(x), sizeof((x)))
+
+extern int kdb_getphysword(unsigned long *word,
+			unsigned long addr, size_t size);
+extern int kdb_getword(unsigned long *, unsigned long, size_t);
+extern int kdb_putword(unsigned long, unsigned long, size_t);
+
+extern int kdbgetularg(const char *, unsigned long *);
+extern int kdbgetu64arg(const char *, u64 *);
+extern char *kdbgetenv(const char *);
+extern int kdbgetaddrarg(int, const char **, int*, unsigned long *,
+			 long *, char **);
+
+/* Symbol table format returned by kallsyms. */
+typedef struct __ksymtab {
+		unsigned long value;	/* Address of symbol */
+		const char *mod_name;	/* Module containing symbol or
+					 * "kernel" */
+		unsigned long mod_start;
+		unsigned long mod_end;
+		const char *sec_name;	/* Section containing symbol */
+		unsigned long sec_start;
+		unsigned long sec_end;
+		const char *sym_name;	/* Full symbol name, including
+					 * any version */
+		unsigned long sym_start;
+		unsigned long sym_end;
+} kdb_symtab_t;
+extern int kallsyms_symbol_next(char *prefix_name, int flag);
+extern int kallsyms_symbol_complete(char *prefix_name, int max_len);
+
+extern int kdbgetsymval(const char *, kdb_symtab_t *);
+extern int kdbnearsym(unsigned long, kdb_symtab_t *);
+extern void kdbnearsym_cleanup(void);
+extern char *kdb_strdup(const char *str, gfp_t type);
+extern void kdb_symbol_print(unsigned long, const kdb_symtab_t *, unsigned int);
+
+extern void kdb_ps_suppressed(void);
+extern void kdb_ps1(const struct task_struct *p);
+extern void kdb_print_nameval(const char *name, unsigned long val);
+extern void kdb_send_sig_info(struct task_struct *p, struct siginfo *info);
+extern void kdb_meminfo_proc_show(void);
+extern char *kdb_getstr(char *, size_t, char *);
+
+/* Defines for kdb_symbol_print */
+#define KDB_SP_SPACEB	0x0001		/* Space before string */
+#define KDB_SP_SPACEA	0x0002		/* Space after string */
+#define KDB_SP_PAREN	0x0004		/* Parenthesis around string */
+#define KDB_SP_VALUE	0x0008		/* Print the value of the address */
+#define KDB_SP_SYMSIZE	0x0010		/* Print the size of the symbol */
+#define KDB_SP_NEWLINE	0x0020		/* Newline after string */
+#define KDB_SP_DEFAULT (KDB_SP_VALUE|KDB_SP_PAREN)
+
+#define KDB_TSK(cpu) (kgdb_info[cpu].task)
+#define KDB_TSKREGS(cpu) (kgdb_info[cpu].debuggerinfo)
+
+extern struct task_struct *kdb_curr_task(int);
+
+#define kdb_task_has_cpu(p) (task_curr(p))
+
+/* Simplify coexistence with NPTL */
+#define	kdb_do_each_thread(g, p) do_each_thread(g, p)
+#define	kdb_while_each_thread(g, p) while_each_thread(g, p)
+
+#define GFP_KDB (in_interrupt() ? GFP_ATOMIC : GFP_KERNEL)
+
+extern void *debug_kmalloc(size_t size, gfp_t flags);
+extern void debug_kfree(void *);
+extern void debug_kusage(void);
+
+extern void kdb_set_current_task(struct task_struct *);
+extern struct task_struct *kdb_current_task;
 #else /* ! CONFIG_KGDB_KDB */
 static inline __printf(1, 2) int kdb_printf(const char *fmt, ...) { return 0; }
 static inline void kdb_init(int level) {}
@@ -157,6 +245,7 @@ static inline int kdb_register_repeat(ch
 				      char *help, short minlen,
 				      kdb_repeat_t repeat) { return 0; }
 static inline int kdb_unregister(char *cmd) { return 0; }
+
 #endif	/* CONFIG_KGDB_KDB */
 enum {
 	KDB_NOT_INITIALIZED,
--- linux.orig/kernel/debug/debug_core.h
+++ linux/kernel/debug/debug_core.h
@@ -71,7 +71,6 @@ extern int dbg_kdb_mode;
 
 #ifdef CONFIG_KGDB_KDB
 extern int kdb_stub(struct kgdb_state *ks);
-extern int kdb_parse(const char *cmdstr);
 extern int kdb_common_init_state(struct kgdb_state *ks);
 extern int kdb_common_deinit_state(void);
 #else /* ! CONFIG_KGDB_KDB */
--- linux.orig/kernel/debug/kdb/kdb_private.h
+++ linux/kernel/debug/kdb/kdb_private.h
@@ -68,51 +68,6 @@
  */
 #define KDB_MAXBPT	16
 
-/* Symbol table format returned by kallsyms. */
-typedef struct __ksymtab {
-		unsigned long value;	/* Address of symbol */
-		const char *mod_name;	/* Module containing symbol or
-					 * "kernel" */
-		unsigned long mod_start;
-		unsigned long mod_end;
-		const char *sec_name;	/* Section containing symbol */
-		unsigned long sec_start;
-		unsigned long sec_end;
-		const char *sym_name;	/* Full symbol name, including
-					 * any version */
-		unsigned long sym_start;
-		unsigned long sym_end;
-		} kdb_symtab_t;
-extern int kallsyms_symbol_next(char *prefix_name, int flag);
-extern int kallsyms_symbol_complete(char *prefix_name, int max_len);
-
-/* Exported Symbols for kernel loadable modules to use. */
-extern int kdb_getarea_size(void *, unsigned long, size_t);
-extern int kdb_putarea_size(unsigned long, void *, size_t);
-
-/*
- * Like get_user and put_user, kdb_getarea and kdb_putarea take variable
- * names, not pointers.  The underlying *_size functions take pointers.
- */
-#define kdb_getarea(x, addr) kdb_getarea_size(&(x), addr, sizeof((x)))
-#define kdb_putarea(addr, x) kdb_putarea_size(addr, &(x), sizeof((x)))
-
-extern int kdb_getphysword(unsigned long *word,
-			unsigned long addr, size_t size);
-extern int kdb_getword(unsigned long *, unsigned long, size_t);
-extern int kdb_putword(unsigned long, unsigned long, size_t);
-
-extern int kdbgetularg(const char *, unsigned long *);
-extern int kdbgetu64arg(const char *, u64 *);
-extern char *kdbgetenv(const char *);
-extern int kdbgetaddrarg(int, const char **, int*, unsigned long *,
-			 long *, char **);
-extern int kdbgetsymval(const char *, kdb_symtab_t *);
-extern int kdbnearsym(unsigned long, kdb_symtab_t *);
-extern void kdbnearsym_cleanup(void);
-extern char *kdb_strdup(const char *str, gfp_t type);
-extern void kdb_symbol_print(unsigned long, const kdb_symtab_t *, unsigned int);
-
 /* Routine for debugging the debugger state. */
 extern void kdb_print_state(const char *, int);
 
@@ -205,42 +160,8 @@ extern unsigned long kdb_task_state_stri
 extern char kdb_task_state_char (const struct task_struct *);
 extern unsigned long kdb_task_state(const struct task_struct *p,
 				    unsigned long mask);
-extern void kdb_ps_suppressed(void);
-extern void kdb_ps1(const struct task_struct *p);
-extern void kdb_print_nameval(const char *name, unsigned long val);
-extern void kdb_send_sig_info(struct task_struct *p, struct siginfo *info);
-extern void kdb_meminfo_proc_show(void);
-extern char *kdb_getstr(char *, size_t, char *);
 extern void kdb_gdb_state_pass(char *buf);
 
-/* Defines for kdb_symbol_print */
-#define KDB_SP_SPACEB	0x0001		/* Space before string */
-#define KDB_SP_SPACEA	0x0002		/* Space after string */
-#define KDB_SP_PAREN	0x0004		/* Parenthesis around string */
-#define KDB_SP_VALUE	0x0008		/* Print the value of the address */
-#define KDB_SP_SYMSIZE	0x0010		/* Print the size of the symbol */
-#define KDB_SP_NEWLINE	0x0020		/* Newline after string */
-#define KDB_SP_DEFAULT (KDB_SP_VALUE|KDB_SP_PAREN)
-
-#define KDB_TSK(cpu) kgdb_info[cpu].task
-#define KDB_TSKREGS(cpu) kgdb_info[cpu].debuggerinfo
-
-extern struct task_struct *kdb_curr_task(int);
-
-#define kdb_task_has_cpu(p) (task_curr(p))
-
-/* Simplify coexistence with NPTL */
-#define	kdb_do_each_thread(g, p) do_each_thread(g, p)
-#define	kdb_while_each_thread(g, p) while_each_thread(g, p)
-
-#define GFP_KDB (in_interrupt() ? GFP_ATOMIC : GFP_KERNEL)
-
-extern void *debug_kmalloc(size_t size, gfp_t flags);
-extern void debug_kfree(void *);
-extern void debug_kusage(void);
-
-extern void kdb_set_current_task(struct task_struct *);
-extern struct task_struct *kdb_current_task;
 
 #ifdef CONFIG_KDB_KEYBOARD
 extern void kdb_kbd_cleanup_state(void);

-- 
