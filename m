Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3FNVc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:32:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34443 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3FNVcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:32:23 -0400
Date: Fri, 14 Jun 2013 14:32:06 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-88168dcb255f44892bcf9f6fac6aeb424471ffaa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tangchen@cn.fujitsu.com,
        jacob.shin@amd.com, trenn@suse.de, tglx@linutronix.de,
        hpa@linux.intel.com, rjw@sisk.pl
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tangchen@cn.fujitsu.com,
        jacob.shin@amd.com, tglx@linutronix.de, trenn@suse.de, rjw@sisk.pl,
        hpa@linux.intel.com
In-Reply-To: <1371128589-8953-10-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-10-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, ACPI:
  Find acpi tables in initrd early from head_32.S/head64.c
Git-Commit-ID: 88168dcb255f44892bcf9f6fac6aeb424471ffaa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:32:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88168dcb255f44892bcf9f6fac6aeb424471ffaa
Gitweb:     http://git.kernel.org/tip/88168dcb255f44892bcf9f6fac6aeb424471ffaa
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:02:56 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:04:50 -0700

x86, ACPI: Find acpi tables in initrd early from head_32.S/head64.c

head64.c can use the #PF handler automatic page tables to access initrd before
init mem mapping and initrd relocating.

head_32.S can use 32-bit flat mode to access initrd before init mem
mapping initrd relocating.

This patch introduces x86_acpi_override_find(), which is called from
head_32.S/head64.c, to replace acpi_initrd_override_find(). So that we
can makes 32bit and 64 bit more consistent.

-v2: use inline function in header file instead according to tj.
     also still need to keep #idef head_32.S to avoid compiling error.
-v3: need to move down reserve_initrd() after acpi_initrd_override_copy(),
     to make sure we are using right address.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-10-git-send-email-tangchen@cn.fujitsu.com
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Tested-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index 55b6761..229b281 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -175,6 +175,8 @@ void __init x86_64_start_kernel(char * real_mode_data)
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
index 142e042..d11b1b7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -421,6 +421,34 @@ static void __init reserve_initrd(void)
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
@@ -1117,12 +1145,10 @@ void __init setup_arch(char **cmdline_p)
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
