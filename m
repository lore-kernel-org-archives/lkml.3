Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3KUGUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 01:20:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab3KUGUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 01:20:39 -0500
Message-Id: <20131121061754.887381332@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Thu, 21 Nov 2013 14:17:09 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com,
        Dave Young <dyoung@redhat.com>
Subject: [patch 5/9 v3] efi: export more efi table variable to sysfs
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
Content-Disposition: inline; filename=05-export-more-efi-sysfs-vars.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export fw_vendor, runtime and config tables physical
addresses to /sys/firmware/efi/systab becaue kexec
kernel will need them.

>From EFI spec these 3 variables will be updated to
virtual address after entering virtual mode. But
kernel startup code will need the physical address.

changelog:
Greg: add standalone sysfs files instead of add lines to systab
Document them as testing ABI

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 Documentation/ABI/testing/sysfs-firmware-efi |   26 +++++++++
 arch/x86/platform/efi/efi.c                  |    4 +
 drivers/firmware/efi/efi.c                   |   71 +++++++++++++++++++++++++--
 include/linux/efi.h                          |    3 +
 4 files changed, 101 insertions(+), 3 deletions(-)

--- efi.orig/drivers/firmware/efi/efi.c
+++ efi/drivers/firmware/efi/efi.c
@@ -32,6 +32,9 @@ struct efi __read_mostly efi = {
 	.hcdp       = EFI_INVALID_TABLE_ADDR,
 	.uga        = EFI_INVALID_TABLE_ADDR,
 	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
+	.runtime    = EFI_INVALID_TABLE_ADDR,
+	.config_table  = EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -71,6 +74,31 @@ static ssize_t systab_show(struct kobjec
 static struct kobj_attribute efi_attr_systab =
 			__ATTR(systab, 0400, systab_show, NULL);
 
+static ssize_t fw_vendor_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%lx\n", efi.fw_vendor);
+}
+
+static ssize_t runtime_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%lx\n", efi.runtime);
+}
+
+static ssize_t config_table_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%lx\n", efi.config_table);
+}
+
+static struct kobj_attribute efi_attr_fw_vendor =
+				__ATTR(fw_vendor, 0400, fw_vendor_show, NULL);
+static struct kobj_attribute efi_attr_runtime =
+			__ATTR(runtime, 0400, runtime_show, NULL);
+static struct kobj_attribute efi_attr_config_table =
+			__ATTR(config_table, 0400, config_table_show, NULL);
+
 static struct attribute *efi_subsys_attrs[] = {
 	&efi_attr_systab.attr,
 	NULL,	/* maybe more in the future? */
@@ -123,21 +151,58 @@ static int __init efisubsys_init(void)
 
 	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
 	if (error) {
-		pr_err("efi: Sysfs attribute export failed with error %d.\n",
-		       error);
+		pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
+		       efi_attr_systab.attr.name, error);
 		goto err_unregister;
 	}
 
+	if (efi.fw_vendor != EFI_INVALID_TABLE_ADDR) {
+		error = sysfs_create_file(efi_kobj, &efi_attr_fw_vendor.attr);
+		if (error) {
+			pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
+				efi_attr_fw_vendor.attr.name, error);
+			goto err_remove_group;
+		}
+	}
+
+	if (efi.runtime != EFI_INVALID_TABLE_ADDR) {
+		error = sysfs_create_file(efi_kobj, &efi_attr_runtime.attr);
+		if (error) {
+			pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
+				efi_attr_runtime.attr.name, error);
+			goto err_remove_fw_vendor;
+		}
+	}
+
+	if (efi.config_table != EFI_INVALID_TABLE_ADDR) {
+		error = sysfs_create_file(efi_kobj,
+					&efi_attr_config_table.attr);
+		if (error) {
+			pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
+				efi_attr_config_table.attr.name, error);
+			goto err_remove_runtime;
+		}
+	}
+
 	/* and the standard mountpoint for efivarfs */
 	efivars_kobj = kobject_create_and_add("efivars", efi_kobj);
 	if (!efivars_kobj) {
 		pr_err("efivars: Subsystem registration failed.\n");
 		error = -ENOMEM;
-		goto err_remove_group;
+		goto err_remove_config_table;
 	}
 
 	return 0;
 
+err_remove_config_table:
+	if (efi.config_table != EFI_INVALID_TABLE_ADDR)
+		sysfs_remove_file(efi_kobj, &efi_attr_config_table.attr);
+err_remove_runtime:
+	if (efi.runtime != EFI_INVALID_TABLE_ADDR)
+		sysfs_remove_file(efi_kobj, &efi_attr_runtime.attr);
+err_remove_fw_vendor:
+	if (efi.fw_vendor != EFI_INVALID_TABLE_ADDR)
+		sysfs_remove_file(efi_kobj, &efi_attr_fw_vendor.attr);
 err_remove_group:
 	sysfs_remove_group(efi_kobj, &efi_subsys_attr_group);
 err_unregister:
--- efi.orig/include/linux/efi.h
+++ efi/include/linux/efi.h
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
--- efi.orig/arch/x86/platform/efi/efi.c
+++ efi/arch/x86/platform/efi/efi.c
@@ -653,6 +653,10 @@ void __init efi_init(void)
 
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
+	efi.fw_vendor = (unsigned long)efi.systab->fw_vendor;
+	efi.runtime = (unsigned long)efi.systab->runtime;
+	efi.config_table = (unsigned long)efi.systab->tables;
+
 	/*
 	 * Show what we know for posterity
 	 */
--- /dev/null
+++ efi/Documentation/ABI/testing/sysfs-firmware-efi
@@ -0,0 +1,26 @@
+What:		/sys/firmware/efi/fw_vendor
+Date:		Nov 2013
+Contact:	Dave Young <dyoung@redhat.org>
+Description:
+		Shows the physical address of firmware vendor in the EFI
+		system table.
+Users:
+		Kexec Mailing List <kexec@lists.infradead.org>
+
+What:		/sys/firmware/efi/runtime
+Date:		Nov 2013
+Contact:	Dave Young <dyoung@redhat.org>
+Description:
+		Shows the physical address of runtime service table in the
+		EFI system table.
+Users:
+		Kexec Mailing List <kexec@lists.infradead.org>
+
+What:		/sys/firmware/efi/config_table
+Date:		Nov 2013
+Contact:	Dave Young <dyoung@redhat.org>
+Description:
+		Shows the physical address of config table in the EFI
+		system table.
+Users:
+		Kexec Mailing List <kexec@lists.infradead.org>

