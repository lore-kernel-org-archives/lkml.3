Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab3CLTjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:39:46 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48714 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755554Ab3CLTi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:38:26 -0400
Message-Id: <20130312193824.025713118@gulag1.americas.sgi.com>
References: <20130312193823.212544181@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 12 Mar 2013 14:38:28 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cong Wang <amwang@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH 05/14] KDB: add more exports for supporting KDB modules
Content-Disposition: inline; filename=kdb-add-module-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some important KDB functions to be externally
usable by loadable KDB modules.  Note that often drivers bring
in KDB modules for debugging, and in the past KDB has not been
limited to use by GPL only modules.  This patch restores KDB
usefullness to non-GPL modules.

Cc: Tim Bird <tim.bird@am.sony.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Cong Wang <amwang@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/debug/kdb/kdb_io.c      |    5 ++++-
 kernel/debug/kdb/kdb_main.c    |   21 ++++++++++++++++++---
 kernel/debug/kdb/kdb_support.c |   17 +++++++++++++++++
 kernel/kallsyms.c              |    9 +++++----
 kernel/signal.c                |    5 +++--
 5 files changed, 47 insertions(+), 10 deletions(-)

--- linux.orig/kernel/debug/kdb/kdb_io.c
+++ linux/kernel/debug/kdb/kdb_io.c
@@ -30,6 +30,7 @@
 char kdb_prompt_str[CMD_BUFLEN];
 
 int kdb_trap_printk;
+EXPORT_SYMBOL(kdb_trap_printk);
 
 static int kgdb_transition_check(char *buffer)
 {
@@ -447,6 +448,7 @@ char *kdb_getstr(char *buffer, size_t bu
 	kdb_nextline = 1;	/* Prompt and input resets line number */
 	return kdb_read(buffer, bufsize);
 }
+EXPORT_SYMBOL(kdb_getstr);
 
 /*
  * kdb_input_flush
@@ -839,6 +841,7 @@ kdb_print_out:
 	preempt_enable();
 	return retlen;
 }
+EXPORT_SYMBOL(vkdb_printf);
 
 int kdb_printf(const char *fmt, ...)
 {
@@ -851,4 +854,4 @@ int kdb_printf(const char *fmt, ...)
 
 	return r;
 }
-EXPORT_SYMBOL_GPL(kdb_printf);
+EXPORT_SYMBOL(kdb_printf);
--- linux.orig/kernel/debug/kdb/kdb_main.c
+++ linux/kernel/debug/kdb/kdb_main.c
@@ -53,19 +53,23 @@ int kdb_grep_trailing;
  * Kernel debugger state flags
  */
 int kdb_flags;
+EXPORT_SYMBOL(kdb_flags);
 atomic_t kdb_event;
+EXPORT_SYMBOL(kdb_event);
 
 /*
  * kdb_lock protects updates to kdb_initial_cpu.  Used to
  * single thread processors through the kernel debugger.
  */
 int kdb_initial_cpu = -1;	/* cpu number that owns kdb */
+EXPORT_SYMBOL(kdb_initial_cpu);
 int kdb_nextline = 1;
 int kdb_state;			/* General KDB state */
 
 struct task_struct *kdb_current_task;
 EXPORT_SYMBOL(kdb_current_task);
 struct pt_regs *kdb_current_regs;
+EXPORT_SYMBOL(kdb_current_regs);
 
 const char *kdb_diemsg;
 static int kdb_go_count;
@@ -186,6 +190,7 @@ struct task_struct *kdb_curr_task(int cp
 #endif
 	return p;
 }
+EXPORT_SYMBOL(kdb_curr_task);
 
 /*
  * kdbgetenv - This function will return the character string value of
@@ -217,6 +222,7 @@ char *kdbgetenv(const char *match)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(kdbgetenv);
 
 /*
  * kdballocenv - This function is used to allocate bytes for
@@ -293,6 +299,7 @@ int kdbgetintenv(const char *match, int
 		*value = (int) val;
 	return diag;
 }
+EXPORT_SYMBOL(kdbgetintenv);
 
 /*
  * kdbgetularg - This function will convert a numeric string into an
@@ -325,6 +332,7 @@ int kdbgetularg(const char *arg, unsigne
 
 	return 0;
 }
+EXPORT_SYMBOL(kdbgetularg);
 
 int kdbgetu64arg(const char *arg, u64 *value)
 {
@@ -344,6 +352,7 @@ int kdbgetu64arg(const char *arg, u64 *v
 
 	return 0;
 }
+EXPORT_SYMBOL(kdbgetu64arg);
 
 /*
  * kdb_set - This function implements the 'set' command.  Alter an
@@ -425,6 +434,7 @@ int kdb_set(int argc, const char **argv)
 
 	return KDB_ENVFULL;
 }
+EXPORT_SYMBOL(kdb_set);
 
 static int kdb_check_regs(void)
 {
@@ -585,6 +595,7 @@ int kdbgetaddrarg(int argc, const char *
 
 	return 0;
 }
+EXPORT_SYMBOL(kdbgetaddrarg);
 
 static void kdb_cmderror(int diag)
 {
@@ -1049,6 +1060,7 @@ int kdb_parse(const char *cmdstr)
 		return 0;
 	}
 }
+EXPORT_SYMBOL(kdb_parse);
 
 
 static int handle_ctrl_cmd(char *cmd)
@@ -1109,6 +1121,7 @@ void kdb_set_current_task(struct task_st
 	}
 	kdb_current_regs = NULL;
 }
+EXPORT_SYMBOL(kdb_set_current_task);
 
 /*
  * kdb_local - The main code for kdb.  This routine is invoked on a
@@ -2249,6 +2262,7 @@ void kdb_ps_suppressed(void)
 		kdb_printf(" suppressed,\nuse 'ps A' to see all.\n");
 	}
 }
+EXPORT_SYMBOL(kdb_ps_suppressed);
 
 /*
  * kdb_ps - This function implements the 'ps' command which shows a
@@ -2281,6 +2295,7 @@ void kdb_ps1(const struct task_struct *p
 		}
 	}
 }
+EXPORT_SYMBOL(kdb_ps1);
 
 static int kdb_ps(int argc, const char **argv)
 {
@@ -2697,7 +2712,7 @@ int kdb_register_repeat(char *cmd,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kdb_register_repeat);
+EXPORT_SYMBOL(kdb_register_repeat);
 
 
 /*
@@ -2721,7 +2736,7 @@ int kdb_register(char *cmd,
 	return kdb_register_repeat(cmd, func, usage, help, minlen,
 				   KDB_REPEAT_NONE);
 }
-EXPORT_SYMBOL_GPL(kdb_register);
+EXPORT_SYMBOL(kdb_register);
 
 /*
  * kdb_unregister - This function is used to unregister a kernel
@@ -2750,7 +2765,7 @@ int kdb_unregister(char *cmd)
 	/* Couldn't find it.  */
 	return 1;
 }
-EXPORT_SYMBOL_GPL(kdb_unregister);
+EXPORT_SYMBOL(kdb_unregister);
 
 /* Initialize the kdb command table. */
 static void __init kdb_inittab(void)
--- linux.orig/kernel/debug/kdb/kdb_support.c
+++ linux/kernel/debug/kdb/kdb_support.c
@@ -157,6 +157,7 @@ out:
 	debug_kfree(knt1);
 	return ret;
 }
+EXPORT_SYMBOL(kdbnearsym);
 
 void kdbnearsym_cleanup(void)
 {
@@ -168,6 +169,7 @@ void kdbnearsym_cleanup(void)
 		}
 	}
 }
+EXPORT_SYMBOL(kdbnearsym_cleanup);
 
 static char ks_namebuf[KSYM_NAME_LEN+1], ks_namebuf_prev[KSYM_NAME_LEN+1];
 
@@ -214,6 +216,7 @@ int kallsyms_symbol_complete(char *prefi
 		memcpy(prefix_name, ks_namebuf_prev, prev_len+1);
 	return number;
 }
+EXPORT_SYMBOL(kallsyms_symbol_complete);
 
 /*
  * kallsyms_symbol_next
@@ -242,6 +245,7 @@ int kallsyms_symbol_next(char *prefix_na
 	}
 	return 0;
 }
+EXPORT_SYMBOL(kallsyms_symbol_next);
 
 /*
  * kdb_symbol_print - Standard method for printing a symbol name and offset.
@@ -292,6 +296,7 @@ void kdb_symbol_print(unsigned long addr
 	if (punc & KDB_SP_NEWLINE)
 		kdb_printf("\n");
 }
+EXPORT_SYMBOL(kdb_symbol_print);
 
 /*
  * kdb_strdup - kdb equivalent of strdup, for disasm code.
@@ -312,6 +317,7 @@ char *kdb_strdup(const char *str, gfp_t
 		return NULL;
 	return strcpy(s, str);
 }
+EXPORT_SYMBOL(kdb_strdup);
 
 /*
  * kdb_getarea_size - Read an area of data.  The kdb equivalent of
@@ -337,6 +343,7 @@ int kdb_getarea_size(void *res, unsigned
 	}
 	return ret;
 }
+EXPORT_SYMBOL(kdb_getarea_size);
 
 /*
  * kdb_putarea_size - Write an area of data.  The kdb equivalent of
@@ -362,6 +369,7 @@ int kdb_putarea_size(unsigned long addr,
 	}
 	return ret;
 }
+EXPORT_SYMBOL(kdb_putarea_size);
 
 /*
  * kdb_getphys - Read data from a physical address. Validate the
@@ -439,6 +447,7 @@ int kdb_getphysword(unsigned long *word,
 	}
 	return diag;
 }
+EXPORT_SYMBOL(kdb_getphysword);
 
 /*
  * kdb_getword - Read a binary value.  Unlike kdb_getarea, this treats
@@ -488,6 +497,7 @@ int kdb_getword(unsigned long *word, uns
 	}
 	return diag;
 }
+EXPORT_SYMBOL(kdb_getword);
 
 /*
  * kdb_putword - Write a binary value.  Unlike kdb_putarea, this
@@ -532,6 +542,7 @@ int kdb_putword(unsigned long addr, unsi
 	}
 	return diag;
 }
+EXPORT_SYMBOL(kdb_putword);
 
 /*
  * kdb_task_state_string - Convert a string containing any of the
@@ -681,6 +692,7 @@ void kdb_print_nameval(const char *name,
 	else
 		kdb_printf("0x%lx\n", val);
 }
+EXPORT_SYMBOL(kdb_print_nameval);
 
 /* Last ditch allocator for debugging, so we can still debug even when
  * the GFP_ATOMIC pool has been exhausted.  The algorithms are tuned
@@ -799,6 +811,7 @@ out:
 	spin_unlock(&dap_lock);
 	return p;
 }
+EXPORT_SYMBOL(debug_kmalloc);
 
 void debug_kfree(void *p)
 {
@@ -858,6 +871,7 @@ void debug_kfree(void *p)
 	}
 	spin_unlock(&dap_lock);
 }
+EXPORT_SYMBOL(debug_kfree);
 
 void debug_kusage(void)
 {
@@ -907,6 +921,7 @@ void debug_kusage(void)
 out:
 	spin_unlock(&dap_lock);
 }
+EXPORT_SYMBOL(debug_kusage);
 
 /* Maintain a small stack of kdb_flags to allow recursion without disturbing
  * the global kdb state.
@@ -919,9 +934,11 @@ void kdb_save_flags(void)
 	BUG_ON(kdb_flags_index >= ARRAY_SIZE(kdb_flags_stack));
 	kdb_flags_stack[kdb_flags_index++] = kdb_flags;
 }
+EXPORT_SYMBOL(kdb_save_flags);
 
 void kdb_restore_flags(void)
 {
 	BUG_ON(kdb_flags_index <= 0);
 	kdb_flags = kdb_flags_stack[--kdb_flags_index];
 }
+EXPORT_SYMBOL(kdb_restore_flags);
--- linux.orig/kernel/kallsyms.c
+++ linux/kernel/kallsyms.c
@@ -183,7 +183,7 @@ unsigned long kallsyms_lookup_name(const
 	}
 	return module_kallsyms_lookup_name(name);
 }
-EXPORT_SYMBOL_GPL(kallsyms_lookup_name);
+EXPORT_SYMBOL(kallsyms_lookup_name);
 
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
@@ -202,7 +202,7 @@ int kallsyms_on_each_symbol(int (*fn)(vo
 	}
 	return module_kallsyms_on_each_symbol(fn, data);
 }
-EXPORT_SYMBOL_GPL(kallsyms_on_each_symbol);
+EXPORT_SYMBOL(kallsyms_on_each_symbol);
 
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
@@ -384,7 +384,7 @@ int sprint_symbol(char *buffer, unsigned
 {
 	return __sprint_symbol(buffer, address, 0, 1);
 }
-EXPORT_SYMBOL_GPL(sprint_symbol);
+EXPORT_SYMBOL(sprint_symbol);
 
 /**
  * sprint_symbol_no_offset - Look up a kernel symbol and return it in a text buffer
@@ -401,7 +401,7 @@ int sprint_symbol_no_offset(char *buffer
 {
 	return __sprint_symbol(buffer, address, 0, 0);
 }
-EXPORT_SYMBOL_GPL(sprint_symbol_no_offset);
+EXPORT_SYMBOL(sprint_symbol_no_offset);
 
 /**
  * sprint_backtrace - Look up a backtrace symbol and return it in a text buffer
@@ -587,6 +587,7 @@ const char *kdb_walk_kallsyms(loff_t *po
 			return kdb_walk_kallsyms_iter.name;
 	}
 }
+EXPORT_SYMBOL(kdb_walk_kallsyms);
 #endif	/* CONFIG_KGDB_KDB */
 
 static const struct file_operations kallsyms_operations = {
--- linux.orig/kernel/signal.c
+++ linux/kernel/signal.c
@@ -1419,7 +1419,7 @@ out_unlock:
 	rcu_read_unlock();
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kill_pid_info_as_cred);
+EXPORT_SYMBOL(kill_pid_info_as_cred);
 
 /*
  * kill_something_info() interprets pid in interesting ways just like kill(2).
@@ -2491,7 +2491,7 @@ out:
 }
 
 EXPORT_SYMBOL(recalc_sigpending);
-EXPORT_SYMBOL_GPL(dequeue_signal);
+EXPORT_SYMBOL(dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
 EXPORT_SYMBOL(force_sig);
 EXPORT_SYMBOL(send_sig);
@@ -3661,4 +3661,5 @@ kdb_send_sig_info(struct task_struct *t,
 	else
 		kdb_printf("Signal %d is sent to process %d.\n", sig, t->pid);
 }
+EXPORT_SYMBOL(kdb_send_sig_info);
 #endif	/* CONFIG_KGDB_KDB */

-- 
