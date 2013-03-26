Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3CZETY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 00:19:24 -0400
Received: from relay1.sgi.com ([192.48.179.29]:52309 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab3CZETX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 00:19:23 -0400
Message-ID: <515121C5.2020702@sgi.com>
Date: Mon, 25 Mar 2013 21:19:17 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@redhat.com>,
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
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 05/15] KDB: add more exports for supporting KDB modules
 v2
References: <20130325185007.321022858@gulag1.americas.sgi.com> <20130325185008.059875584@gulag1.americas.sgi.com> <87ehf2j367.fsf@xmission.com>
In-Reply-To: <87ehf2j367.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 3/25/2013 7:38 PM, Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
> 
>> This patch adds some significant KDB functions to be usable by
>> externally built and loadable KDB modules.   All added functions
>> have been marked EXPORT_SYMBOL_GPL as that seems to be the norm.
>> No 'EXPORT_SYMBOL's were changed from previous instances to avoid
>> breaking existing modules.
> 
> I don't have any real objections.  Although the export of kallsyms
> probably is enough to raise an eyebrow or two.
> 
> Are there plans for these external modules to be merged?
> 
> In general the policy is to not export things unless there are in tree
> users.  Otherwise maitenance can be a challenge if you can't update your
> users when you update their helper functions.  Certainly a symbol being
> exported is not a guarantee that the exported function won't be changed.
> 
> Eric

I have a few of the older KDB modules converted to be built as
regular external kernel modules but I wasn't certain if they would be
accepted into the base kernel source tree.  Both kdbm_dereference.c
and kdbm_debugtypes.c are there which support the following kdb cmds:

"print", "<expression>", "Type casting as in lcrash"
"px", "<expression>", "Print in hex (type casting) (see 'pxhelp')"
"whatis", or symbol>", "Display the type, or the address for a symbol"
"sizeof", "<type>", "Display the size of a structure, typedef, etc."
"pxhelp", "", "Display help for the px command"
"walk", "<expression>", "Walk linked structs (see walkhelp)",
"walkhelp", "", "Display help for the walk command"

These essentially use the kernel symtab to print structure members,
and to walk linked structures from within KDB.  That was the primary
motivation for moving the ksymtab stuff to be externally exported.
It currently has a couple of problems but here's an example:

[8]kdb> md8c1 kdb_current_task
0xffffffff81c8ed00 ffff88081d714bf0                    .Kq.....                                                               
[8]kdb> px *(task_struct *)0xffff88081d714bf0
struct task_struct {
        state = 0x0
        stack = 0xffff88081d71a000
        usage = atomic_t {
                counter = 0x2
        }
        flags = 0x10202040
        ptrace = 0x0
        wake_entry = struct llist_node {
                next = (nil)
        }                                                                                                                     
...

(First 'kdb_current_task' should have been taken as the argument to
the px cmd, and second the printout does not stop with 'q' to the
"more>" prompt.)  I will sign up to merge these if there is interest?

Thanks,
Mike

> 
>> Cc: Tim Bird <tim.bird@am.sony.com>
>> Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
>> Cc: Sasha Levin <sasha.levin@oracle.com>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Cong Wang <amwang@redhat.com>
>> Cc: Stephen Boyd <sboyd@codeaurora.org>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Oleg Nesterov <oleg@redhat.com>
>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>> Cc: Serge Hallyn <serge.hallyn@canonical.com>
>> Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> ---
>> v2: change in handling of EXPORT_SYMBOLS.
>> ---
>>  kernel/debug/kdb/kdb_io.c      |    3 +++
>>  kernel/debug/kdb/kdb_main.c    |   14 ++++++++++++++
>>  kernel/debug/kdb/kdb_support.c |   17 +++++++++++++++++
>>  kernel/kallsyms.c              |    1 +
>>  4 files changed, 35 insertions(+)
>>
>> --- linux.orig/kernel/debug/kdb/kdb_io.c
>> +++ linux/kernel/debug/kdb/kdb_io.c
>> @@ -30,6 +30,7 @@
>>  char kdb_prompt_str[CMD_BUFLEN];
>>  
>>  int kdb_trap_printk;
>> +EXPORT_SYMBOL_GPL(kdb_trap_printk);
>>  
>>  static int kgdb_transition_check(char *buffer)
>>  {
>> @@ -447,6 +448,7 @@ char *kdb_getstr(char *buffer, size_t bu
>>  	kdb_nextline = 1;	/* Prompt and input resets line number */
>>  	return kdb_read(buffer, bufsize);
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_getstr);
>>  
>>  /*
>>   * kdb_input_flush
>> @@ -839,6 +841,7 @@ kdb_print_out:
>>  	preempt_enable();
>>  	return retlen;
>>  }
>> +EXPORT_SYMBOL_GPL(vkdb_printf);
>>  
>>  int kdb_printf(const char *fmt, ...)
>>  {
>> --- linux.orig/kernel/debug/kdb/kdb_main.c
>> +++ linux/kernel/debug/kdb/kdb_main.c
>> @@ -53,6 +53,7 @@ int kdb_grep_trailing;
>>   * Kernel debugger state flags
>>   */
>>  int kdb_flags;
>> +EXPORT_SYMBOL_GPL(kdb_flags);
>>  atomic_t kdb_event;
>>  
>>  /*
>> @@ -60,12 +61,14 @@ atomic_t kdb_event;
>>   * single thread processors through the kernel debugger.
>>   */
>>  int kdb_initial_cpu = -1;	/* cpu number that owns kdb */
>> +EXPORT_SYMBOL_GPL(kdb_initial_cpu);
>>  int kdb_nextline = 1;
>>  int kdb_state;			/* General KDB state */
>>  
>>  struct task_struct *kdb_current_task;
>>  EXPORT_SYMBOL(kdb_current_task);
>>  struct pt_regs *kdb_current_regs;
>> +EXPORT_SYMBOL_GPL(kdb_current_regs);
>>  
>>  const char *kdb_diemsg;
>>  static int kdb_go_count;
>> @@ -186,6 +189,7 @@ struct task_struct *kdb_curr_task(int cp
>>  #endif
>>  	return p;
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_curr_task);
>>  
>>  /*
>>   * kdbgetenv - This function will return the character string value of
>> @@ -217,6 +221,7 @@ char *kdbgetenv(const char *match)
>>  	}
>>  	return NULL;
>>  }
>> +EXPORT_SYMBOL_GPL(kdbgetenv);
>>  
>>  /*
>>   * kdballocenv - This function is used to allocate bytes for
>> @@ -293,6 +298,7 @@ int kdbgetintenv(const char *match, int
>>  		*value = (int) val;
>>  	return diag;
>>  }
>> +EXPORT_SYMBOL_GPL(kdbgetintenv);
>>  
>>  /*
>>   * kdbgetularg - This function will convert a numeric string into an
>> @@ -325,6 +331,7 @@ int kdbgetularg(const char *arg, unsigne
>>  
>>  	return 0;
>>  }
>> +EXPORT_SYMBOL_GPL(kdbgetularg);
>>  
>>  int kdbgetu64arg(const char *arg, u64 *value)
>>  {
>> @@ -344,6 +351,7 @@ int kdbgetu64arg(const char *arg, u64 *v
>>  
>>  	return 0;
>>  }
>> +EXPORT_SYMBOL_GPL(kdbgetu64arg);
>>  
>>  /*
>>   * kdb_set - This function implements the 'set' command.  Alter an
>> @@ -425,6 +433,7 @@ int kdb_set(int argc, const char **argv)
>>  
>>  	return KDB_ENVFULL;
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_set);
>>  
>>  static int kdb_check_regs(void)
>>  {
>> @@ -585,6 +594,7 @@ int kdbgetaddrarg(int argc, const char *
>>  
>>  	return 0;
>>  }
>> +EXPORT_SYMBOL_GPL(kdbgetaddrarg);
>>  
>>  static void kdb_cmderror(int diag)
>>  {
>> @@ -1049,6 +1059,7 @@ int kdb_parse(const char *cmdstr)
>>  		return 0;
>>  	}
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_parse);
>>  
>>  
>>  static int handle_ctrl_cmd(char *cmd)
>> @@ -1109,6 +1120,7 @@ void kdb_set_current_task(struct task_st
>>  	}
>>  	kdb_current_regs = NULL;
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_set_current_task);
>>  
>>  /*
>>   * kdb_local - The main code for kdb.  This routine is invoked on a
>> @@ -2249,6 +2261,7 @@ void kdb_ps_suppressed(void)
>>  		kdb_printf(" suppressed,\nuse 'ps A' to see all.\n");
>>  	}
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_ps_suppressed);
>>  
>>  /*
>>   * kdb_ps - This function implements the 'ps' command which shows a
>> @@ -2281,6 +2294,7 @@ void kdb_ps1(const struct task_struct *p
>>  		}
>>  	}
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_ps1);
>>  
>>  static int kdb_ps(int argc, const char **argv)
>>  {
>> --- linux.orig/kernel/debug/kdb/kdb_support.c
>> +++ linux/kernel/debug/kdb/kdb_support.c
>> @@ -157,6 +157,7 @@ out:
>>  	debug_kfree(knt1);
>>  	return ret;
>>  }
>> +EXPORT_SYMBOL_GPL(kdbnearsym);
>>  
>>  void kdbnearsym_cleanup(void)
>>  {
>> @@ -168,6 +169,7 @@ void kdbnearsym_cleanup(void)
>>  		}
>>  	}
>>  }
>> +EXPORT_SYMBOL_GPL(kdbnearsym_cleanup);
>>  
>>  static char ks_namebuf[KSYM_NAME_LEN+1], ks_namebuf_prev[KSYM_NAME_LEN+1];
>>  
>> @@ -214,6 +216,7 @@ int kallsyms_symbol_complete(char *prefi
>>  		memcpy(prefix_name, ks_namebuf_prev, prev_len+1);
>>  	return number;
>>  }
>> +EXPORT_SYMBOL_GPL(kallsyms_symbol_complete);
>>  
>>  /*
>>   * kallsyms_symbol_next
>> @@ -242,6 +245,7 @@ int kallsyms_symbol_next(char *prefix_na
>>  	}
>>  	return 0;
>>  }
>> +EXPORT_SYMBOL_GPL(kallsyms_symbol_next);
>>  
>>  /*
>>   * kdb_symbol_print - Standard method for printing a symbol name and offset.
>> @@ -292,6 +296,7 @@ void kdb_symbol_print(unsigned long addr
>>  	if (punc & KDB_SP_NEWLINE)
>>  		kdb_printf("\n");
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_symbol_print);
>>  
>>  /*
>>   * kdb_strdup - kdb equivalent of strdup, for disasm code.
>> @@ -312,6 +317,7 @@ char *kdb_strdup(const char *str, gfp_t
>>  		return NULL;
>>  	return strcpy(s, str);
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_strdup);
>>  
>>  /*
>>   * kdb_getarea_size - Read an area of data.  The kdb equivalent of
>> @@ -337,6 +343,7 @@ int kdb_getarea_size(void *res, unsigned
>>  	}
>>  	return ret;
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_getarea_size);
>>  
>>  /*
>>   * kdb_putarea_size - Write an area of data.  The kdb equivalent of
>> @@ -362,6 +369,7 @@ int kdb_putarea_size(unsigned long addr,
>>  	}
>>  	return ret;
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_putarea_size);
>>  
>>  /*
>>   * kdb_getphys - Read data from a physical address. Validate the
>> @@ -439,6 +447,7 @@ int kdb_getphysword(unsigned long *word,
>>  	}
>>  	return diag;
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_getphysword);
>>  
>>  /*
>>   * kdb_getword - Read a binary value.  Unlike kdb_getarea, this treats
>> @@ -488,6 +497,7 @@ int kdb_getword(unsigned long *word, uns
>>  	}
>>  	return diag;
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_getword);
>>  
>>  /*
>>   * kdb_putword - Write a binary value.  Unlike kdb_putarea, this
>> @@ -532,6 +542,7 @@ int kdb_putword(unsigned long addr, unsi
>>  	}
>>  	return diag;
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_putword);
>>  
>>  /*
>>   * kdb_task_state_string - Convert a string containing any of the
>> @@ -681,6 +692,7 @@ void kdb_print_nameval(const char *name,
>>  	else
>>  		kdb_printf("0x%lx\n", val);
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_print_nameval);
>>  
>>  /* Last ditch allocator for debugging, so we can still debug even when
>>   * the GFP_ATOMIC pool has been exhausted.  The algorithms are tuned
>> @@ -799,6 +811,7 @@ out:
>>  	spin_unlock(&dap_lock);
>>  	return p;
>>  }
>> +EXPORT_SYMBOL_GPL(debug_kmalloc);
>>  
>>  void debug_kfree(void *p)
>>  {
>> @@ -858,6 +871,7 @@ void debug_kfree(void *p)
>>  	}
>>  	spin_unlock(&dap_lock);
>>  }
>> +EXPORT_SYMBOL_GPL(debug_kfree);
>>  
>>  void debug_kusage(void)
>>  {
>> @@ -907,6 +921,7 @@ void debug_kusage(void)
>>  out:
>>  	spin_unlock(&dap_lock);
>>  }
>> +EXPORT_SYMBOL_GPL(debug_kusage);
>>  
>>  /* Maintain a small stack of kdb_flags to allow recursion without disturbing
>>   * the global kdb state.
>> @@ -919,9 +934,11 @@ void kdb_save_flags(void)
>>  	BUG_ON(kdb_flags_index >= ARRAY_SIZE(kdb_flags_stack));
>>  	kdb_flags_stack[kdb_flags_index++] = kdb_flags;
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_save_flags);
>>  
>>  void kdb_restore_flags(void)
>>  {
>>  	BUG_ON(kdb_flags_index <= 0);
>>  	kdb_flags = kdb_flags_stack[--kdb_flags_index];
>>  }
>> +EXPORT_SYMBOL_GPL(kdb_restore_flags);
>> --- linux.orig/kernel/kallsyms.c
>> +++ linux/kernel/kallsyms.c
>> @@ -588,6 +588,7 @@ const char *kdb_walk_kallsyms(loff_t *po
>>  	}
>>  }
>>  #endif	/* CONFIG_KGDB_KDB */
>> +EXPORT_SYMBOL_GPL(kdb_walk_kallsyms);
>>  
>>  static const struct file_operations kallsyms_operations = {
>>  	.open = kallsyms_open,
