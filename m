Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765610Ab3DDXvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:51:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32205 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765070Ab3DDXr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:47:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH v3 09/22] x86, ACPI: Find acpi tables in initrd early from head_32.S/head64.c
Date: Thu,  4 Apr 2013 16:46:13 -0700
Message-Id: <1365119186-23487-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

head64.c could use #PF handler set page table to access initrd before
init mem mapping and initrd relocating.

head_32.S could use 32bit flat mode to access initrd before init mem
mapping initrd relocating.

That make 32bit and 64 bit more consistent.

-v2: use inline function in header file instead according to tj.
     also still need to keep #idef head_32.S to avoid compiling error.
-v3: need to move down reserve_initrd() after acpi_initrd_override_copy(),
     to make sure we are using right address.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 arch/x86/include/asm/setup.h |  6 ++++++
 arch/x86/kernel/head64.c     |  2 ++
 arch/x86/kernel/head_32.S    |  4 ++++
 arch/x86/kernel/setup.c      | 34 ++++++++++++++++++++++++++++++----
 4 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 4f71d48..6f885b7 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -42,6 +42,12 @@ extern void visws_early_detect(void);
 static inline void visws_early_detect(void) { }
 #endif
 
+#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
+void x86_acpi_override_find(void);
+#else
+static inline void x86_acpi_override_find(void) { }
+#endif
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
index 16a703f..2d29bc0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -424,6 +424,34 @@ static void __init reserve_initrd(void)
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
+	/*
+	 * 32bit is from head_32.S, and it is 32bit flat mode.
+	 * So need to use phys address to access global variables.
+	 */
+	boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
+	ramdisk_image = get_ramdisk_image(boot_params_p);
+	ramdisk_size  = get_ramdisk_size(boot_params_p);
+	p = (unsigned char *)ramdisk_image;
+	acpi_initrd_override_find(p, ramdisk_size, true);
+#else
+	ramdisk_image = get_ramdisk_image(&boot_params);
+	ramdisk_size  = get_ramdisk_size(&boot_params);
+	if (ramdisk_image)
+		p = __va(ramdisk_image);
+	acpi_initrd_override_find(p, ramdisk_size, false);
+#endif
+}
+#endif
+
 static void __init parse_setup_data(void)
 {
 	struct setup_data *data;
@@ -1090,12 +1118,10 @@ void __init setup_arch(char **cmdline_p)
 	/* Allocate bigger log buffer */
 	setup_log_buf(1);
 
-	reserve_initrd();
-
-	acpi_initrd_override_find((void *)initrd_start,
-					initrd_end - initrd_start, false);
 	acpi_initrd_override_copy();
 
+	reserve_initrd();
+
 	reserve_crashkernel();
 
 	vsmp_init();
-- 
1.8.1.4

