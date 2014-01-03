Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaACA5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:57:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:25390 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbaACA5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:57:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,594,1384329600"; 
   d="scan'208";a="453003860"
From: eric.ernst@linux.intel.com
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Gabriel Touzeau <gabrielx.touzeau@intel.com>,
        Eric Ernst <eric.ernst@linux.intel.com>,
        Yann Puech <yann.puech@intel.com>,
        Jeremy Compostella <jeremy.compostella@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 1/1] watchdog: Adding Merrifield watchdog driver support
Date: Thu,  2 Jan 2014 16:56:42 -0800
Message-Id: <1388710602-18513-1-git-send-email-eric.ernst@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Touzeau <gabrielx.touzeau@intel.com>

Added Merrifield watchdog driver support.

Based on initial implementation from prior Intel SCU-based platforms, this
driver has several changes specific to the Tangier SoC / Merrifield platform.

Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>
Signed-off-by: Yann Puech <yann.puech@intel.com>
Signed-off-by: Jeremy Compostella <jeremy.compostella@intel.com>
Signed-off-by: Gabriel Touzeau <gabrielx.touzeau@intel.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/watchdog/Kconfig                  |   12 +
 drivers/watchdog/Makefile                 |    1 +
 drivers/watchdog/intel_scu_watchdog_evo.c |  587 +++++++++++++++++++++++++++++
 drivers/watchdog/intel_scu_watchdog_evo.h |   54 +++
 4 files changed, 654 insertions(+)
 create mode 100644 drivers/watchdog/intel_scu_watchdog_evo.c
 create mode 100644 drivers/watchdog/intel_scu_watchdog_evo.h

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index d1d53f301de7..bb3ef92d2788 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -616,6 +616,18 @@ config INTEL_SCU_WATCHDOG
 
 	  To compile this driver as a module, choose M here.
 
+config INTEL_SCU_WATCHDOG_EVO
+	bool "Intel SCU Watchdog Evolution for Mobile Platforms"
+	depends on X86_INTEL_MID
+	---help---
+	  Hardware driver evolution for the watchdog timer built into the Intel
+	  SCU for Intel Mobile Platforms.
+
+	  This driver supports the watchdog evolution implementation in SCU,
+	  available for Merrifield generation.
+
+	  To compile this driver as a module, choose M here.
+
 config ITCO_WDT
 	tristate "Intel TCO Timer/Watchdog"
 	depends on (X86 || IA64) && PCI
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 6c5bb274d3cd..e4b150efa938 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -112,6 +112,7 @@ obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
 obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 obj-$(CONFIG_INTEL_SCU_WATCHDOG) += intel_scu_watchdog.o
+obj-$(CONFIG_INTEL_SCU_WATCHDOG_EVO) += intel_scu_watchdog_evo.o
 
 # M32R Architecture
 
diff --git a/drivers/watchdog/intel_scu_watchdog_evo.c b/drivers/watchdog/intel_scu_watchdog_evo.c
new file mode 100644
index 000000000000..fc9a37a33ddd
--- /dev/null
+++ b/drivers/watchdog/intel_scu_watchdog_evo.c
@@ -0,0 +1,587 @@
+/*
+ *      intel_scu_watchdog_evo:  An Intel SCU IOH Based Watchdog Device
+ *			for Tangier SoC (Merrifield platform)
+ *
+ *      Based on previous intel_scu based watchdog driver, intel_scu_watchdog.
+ *
+ *      Copyright (C) 2009-2013 Intel Corporation. All rights reserved.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/nmi.h>
+#include <linux/reboot.h>
+#include <linux/fs.h>
+#include <linux/watchdog.h>
+#include <asm/intel-mid.h>
+#include <asm/intel_scu_ipc.h>
+
+#include "intel_scu_watchdog_evo.h"
+
+/* Defines */
+#define STRING_RESET_TYPE_MAX_LEN   11
+#define STRING_COLD_OFF             "COLD_OFF"
+#define STRING_COLD_RESET           "COLD_RESET"
+#define STRING_COLD_BOOT            "COLD_BOOT"
+
+#define EXT_TIMER0_MSI 15
+
+#define IPC_WATCHDOG 0xf8
+
+/* watchdog message options */
+enum {
+	SCU_WATCHDOG_START = 0,
+	SCU_WATCHDOG_STOP,
+	SCU_WATCHDOG_KEEPALIVE,
+	SCU_WATCHDOG_SET_ACTION_ON_TIMEOUT
+};
+
+/* watchdog reset options */
+enum {
+	SCU_COLD_OFF_ON_TIMEOUT = 0,
+	SCU_COLD_RESET_ON_TIMEOUT,
+	SCU_COLD_BOOT_ON_TIMEOUT,
+	SCU_DO_NOTHING_ON_TIMEOUT
+};
+
+/* Statics */
+static struct intel_scu_watchdog_dev watchdog_device;
+
+/* Module params */
+static bool disable_kernel_watchdog;
+module_param(disable_kernel_watchdog, bool, S_IRUGO);
+MODULE_PARM_DESC(disable_kernel_watchdog,
+		"Disable kernel watchdog"
+		"Set to 0, watchdog started at boot"
+		"and left running; Set to 1; watchdog"
+		"is not started until user space"
+		"watchdog daemon is started; also if the"
+		"timer is started by the iafw firmware, it"
+		"will be disabled upon initialization of this"
+		"driver if disable_kernel_watchdog is set");
+
+static int pre_timeout = DEFAULT_PRETIMEOUT;
+module_param(pre_timeout, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(pre_timeout,
+		"Watchdog pre timeout"
+		"Time between interrupt and resetting the system"
+		"The range is from 1 to 160");
+
+static int timeout = DEFAULT_TIMEOUT;
+module_param(timeout, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(timeout,
+		"Default Watchdog timer setting"
+		"Complete cycle time"
+		"The range is from 1 to 170"
+		"This is the time for all keep alives to arrive");
+
+/* Setting reset_on_release will cause an immediate reset when the watchdog
+ * is released. If false, the watchdog timer is refreshed for one more
+ * interval. At the end of that interval, the watchdog timer will reset the
+ * system.
+ */
+static bool reset_on_release = true;
+
+/* Check current timeouts */
+static int check_timeouts(int pre_timeout_time, int timeout_time)
+{
+	if (pre_timeout_time < timeout_time)
+		return 0;
+
+	return -EINVAL;
+}
+
+/* Set the different timeouts needed by the SCU FW and start the
+ * kernel watchdog */
+static int watchdog_set_timeouts_and_start(int pretimeout,
+					   int timeout)
+{
+	int ret, input_size;
+	struct ipc_wd_start {
+		u32 pretimeout;
+		u32 timeout;
+	} ipc_wd_start = { pretimeout, timeout };
+
+	/* SCU expects the input size for watchdog IPC to
+	 * be based on double-word */
+	input_size = (sizeof(ipc_wd_start) + 3) / 4;
+
+	ret = intel_scu_ipc_command(IPC_WATCHDOG,
+				    SCU_WATCHDOG_START, (u32 *)&ipc_wd_start,
+				    input_size, NULL, 0);
+	if (ret) {
+		pr_crit("Error configuring and starting watchdog: %d\n",
+			ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/* Provisioning function for future enhancement : allow to fine tune timing
+   according to watchdog action settings */
+static int watchdog_set_appropriate_timeouts(void)
+{
+	pr_debug("Setting shutdown timeouts\n");
+	return watchdog_set_timeouts_and_start(pre_timeout, timeout);
+}
+
+/* Keep alive  */
+static int watchdog_keepalive(void)
+{
+	int ret;
+
+	/* Pet the watchdog */
+	ret = intel_scu_ipc_command(IPC_WATCHDOG,
+					SCU_WATCHDOG_KEEPALIVE, NULL, 0, NULL, 0);
+	if (ret) {
+		pr_crit("Error executing keepalive: %x\n", ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/* stops the timer */
+static int watchdog_stop(void)
+{
+	int ret;
+
+	watchdog_device.started = false;
+
+	ret = intel_scu_ipc_command(IPC_WATCHDOG,
+					SCU_WATCHDOG_STOP, NULL, 0, NULL, 0);
+	if (ret) {
+		pr_crit("Error stopping watchdog: %x\n", ret);
+		return -EIO;
+	}
+	return 0;
+}
+
+/* warning interrupt handler */
+static irqreturn_t watchdog_warning_interrupt(int irq, void *dev_id)
+{
+	pr_warn("[SHTDWN] %s, WATCHDOG TIMEOUT!\n", __func__);
+
+	/* Let's reset the platform after dumping some data */
+	trigger_all_cpu_backtrace();
+	panic("Kernel Watchdog");
+
+	/* This code should not be reached */
+	return IRQ_HANDLED;
+}
+
+/* Program and starts the timer */
+static int watchdog_config_and_start(u32 newtimeout, u32 newpretimeout)
+{
+	int ret;
+
+	timeout = newtimeout;
+	pre_timeout = newpretimeout;
+
+	pr_info("timeout=%ds, pre_timeout=%ds\n", timeout, pre_timeout);
+
+	/* Configure the watchdog */
+	ret = watchdog_set_timeouts_and_start(pre_timeout, timeout);
+	if (ret) {
+		pr_err("%s: Cannot configure the watchdog\n", __func__);
+
+		/* Make sure the watchdog timer is stopped */
+		watchdog_stop();
+		return ret;
+	}
+
+	watchdog_device.started = true;
+
+	return 0;
+}
+
+/* Open */
+static int intel_scu_open(struct inode *inode, struct file *file)
+{
+	/* Set flag to indicate that watchdog device is open */
+	if (test_and_set_bit(0, &watchdog_device.driver_open)) {
+		pr_err("watchdog device is busy\n");
+		return -EBUSY;
+	}
+
+	return nonseekable_open(inode, file);
+}
+
+/* Release */
+static int intel_scu_release(struct inode *inode, struct file *file)
+{
+	/*
+	 * This watchdog should not be closed after the timer
+	 * is started with the WDIPC_SETTIMEOUT ioctl.
+	 * If reset_on_release is set this  will cause an
+	 * immediate reset. If reset_on_release is not set, the watchdog
+	 * timer is refreshed for one more interval. At the end
+	 * of that interval, the watchdog timer will reset the system.
+	 */
+
+	if (!test_bit(0, &watchdog_device.driver_open)) {
+		pr_err("intel_scu_release, without open\n");
+		return -ENOTTY;
+	}
+
+	if (!watchdog_device.started) {
+		/* Just close, since timer has not been started */
+		pr_err("Closed, without starting timer\n");
+		return 0;
+	}
+
+	/* The watchdog should not be closed after the timer is started */
+	pr_crit("Unexpected close of /dev/watchdog!\n");
+
+	/* Refresh the timer for one more interval */
+	watchdog_keepalive();
+
+	/* Reboot system if requested */
+	if (reset_on_release) {
+		pr_crit("Initiating system reboot.\n");
+		emergency_restart();
+	}
+
+	pr_crit("Immediate Reboot Disabled\n");
+	pr_crit("System will reset when watchdog timer expire!\n");
+
+	return 0;
+}
+
+/* Write */
+static ssize_t intel_scu_write(struct file *file, char const *data, size_t len,
+			      loff_t *ppos)
+{
+	if (watchdog_device.shutdown_flag == true)
+		/* do nothing if we are shutting down */
+		return len;
+
+	if (watchdog_device.started) {
+		/* Watchdog already started, keep it alive */
+		watchdog_keepalive();
+	}
+
+	return len;
+}
+
+/* ioctl */
+static long intel_scu_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	u32 __user *p = argp;
+	u32 val;
+	int options;
+
+	static const struct watchdog_info ident = {
+		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+		/* @todo Get from SCU via ipc_get_scu_fw_version */
+		.firmware_version = 0,
+		/* len < 32 */
+		.identity = "Intel_SCU IOH Watchdog"
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident,
+				    sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		if (!watchdog_device.started)
+			return -EINVAL;
+
+		watchdog_keepalive();
+		return 0;
+	case WDIOC_SETPRETIMEOUT:
+		pr_info("%s: setpretimeout ioctl\n", __func__);
+
+		if (watchdog_device.started)
+			return -EBUSY;
+
+		/* Timeout to warn */
+		if (get_user(val, p))
+			return -EFAULT;
+
+		pre_timeout = val;
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		pr_info("%s: settimeout ioctl\n", __func__);
+
+		if (watchdog_device.started)
+			return -EBUSY;
+
+		if (get_user(val, p))
+			return -EFAULT;
+
+		timeout = val;
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	case WDIOC_SETOPTIONS:
+		if (get_user(options, p))
+			return -EFAULT;
+
+		if (options & WDIOS_DISABLECARD) {
+			pr_info("%s: Stopping the watchdog\n", __func__);
+			watchdog_stop();
+			return 0;
+		}
+
+		if (options & WDIOS_ENABLECARD) {
+			pr_info("%s: Starting the watchdog\n", __func__);
+
+			if (watchdog_device.started)
+				return -EBUSY;
+
+			if (check_timeouts(pre_timeout, timeout)) {
+				pr_warn("%s: Invalid thresholds\n",
+					__func__);
+				return -EINVAL;
+			}
+			if (watchdog_config_and_start(timeout, pre_timeout))
+				return -EINVAL;
+			return 0;
+		}
+		return 0;
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int watchdog_set_reset_type(int reset_type)
+{
+	int ret, input_size;
+	u32 ipc_wd_on_timeout = reset_type;
+
+	/* SCU expects the input size for watchdog IPC to
+	 * be based on double-word */
+	input_size = (sizeof(ipc_wd_on_timeout) + 3) / 4;
+
+	ret = intel_scu_ipc_command(IPC_WATCHDOG,
+				    SCU_WATCHDOG_SET_ACTION_ON_TIMEOUT,
+				    (u32 *)&ipc_wd_on_timeout,
+				    input_size, NULL, 0);
+	if (ret) {
+		pr_crit("Error setting watchdog action: %d\n", ret);
+		return -EIO;
+	}
+
+	watchdog_device.normal_wd_action = reset_type;
+
+	return 0;
+}
+
+/* Reboot notifier */
+static int reboot_notifier(struct notifier_block *this,
+			   unsigned long code,
+			   void *another_unused)
+{
+	int ret;
+
+	if (code == SYS_RESTART || code == SYS_HALT || code == SYS_POWER_OFF) {
+		pr_warn("Reboot notifier\n");
+
+		if (watchdog_set_appropriate_timeouts())
+			pr_crit("reboot notifier can't set time\n");
+
+		switch (code) {
+		case SYS_RESTART:
+			ret = watchdog_set_reset_type(
+				watchdog_device.reboot_wd_action);
+			break;
+
+		case SYS_HALT:
+		case SYS_POWER_OFF:
+			ret = watchdog_set_reset_type(
+				watchdog_device.shutdown_wd_action);
+			break;
+		}
+		if (ret)
+			pr_err("%s: could not set reset type\n", __func__);
+
+		/* Don't do instant reset on close */
+		reset_on_release = false;
+
+		/* Kick once again */
+		if (disable_kernel_watchdog == false) {
+			ret = watchdog_keepalive();
+			if (ret)
+				pr_warn("%s: no keep alive\n", __func__);
+
+			/* Don't allow any more keep-alives */
+			watchdog_device.shutdown_flag = true;
+		}
+	}
+	return NOTIFY_DONE;
+}
+
+
+/* Kernel Interfaces */
+static const struct file_operations intel_scu_fops = {
+	.owner          = THIS_MODULE,
+	.llseek         = no_llseek,
+	.write          = intel_scu_write,
+	.unlocked_ioctl = intel_scu_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= intel_scu_ioctl,
+#endif
+	.open           = intel_scu_open,
+	.release        = intel_scu_release,
+};
+
+static int handle_mrfl_dev_ioapic(int irq)
+{
+	int ioapic;
+	struct io_apic_irq_attr irq_attr;
+
+	ioapic = mp_find_ioapic(irq);
+	if (ioapic >= 0) {
+		irq_attr.ioapic = ioapic;
+		irq_attr.ioapic_pin = irq;
+		irq_attr.trigger = 1;
+		irq_attr.polarity = 0; /* Active high */
+		io_apic_set_pci_routing(NULL, irq, &irq_attr);
+	} else {
+		pr_err("cannot find interrupt %d in ioapic\n", irq);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Init code */
+static int __init intel_scu_watchdog_init(void)
+{
+	int ret = 0;
+
+	/*
+	 *  This is only valid for Merrifield based platforms
+	 */
+	if (intel_mid_identify_cpu() != INTEL_MID_CPU_CHIP_TANGIER)
+		return -ENODEV;
+
+	watchdog_device.normal_wd_action   = SCU_COLD_RESET_ON_TIMEOUT;
+	watchdog_device.reboot_wd_action   = SCU_COLD_RESET_ON_TIMEOUT;
+	watchdog_device.shutdown_wd_action = SCU_COLD_OFF_ON_TIMEOUT;
+
+	/* Initially, we are not in shutdown mode */
+	watchdog_device.shutdown_flag = false;
+
+	/* Check timeouts boot parameter */
+	if (check_timeouts(pre_timeout, timeout)) {
+		pr_err("%s: Invalid timeouts\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Reboot notifier */
+	watchdog_device.reboot_notifier.notifier_call = reboot_notifier;
+	watchdog_device.reboot_notifier.priority = 1;
+	ret = register_reboot_notifier(&watchdog_device.reboot_notifier);
+	if (ret) {
+		pr_crit("cannot register reboot notifier %d\n", ret);
+		goto error_stop_timer;
+	}
+
+	/* Do not publish the watchdog device when disabled */
+	if (!disable_kernel_watchdog) {
+		watchdog_device.miscdev.minor = WATCHDOG_MINOR;
+		watchdog_device.miscdev.name = "watchdog";
+		watchdog_device.miscdev.fops = &intel_scu_fops;
+
+		ret = misc_register(&watchdog_device.miscdev);
+		if (ret) {
+			pr_crit("Cannot register miscdev %d err =%d\n",
+				WATCHDOG_MINOR, ret);
+			goto error_reboot_notifier;
+		}
+	}
+
+	/* MSI #15 handler to dump registers */
+	handle_mrfl_dev_ioapic(EXT_TIMER0_MSI);
+	ret = request_irq((unsigned int)EXT_TIMER0_MSI,
+		watchdog_warning_interrupt,
+		IRQF_SHARED|IRQF_NO_SUSPEND, "watchdog",
+		&watchdog_device);
+	if (ret) {
+		pr_err("error requesting warning irq %d\n",
+		       EXT_TIMER0_MSI);
+		pr_err("error value returned is %d\n", ret);
+		goto error_misc_register;
+	}
+
+	if (disable_kernel_watchdog) {
+		pr_info("%s: Disable kernel watchdog\n", __func__);
+
+		/* Make sure timer is stopped */
+		ret = watchdog_stop();
+		if (ret != 0)
+			pr_warn("can't disable timer\n");
+	}
+
+
+	watchdog_device.started = false;
+
+	return ret;
+
+error_misc_register:
+	misc_deregister(&watchdog_device.miscdev);
+
+error_reboot_notifier:
+	unregister_reboot_notifier(&watchdog_device.reboot_notifier);
+
+error_stop_timer:
+	watchdog_stop();
+
+	return ret;
+}
+
+static void __exit intel_scu_watchdog_exit(void)
+{
+	int ret = 0;
+
+	ret = watchdog_stop();
+	if (ret != 0)
+		pr_err("cant disable timer\n");
+
+	misc_deregister(&watchdog_device.miscdev);
+	unregister_reboot_notifier(&watchdog_device.reboot_notifier);
+}
+
+#ifdef MODULE
+module_init(intel_scu_watchdog_init);
+#else
+rootfs_initcall(intel_scu_watchdog_init);
+#endif
+module_exit(intel_scu_watchdog_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_AUTHOR("Gabriel Touzeau <gabrielx.touzeau@intel.com>");
+MODULE_AUTHOR("Jeremy Compostella <jeremy.compostella@intel.com");
+MODULE_AUTHOR("Eric Ernst <eric.ernst@linux.intel.com>");
+MODULE_DESCRIPTION("Intel SCU Watchdog Device Driver for Merrifield platform");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_VERSION(WDT_VER);
diff --git a/drivers/watchdog/intel_scu_watchdog_evo.h b/drivers/watchdog/intel_scu_watchdog_evo.h
new file mode 100644
index 000000000000..d53c568f65a5
--- /dev/null
+++ b/drivers/watchdog/intel_scu_watchdog_evo.h
@@ -0,0 +1,54 @@
+/*
+ *      Intel_SCU 0.3:  An Intel SCU IOH Based Watchdog Device
+ *			for Intel's Tangier SoC / Merrifield platform
+ *
+ *      Copyright (C) 2009-2013 Intel Corporation. All rights reserved.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ *
+ */
+
+#ifndef __INTEL_SCU_WATCHDOG_H
+#define __INTEL_SCU_WATCHDOG_H
+
+#include <linux/miscdevice.h>
+#include <linux/types.h>
+#include <linux/notifier.h>
+
+#ifdef CONFIG_COMPAT
+#include <linux/compat.h>
+#endif
+
+#define PFX "intel_scu_watchdog: "
+#define WDT_VER "0.3"
+
+#define DEFAULT_PRETIMEOUT 75
+#define DEFAULT_TIMEOUT 90
+
+struct intel_scu_watchdog_dev {
+	ulong driver_open;
+	ulong driver_closed;
+	bool started;
+	struct notifier_block reboot_notifier;
+	struct miscdevice miscdev;
+	bool shutdown_flag;
+	int reset_type;
+	int normal_wd_action;
+	int reboot_wd_action;
+	int shutdown_wd_action;
+};
+
+#endif /* __INTEL_SCU_WATCHDOG_H */
-- 
1.7.9.5

