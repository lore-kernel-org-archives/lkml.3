Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab3CHE7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:59:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43473 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab3CHE7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:59:46 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH 05/14] x86, ACPI: Find acpi tables in initrd early at head_32.S/head64.c
Date: Thu,  7 Mar 2013 20:58:31 -0800
Message-Id: <1362718720-27048-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

head64.c could use #PF handler set page table to access initrd before
mapping and relocating.

head_32.S could use 32bit flat mode to access initrd before mapping
and relocating.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 arch/x86/include/asm/setup.h |    2 ++
 arch/x86/kernel/head64.c     |    2 ++
 arch/x86/kernel/head_32.S    |    4 ++++
 arch/x86/kernel/setup.c      |   28 ++++++++++++++++++++++++++--
 4 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index b7bf350..b09db26 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -42,6 +42,8 @@ extern void visws_early_detect(void);
 static inline void visws_early_detect(void) { }
 #endif
 
+void x86_acpi_override_find(void);
+
 extern unsigned long saved_video_mode;
 
 extern void reserve_standard_io_resources(void);
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index c5e403f..a31bc63 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -174,6 +174,8 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	if (console_loglevel == 10)
 		early_printk("Kernel alive\n");
 
+	x86_acpi_override_find();
+
 	clear_page(init_level4_pgt);
 	/* set init_level4_pgt kernel high mapping*/
 	init_level4_pgt[511] = early_level4_pgt[511];
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 73afd11..ca08f0e 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -149,6 +149,10 @@ ENTRY(startup_32)
 	call load_ucode_bsp
 #endif
 
+#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
+	call x86_acpi_override_find
+#endif
+
 /*
  * Initialize page tables.  This creates a PDE and a set of page
  * tables, which are located immediately beyond __brk_base.  The variable
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 668e658..d43545a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -424,6 +424,32 @@ static void __init reserve_initrd(void)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
+void __init x86_acpi_override_find(void)
+{
+	unsigned long ramdisk_image, ramdisk_size;
+	unsigned char *p = NULL;
+
+#ifdef CONFIG_X86_32
+	struct boot_params *boot_params_p;
+
+	boot_params_p = (struct boot_params *)__pa_symbol(&boot_params);
+	ramdisk_image = boot_params_p->hdr.ramdisk_image;
+	ramdisk_size  = boot_params_p->hdr.ramdisk_size;
+	p = (unsigned char *)ramdisk_image;
+	acpi_initrd_override_find(p, ramdisk_size, true);
+#else
+	ramdisk_image = get_ramdisk_image();
+	ramdisk_size  = get_ramdisk_size();
+	if (ramdisk_image)
+		p = __va(ramdisk_image);
+	acpi_initrd_override_find(p, ramdisk_size, false);
+#endif
+}
+#else
+void __init x86_acpi_override_find(void) { }
+#endif
+
 static void __init parse_setup_data(void)
 {
 	struct setup_data *data;
@@ -1092,8 +1118,6 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_initrd();
 
-	acpi_initrd_override_find((void *)initrd_start,
-					initrd_end - initrd_start, false);
 	acpi_initrd_override_copy();
 
 	reserve_crashkernel();
-- 
1.7.10.4

