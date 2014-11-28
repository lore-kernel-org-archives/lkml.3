Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaK1PT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:19:29 -0500
Received: from sender1.zohomail.com ([72.5.230.103]:29945 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaK1PT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:19:26 -0500
From: =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, joshc@codeaurora.org,
        johannes.thumshirn@men.de, kheitke@codeaurora.org,
        laurent.pinchart+renesas@ideasonboard.com, geert+renesas@glider.be,
        horms+renesas@verge.net.au, damm@opensource.se, tomi.valkeinen@ti.com,
        mbohan@codeaurora.org, michal.simek@xilinx.com
Cc: pawel.moll@arm.com, Andrew.Thoelke@arm.com, javier@javigon.com
Subject: [RFC PATCH 1/3] Add generic TrustZone driver
Date: Fri, 28 Nov 2014 16:03:34 +0100
Message-Id: <1417187016-7731-2-git-send-email-javier@javigon.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417187016-7731-1-git-send-email-javier@javigon.com>
References: <1417187016-7731-1-git-send-email-javier@javigon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-ZohoMail: Ss  SS_10 UW UB CHF_INT_SMD_EXT  SGR4_1_19114_171
X-ZohoMail-Owner: <1417187016-7731-2-git-send-email-javier@javigon.com>+zmo_0_<javier@javigon.com>
X-ZohoMail-Sender: 130.226.133.124
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Gonzalez <javier@javigon.com>

This commit introduces a generic TrustZone driver to the Linux Kernel. Since
there is no place to add drivers related to secure processors, a new subsystem
for secure hardware in general (drivers/sechw) is also introduced.

Today, TrustZone solutions are implementation specific. In user space, mobile
devices are normally compliant with Global Platform's API
<http://www.globalplatform.org>. However, there is no common TrustZone interface
for kernel space, as it exists for Trusted Computing Module (TPM). As a result,
different TrustZone frameworks use different kernel loadable modules to provide
the context to communicate with the Trusted Execution Environment leveraged by
TrustZone's secure world.

Regarding use cases, TrustZone has traditionally been used for offloading secure
tasks to the secure world. Examples include banking applications, Digital Rights
Management (DRM), or specific secure solutions. As more and more frameworks
enabling TrustZone appear, new use cases are starting to emerge: key management,
encryption, integrity checking, etc. Extreme cases today involve  running a RTOS
in the secure world, or using the secure world to implement usage control
policies governing the normal world. The advent of ARMv8 will only expand this
list.

This commit introduces a generic TrustZone driver for kernel space. The first
design goal is to be flexible enough as to NOT introduce policy regarding the
TrustZone interface. In this way, we introduce a simple session based read/write
interface where several TrustZone drivers can potentially be used. The design is
simple and it consist on an interface that different TrustZone drivers can
implement to communicate with the specific frameworks.

Specific contributions in this patch are:
- TrustZone generic driver:
	- Generic read/write TrustZone interface implemented as pointers to
	functions that are to be implemented by specific TrustZone drivers.
- Secure hardware subsystem:
	- Introduction of a subsystem in drivers/sechw to contain drivers
	concerning secure hardware. TPM is a good candidate.

Signed-off-by: Javier Gonzalez <javier@javigon.com>
---
 drivers/Kconfig                     |   2 +
 drivers/Makefile                    |   2 +
 drivers/sechw/Kconfig               |  11 ++
 drivers/sechw/Makefile              |   5 +
 drivers/sechw/trustzone/Kconfig     |  28 +++
 drivers/sechw/trustzone/Makefile    |   7 +
 drivers/sechw/trustzone/trustzone.c | 349 ++++++++++++++++++++++++++++++++++++
 drivers/sechw/trustzone/trustzone.h |  68 +++++++
 include/linux/trustzone.h           |  95 ++++++++++
 9 files changed, 567 insertions(+)
 create mode 100644 drivers/sechw/Kconfig
 create mode 100644 drivers/sechw/Makefile
 create mode 100644 drivers/sechw/trustzone/Kconfig
 create mode 100644 drivers/sechw/trustzone/Makefile
 create mode 100644 drivers/sechw/trustzone/trustzone.c
 create mode 100644 drivers/sechw/trustzone/trustzone.h
 create mode 100644 include/linux/trustzone.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 0a0a90f..2c447eb 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -174,4 +174,6 @@ source "drivers/powercap/Kconfig"
 
 source "drivers/mcb/Kconfig"
 
+source "drivers/sechw/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 7183b6a..e71ab9c 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -157,3 +157,5 @@ obj-$(CONFIG_NTB)		+= ntb/
 obj-$(CONFIG_FMC)		+= fmc/
 obj-$(CONFIG_POWERCAP)		+= powercap/
 obj-$(CONFIG_MCB)		+= mcb/
+obj-$(CONFIG_SECURE_HARDWARE)	+= sechw/
+
diff --git a/drivers/sechw/Kconfig b/drivers/sechw/Kconfig
new file mode 100644
index 0000000..706ff0f
--- /dev/null
+++ b/drivers/sechw/Kconfig
@@ -0,0 +1,11 @@
+#
+# Secure hardware configuration
+#
+
+menu "Secure Hardware Devices"
+
+#TrustZone
+source "drivers/sechw/trustzone/Kconfig"
+
+endmenu
+
diff --git a/drivers/sechw/Makefile b/drivers/sechw/Makefile
new file mode 100644
index 0000000..b0af25f
--- /dev/null
+++ b/drivers/sechw/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the kernel secure hardware (sechw) drivers.
+#
+
+obj-$(CONFIG_ARM_TRUSTZONE) 		+= trustzone/
diff --git a/drivers/sechw/trustzone/Kconfig b/drivers/sechw/trustzone/Kconfig
new file mode 100644
index 0000000..f9283dd
--- /dev/null
+++ b/drivers/sechw/trustzone/Kconfig
@@ -0,0 +1,28 @@
+#
+# Copyright (C) 2014 Javier González
+#
+# TrustZone device configuration
+#
+
+menuconfig SECURE_HARDWARE
+	tristate "Secure Hardware Support"
+	depends on ARM
+	select SECURITYFS
+	---help---
+	If you have a piece of secure hardware that you want to configure say Yes.
+	To compile this driver as a module choose M here. If unsure say N.
+
+
+if SECURE_HARDWARE
+config ARM_TRUSTZONE
+	tristate "TrustZone Support"
+	# depends on HAS_IOMEM //XXX: We need to look into this
+	# XXX: Can we make it depend on ARM compatible processors?
+	# XXX: We need to look at the dependencies with TIM
+	---help---
+	If you have an ARM processor that is compatible with TrustZone and were
+	the TrustZone security extensions are anabled say Yes to get support
+	from within the Linux kernel. If unsure, say N.
+	# TODO: We need to specify what are the dependencies.
+
+endif # SECURE_HARDWARE
diff --git a/drivers/sechw/trustzone/Makefile b/drivers/sechw/trustzone/Makefile
new file mode 100644
index 0000000..53b6a27
--- /dev/null
+++ b/drivers/sechw/trustzone/Makefile
@@ -0,0 +1,7 @@
+#
+# Copyright (C) 2014 Javier González
+#
+# Makefile for the kernel trustzone device drivers.
+#
+
+obj-$(CONFIG_ARM_TRUSTZONE) += trustzone.o
diff --git a/drivers/sechw/trustzone/trustzone.c b/drivers/sechw/trustzone/trustzone.c
new file mode 100644
index 0000000..c1740d7
--- /dev/null
+++ b/drivers/sechw/trustzone/trustzone.c
@@ -0,0 +1,349 @@
+/*
+ * Copyright (C) 2014 Javier González
+ *
+ * Generic device driver for ARM TrustZone.
+ *
+ * TODO: All checkings
+ * TODO: Revise return values
+ */
+
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+
+#include "trustzone.h"
+
+static LIST_HEAD(trustzone_chip_list);
+static DEFINE_SPINLOCK(driver_lock);
+static DECLARE_BITMAP(dev_mask, TRUSTZONE_NUM_DEVICES);
+
+static struct trustzone_chip *tz_chip_find_get(u32 chip_num)
+{
+	struct trustzone_chip *pos, *chip = NULL;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(pos, &trustzone_chip_list, list) {
+		if (chip_num != TRUSTZONE_ANY_NUM && chip_num != pos->dev_num)
+			continue;
+
+		/* XXX: Look into this: struct platform_driver otz_driver */
+		/* if (try_module_get(pos->dev->driver->owner)) { */
+			chip = pos;
+			break;
+		/* } */
+	}
+	rcu_read_unlock();
+	return chip;
+}
+
+int __tz_open(struct trustzone_chip *chip,
+		struct trustzone_session *session, u8 primitive)
+{
+	int ret = 0;
+
+	ret = chip->tz_ops.open(primitive, session);
+	if (ret) {
+		dev_err(chip->dev, "Open session failed in TrustZone"
+				" chip (id:%d)\n", chip->dev_num);
+		return ret;
+	}
+
+	/* TODO: We need to look into this: struct platform_driver otz_driver
+	 * This problem occurs up too;
+	 * */
+	/* trustzone_chip_put(chip); */
+	return ret;
+}
+
+int __tz_close(struct trustzone_chip *chip,
+		struct trustzone_session *tz_session)
+{
+	int ret = 0;
+
+	ret = chip->tz_ops.close(tz_session);
+	if (ret) {
+		dev_err(chip->dev, "Close session failed in TrustZone chip"
+				" (id:%d)\n", chip->dev_num);
+		return ret;
+	}
+	/* TODO: Look at the trustzone_chip_put(chip) to see if it is
+	 * necessary to take the chip out of a list.
+	 */
+	return ret;
+}
+
+static int __tz_transmit(struct trustzone_chip *chip,
+		struct trustzone_session *session, struct trustzone_cmd *cmd,
+		struct trustzone_parameter_list *params)
+{
+	int ret = 0;
+
+	ret = chip->tz_ops.invoke_command(session, cmd, params);
+	if (ret) {
+		dev_err(chip->dev, "Transmit command failed in TrustZone chip"
+				" (id:%d)\n", chip->dev_num);
+		goto out;
+	}
+	dev_dbg(chip->dev, "Transmit command succeeded\n");
+
+out:
+	return ret;
+}
+
+
+/**
+ * TrustZone Generic Operations
+ */
+
+int tz_open(u32 chip_num, struct trustzone_session *session,
+		u8 primitive)
+{
+	struct trustzone_chip *chip;
+	int ret = 0;
+
+	chip = tz_chip_find_get(chip_num);
+	if (chip == NULL) {
+		dev_err(chip->dev, "Could not find TrustZone chip (id:%d)"
+				" registered\n", chip_num);
+		return -ENODEV;
+	}
+	mutex_lock(&chip->tz_mutex);
+	ret = __tz_open(chip, session, primitive);
+	mutex_unlock(&chip->tz_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tz_open);
+
+int tz_close(u32 chip_num, struct trustzone_session *tz_session)
+{
+	struct trustzone_chip *chip;
+	int ret = 0;
+
+	chip = tz_chip_find_get(chip_num);
+	if (chip == NULL) {
+		dev_err(chip->dev, "Could not find TrustZone chip (id:%d)"
+				" registered\n", chip_num);
+		return -ENODEV;
+	}
+	mutex_lock(&chip->tz_mutex);
+	ret = __tz_close(chip, tz_session);
+	mutex_unlock(&chip->tz_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tz_close);
+
+
+/* XXX: Maybe we should have a general mapping of sessions where each session
+ * has a general ID independently from the chip. This is future work.
+ */
+int tz_transmit(u32 chip_num, struct trustzone_session *session,
+		struct trustzone_cmd *cmd,
+		struct trustzone_parameter_list *params)
+{
+	struct trustzone_chip *chip;
+	int ret = 0;
+
+	chip = tz_chip_find_get(chip_num);
+	if (chip == NULL) {
+		dev_err(chip->dev, "Could not find TrustZone chip (id:%d)"
+				" registered\n", chip_num);
+		ret = -ENODEV;
+		goto out;
+	}
+	mutex_lock(&chip->tz_mutex);
+	ret = __tz_transmit(chip, session, cmd, params);
+	mutex_unlock(&chip->tz_mutex);
+	dev_dbg(chip->dev, "Transmit command succeeded\n");
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tz_transmit);
+
+/*
+ * Perform an operation in the TEE.
+ *
+ * Performing an operation entails opening a TEE session, sending a single task
+ * and closing the TEE session.
+ *
+ * This operation is recommended when sending a single task to the TEE. For
+ * sending a series of tasks is better to explicetly opening and closing a
+ * session, sending the desired tasks to the TEE in the middle
+ */
+int tz_send_operation(u32 chip_num, struct trustzone_session *session,
+		struct trustzone_cmd *cmd,
+		struct trustzone_parameter_list *params)
+{
+	return tz_transmit(chip_num, session, cmd, params);
+}
+
+/**
+  * TODO: Are these operations necessary? We can either maintain a wimple
+  * read/write interface and delegate the behaviour to the commands sent to the
+  * secure world, or provide a richer interface for common operations (e.g.,
+  * allocate shared memory
+  */
+#if 0
+int tz_shared_memory_allocate(void)
+{
+	return 0;
+}
+
+int tz_shared_memory_register(void)
+{
+	return 0;
+}
+
+int tz_shared_memory_free(void)
+{
+	return 0;
+}
+#endif
+
+/*
+ *TODO: Secure system primitives should probably be located in a sepparate file.
+ */
+int tz_monitor_syscall(u32 chip_num, struct trustzone_session *tz_session,
+		unsigned long sig, siginfo_t *sig_info)
+{
+	struct trustzone_cmd cmd;
+	struct trustzone_session my_tz_session;
+	struct trustzone_chip *chip;
+	int ret = 0;
+
+	cmd.cmd = TZ_SYSCALL_MONITOR;
+	chip = tz_chip_find_get(chip_num);
+	if (chip == NULL) {
+		dev_err(chip->dev, "Could not find TrustZone chip (id:%d)"
+				" registered\n", chip_num);
+		return -ENODEV;
+	}
+	mutex_lock(&chip->tz_mutex);
+	ret = __tz_open(chip, &my_tz_session,
+		TZ_SECURE_PRIMITIVE_SVC);
+
+	if (ret) {
+		dev_err(chip->dev, "Open session failed for TZ_SYSCALL_MONITOR");
+		return ret;
+	}
+	ret = __tz_transmit(chip, &my_tz_session, &cmd, NULL);
+
+	if (ret) {
+		dev_err(chip->dev, "Send TZ_SYSCALL_MONITOR to SW failed\n");
+		goto out;
+	}
+	ret = __tz_close(chip, &my_tz_session);
+
+	if (ret) {
+		dev_err(chip->dev, "Close session failed during test\n");
+		return ret;
+	}
+	mutex_unlock(&chip->tz_mutex);
+
+out:
+	return ret;
+}
+
+/*
+ * If the vendor provides a release function, call it too
+ */
+void trustzone_vendor_release(struct trustzone_chip *chip)
+{
+	if (!chip)
+		return;
+
+	if (chip->tz_ops.release)
+		chip->tz_ops.release(chip->dev);
+
+	kfree(chip->tz_ops.miscdev.name);
+}
+
+static void trustzone_dev_release(struct device *dev)
+{
+	/* FIXME: You need to fix all this crap... */
+	/* struct trustzone_chip *chip = dev_get_drvdata(dev); */
+	/* struct trustzone_chip *chip; */
+
+	/* if (!chip) */
+		/* return; */
+
+	/* trustzone_vendor_release(chip); */
+
+	/* chip->release(dev); */
+	/* kfree(chip); */
+}
+EXPORT_SYMBOL_GPL(trustzone_dev_release);
+
+struct trustzone_chip *trustzone_register_hardware(struct device *dev,
+		const struct trustzone_operations *entry)
+{
+	char *devname;
+	struct trustzone_chip *chip;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	devname = kmalloc(TRUSTZONE_NAME_MAX, GFP_KERNEL);
+
+	if (chip == NULL || devname == NULL)
+		goto out_free;
+
+	/* TODO: All mutexes and timers, as they do in the TPM module */
+	mutex_init(&chip->tz_mutex);
+	INIT_LIST_HEAD(&chip->list);
+	memcpy(&chip->tz_ops, entry, sizeof(struct trustzone_operations));
+	chip->dev_num = find_first_zero_bit(dev_mask, TRUSTZONE_NUM_DEVICES);
+
+	if (chip->dev_num >= TRUSTZONE_NUM_DEVICES) {
+		dev_err(dev, "No available trustzone device numbers\n");
+		goto out_free;
+	} else if (chip->dev_num == 0)
+		chip->tz_ops.miscdev.minor = MISC_DYNAMIC_MINOR;
+
+	set_bit(chip->dev_num, dev_mask);
+	scnprintf(devname, TRUSTZONE_NAME_MAX, "%s%d", "tz", chip->dev_num);
+	chip->tz_ops.miscdev.name = devname;
+	chip->tz_ops.miscdev.parent = dev;
+	chip->dev = get_device(dev);
+	chip->release = dev->release;
+	dev->release = trustzone_dev_release;
+	dev_set_drvdata(dev, chip);
+
+	if (misc_register(&chip->tz_ops.miscdev)) {
+		dev_err(chip->dev,
+				"unable to misc_register %s, minor %d\n",
+				chip->tz_ops.miscdev.name,
+				chip->tz_ops.miscdev.minor);
+		goto put_device;
+	}
+	/* TODO: Add sysfs interface
+	 * TODO: Add debugfs interface
+	if (sysfs_create_group(&dev->kobj, chip->tz_ops.attr_group)) {
+		misc_deregister(&chip->tz_ops.miscdev);
+		goto put_device;
+	}
+	*/
+
+	/* Make chip available */
+	spin_lock(&driver_lock);
+	list_add_rcu(&chip->list, &trustzone_chip_list);
+	spin_unlock(&driver_lock);
+
+	return chip;
+
+put_device:
+	put_device(chip->dev);
+out_free:
+	if (chip != NULL)
+		kfree(chip);
+	if (devname != NULL)
+		kfree(devname);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(trustzone_register_hardware);
+
+MODULE_AUTHOR("Javier González (jgon@itu.dk)");
+MODULE_DESCRIPTION("TrustZone Generic Driver");
+MODULE_VERSION("1.0");
+MODULE_LICENSE("GPL");
diff --git a/drivers/sechw/trustzone/trustzone.h b/drivers/sechw/trustzone/trustzone.h
new file mode 100644
index 0000000..6bf6989
--- /dev/null
+++ b/drivers/sechw/trustzone/trustzone.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2014 Javier González
+ *
+ * Device driver for ARM TrustZone.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/trustzone.h>
+
+/* Maximun number of letter for a TrustZone device name string */
+#define TRUSTZONE_NAME_MAX	10
+
+enum tpm_const {
+	/* TRUSTZONE_MINOR = X, */
+	TRUSTZONE_NUM_DEVICES = 256,
+};
+
+/**
+ * Enums used for secure system primitives
+ */
+enum tz_secure_system_primitives {
+	TZ_SYSCALL_MONITOR = 0x0,
+};
+
+struct trustzone_operations {
+	char name[TRUSTZONE_NAME_MAX + 1];
+	struct miscdevice miscdev;
+	struct attribute_group *attr_group;
+	struct list_head list;
+
+	int (*open) (int, struct trustzone_session *);
+	int (*close) (struct trustzone_session *);
+	int (*invoke_command) (struct trustzone_session *,
+		struct trustzone_cmd *, struct trustzone_parameter_list *);
+	int (*install_task) (void);
+	int (*delete_task) (void);
+	int (*install_primitive) (void);
+	int (*delete_primitive) (void);
+	int (*memory_allocate) (void);
+	int (*memory_register) (void);
+	int (*memory_free) (void);
+	void (*release) (struct device *);
+};
+
+struct trustzone_chip {
+	struct device *dev;
+	int dev_num;	/* /dev/trustzone# */
+
+	/* Data transmitted from/to trustzone's secure world */
+	u8 *data_buffer;
+	u16 buffer_size;
+	atomic_t data_pending;
+	struct mutex tz_mutex;
+	struct trustzone_operations tz_ops;
+	struct list_head list;
+	void (*release) (struct device *);
+};
+
+static inline void trustzone_chip_put(struct trustzone_chip *chip)
+{
+	module_put(chip->dev->driver->owner);
+}
+
+extern struct trustzone_chip *trustzone_register_hardware(struct device *dev,
+		const struct trustzone_operations *entry);
diff --git a/include/linux/trustzone.h b/include/linux/trustzone.h
new file mode 100644
index 0000000..db2a6f2
--- /dev/null
+++ b/include/linux/trustzone.h
@@ -0,0 +1,95 @@
+/*
+ * Author:
+ * Javier Gonzalez <jgon@itu.dk>
+ *
+ * Device driver for ARM TrustZone.
+ *
+ * TODO: Copyright
+ * TODO: Implement hooks to delegate functions to specific TrustZone
+ * implementations.
+ */
+
+#ifndef __LINUX_TRUSTZONE_H__
+#define __LINUX_TRUSTZONE_H__
+
+#include <asm/siginfo.h>
+
+//TODO: We need to check if any TrustZone implementation is actually loaded. It
+//is important to check wheather we can do this dynamically with LKMs or not. It
+//this is possible, we can keep Sierraware's implementation as a LKM - as they
+//originally designed it - and let other implementations be coded in a different
+//fashion. This might not make sense in a real depolyment since only one
+//TrustZone implementation should be used (or not?).
+
+/*
+ * Chip num is the value of a trustzone id.
+ * This is the default
+ */
+#define TRUSTZONE_ANY_NUM 0xFFFF
+
+enum tz_param_type {
+	TZ_UINT8 = 0,
+	TZ_UINT32,
+	TZ_GENERIC
+};
+
+//TODO: Implement INOUT
+enum tz_param_purpose {
+	TZ_PARAM_IN = 0x0,
+	TZ_PARAM_OUT,
+	TZ_PARAM_INOUT
+};
+
+enum tz_services {
+	TZ_SECURE_PRIMITIVE_SVC = 0x0
+};
+
+struct trustzone_parameter {
+	uint8_t type; 
+	uint8_t inout;
+	void *value;
+	uint32_t size;
+	struct trustzone_parameter *nxt;
+};
+
+struct trustzone_parameter_list {
+	struct trustzone_parameter *params;
+	uint8_t n_params;
+};
+
+//XXX: Maybe we introduce a flag marking if the command was executed or not...
+struct trustzone_cmd {
+	int cmd;
+};
+
+struct trustzone_session{
+	void *impl_session;
+};
+
+/*
+ * Hooks to Secure System Primitives
+ */
+extern int tz_monitor_syscall(u32, struct trustzone_session*, unsigned long,
+		siginfo_t*);
+
+/*
+ * TrustZone Generic Operations
+ */
+extern int tz_open(u32, struct trustzone_session*, u8);
+extern int tz_close(u32, struct trustzone_session*);
+extern int tz_transmit(u32, struct trustzone_session*, struct trustzone_cmd*,
+		struct trustzone_parameter_list*);
+extern int tz_send_operation(u32, struct trustzone_session*, struct
+		trustzone_cmd*, struct trustzone_parameter_list*);
+
+//TODO: This should be under a DEBUG ifdef
+extern int tz_send_test_operation(u32, u8);
+
+//TODO: This should be under a debug flag
+enum trustzone_test_implementations {
+	TZ_OPEN_VIRTUALIZATION = 0,
+	TZ_SAFEG,
+	TZ_GENODE
+};
+
+#endif
-- 
1.9.1


