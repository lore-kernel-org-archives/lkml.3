Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaI3TI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:08:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaI3TIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:08:54 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Jason Wessel <jason.wessel@windriver.com>,
        Roland McGrath <roland@hack.frob.com>, Oleg Nesterov <oleg@redhat.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH] modules, split MODULE_STATE_UNFORMED into separate states
Date: Tue, 30 Sep 2014 15:08:30 -0400
Message-Id: <1412104110-18441-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a heads up, the changes here are really to the core module code.  The
changes to kgdb and the tracing code are small simple changes.

P.

---8<---

A panic was seen in the following sitation.

There are two threads running on the system. The first thread is a system
monitoring thread that is reading /proc/modules. The second thread is
loading and unloading a module (in this example I'm using my simple
dummy-module.ko).  Note, in the "real world" this occurred with the qlogic
driver module.

When doing this, the following panic occurred:

 ------------[ cut here ]------------
 kernel BUG at kernel/module.c:3739!
 invalid opcode: 0000 [#1] SMP
 Modules linked in: binfmt_misc sg nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel lrw igb gf128mul glue_helper iTCO_wdt iTCO_vendor_support ablk_helper ptp sb_edac cryptd pps_core edac_core shpchp i2c_i801 pcspkr wmi lpc_ich ioatdma mfd_core dca ipmi_si nfsd ipmi_msghandler auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sr_mod cdrom sd_mod crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm isci drm libsas ahci libahci scsi_transport_sas libata i2c_core dm_mirror dm_region_hash dm_log dm_mod [last unloaded: dummy_module]
 CPU: 37 PID: 186343 Comm: cat Tainted: GF          O--------------   3.10.0+ #7
 Hardware name: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.00.29.D696.1311111329 11/11/2013
 task: ffff8807fd2d8000 ti: ffff88080fa7c000 task.ti: ffff88080fa7c000
 RIP: 0010:[<ffffffff810d64c5>]  [<ffffffff810d64c5>] module_flags+0xb5/0xc0
 RSP: 0018:ffff88080fa7fe18  EFLAGS: 00010246
 RAX: 0000000000000003 RBX: ffffffffa03b5200 RCX: 0000000000000000
 RDX: 0000000000001000 RSI: ffff88080fa7fe38 RDI: ffffffffa03b5000
 RBP: ffff88080fa7fe28 R08: 0000000000000010 R09: 0000000000000000
 R10: 0000000000000000 R11: 000000000000000f R12: ffffffffa03b5000
 R13: ffffffffa03b5008 R14: ffffffffa03b5200 R15: ffffffffa03b5000
 FS:  00007f6ae57ef740(0000) GS:ffff88101e7a0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000404f70 CR3: 0000000ffed48000 CR4: 00000000001407e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Stack:
  ffffffffa03b5200 ffff8810101e4800 ffff88080fa7fe70 ffffffff810d666c
  ffff88081e807300 000000002e0f2fbf 0000000000000000 ffff88100f257b00
  ffffffffa03b5008 ffff88080fa7ff48 ffff8810101e4800 ffff88080fa7fee0
 Call Trace:
  [<ffffffff810d666c>] m_show+0x19c/0x1e0
  [<ffffffff811e4d7e>] seq_read+0x16e/0x3b0
  [<ffffffff812281ed>] proc_reg_read+0x3d/0x80
  [<ffffffff811c0f2c>] vfs_read+0x9c/0x170
  [<ffffffff811c1a58>] SyS_read+0x58/0xb0
  [<ffffffff81605829>] system_call_fastpath+0x16/0x1b
 Code: 48 63 c2 83 c2 01 c6 04 03 29 48 63 d2 eb d9 0f 1f 80 00 00 00 00 48 63 d2 c6 04 13 2d 41 8b 0c 24 8d 50 02 83 f9 01 75 b2 eb cb <0f> 0b 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41
 RIP  [<ffffffff810d64c5>] module_flags+0xb5/0xc0
  RSP <ffff88080fa7fe18>

    Consider the two processes running on the system.

    CPU 0 (/proc/modules reader)
    CPU 1 (loading/unloading module)

    CPU 0 opens /proc/modules, and starts displaying data for each module by
    traversing the modules list via fs/seq_file.c:seq_open() and
    fs/seq_file.c:seq_read().  For each module in the modules list, seq_read
    does

            op->start()  <-- this is a pointer to m_start()
            op->show()   <- this is a pointer to m_show()
            op->stop()   <-- this is a pointer to m_stop()

    The m_start(), m_show(), and m_stop() module functions are defined in
    kernel/module.c. The m_start() and m_stop() functions acquire and release
    the module_mutex respectively.

    ie) When reading /proc/modules, the module_mutex is acquired and released
    for each module.

    m_show() is called with the module_mutex held.  It accesses the module
    struct data and attempts to write out module data.  It is in this code
    path that the above BUG_ON() warning is encountered, specifically m_show()
    calls

    static char *module_flags(struct module *mod, char *buf)
    {
            int bx = 0;

            BUG_ON(mod->state == MODULE_STATE_UNFORMED);
    ...

    The other thread, CPU 1, in unloading the module calls the syscall
    delete_module() defined in kernel/module.c.  The module_mutex is acquired
    for a short time, and then released.  free_module() is called without the
    module_mutex.  free_module() then sets mod->state = MODULE_STATE_UNFORMED,
    also without the module_mutex.  Some additional code is called and then the
    module_mutex is reacquired to remove the module from the modules list:

        /* Now we can delete it from the lists */
        mutex_lock(&module_mutex);
        stop_machine(__unlink_module, mod, NULL);
        mutex_unlock(&module_mutex);

This is the sequence of events that leads to the panic.

CPU 1 is removing dummy_module via delete_module().  It acquires the
module_mutex, and then releases it.  CPU 1 has NOT set dummy_module->state to
MODULE_STATE_UNFORMED yet.

CPU 0, which is reading the /proc/modules, acquires the module_mutex and
acquires a pointer to the dummy_module which is still in the modules list.
CPU 0 calls m_show for dummy_module.  The check in m_show() for
MODULE_STATE_UNFORMED passed for dummy_module even though it is being
torn down.

Meanwhile CPU 1, which has been continuing to remove dummy_module without
holding the module_mutex, now calls free_module() and sets
dummy_module->state to MODULE_STATE_UNFORMED.

CPU 0 now calls module_flags() with dummy_module and ...

static char *module_flags(struct module *mod, char *buf)
{
        int bx = 0;

        BUG_ON(mod->state == MODULE_STATE_UNFORMED);

and BOOM.

Inspection of the code calls into question whether-or-not module_flags()
should have that BUG_ON().  It seems to me that the BUG_ON() only has
purpose during a module load, as the data is in a questionable state when
module_flags() is called and a BUG_ON() is appropriate.  On a module
delete the data is valid until the module is removed from the
modules list, after which module_flags() won't be called on the module.

MODULE_STATE_UNFORMED needs to be separated into two states; one for the
module load (MODULE_STATE_LOAD), and one for the module delete
(MODULE_STATE_DELETE).  This fixes the "false" BUG_ON(), and allows the
output of module_flags to be consistent and correct for panic output and
/proc/modules output.

To make the code a bit cleaner I've added a helper function,
module_state_is_unformed(), which reports if the module is in either
new state.

In addition to this I've updated the module state descriptions with slightly
more detail.

Testing: In the unpatched kernel I can panic the system within 1 minute by
doing

while (true) do insmod dummy_module.ko; rmmod dummy_module.ko; done

and

while (true) do cat /proc/modules; done

in separate terminals.

In the patched kernel I was able to run just over one hour without seeing
any issues.  I also verified the output of panic via sysrq-c and the output
of /proc/modules looks correct for all three states for the dummy_module.

        dummy_module 12661 0 - Unloading 0xffffffffa03a5000 (OE-)
        dummy_module 12661 0 - Live 0xffffffffa03bb000 (OE)
        dummy_module 14015 1 - Loading 0xffffffffa03a5000 (OE+)

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: kgdb-bugreport@lists.sourceforge.net
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 include/linux/module.h      |   13 ++++++--
 kernel/debug/kdb/kdb_main.c |    2 +-
 kernel/module.c             |   74 ++++++++++++++++++++++++++-----------------
 kernel/tracepoint.c         |    3 +-
 4 files changed, 59 insertions(+), 33 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 71f282a..f49c4612 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -206,8 +206,9 @@ struct module_use {
 enum module_state {
 	MODULE_STATE_LIVE,	/* Normal state. */
 	MODULE_STATE_COMING,	/* Full formed, running module_init. */
-	MODULE_STATE_GOING,	/* Going away. */
-	MODULE_STATE_UNFORMED,	/* Still setting it up. */
+	MODULE_STATE_GOING,	/* Early delete. */
+	MODULE_STATE_LOAD,	/* Early init. */
+	MODULE_STATE_DELETE,	/* Late delete. */
 };
 
 /**
@@ -390,6 +391,14 @@ static inline int module_is_live(struct module *mod)
 	return mod->state != MODULE_STATE_GOING;
 }
 
+static inline bool module_state_is_unformed(struct module *module)
+{
+	if ((module->state == MODULE_STATE_LOAD) ||
+	    (module->state == MODULE_STATE_DELETE))
+		return true;
+	return false;
+}
+
 struct module *__module_text_address(unsigned long addr);
 struct module *__module_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 379650b..fa72b26 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1973,7 +1973,7 @@ static int kdb_lsmod(int argc, const char **argv)
 
 	kdb_printf("Module                  Size  modstruct     Used by\n");
 	list_for_each_entry(mod, kdb_modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (module_state_is_unformed(mod))
 			continue;
 
 		kdb_printf("%-20s%8u  0x%p ", mod->name,
diff --git a/kernel/module.c b/kernel/module.c
index 03214bd2..bb00bf6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -188,7 +188,7 @@ struct load_info {
    ongoing or failed initialization etc. */
 static inline int strong_try_module_get(struct module *mod)
 {
-	BUG_ON(mod && mod->state == MODULE_STATE_UNFORMED);
+	BUG_ON(mod && module_state_is_unformed(mod));
 	if (mod && mod->state == MODULE_STATE_COMING)
 		return -EBUSY;
 	if (try_module_get(mod))
@@ -345,7 +345,7 @@ bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
 #endif
 		};
 
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (module_state_is_unformed(mod))
 			continue;
 
 		if (each_symbol_in_section(arr, ARRAY_SIZE(arr), mod, fn, data))
@@ -459,7 +459,7 @@ static struct module *find_module_all(const char *name, size_t len,
 	struct module *mod;
 
 	list_for_each_entry(mod, &modules, list) {
-		if (!even_unformed && mod->state == MODULE_STATE_UNFORMED)
+		if (!even_unformed && module_state_is_unformed(mod))
 			continue;
 		if (strlen(mod->name) == len && !memcmp(mod->name, name, len))
 			return mod;
@@ -540,7 +540,7 @@ bool is_module_percpu_address(unsigned long addr)
 	preempt_disable();
 
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (module_state_is_unformed(mod))
 			continue;
 		if (!mod->percpu_size)
 			continue;
@@ -1780,7 +1780,7 @@ void set_all_modules_text_rw(void)
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (module_state_is_unformed(mod))
 			continue;
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
@@ -1803,7 +1803,7 @@ void set_all_modules_text_ro(void)
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (module_state_is_unformed(mod))
 			continue;
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
@@ -1842,7 +1842,7 @@ static void free_module(struct module *mod)
 
 	/* We leave it in list to prevent duplicate loads, but make sure
 	 * that noone uses it while it's being deconstructed. */
-	mod->state = MODULE_STATE_UNFORMED;
+	mod->state = MODULE_STATE_DELETE;
 
 	/* Remove dynamic debug info */
 	ddebug_remove_module(mod->name);
@@ -3104,14 +3104,14 @@ static int add_unformed_module(struct module *mod)
 	int err;
 	struct module *old;
 
-	mod->state = MODULE_STATE_UNFORMED;
+	mod->state = MODULE_STATE_LOAD;
 
 again:
 	mutex_lock(&module_mutex);
 	old = find_module_all(mod->name, strlen(mod->name), true);
 	if (old != NULL) {
 		if (old->state == MODULE_STATE_COMING
-		    || old->state == MODULE_STATE_UNFORMED) {
+		    || old->state == MODULE_STATE_LOAD) {
 			/* Wait in case it fails to load. */
 			mutex_unlock(&module_mutex);
 			err = wait_event_interruptible(module_wq,
@@ -3267,7 +3267,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 
 	dynamic_debug_setup(info->debug, info->num_debug);
 
-	/* Ftrace init must be called in the MODULE_STATE_UNFORMED state */
+	/* Ftrace init must be called in the MODULE_STATE_LOAD state */
 	ftrace_module_init(mod);
 
 	/* Finally it's fully formed, ready to start executing. */
@@ -3449,7 +3449,7 @@ const char *module_address_lookup(unsigned long addr,
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (module_state_is_unformed(mod))
 			continue;
 		if (within_module(addr, mod)) {
 			if (modname)
@@ -3473,7 +3473,7 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (module_state_is_unformed(mod))
 			continue;
 		if (within_module(addr, mod)) {
 			const char *sym;
@@ -3498,7 +3498,7 @@ int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (module_state_is_unformed(mod))
 			continue;
 		if (within_module(addr, mod)) {
 			const char *sym;
@@ -3526,7 +3526,7 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (module_state_is_unformed(mod))
 			continue;
 		if (symnum < mod->num_symtab) {
 			*value = mod->symtab[symnum].st_value;
@@ -3569,7 +3569,7 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 			ret = mod_find_symname(mod, colon+1);
 	} else {
 		list_for_each_entry_rcu(mod, &modules, list) {
-			if (mod->state == MODULE_STATE_UNFORMED)
+			if (module_state_is_unformed(mod))
 				continue;
 			if ((ret = mod_find_symname(mod, name)) != 0)
 				break;
@@ -3588,7 +3588,7 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 	int ret;
 
 	list_for_each_entry(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (module_state_is_unformed(mod))
 			continue;
 		for (i = 0; i < mod->num_symtab; i++) {
 			ret = fn(data, mod->strtab + mod->symtab[i].st_name,
@@ -3605,14 +3605,13 @@ static char *module_flags(struct module *mod, char *buf)
 {
 	int bx = 0;
 
-	BUG_ON(mod->state == MODULE_STATE_UNFORMED);
-	if (mod->taints ||
-	    mod->state == MODULE_STATE_GOING ||
-	    mod->state == MODULE_STATE_COMING) {
+	BUG_ON(mod->state == MODULE_STATE_LOAD);
+	if (mod->taints || mod->state != MODULE_STATE_LIVE) {
 		buf[bx++] = '(';
 		bx += module_flags_taint(mod, buf + bx);
 		/* Show a - for module-is-being-unloaded */
-		if (mod->state == MODULE_STATE_GOING)
+		if ((mod->state == MODULE_STATE_GOING) ||
+		    (mod->state == MODULE_STATE_DELETE))
 			buf[bx++] = '-';
 		/* Show a + for module-is-being-loaded */
 		if (mod->state == MODULE_STATE_COMING)
@@ -3647,18 +3646,29 @@ static int m_show(struct seq_file *m, void *p)
 	struct module *mod = list_entry(p, struct module, list);
 	char buf[8];
 
-	/* We always ignore unformed modules. */
-	if (mod->state == MODULE_STATE_UNFORMED)
+	/*
+	 * If the state is MODULE_STATE_LOAD then the module is in
+	 * the early stages of loading.  No information should be printed
+	 * for this module as the data could be in an uninitialized state.
+	 */
+	if (mod->state == MODULE_STATE_LOAD)
 		return 0;
 
 	seq_printf(m, "%s %u",
 		   mod->name, mod->init_size + mod->core_size);
 	print_unload_info(m, mod);
 
-	/* Informative for users. */
+	/*
+	 * Information for users.
+	 *
+	 * If the state is MODULE_STATE_DELETE then the module is in the
+	 * late stages of unloading.  The data is still valid and can be
+	 * displayed.
+	 */
 	seq_printf(m, " %s",
-		   mod->state == MODULE_STATE_GOING ? "Unloading":
-		   mod->state == MODULE_STATE_COMING ? "Loading":
+		   mod->state == MODULE_STATE_GOING ? "Unloading" :
+		   mod->state == MODULE_STATE_COMING ? "Loading" :
+		   mod->state == MODULE_STATE_DELETE ? "Unloading" :
 		   "Live");
 	/* Used by oprofile and other similar tools. */
 	seq_printf(m, " 0x%pK", mod->module_core);
@@ -3711,7 +3721,7 @@ const struct exception_table_entry *search_module_extables(unsigned long addr)
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (module_state_is_unformed(mod))
 			continue;
 		if (mod->num_exentries == 0)
 			continue;
@@ -3762,7 +3772,7 @@ struct module *__module_address(unsigned long addr)
 		return NULL;
 
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (module_state_is_unformed(mod))
 			continue;
 		if (within_module(addr, mod))
 			return mod;
@@ -3820,7 +3830,13 @@ void print_modules(void)
 	/* Most callers should already have preempt disabled, but make sure */
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		/*
+		 * If the state is MODULE_STATE_LOAD then the module
+		 * is in the early stages of loading.  No information should be
+		 * printed for this module as the data could be in an
+		 * uninitialized state.
+		 */
+		if (mod->state == MODULE_STATE_LOAD)
 			continue;
 		pr_cont(" %s%s", mod->name, module_flags(mod, buf));
 	}
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 3490407..a96dbcc 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -435,7 +435,8 @@ static int tracepoint_module_notify(struct notifier_block *self,
 	case MODULE_STATE_GOING:
 		tracepoint_module_going(mod);
 		break;
-	case MODULE_STATE_UNFORMED:
+	case MODULE_STATE_LOAD:
+	case MODULE_STATE_DELETE:
 		break;
 	}
 	return ret;
-- 
1.7.9.3

