Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3IJVr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:47:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab3IJVpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 15/16] bootparam: Pass acpi_rsdp pointer in bootparam
Date: Tue, 10 Sep 2013 17:44:30 -0400
Message-Id: <1378849471-10521-16-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kexec does not enables EFI and its tables in second kernel. Hence
acpi rsdp root pointer is passed on command line. But secureboot does not trust
acpi_rsdp on command line as kernel can execute some of the code as retrieved
by following acpi_rsdp and root can modify command line. So in secureboot
mode we ignore acpi_rsdp on command line.

Start passing it in bootparams for the time being. kexec-tools will prepare
the bootparams and put acpi_rsdp pointer there.

Peter Jones suggested that scan all ACPI memory for acpi_rsdp if EFI is
not enabled. This probably is a better fix and most likely this patch will
change and adopt that approach down the line.

In fact if we figure out how to make UEFI run time calls in second kernel,
we will not need acpi_rsdp at all.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/include/uapi/asm/bootparam.h |  3 ++-
 arch/x86/kernel/acpi/boot.c           |  5 +++++
 drivers/acpi/osl.c                    | 10 ++++++++++
 include/linux/acpi.h                  |  1 +
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index c15ddaf..8a5f7ae 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -122,7 +122,8 @@ struct boot_params {
 	__u32 ext_ramdisk_image;			/* 0x0c0 */
 	__u32 ext_ramdisk_size;				/* 0x0c4 */
 	__u32 ext_cmd_line_ptr;				/* 0x0c8 */
-	__u8  _pad4[116];				/* 0x0cc */
+	__u64 acpi_rsdp_addr;				/* 0x0cc */
+	__u8  _pad4[108];				/* 0x0d4 */
 	struct edid_info edid_info;			/* 0x140 */
 	struct efi_info efi_info;			/* 0x1c0 */
 	__u32 alt_mem_k;				/* 0x1e0 */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 2627a81..b667d65 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -43,6 +43,8 @@
 #include <asm/io.h>
 #include <asm/mpspec.h>
 #include <asm/smp.h>
+#include <asm/bootparam.h>
+#include <asm/setup.h>
 
 #include "sleep.h" /* To include x86_acpi_suspend_lowlevel */
 static int __initdata acpi_force = 0;
@@ -1518,6 +1520,9 @@ static struct dmi_system_id __initdata acpi_dmi_table_late[] = {
 
 void __init acpi_boot_table_init(void)
 {
+	/* Read  acpi_rsdp_bootparams from bootparam */
+	acpi_rsdp_bootparam = boot_params.acpi_rsdp_addr;
+
 	dmi_check_system(acpi_dmi_table);
 
 	/*
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 6ab2c35..99e8ca9 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -242,9 +242,19 @@ static int __init setup_acpi_rsdp(char *arg)
 early_param("acpi_rsdp", setup_acpi_rsdp);
 #endif
 
+unsigned long long acpi_rsdp_bootparam;
 acpi_physical_address __init acpi_os_get_root_pointer(void)
 {
 #ifdef CONFIG_KEXEC
+	/*
+	 * If bootloader (kexec in this case), has passed, the acpi_rsdp
+	 * in boot params, use that. In case of secureboot /sbin/kexec
+	 * is signed and verified. That means we can trust acpi_rsdp
+	 * as passed in by kexec bootloader
+	 */
+	if (acpi_rsdp_bootparam)
+		return acpi_rsdp_bootparam;
+
 	if (acpi_rsdp)
 		return acpi_rsdp;
 #endif
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 6ad72f9..54cc8ab 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -128,6 +128,7 @@ extern u32 acpi_irq_not_handled;
 
 extern int sbf_port;
 extern unsigned long acpi_realmode_flags;
+extern unsigned long long acpi_rsdp_bootparam;
 
 int acpi_register_gsi (struct device *dev, u32 gsi, int triggering, int polarity);
 int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
-- 
1.8.3.1

