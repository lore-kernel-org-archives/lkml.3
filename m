Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaFBSYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:24:49 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:43125 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaFBSYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:24:45 -0400
From: Tom Gundersen <teg@jklm.no>
To: linux-kernel@vger.kernel.org
Cc: Tom Gundersen <teg@jklm.no>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Abhay Salunke <Abhay_Salunke@dell.com>, Stefan Roese <sr@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Kay Sievers <kay@vrfy.org>
Subject: [PATCH] firmware loader: allow disabling of udev as firmware loader
Date: Mon,  2 Jun 2014 20:24:34 +0200
Message-Id: <1401733474-1767-1-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently (at least) the dell-rbu driver selects FW_LOADER_USER_HELPER,
which means that distros can't really stop loading firmware through udev
without breaking other users (though some have).

Ideally we would remove/disable the udev firmware helper in both the kernel
and in udev, but if we were to disable it in udev and not the kernel, the result
would be (seemingly) hung kernels as no one would be around to cancel firmware
requests.

This patch allows udev firmware loading to be disabled while still allowing
non-udev firmware loading, as done by the dell-rbu driver, to continue
working. This is achieved by only using the fallback mechanism when the
uevent is suppressed.

Tested with
    FW_LOADER_USER_HELPER=n
    LATTICE_ECP3_CONFIG=y
    DELL_RBU=y
and udev without the firmware loading support, but I don't have the hardware
to test the lattice/dell drivers, so additional testing would be appreciated.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Abhay Salunke <Abhay_Salunke@dell.com>
Cc: Stefan Roese <sr@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kay Sievers <kay@vrfy.org>
---
 drivers/base/Kconfig          | 10 +++++++++-
 drivers/base/firmware_class.c | 34 +++++++++++++++++++++++-----------
 drivers/firmware/Kconfig      |  2 +-
 drivers/misc/Kconfig          |  1 +
 include/linux/firmware.h      |  2 +-
 5 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 8fa8dea..28334ac 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -143,16 +143,24 @@ config EXTRA_FIRMWARE_DIR
 	  this option you can point it elsewhere, such as /lib/firmware/ or
 	  some other directory containing the firmware files.
 
+config FW_LOADER_FALLBACK
+	bool
+	default n
+
 config FW_LOADER_USER_HELPER
 	bool "Fallback user-helper invocation for firmware loading"
 	depends on FW_LOADER
+	select FW_LOADER_FALLBACK
 	default y
 	help
 	  This option enables / disables the invocation of user-helper
 	  (e.g. udev) for loading firmware files as a fallback after the
 	  direct file loading in kernel fails.  The user-mode helper is
 	  no longer required unless you have a special firmware file that
-	  resides in a non-standard path.
+	  resides in a non-standard path. Moreover, the udev support has
+	  been deprecated upstream.
+
+	  If you are unsure about this, say N here.
 
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d276e33..260e8ec 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -99,7 +99,7 @@ static inline long firmware_loading_timeout(void)
 /* firmware behavior options */
 #define FW_OPT_UEVENT	(1U << 0)
 #define FW_OPT_NOWAIT	(1U << 1)
-#ifdef CONFIG_FW_LOADER_USER_HELPER
+#ifdef CONFIG_FW_LOADER_FALLBACK
 #define FW_OPT_FALLBACK	(1U << 2)
 #else
 #define FW_OPT_FALLBACK	0
@@ -135,7 +135,7 @@ struct firmware_buf {
 	unsigned long status;
 	void *data;
 	size_t size;
-#ifdef CONFIG_FW_LOADER_USER_HELPER
+#ifdef CONFIG_FW_LOADER_FALLBACK
 	bool is_paged_buf;
 	bool need_uevent;
 	struct page **pages;
@@ -183,7 +183,7 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
 	strcpy(buf->fw_id, fw_name);
 	buf->fwc = fwc;
 	init_completion(&buf->completion);
-#ifdef CONFIG_FW_LOADER_USER_HELPER
+#ifdef CONFIG_FW_LOADER_FALLBACK
 	INIT_LIST_HEAD(&buf->pending_list);
 #endif
 
@@ -240,7 +240,7 @@ static void __fw_free_buf(struct kref *ref)
 	list_del(&buf->list);
 	spin_unlock(&fwc->lock);
 
-#ifdef CONFIG_FW_LOADER_USER_HELPER
+#ifdef CONFIG_FW_LOADER_FALLBACK
 	if (buf->is_paged_buf) {
 		int i;
 		vunmap(buf->data);
@@ -372,7 +372,7 @@ static void firmware_free_data(const struct firmware *fw)
 static void fw_set_page_data(struct firmware_buf *buf, struct firmware *fw)
 {
 	fw->priv = buf;
-#ifdef CONFIG_FW_LOADER_USER_HELPER
+#ifdef CONFIG_FW_LOADER_FALLBACK
 	fw->pages = buf->pages;
 #endif
 	fw->size = buf->size;
@@ -443,7 +443,7 @@ static int fw_add_devm_name(struct device *dev, const char *name)
 /*
  * user-mode helper code
  */
-#ifdef CONFIG_FW_LOADER_USER_HELPER
+#ifdef CONFIG_FW_LOADER_FALLBACK
 struct firmware_priv {
 	struct delayed_work timeout_work;
 	bool nowait;
@@ -954,7 +954,7 @@ static void kill_requests_without_uevent(void)
 }
 #endif
 
-#else /* CONFIG_FW_LOADER_USER_HELPER */
+#else /* CONFIG_FW_LOADER_FALLBACK */
 static inline int
 fw_load_from_user_helper(struct firmware *firmware, const char *name,
 			 struct device *device, unsigned int opt_flags,
@@ -970,7 +970,7 @@ fw_load_from_user_helper(struct firmware *firmware, const char *name,
 static inline void kill_requests_without_uevent(void) { }
 #endif
 
-#endif /* CONFIG_FW_LOADER_USER_HELPER */
+#endif /* CONFIG_FW_LOADER_FALLBACK */
 
 
 /* wait until the shared firmware_buf becomes ready (or error) */
@@ -1164,14 +1164,21 @@ request_firmware(const struct firmware **firmware_p, const char *name,
 
 	/* Need to pin this module until return */
 	__module_get(THIS_MODULE);
+
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 	ret = _request_firmware(firmware_p, name, device,
 				FW_OPT_UEVENT | FW_OPT_FALLBACK);
+#else
+	ret = _request_firmware(firmware_p, name, device,
+				FW_OPT_UEVENT);
+#endif
+
 	module_put(THIS_MODULE);
 	return ret;
 }
 EXPORT_SYMBOL(request_firmware);
 
-#ifdef CONFIG_FW_LOADER_USER_HELPER
+#ifdef CONFIG_FW_LOADER_FALLBACK
 /**
  * request_firmware: - load firmware directly without usermode helper
  * @firmware_p: pointer to firmware image
@@ -1276,8 +1283,13 @@ request_firmware_nowait(
 	fw_work->device = device;
 	fw_work->context = context;
 	fw_work->cont = cont;
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 	fw_work->opt_flags = FW_OPT_NOWAIT | FW_OPT_FALLBACK |
 		(uevent ? FW_OPT_UEVENT : 0);
+#else
+	fw_work->opt_flags = FW_OPT_NOWAIT |
+		(uevent ? FW_OPT_UEVENT : FW_OPT_FALLBACK);
+#endif
 
 	if (!try_module_get(module)) {
 		kfree(fw_work);
@@ -1648,7 +1660,7 @@ static void __init fw_cache_init(void)
 static int __init firmware_class_init(void)
 {
 	fw_cache_init();
-#ifdef CONFIG_FW_LOADER_USER_HELPER
+#ifdef CONFIG_FW_LOADER_FALLBACK
 	register_reboot_notifier(&fw_shutdown_nb);
 	return class_register(&firmware_class);
 #else
@@ -1662,7 +1674,7 @@ static void __exit firmware_class_exit(void)
 	unregister_syscore_ops(&fw_syscore_ops);
 	unregister_pm_notifier(&fw_cache.pm_notify);
 #endif
-#ifdef CONFIG_FW_LOADER_USER_HELPER
+#ifdef CONFIG_FW_LOADER_FALLBACK
 	unregister_reboot_notifier(&fw_shutdown_nb);
 	class_unregister(&firmware_class);
 #endif
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 4198388..d6c864e 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -64,7 +64,7 @@ config DELL_RBU
 	tristate "BIOS update support for DELL systems via sysfs"
 	depends on X86
 	select FW_LOADER
-	select FW_LOADER_USER_HELPER
+	select FW_LOADER_FALLBACK
 	help
 	 Say m if you want to have the option of updating the BIOS for your
 	 DELL system. Note you need a Dell OpenManage or Dell Update package (DUP)
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 8baff0e..2a3552e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -499,6 +499,7 @@ config LATTICE_ECP3_CONFIG
 	tristate "Lattice ECP3 FPGA bitstream configuration via SPI"
 	depends on SPI && SYSFS
 	select FW_LOADER
+	select FW_LOADER_FALLBACK
 	default	n
 	help
 	  This option enables support for bitstream configuration (programming
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 5952933..29c8914 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -68,7 +68,7 @@ static inline void release_firmware(const struct firmware *fw)
 
 #endif
 
-#ifdef CONFIG_FW_LOADER_USER_HELPER
+#ifdef CONFIG_FW_LOADER_FALLBACK
 int request_firmware_direct(const struct firmware **fw, const char *name,
 			    struct device *device);
 #else
-- 
1.9.0

