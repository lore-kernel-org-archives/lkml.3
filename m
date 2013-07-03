Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab3GCMtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:49:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174Ab3GCMsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:48:43 -0400
From: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net, trenn@suse.de,
        Arjan van de Ven <arjan@linux.intel.com>, hpa@zytor.com
Subject: [PATCH 1/3] x86 microcode: Remove old MICROCODE_OLD_INTERFACE
Date: Wed,  3 Jul 2013 14:48:37 +0200
Message-Id: <1372855719-34315-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1372855719-34315-1-git-send-email-trenn@suse.de>
References: <1372855719-34315-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLE11 nowadays makes use of the new interface without doing any modifications
to the kernel in this area. That means the old interface is not needed at
least since 3.0 or longer.

Time to get rid of it.


CC: Arjan van de Ven <arjan@linux.intel.com>
CC: hpa@zytor.com
Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/Kconfig                 |    4 --
 arch/x86/kernel/microcode_core.c |  103 --------------------------------------
 2 files changed, 0 insertions(+), 107 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fe120da..01dae97 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1049,10 +1049,6 @@ config MICROCODE_AMD
 	  If you select this option, microcode patch loading support for AMD
 	  processors will be enabled.
 
-config MICROCODE_OLD_INTERFACE
-	def_bool y
-	depends on MICROCODE
-
 config MICROCODE_INTEL_LIB
 	def_bool y
 	depends on MICROCODE_INTEL
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 22db92b..6a9fd04 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -180,99 +180,6 @@ static int apply_microcode_on_target(int cpu)
 	return ret;
 }
 
-#ifdef CONFIG_MICROCODE_OLD_INTERFACE
-static int do_microcode_update(const void __user *buf, size_t size)
-{
-	int error = 0;
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-		enum ucode_state ustate;
-
-		if (!uci->valid)
-			continue;
-
-		ustate = microcode_ops->request_microcode_user(cpu, buf, size);
-		if (ustate == UCODE_ERROR) {
-			error = -1;
-			break;
-		} else if (ustate == UCODE_OK)
-			apply_microcode_on_target(cpu);
-	}
-
-	return error;
-}
-
-static int microcode_open(struct inode *inode, struct file *file)
-{
-	return capable(CAP_SYS_RAWIO) ? nonseekable_open(inode, file) : -EPERM;
-}
-
-static ssize_t microcode_write(struct file *file, const char __user *buf,
-			       size_t len, loff_t *ppos)
-{
-	ssize_t ret = -EINVAL;
-
-	if ((len >> PAGE_SHIFT) > totalram_pages) {
-		pr_err("too much data (max %ld pages)\n", totalram_pages);
-		return ret;
-	}
-
-	get_online_cpus();
-	mutex_lock(&microcode_mutex);
-
-	if (do_microcode_update(buf, len) == 0)
-		ret = (ssize_t)len;
-
-	if (ret > 0)
-		perf_check_microcode();
-
-	mutex_unlock(&microcode_mutex);
-	put_online_cpus();
-
-	return ret;
-}
-
-static const struct file_operations microcode_fops = {
-	.owner			= THIS_MODULE,
-	.write			= microcode_write,
-	.open			= microcode_open,
-	.llseek		= no_llseek,
-};
-
-static struct miscdevice microcode_dev = {
-	.minor			= MICROCODE_MINOR,
-	.name			= "microcode",
-	.nodename		= "cpu/microcode",
-	.fops			= &microcode_fops,
-};
-
-static int __init microcode_dev_init(void)
-{
-	int error;
-
-	error = misc_register(&microcode_dev);
-	if (error) {
-		pr_err("can't misc_register on minor=%d\n", MICROCODE_MINOR);
-		return error;
-	}
-
-	return 0;
-}
-
-static void __exit microcode_dev_exit(void)
-{
-	misc_deregister(&microcode_dev);
-}
-
-MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
-MODULE_ALIAS("devname:cpu/microcode");
-#else
-#define microcode_dev_init()	0
-#define microcode_dev_exit()	do { } while (0)
-#endif
-
 /* fake device for request_firmware */
 static struct platform_device	*microcode_pdev;
 
@@ -581,10 +488,6 @@ static int __init microcode_init(void)
 		goto out_driver;
 	}
 
-	error = microcode_dev_init();
-	if (error)
-		goto out_ucode_group;
-
 	register_syscore_ops(&mc_syscore_ops);
 	register_hotcpu_notifier(&mc_cpu_notifier);
 
@@ -593,10 +496,6 @@ static int __init microcode_init(void)
 
 	return 0;
 
- out_ucode_group:
-	sysfs_remove_group(&cpu_subsys.dev_root->kobj,
-			   &cpu_root_microcode_group);
-
  out_driver:
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
@@ -617,8 +516,6 @@ static void __exit microcode_exit(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
 
-	microcode_dev_exit();
-
 	unregister_hotcpu_notifier(&mc_cpu_notifier);
 	unregister_syscore_ops(&mc_syscore_ops);
 
-- 
1.7.6.1

