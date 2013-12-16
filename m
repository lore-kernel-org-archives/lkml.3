Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3LPJdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:33:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab3LPJdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:33:13 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com, akpm@linux-foundation.org,
        mingo@kernel.org, msalter@redhat.com, leif.lindholm@linaro.org
Subject: [PATCH v6 07/14] efi: export more efi table variable to sysfs
Date: Mon, 16 Dec 2013 17:30:28 +0800
Message-Id: <1387186235-15972-8-git-send-email-dyoung@redhat.com>
In-Reply-To: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export fw_vendor, runtime and config table physical addresses to
/sys/firmware/efi/{fw_vendor,runtime,config_table} because kexec kernel
need them.

>From EFI spec these 3 variables will be updated to
virtual address after entering virtual mode. But
kernel startup code will need the physical address.

changelog:
Greg: add standalone sysfs files instead of add lines to systab
Document them as testing ABI
Greg: use group attrs and is_visible
Boris: align comments lines
Boris: add macros for _show functions, documentation fixes.
Matt: Documentation fixes.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 Documentation/ABI/testing/sysfs-firmware-efi | 20 ++++++++++++++
 arch/x86/platform/efi/efi.c                  |  4 +++
 drivers/firmware/efi/efi.c                   | 41 +++++++++++++++++++++++++++-
 include/linux/efi.h                          |  3 ++
 4 files changed, 67 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi

diff --git a/Documentation/ABI/testing/sysfs-firmware-efi b/Documentation/ABI/testing/sysfs-firmware-efi
new file mode 100644
index 0000000..05874da
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-efi
@@ -0,0 +1,20 @@
+What:		/sys/firmware/efi/fw_vendor
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:	It shows the physical address of firmware vendor field in the
+		EFI system table.
+Users:		Kexec
+
+What:		/sys/firmware/efi/runtime
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:	It shows the physical address of runtime service table entry in
+		the EFI system table.
+Users:		Kexec
+
+What:		/sys/firmware/efi/config_table
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:	It shows the physical address of config table entry in the EFI
+		system table.
+Users:		Kexec
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 7778b5f..3e8b760 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -653,6 +653,10 @@ void __init efi_init(void)
 
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
+	efi.config_table = (unsigned long)efi.systab->tables;
+	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
+	efi.runtime	 = (unsigned long)efi.systab->runtime;
+
 	/*
 	 * Show what we know for posterity
 	 */
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index b716a66..6d0bc52 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -32,6 +32,9 @@ struct efi __read_mostly efi = {
 	.hcdp       = EFI_INVALID_TABLE_ADDR,
 	.uga        = EFI_INVALID_TABLE_ADDR,
 	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
+	.runtime    = EFI_INVALID_TABLE_ADDR,
+	.config_table  = EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -71,13 +74,49 @@ static ssize_t systab_show(struct kobject *kobj,
 static struct kobj_attribute efi_attr_systab =
 			__ATTR(systab, 0400, systab_show, NULL);
 
+#define EFI_FIELD(var) efi.var
+
+#define EFI_ATTR_SHOW(name) \
+static ssize_t name##_show(struct kobject *kobj, \
+				struct kobj_attribute *attr, char *buf) \
+{ \
+	return sprintf(buf, "0x%lx\n", EFI_FIELD(name)); \
+}
+
+EFI_ATTR_SHOW(fw_vendor);
+EFI_ATTR_SHOW(runtime);
+EFI_ATTR_SHOW(config_table);
+
+static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
+static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
+static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
+
 static struct attribute *efi_subsys_attrs[] = {
 	&efi_attr_systab.attr,
-	NULL,	/* maybe more in the future? */
+	&efi_attr_fw_vendor.attr,
+	&efi_attr_runtime.attr,
+	&efi_attr_config_table.attr,
+	NULL,
 };
 
+static umode_t efi_attr_is_visible(struct kobject *kobj,
+				   struct attribute *attr, int n)
+{
+	umode_t mode = attr->mode;
+
+	if (attr == &efi_attr_fw_vendor.attr)
+		return (efi.fw_vendor == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+	else if (attr == &efi_attr_runtime.attr)
+		return (efi.runtime == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+	else if (attr == &efi_attr_config_table.attr)
+		return (efi.config_table == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+
+	return mode;
+}
+
 static struct attribute_group efi_subsys_attr_group = {
 	.attrs = efi_subsys_attrs,
+	.is_visible = efi_attr_is_visible,
 };
 
 static struct efivars generic_efivars;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 49ece2c..988af61 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -556,6 +556,9 @@ extern struct efi {
 	unsigned long hcdp;		/* HCDP table */
 	unsigned long uga;		/* UGA table */
 	unsigned long uv_systab;	/* UV system table */
+	unsigned long fw_vendor;	/* fw_vendor */
+	unsigned long runtime;		/* runtime table */
+	unsigned long config_table;	/* config tables */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
-- 
1.8.3.1

