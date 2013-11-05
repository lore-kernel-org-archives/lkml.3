Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab3KEIjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 03:39:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab3KEIjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:39:45 -0500
Message-Id: <20131105082717.561020034@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Tue, 05 Nov 2013 16:20:11 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de,
        Dave Young <dyoung@redhat.com>
Subject: [patch 4/7 v2] export more efi table variable to sysfs
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
Content-Disposition: inline; filename=04-export-more-efi-sysfs-vars.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export fw_vendor, runtime and config tables physical
addresses to /sys/firmware/efi/systab becaue kexec
kernel will need them.

>From EFI spec these 3 variables will be updated to
virtual address after entering virtual mode. But
kernel startup code will need the physical address.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c |    4 ++++
 drivers/firmware/efi/efi.c  |    9 +++++++++
 include/linux/efi.h         |    3 +++
 3 files changed, 16 insertions(+)

--- linux-2.6.orig/drivers/firmware/efi/efi.c
+++ linux-2.6/drivers/firmware/efi/efi.c
@@ -32,6 +32,9 @@ struct efi __read_mostly efi = {
 	.hcdp       = EFI_INVALID_TABLE_ADDR,
 	.uga        = EFI_INVALID_TABLE_ADDR,
 	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
+	.runtime    = EFI_INVALID_TABLE_ADDR,
+	.config_tables  = EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -64,6 +67,12 @@ static ssize_t systab_show(struct kobjec
 		str += sprintf(str, "BOOTINFO=0x%lx\n", efi.boot_info);
 	if (efi.uga != EFI_INVALID_TABLE_ADDR)
 		str += sprintf(str, "UGA=0x%lx\n", efi.uga);
+	if (efi.fw_vendor != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "fw_vendor=0x%lx\n", efi.fw_vendor);
+	if (efi.runtime != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "runtime=0x%lx\n", efi.runtime);
+	if (efi.config_tables != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "config_tables=0x%lx\n", efi.config_tables);
 
 	return str - buf;
 }
--- linux-2.6.orig/include/linux/efi.h
+++ linux-2.6/include/linux/efi.h
@@ -556,6 +556,9 @@ extern struct efi {
 	unsigned long hcdp;		/* HCDP table */
 	unsigned long uga;		/* UGA table */
 	unsigned long uv_systab;	/* UV system table */
+	unsigned long fw_vendor;
+	unsigned long runtime;
+	unsigned long config_tables;
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
--- linux-2.6.orig/arch/x86/platform/efi/efi.c
+++ linux-2.6/arch/x86/platform/efi/efi.c
@@ -653,6 +653,10 @@ void __init efi_init(void)
 
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
+	efi.fw_vendor = (unsigned long)efi.systab->fw_vendor;
+	efi.runtime = (unsigned long)efi.systab->runtime;
+	efi.config_tables = (unsigned long)efi.systab->tables;
+
 	/*
 	 * Show what we know for posterity
 	 */

