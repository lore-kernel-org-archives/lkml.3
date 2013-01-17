Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab3AQCix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:38:53 -0500
Received: from ozlabs.org ([203.10.76.45]:59385 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581Ab3AQCig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:38:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Subject: Re: [PATCH] MODSIGN: Add TAINT_NOKEY_MODULE
In-Reply-To: <20130116193724.GF6964@hansolo.jdub.homelinux.org>
References: <20130104191205.GD27554@hansolo.jdub.homelinux.org> <87bod14x44.fsf@rustcorp.com.au> <20130107145832.GA12363@hansolo.jdub.homelinux.org> <20130115190911.GA6964@hansolo.jdub.homelinux.org> <87y5ftyf51.fsf@rustcorp.com.au> <20130116193724.GF6964@hansolo.jdub.homelinux.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 17 Jan 2013 11:27:27 +1030
Message-ID: <87pq14y6bs.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:
>> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
>> index 86e2f4a..7acca64 100644
>> --- a/drivers/iommu/dmar.c
>> +++ b/drivers/iommu/dmar.c
>> @@ -230,7 +230,7 @@ dmar_parse_one_rhsa(struct acpi_dmar_header *header)
>>  		}
>>  	}
>>  	WARN_TAINT(
>> -		1, TAINT_FIRMWARE_WORKAROUND,
>> +		1, TAINT_FIRMWARE_WORKAROUND, true,
>>  		"Your BIOS is broken; RHSA refers to non-existent DMAR unit at %llx\n"
>>  		"BIOS vendor: %s; Ver: %s; Product Version: %s\n",
>>  		drhd->reg_base_addr,
>
> This bit causes a build failure here:

Oops, that slipped in from a previous version, where I was going to
add the lockdep_ok flag to WARN().  I forgot to flip the module sig_ok
case, which was the entire point!

Here it is:

taint: add explicit flag to show whether lock dep is still OK.

Fix up all callers as they were before, with make one change: an
unsigned module taints the kernel, but doesn't turn off lockdep.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 272666d..2fca8ca 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -186,7 +186,7 @@ die_if_kernel(char * str, struct pt_regs *regs, long err, unsigned long *r9_15)
 #endif
 	printk("%s(%d): %s %ld\n", current->comm, task_pid_nr(current), str, err);
 	dik_show_regs(regs, r9_15);
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	dik_show_trace((unsigned long *)(regs+1));
 	dik_show_code((unsigned int *)regs->pc);
 
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index b0179b8..02d2e1a 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -296,7 +296,7 @@ static void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 
 	bust_spinlocks(0);
 	die_owner = -1;
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	die_nest_count--;
 	if (!die_nest_count)
 		/* Nest count reaches zero, release the lock. */
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 3883f84..d4fe267 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -242,7 +242,7 @@ void die(const char *str, struct pt_regs *regs, int err)
 		crash_kexec(regs);
 
 	bust_spinlocks(0);
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	raw_spin_unlock_irq(&die_lock);
 	oops_exit();
 
diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index 3d760c0..4c084d9 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -61,7 +61,7 @@ void die(const char *str, struct pt_regs *regs, long err)
 	show_regs_log_lvl(regs, KERN_EMERG);
 	show_stack_log_lvl(current, regs->sp, regs, KERN_EMERG);
 	bust_spinlocks(0);
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	spin_unlock_irq(&die_lock);
 
 	if (in_interrupt())
diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index a41eeb8..0637a86 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -225,7 +225,7 @@ int die(const char *str, struct pt_regs *regs, long err)
 	do_show_stack(current, &regs->r30, pt_elr(regs));
 
 	bust_spinlocks(0);
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 
 	spin_unlock_irq(&die.lock);
 
diff --git a/arch/ia64/kernel/traps.c b/arch/ia64/kernel/traps.c
index bd42b76..e4e71c5 100644
--- a/arch/ia64/kernel/traps.c
+++ b/arch/ia64/kernel/traps.c
@@ -72,7 +72,7 @@ die (const char *str, struct pt_regs *regs, long err)
 
 	bust_spinlocks(0);
 	die.lock_owner = -1;
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	spin_unlock_irq(&die.lock);
 
 	if (!regs)
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index cbc624a..18798af 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -1176,7 +1176,7 @@ void die_if_kernel (char *str, struct pt_regs *fp, int nr)
 	console_verbose();
 	printk("%s: %08x\n",str,nr);
 	show_registers(fp);
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	do_exit(SIGSEGV);
 }
 
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index cf7ac54..a88f820 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -396,7 +396,7 @@ void __noreturn die(const char *str, struct pt_regs *regs)
 
 	printk("%s[#%d]:\n", str, ++die_counter);
 	show_registers(regs);
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	raw_spin_unlock_irq(&die_lock);
 
 	oops_exit();
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 45ba99f..614dc31 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -282,7 +282,7 @@ void die_if_kernel(char *str, struct pt_regs *regs, long err)
 
 	show_regs(regs);
 	dump_stack();
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 3251840..ec875b8 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -138,7 +138,7 @@ static void __kprobes oops_end(unsigned long flags, struct pt_regs *regs,
 {
 	bust_spinlocks(0);
 	die_owner = -1;
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	die_nest_count--;
 	oops_exit();
 	printk("\n");
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 70ecfc5..09ff735 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -271,7 +271,7 @@ void die(struct pt_regs *regs, const char *str)
 	print_modules();
 	show_regs(regs);
 	bust_spinlocks(0);
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	spin_unlock_irq(&die_lock);
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
diff --git a/arch/sh/kernel/traps.c b/arch/sh/kernel/traps.c
index 72246bc..ae0759d 100644
--- a/arch/sh/kernel/traps.c
+++ b/arch/sh/kernel/traps.c
@@ -38,7 +38,7 @@ void die(const char *str, struct pt_regs *regs, long err)
 	notify_die(DIE_OOPS, str, regs, err, 255, SIGSEGV);
 
 	bust_spinlocks(0);
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	spin_unlock_irq(&die_lock);
 	oops_exit();
 
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index 0eaf005..269a0d5 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -115,7 +115,7 @@ static void __init process_switch(char c)
 			break;
 		}
 		cheetah_pcache_forced_on = 1;
-		add_taint(TAINT_MACHINE_CHECK);
+		add_taint(TAINT_MACHINE_CHECK, false);
 		cheetah_enable_pcache();
 		break;
 
diff --git a/arch/sparc/kernel/traps_32.c b/arch/sparc/kernel/traps_32.c
index a5785ea..13f09de 100644
--- a/arch/sparc/kernel/traps_32.c
+++ b/arch/sparc/kernel/traps_32.c
@@ -58,7 +58,7 @@ void die_if_kernel(char *str, struct pt_regs *regs)
 
 	printk("%s(%d): %s [#%d]\n", current->comm, task_pid_nr(current), str, ++die_counter);
 	show_regs(regs);
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 
 	__SAVE; __SAVE; __SAVE; __SAVE;
 	__SAVE; __SAVE; __SAVE; __SAVE;
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index e7ecf15..5db8b53 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -2383,7 +2383,7 @@ void die_if_kernel(char *str, struct pt_regs *regs)
 	notify_die(DIE_OOPS, str, regs, 0, 255, SIGSEGV);
 	__asm__ __volatile__("flushw");
 	show_regs(regs);
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	if (regs->tstate & TSTATE_PRIV) {
 		struct thread_info *tp = current_thread_info();
 		struct reg_window *rw = (struct reg_window *)
diff --git a/arch/unicore32/kernel/traps.c b/arch/unicore32/kernel/traps.c
index 2054f0d..2a2351b 100644
--- a/arch/unicore32/kernel/traps.c
+++ b/arch/unicore32/kernel/traps.c
@@ -231,7 +231,7 @@ void die(const char *str, struct pt_regs *regs, int err)
 	ret = __die(str, err, thread, regs);
 
 	bust_spinlocks(0);
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	spin_unlock_irq(&die_lock);
 	oops_exit();
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 15239ff..b9d242f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -220,8 +220,7 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 	 */
 	WARN_ONCE(1, "WARNING: This combination of AMD"
 		" processors is not suitable for SMP.\n");
-	if (!test_taint(TAINT_UNSAFE_SMP))
-		add_taint(TAINT_UNSAFE_SMP);
+	add_taint(TAINT_UNSAFE_SMP, false);
 
 valid_k7:
 	;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 80dbda8..bc43a1f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1085,7 +1085,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		/*
 		 * Set taint even when machine check was not enabled.
 		 */
-		add_taint(TAINT_MACHINE_CHECK);
+		add_taint(TAINT_MACHINE_CHECK, false);
 
 		severity = mce_severity(&m, cfg->tolerant, NULL);
 
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index 2d5454c..544cdee 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -33,7 +33,7 @@ static void pentium_machine_check(struct pt_regs *regs, long error_code)
 			smp_processor_id());
 	}
 
-	add_taint(TAINT_MACHINE_CHECK);
+	add_taint(TAINT_MACHINE_CHECK, false);
 }
 
 /* Set up machine check reporting for processors with Intel style MCE: */
diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index 2d7998f..6cb85e03a 100644
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -15,7 +15,7 @@
 static void winchip_machine_check(struct pt_regs *regs, long error_code)
 {
 	printk(KERN_EMERG "CPU0: Machine Check Exception.\n");
-	add_taint(TAINT_MACHINE_CHECK);
+	add_taint(TAINT_MACHINE_CHECK, false);
 }
 
 /* Set up machine check reporting on the Winchip C6 series */
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index e9fe907..c00a664 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -542,7 +542,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 
 		if (tmp != mask_lo) {
 			printk(KERN_WARNING "mtrr: your BIOS has configured an incorrect mask, fixing it.\n");
-			add_taint(TAINT_FIRMWARE_WORKAROUND);
+			add_taint(TAINT_FIRMWARE_WORKAROUND, true);
 			mask_lo = tmp;
 		}
 	}
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index ae42418b..7ad7830 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -232,7 +232,7 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 
 	bust_spinlocks(0);
 	die_owner = -1;
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	die_nest_count--;
 	if (!die_nest_count)
 		/* Nest count reaches zero, release the lock. */
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 01e0111..fc1bef8 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -524,7 +524,7 @@ void die(const char * str, struct pt_regs * regs, long err)
 	if (!user_mode(regs))
 		show_stack(NULL, (unsigned long*)regs->areg[1]);
 
-	add_taint(TAINT_DIE);
+	add_taint(TAINT_DIE, false);
 	spin_unlock_irq(&die_lock);
 
 	if (in_interrupt())
diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
index 5d42c24..000c701 100644
--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -66,7 +66,7 @@ static ssize_t cm_write(struct file *file, const char __user * user_buf,
 		buf = NULL;
 		if (ACPI_FAILURE(status))
 			return -EINVAL;
-		add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);
+		add_taint(TAINT_OVERRIDDEN_ACPI_TABLE, false);
 	}
 
 	return count;
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 3ff2678..15b803e 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -661,7 +661,7 @@ static void acpi_table_taint(struct acpi_table_header *table)
 	pr_warn(PREFIX
 		"Override [%4.4s-%8.8s], this is unsafe: tainting kernel\n",
 		table->signature, table->oem_table_id);
-	add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);
+	add_taint(TAINT_OVERRIDDEN_ACPI_TABLE, false);
 }
 
 
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 07aad78..32a5be2 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -232,7 +232,7 @@ static ssize_t regmap_map_write_file(struct file *file,
 		return -EINVAL;
 
 	/* Userspace has been fiddling around behind the kernel's back */
-	add_taint(TAINT_USER);
+	add_taint(TAINT_USER, false);
 
 	regmap_write(map, reg, value);
 	return buf_size;
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c566927..53c14cb 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -398,7 +398,7 @@ extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
 extern int sysctl_panic_on_stackoverflow;
 extern const char *print_tainted(void);
-extern void add_taint(unsigned flag);
+extern void add_taint(unsigned flag, bool lockdebug_ok);
 extern int test_taint(unsigned flag);
 extern unsigned long get_taint(void);
 extern int root_mountflags;
diff --git a/kernel/module.c b/kernel/module.c
index ec535aa..ce96df4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -197,9 +197,10 @@ static inline int strong_try_module_get(struct module *mod)
 		return -ENOENT;
 }
 
-static inline void add_taint_module(struct module *mod, unsigned flag)
+static inline void add_taint_module(struct module *mod, unsigned flag,
+				    bool lockdep_ok)
 {
-	add_taint(flag);
+	add_taint(flag, lockdep_ok);
 	mod->taints |= (1U << flag);
 }
 
@@ -727,7 +728,7 @@ static inline int try_force_unload(unsigned int flags)
 {
 	int ret = (flags & O_TRUNC);
 	if (ret)
-		add_taint(TAINT_FORCED_RMMOD);
+		add_taint(TAINT_FORCED_RMMOD, false);
 	return ret;
 }
 #else
@@ -1138,7 +1139,7 @@ static int try_to_force_load(struct module *mod, const char *reason)
 	if (!test_taint(TAINT_FORCED_MODULE))
 		printk(KERN_WARNING "%s: %s: kernel tainted.\n",
 		       mod->name, reason);
-	add_taint_module(mod, TAINT_FORCED_MODULE);
+	add_taint_module(mod, TAINT_FORCED_MODULE, false);
 	return 0;
 #else
 	return -ENOEXEC;
@@ -2147,7 +2148,7 @@ static void set_license(struct module *mod, const char *license)
 		if (!test_taint(TAINT_PROPRIETARY_MODULE))
 			printk(KERN_WARNING "%s: module license '%s' taints "
 				"kernel.\n", mod->name, license);
-		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
+		add_taint_module(mod, TAINT_PROPRIETARY_MODULE, false);
 	}
 }
 
@@ -2700,10 +2701,10 @@ static int check_modinfo(struct module *mod, struct load_info *info, int flags)
 	}
 
 	if (!get_modinfo(info, "intree"))
-		add_taint_module(mod, TAINT_OOT_MODULE);
+		add_taint_module(mod, TAINT_OOT_MODULE, true);
 
 	if (get_modinfo(info, "staging")) {
-		add_taint_module(mod, TAINT_CRAP);
+		add_taint_module(mod, TAINT_CRAP, true);
 		printk(KERN_WARNING "%s: module is from the staging directory,"
 		       " the quality is unknown, you have been warned.\n",
 		       mod->name);
@@ -2869,15 +2870,15 @@ static int check_module_license_and_versions(struct module *mod)
 	 * using GPL-only symbols it needs.
 	 */
 	if (strcmp(mod->name, "ndiswrapper") == 0)
-		add_taint(TAINT_PROPRIETARY_MODULE);
+		add_taint(TAINT_PROPRIETARY_MODULE, false);
 
 	/* driverloader was caught wrongly pretending to be under GPL */
 	if (strcmp(mod->name, "driverloader") == 0)
-		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
+		add_taint_module(mod, TAINT_PROPRIETARY_MODULE, false);
 
 	/* lve claims to be GPL but upstream won't provide source */
 	if (strcmp(mod->name, "lve") == 0)
-		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
+		add_taint_module(mod, TAINT_PROPRIETARY_MODULE, false);
 
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !mod->crcs)
@@ -3170,7 +3171,7 @@ again:
 #ifdef CONFIG_MODULE_SIG
 	mod->sig_ok = info->sig_ok;
 	if (!mod->sig_ok)
-		add_taint_module(mod, TAINT_FORCED_MODULE);
+		add_taint_module(mod, TAINT_FORCED_MODULE, true);
 #endif
 
 	/* Now module is in final location, initialize linked lists, etc. */
diff --git a/kernel/panic.c b/kernel/panic.c
index e1b2822..92d38de 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -259,26 +259,19 @@ unsigned long get_taint(void)
 	return tainted_mask;
 }
 
-void add_taint(unsigned flag)
+/**
+ * add_taint: add a taint flag if not already set.
+ * @flag: one of the TAINT_* constants.
+ * @lockdebug_ok: whether lock debugging is still OK.
+ *
+ * If something bad has gone wrong, you'll want @lockdebug_ok = false, but for
+ * some notewortht-but-not-corrupting cases, it can be set to true.
+ */
+void add_taint(unsigned flag, bool lockdebug_ok)
 {
-	/*
-	 * Can't trust the integrity of the kernel anymore.
-	 * We don't call directly debug_locks_off() because the issue
-	 * is not necessarily serious enough to set oops_in_progress to 1
-	 * Also we want to keep up lockdep for staging/out-of-tree
-	 * development and post-warning case.
-	 */
-	switch (flag) {
-	case TAINT_CRAP:
-	case TAINT_OOT_MODULE:
-	case TAINT_WARN:
-	case TAINT_FIRMWARE_WORKAROUND:
-		break;
-
-	default:
-		if (__debug_locks_off())
-			printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
-	}
+	if (!lockdebug_ok && __debug_locks_off())
+		printk(KERN_WARNING
+		       "Disabling lock debugging due to kernel taint\n");
 
 	set_bit(flag, &tainted_mask);
 }
@@ -421,7 +414,7 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
 	print_modules();
 	dump_stack();
 	print_oops_end_marker();
-	add_taint(taint);
+	add_taint(taint, true); /* Just a warning, don't kill lockdep. */
 }
 
 void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 257002c..dc05028 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2785,7 +2785,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
 	dump_stack();
-	add_taint(TAINT_WARN);
+	add_taint(TAINT_WARN, true);
 }
 
 /*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c88878d..7137a2d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2006,7 +2006,7 @@ static int proc_taint(struct ctl_table *table, int write,
 		int i;
 		for (i = 0; i < BITS_PER_LONG && tmptaint >> i; i++) {
 			if ((tmptaint >> i) & 1)
-				add_taint(i);
+				add_taint(i, true);
 		}
 	}
 
diff --git a/lib/bug.c b/lib/bug.c
index d0cdf14..8d57bca 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -166,7 +166,8 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 		print_modules();
 		show_regs(regs);
 		print_oops_end_marker();
-		add_taint(BUG_GET_TAINT(bug));
+		/* Just a warning, don't kill lockdep. */
+		add_taint(BUG_GET_TAINT(bug), true);
 		return BUG_TRAP_TYPE_WARN;
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index bb1369f..8473e48 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -716,7 +716,7 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
 		print_symbol(KERN_ALERT "vma->vm_file->f_op->mmap: %s\n",
 				(unsigned long)vma->vm_file->f_op->mmap);
 	dump_stack();
-	add_taint(TAINT_BAD_PAGE);
+	add_taint(TAINT_BAD_PAGE, false);
 }
 
 static inline bool is_cow_mapping(vm_flags_t flags)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index df2022f..c978a3d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -320,7 +320,7 @@ static void bad_page(struct page *page)
 out:
 	/* Leave bad fields for debug, except PageBuddy could make trouble */
 	reset_page_mapcount(page); /* remove PageBuddy */
-	add_taint(TAINT_BAD_PAGE);
+	add_taint(TAINT_BAD_PAGE, false);
 }
 
 /*
diff --git a/mm/slab.c b/mm/slab.c
index e7667a3..f3e8bf2 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -812,7 +812,7 @@ static void __slab_error(const char *function, struct kmem_cache *cachep,
 	printk(KERN_ERR "slab error in %s(): cache `%s': %s\n",
 	       function, cachep->name, msg);
 	dump_stack();
-	add_taint(TAINT_BAD_PAGE);
+	add_taint(TAINT_BAD_PAGE, false);
 }
 #endif
 
diff --git a/mm/slub.c b/mm/slub.c
index ba2ca53..786ed87 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -562,7 +562,7 @@ static void slab_bug(struct kmem_cache *s, char *fmt, ...)
 	printk(KERN_ERR "----------------------------------------"
 			"-------------------------------------\n\n");
 
-	add_taint(TAINT_BAD_PAGE);
+	add_taint(TAINT_BAD_PAGE, false);
 }
 
 static void slab_fix(struct kmem_cache *s, char *fmt, ...)
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 91d592f..9ecbb53 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -251,7 +251,7 @@ static ssize_t codec_reg_write_file(struct file *file,
 		return -EINVAL;
 
 	/* Userspace has been fiddling around behind the kernel's back */
-	add_taint(TAINT_USER);
+	add_taint(TAINT_USER, false);
 
 	snd_soc_write(codec, reg, value);
 	return buf_size;
