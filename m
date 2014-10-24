Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbaJXGQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:16:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:14197 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbaJXGQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:16:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,778,1406617200"; 
   d="scan'208";a="619636788"
From: Kweh Hock Leong <hock.leong.kweh@intel.com>
To: Matt Fleming <matt.fleming@intel.com>, Ming Lei <ming.lei@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>
Subject: [PATCH v1 3/3] efi: Capsule update with user helper interface
Date: Fri, 24 Oct 2014 14:18:22 +0800
Message-Id: <1414131502-13886-4-git-send-email-hock.leong.kweh@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
References: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>

Introducing a kernel module to expose user helper interface for
user to upload capsule binaries. This module leverage the
request_firmware_nowait() to expose an interface to user.

Example steps to load the capsule binary:
1.) echo 1 > /sys/class/firmware/efi-capsule-file/loading
2.) cat capsule.bin > /sys/class/firmware/efi-capsule-file/data
3.) echo 0 > /sys/class/firmware/efi-capsule-file/loading

Whereas, this module does not allow the capsule binaries to be
obtained from the request_firmware library search path. If any
capsule binary loaded from firmware seach path, the module will
stop functioning.

Besides the request_firmware user helper interface, this module
also expose a 'capsule_loaded' file note for user to verify
the number of successfully uploaded capsule binaries. This
file note has the read only attribute.

Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
---
 drivers/firmware/efi/Kconfig                   |   13 ++
 drivers/firmware/efi/Makefile                  |    1 +
 drivers/firmware/efi/efi-capsule-user-helper.c |  246 ++++++++++++++++++++++++
 3 files changed, 260 insertions(+)
 create mode 100644 drivers/firmware/efi/efi-capsule-user-helper.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index f712d47..7dc814e 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -60,6 +60,19 @@ config EFI_RUNTIME_WRAPPERS
 config EFI_ARMSTUB
 	bool
 
+config EFI_CAPSULE_USER_HELPER
+	tristate "EFI capsule user mode helper"
+	depends on EFI
+	select FW_LOADER
+	select FW_LOADER_USER_HELPER
+	help
+	  This option exposes the user mode helper interface for user to load
+	  EFI capsule binary and update the EFI firmware after system reboot.
+	  This feature does not support auto locating capsule binaries at the
+	  firmware lib search path.
+
+	  If unsure, say N.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 698846e..63f6910 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
 obj-$(CONFIG_EFI_STUB)			+= libstub/
+obj-$(CONFIG_EFI_CAPSULE_USER_HELPER)	+= efi-capsule-user-helper.o
diff --git a/drivers/firmware/efi/efi-capsule-user-helper.c b/drivers/firmware/efi/efi-capsule-user-helper.c
new file mode 100644
index 0000000..84a1628
--- /dev/null
+++ b/drivers/firmware/efi/efi-capsule-user-helper.c
@@ -0,0 +1,246 @@
+/*
+ * EFI capsule user mode helper interface driver.
+ *
+ * Copyright 2014 Intel Corporation
+ *
+ * This file is part of the Linux kernel, and is made available under
+ * the terms of the GNU General Public License version 2.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/highmem.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/reboot.h>
+#include <linux/efi.h>
+#include <linux/firmware.h>
+
+#define CAPSULE_NAME "efi-capsule-file"
+#define DEV_NAME "efi_capsule_user_helper"
+#define STRING_INTEGER_MAX_LENGTH 13
+
+static DEFINE_MUTEX(user_helper_lock);
+static int capsule_count;
+static int stop_request;
+static struct platform_device *efi_capsule_pdev;
+
+/*
+ * This function will store the capsule binary and pass it to
+ * efi_capsule_update() API in capsule.c
+ */
+static int efi_capsule_store(const struct firmware *fw)
+{
+	int i;
+	int ret;
+	int count = fw->size;
+	int copy_size = (fw->size > PAGE_SIZE) ? PAGE_SIZE : fw->size;
+	int pages_needed = ALIGN(fw->size, PAGE_SIZE) >> PAGE_SHIFT;
+	struct page **pages;
+	void *page_data;
+	efi_capsule_header_t *capsule = NULL;
+
+	pages = kmalloc_array(pages_needed, sizeof(void *), GFP_KERNEL);
+	if (!pages) {
+		pr_err("%s: kmalloc_array() failed\n", __func__);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < pages_needed; i++) {
+		pages[i] = alloc_page(GFP_KERNEL);
+		if (!pages[i]) {
+			pr_err("%s: alloc_page() failed\n", __func__);
+			--i;
+			ret = -ENOMEM;
+			goto failed;
+		}
+	}
+
+	for (i = 0; i < pages_needed; i++) {
+		page_data = kmap(pages[i]);
+		memcpy(page_data, fw->data + (i * PAGE_SIZE), copy_size);
+
+		if (i == 0)
+			capsule = (efi_capsule_header_t *)page_data;
+		else
+			kunmap(pages[i]);
+
+		count -= copy_size;
+		if (count < PAGE_SIZE)
+			copy_size = count;
+	}
+
+	ret = efi_capsule_update(capsule, pages);
+	if (ret) {
+		pr_err("%s: efi_capsule_update() failed\n", __func__);
+		--i;
+		goto failed;
+	}
+	++capsule_count;
+	kunmap(pages[0]);
+
+	/*
+	 * we cannot free the pages here due to reboot need that data
+	 * maintained.
+	 */
+	return 0;
+
+failed:
+	while (i >= 0)
+		__free_page(pages[i--]);
+	kfree(pages);
+	return ret;
+}
+
+/*
+ * This callback function will be called by request_firmware_nowait() when
+ * user has loaded the capsule binary or aborted user helper interface
+ */
+static void callbackfn_efi_capsule(const struct firmware *fw, void *context)
+{
+	int ret = 0;
+
+	if (fw) {
+		/*
+		 * Binary not getting from user helper interface, fw->pages
+		 * is equal to NULL
+		 */
+		if (!fw->pages) {
+			pr_err("%s: ERROR: Capsule binary '%s' at %s\n",
+			       __func__, CAPSULE_NAME,
+			       "firmware lib search path are not supported");
+			pr_err("user helper interface disabled\n");
+			stop_request = 1;
+		} else {
+			efi_capsule_store(fw);
+		}
+		release_firmware(fw);
+	}
+
+	mutex_lock(&user_helper_lock);
+	if (!stop_request) {
+		ret = request_firmware_nowait(THIS_MODULE,
+					      FW_ACTION_NOHOTPLUG,
+					      CAPSULE_NAME,
+					      &efi_capsule_pdev->dev,
+					      GFP_KERNEL, NULL,
+					      callbackfn_efi_capsule);
+		if (ret) {
+			pr_err("%s: request_firmware_nowait() failed\n",
+			       __func__);
+		}
+	}
+	mutex_unlock(&user_helper_lock);
+}
+
+static ssize_t capsule_loaded_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, STRING_INTEGER_MAX_LENGTH, "%d\n", capsule_count);
+}
+
+static DEVICE_ATTR_RO(capsule_loaded);
+
+/* stop user helper interface for reboot or module unload */
+static void capsule_stop_user_helper(void)
+{
+	mutex_lock(&user_helper_lock);
+	stop_request = 1;
+	mutex_unlock(&user_helper_lock);
+	request_firmware_abort(CAPSULE_NAME);
+}
+
+/* reboot notifier for avoid deadlock with usermode_lock */
+static int capsule_shutdown_notify(struct notifier_block *nb,
+				   unsigned long sys_state,
+				   void *reboot_cmd)
+{
+	capsule_stop_user_helper();
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block capsule_shutdown_nb = {
+	.notifier_call = capsule_shutdown_notify,
+	/*
+	 * In order to reboot properly, it is required to ensure the priority
+	 * here is higher than firmware_class fw_shutdown_nb priority
+	 */
+	.priority = 1,
+};
+
+/*
+ * Use request_firmware_nowait() exposing an user helper interface to obtain
+ * capsule binary from user space
+ */
+static int __init efi_capsule_user_helper_init(void)
+{
+	int ret;
+
+	register_reboot_notifier(&capsule_shutdown_nb);
+
+	efi_capsule_pdev = platform_device_register_simple(DEV_NAME,
+							   PLATFORM_DEVID_NONE,
+							   NULL, 0);
+	if (IS_ERR(efi_capsule_pdev)) {
+		pr_err("%s: platform_device_register_simple() failed\n",
+		       __func__);
+		return PTR_ERR(efi_capsule_pdev);
+	}
+
+	/*
+	 * create this file node for user to check the number of binaries that
+	 * are successfully loaded
+	 */
+	ret = device_create_file(&efi_capsule_pdev->dev,
+				 &dev_attr_capsule_loaded);
+	if (ret) {
+		pr_err("%s: device_create_file() failed\n", __func__);
+		return ret;
+	}
+
+	ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_NOHOTPLUG,
+				      CAPSULE_NAME, &efi_capsule_pdev->dev,
+				      GFP_KERNEL, NULL, callbackfn_efi_capsule);
+	if (ret) {
+		pr_err("%s: request_firmware_nowait() failed\n", __func__);
+		goto out;
+	}
+
+	return 0;
+
+out:
+	device_remove_file(&efi_capsule_pdev->dev, &dev_attr_capsule_loaded);
+	unregister_reboot_notifier(&capsule_shutdown_nb);
+	return ret;
+}
+module_init(efi_capsule_user_helper_init);
+
+/*
+ * rmmod app itself will stop you to remove the module if the user
+ * helper interface is still exposing. In order to remove this driver,
+ * you are require to do the command as below:
+ * rmmod -f efi_capsule_user_helper.ko
+ */
+static void __exit efi_capsule_user_helper_exit(void)
+{
+	unregister_reboot_notifier(&capsule_shutdown_nb);
+
+	capsule_stop_user_helper();
+	/*
+	 * synchronization is needed to make sure request_firmware is fully
+	 * aborted
+	 */
+	while (efi_capsule_pdev->dev.kobj.kref.refcount.counter > 3)
+		msleep(20); /* avoid busy waiting for cooperative kernel */
+
+	device_remove_file(&efi_capsule_pdev->dev, &dev_attr_capsule_loaded);
+	platform_device_unregister(efi_capsule_pdev);
+}
+module_exit(efi_capsule_user_helper_exit);
+
+MODULE_DESCRIPTION("EFI Capsule user helper binary load utility");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

