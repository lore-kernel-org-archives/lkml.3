Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab3CXFPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 01:15:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60226 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3CXFP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 01:15:27 -0400
Date: Sat, 23 Mar 2013 22:13:38 -0700
Message-Id: <201303240513.r2O5Dc2V025273@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 3.9-rc4
Cc: <stable@vger.kernel.org>, Andre Heider <a.heider@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, CQ Tang <cq.tang@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Frederic Crozat <fcrozat@suse.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Josh Boyer <jwboyer@redhat.com>, Lee@zytor.com,
        Chun-Yi <jlee@suse.com>, Lingzhu Xiang <lxiang@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Michael Schroeder <mls@suse.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 23 Mar 2013 22:13:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A collection of minor fixes, more EFI variables paranoia
(anti-bricking) plus the ability to disable the pstore either as a
runtime default or completely, due to bricking concerns.

The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/urgent

for you to fetch changes up to b9726d9df8263fe756d2293ff01906f41f7d2776:

  Merge tag 'efi-for-3.9-rc4' into x86/urgent (2013-03-23 21:49:51 -0700)

----------------------------------------------------------------

Ben Hutchings (1):
      efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE

CQ Tang (1):
      x86-64: Fix the failure case in copy_user_handle_tail()

Fenghua Yu (1):
      x86-32, microcode_intel_early: Fix crash with CONFIG_DEBUG_VIRTUAL

H. Peter Anvin (3):
      x86, microcode_intel_early: Mark apply_microcode_early() as cpuinit
      Merge tag 'efi-for-3.9-rc3' into x86/urgent
      Merge tag 'efi-for-3.9-rc4' into x86/urgent

Matt Fleming (2):
      efivars: explicitly calculate length of VariableName
      efivars: Handle duplicate names from get_next_variable()

Seth Forshee (2):
      efivars: Allow disabling use as a pstore backend
      efivars: Add module parameter to disable use as a pstore backend

 arch/x86/kernel/microcode_intel_early.c |  30 +++----
 arch/x86/lib/usercopy_64.c              |   4 +-
 drivers/firmware/Kconfig                |  18 ++++
 drivers/firmware/efivars.c              | 150 ++++++++++++++++++++++----------
 4 files changed, 139 insertions(+), 63 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index 7890bc8..d893e8e 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -90,13 +90,13 @@ microcode_phys(struct microcode_intel **mc_saved_tmp,
 	struct microcode_intel ***mc_saved;
 
 	mc_saved = (struct microcode_intel ***)
-		   __pa_symbol(&mc_saved_data->mc_saved);
+		   __pa_nodebug(&mc_saved_data->mc_saved);
 	for (i = 0; i < mc_saved_data->mc_saved_count; i++) {
 		struct microcode_intel *p;
 
 		p = *(struct microcode_intel **)
-			__pa(mc_saved_data->mc_saved + i);
-		mc_saved_tmp[i] = (struct microcode_intel *)__pa(p);
+			__pa_nodebug(mc_saved_data->mc_saved + i);
+		mc_saved_tmp[i] = (struct microcode_intel *)__pa_nodebug(p);
 	}
 }
 #endif
@@ -562,7 +562,7 @@ scan_microcode(unsigned long start, unsigned long end,
 	struct cpio_data cd;
 	long offset = 0;
 #ifdef CONFIG_X86_32
-	char *p = (char *)__pa_symbol(ucode_name);
+	char *p = (char *)__pa_nodebug(ucode_name);
 #else
 	char *p = ucode_name;
 #endif
@@ -630,8 +630,8 @@ static void __cpuinit print_ucode(struct ucode_cpu_info *uci)
 	if (mc_intel == NULL)
 		return;
 
-	delay_ucode_info_p = (int *)__pa_symbol(&delay_ucode_info);
-	current_mc_date_p = (int *)__pa_symbol(&current_mc_date);
+	delay_ucode_info_p = (int *)__pa_nodebug(&delay_ucode_info);
+	current_mc_date_p = (int *)__pa_nodebug(&current_mc_date);
 
 	*delay_ucode_info_p = 1;
 	*current_mc_date_p = mc_intel->hdr.date;
@@ -659,8 +659,8 @@ static inline void __cpuinit print_ucode(struct ucode_cpu_info *uci)
 }
 #endif
 
-static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
-				 struct ucode_cpu_info *uci)
+static int __cpuinit apply_microcode_early(struct mc_saved_data *mc_saved_data,
+					   struct ucode_cpu_info *uci)
 {
 	struct microcode_intel *mc_intel;
 	unsigned int val[2];
@@ -741,15 +741,15 @@ load_ucode_intel_bsp(void)
 #ifdef CONFIG_X86_32
 	struct boot_params *boot_params_p;
 
-	boot_params_p = (struct boot_params *)__pa_symbol(&boot_params);
+	boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
 	ramdisk_image = boot_params_p->hdr.ramdisk_image;
 	ramdisk_size  = boot_params_p->hdr.ramdisk_size;
 	initrd_start_early = ramdisk_image;
 	initrd_end_early = initrd_start_early + ramdisk_size;
 
 	_load_ucode_intel_bsp(
-		(struct mc_saved_data *)__pa_symbol(&mc_saved_data),
-		(unsigned long *)__pa_symbol(&mc_saved_in_initrd),
+		(struct mc_saved_data *)__pa_nodebug(&mc_saved_data),
+		(unsigned long *)__pa_nodebug(&mc_saved_in_initrd),
 		initrd_start_early, initrd_end_early, &uci);
 #else
 	ramdisk_image = boot_params.hdr.ramdisk_image;
@@ -772,10 +772,10 @@ void __cpuinit load_ucode_intel_ap(void)
 	unsigned long *initrd_start_p;
 
 	mc_saved_in_initrd_p =
-		(unsigned long *)__pa_symbol(mc_saved_in_initrd);
-	mc_saved_data_p = (struct mc_saved_data *)__pa_symbol(&mc_saved_data);
-	initrd_start_p = (unsigned long *)__pa_symbol(&initrd_start);
-	initrd_start_addr = (unsigned long)__pa_symbol(*initrd_start_p);
+		(unsigned long *)__pa_nodebug(mc_saved_in_initrd);
+	mc_saved_data_p = (struct mc_saved_data *)__pa_nodebug(&mc_saved_data);
+	initrd_start_p = (unsigned long *)__pa_nodebug(&initrd_start);
+	initrd_start_addr = (unsigned long)__pa_nodebug(*initrd_start_p);
 #else
 	mc_saved_data_p = &mc_saved_data;
 	mc_saved_in_initrd_p = mc_saved_in_initrd;
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 05928aa..906fea3 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -74,10 +74,10 @@ copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 	char c;
 	unsigned zero_len;
 
-	for (; len; --len) {
+	for (; len; --len, to++) {
 		if (__get_user_nocheck(c, from++, sizeof(char)))
 			break;
-		if (__put_user_nocheck(c, to++, sizeof(char)))
+		if (__put_user_nocheck(c, to, sizeof(char)))
 			break;
 	}
 
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 9b00072..42c759a 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -53,6 +53,24 @@ config EFI_VARS
 	  Subsequent efibootmgr releases may be found at:
 	  <http://linux.dell.com/efibootmgr>
 
+config EFI_VARS_PSTORE
+	bool "Register efivars backend for pstore"
+	depends on EFI_VARS && PSTORE
+	default y
+	help
+	  Say Y here to enable use efivars as a backend to pstore. This
+	  will allow writing console messages, crash dumps, or anything
+	  else supported by pstore to EFI variables.
+
+config EFI_VARS_PSTORE_DEFAULT_DISABLE
+	bool "Disable using efivars as a pstore backend by default"
+	depends on EFI_VARS_PSTORE
+	default n
+	help
+	  Saying Y here will disable the use of efivars as a storage
+	  backend for pstore by default. This setting can be overridden
+	  using the efivars module's pstore_disable parameter.
+
 config EFI_PCDP
 	bool "Console device selection via EFI PCDP or HCDP table"
 	depends on ACPI && EFI && IA64
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index fe62aa3..7acafb8 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -103,6 +103,11 @@ MODULE_VERSION(EFIVARS_VERSION);
  */
 #define GUID_LEN 36
 
+static bool efivars_pstore_disable =
+	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
+
+module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
+
 /*
  * The maximum size of VariableName + Data = 1024
  * Therefore, it's reasonable to save that much
@@ -165,6 +170,7 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 
 static void efivar_update_sysfs_entries(struct work_struct *);
 static DECLARE_WORK(efivar_work, efivar_update_sysfs_entries);
+static bool efivar_wq_enabled = true;
 
 /* Return the number of unicode characters in data */
 static unsigned long
@@ -1309,9 +1315,7 @@ static const struct inode_operations efivarfs_dir_inode_operations = {
 	.create = efivarfs_create,
 };
 
-static struct pstore_info efi_pstore_info;
-
-#ifdef CONFIG_PSTORE
+#ifdef CONFIG_EFI_VARS_PSTORE
 
 static int efi_pstore_open(struct pstore_info *psi)
 {
@@ -1441,7 +1445,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 
 	spin_unlock_irqrestore(&efivars->lock, flags);
 
-	if (reason == KMSG_DUMP_OOPS)
+	if (reason == KMSG_DUMP_OOPS && efivar_wq_enabled)
 		schedule_work(&efivar_work);
 
 	*id = part;
@@ -1514,38 +1518,6 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 
 	return 0;
 }
-#else
-static int efi_pstore_open(struct pstore_info *psi)
-{
-	return 0;
-}
-
-static int efi_pstore_close(struct pstore_info *psi)
-{
-	return 0;
-}
-
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type, int *count,
-			       struct timespec *timespec,
-			       char **buf, struct pstore_info *psi)
-{
-	return -1;
-}
-
-static int efi_pstore_write(enum pstore_type_id type,
-		enum kmsg_dump_reason reason, u64 *id,
-		unsigned int part, int count, size_t size,
-		struct pstore_info *psi)
-{
-	return 0;
-}
-
-static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
-			    struct timespec time, struct pstore_info *psi)
-{
-	return 0;
-}
-#endif
 
 static struct pstore_info efi_pstore_info = {
 	.owner		= THIS_MODULE,
@@ -1557,6 +1529,24 @@ static struct pstore_info efi_pstore_info = {
 	.erase		= efi_pstore_erase,
 };
 
+static void efivar_pstore_register(struct efivars *efivars)
+{
+	efivars->efi_pstore_info = efi_pstore_info;
+	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
+	if (efivars->efi_pstore_info.buf) {
+		efivars->efi_pstore_info.bufsize = 1024;
+		efivars->efi_pstore_info.data = efivars;
+		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
+		pstore_register(&efivars->efi_pstore_info);
+	}
+}
+#else
+static void efivar_pstore_register(struct efivars *efivars)
+{
+	return;
+}
+#endif
+
 static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
@@ -1716,6 +1706,31 @@ static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
 	return found;
 }
 
+/*
+ * Returns the size of variable_name, in bytes, including the
+ * terminating NULL character, or variable_name_size if no NULL
+ * character is found among the first variable_name_size bytes.
+ */
+static unsigned long var_name_strnsize(efi_char16_t *variable_name,
+				       unsigned long variable_name_size)
+{
+	unsigned long len;
+	efi_char16_t c;
+
+	/*
+	 * The variable name is, by definition, a NULL-terminated
+	 * string, so make absolutely sure that variable_name_size is
+	 * the value we expect it to be. If not, return the real size.
+	 */
+	for (len = 2; len <= variable_name_size; len += sizeof(c)) {
+		c = variable_name[(len / sizeof(c)) - 1];
+		if (!c)
+			break;
+	}
+
+	return min(len, variable_name_size);
+}
+
 static void efivar_update_sysfs_entries(struct work_struct *work)
 {
 	struct efivars *efivars = &__efivars;
@@ -1756,10 +1771,13 @@ static void efivar_update_sysfs_entries(struct work_struct *work)
 		if (!found) {
 			kfree(variable_name);
 			break;
-		} else
+		} else {
+			variable_name_size = var_name_strnsize(variable_name,
+							       variable_name_size);
 			efivar_create_sysfs_entry(efivars,
 						  variable_name_size,
 						  variable_name, &vendor);
+		}
 	}
 }
 
@@ -1958,6 +1976,35 @@ void unregister_efivars(struct efivars *efivars)
 }
 EXPORT_SYMBOL_GPL(unregister_efivars);
 
+/*
+ * Print a warning when duplicate EFI variables are encountered and
+ * disable the sysfs workqueue since the firmware is buggy.
+ */
+static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_guid,
+			     unsigned long len16)
+{
+	size_t i, len8 = len16 / sizeof(efi_char16_t);
+	char *s8;
+
+	/*
+	 * Disable the workqueue since the algorithm it uses for
+	 * detecting new variables won't work with this buggy
+	 * implementation of GetNextVariableName().
+	 */
+	efivar_wq_enabled = false;
+
+	s8 = kzalloc(len8, GFP_KERNEL);
+	if (!s8)
+		return;
+
+	for (i = 0; i < len8; i++)
+		s8[i] = s16[i];
+
+	printk(KERN_WARNING "efivars: duplicate variable: %s-%pUl\n",
+	       s8, vendor_guid);
+	kfree(s8);
+}
+
 int register_efivars(struct efivars *efivars,
 		     const struct efivar_operations *ops,
 		     struct kobject *parent_kobj)
@@ -2006,6 +2053,24 @@ int register_efivars(struct efivars *efivars,
 						&vendor_guid);
 		switch (status) {
 		case EFI_SUCCESS:
+			variable_name_size = var_name_strnsize(variable_name,
+							       variable_name_size);
+
+			/*
+			 * Some firmware implementations return the
+			 * same variable name on multiple calls to
+			 * get_next_variable(). Terminate the loop
+			 * immediately as there is no guarantee that
+			 * we'll ever see a different variable name,
+			 * and may end up looping here forever.
+			 */
+			if (variable_is_present(variable_name, &vendor_guid)) {
+				dup_variable_bug(variable_name, &vendor_guid,
+						 variable_name_size);
+				status = EFI_NOT_FOUND;
+				break;
+			}
+
 			efivar_create_sysfs_entry(efivars,
 						  variable_name_size,
 						  variable_name,
@@ -2025,15 +2090,8 @@ int register_efivars(struct efivars *efivars,
 	if (error)
 		unregister_efivars(efivars);
 
-	efivars->efi_pstore_info = efi_pstore_info;
-
-	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
-	if (efivars->efi_pstore_info.buf) {
-		efivars->efi_pstore_info.bufsize = 1024;
-		efivars->efi_pstore_info.data = efivars;
-		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
-		pstore_register(&efivars->efi_pstore_info);
-	}
+	if (!efivars_pstore_disable)
+		efivar_pstore_register(efivars);
 
 	register_filesystem(&efivarfs_type);
 
