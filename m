Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab3D3IbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:31:19 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:34433 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3D3IbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:31:15 -0400
Date: Tue, 30 Apr 2013 10:31:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform changes for v3.10
Message-ID: <20130430083111.GA22343@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   HEAD: 06d219dc22daa26b79ec8e611caa68801607f15d x86/setup: Drop unneeded include <asm/dmi.h>

Small fixes and cleanups all over the map.

 Thanks,

	Ingo

------------------>
Alexandru Gheorghiu (1):
      x86/platform/uv: Replace kmalloc() & memset with kzalloc()

Jean Delvare (1):
      x86/setup: Drop unneeded include <asm/dmi.h>

Wei Yongjun (1):
      x86/olpc/xo1/sci: Don't call input_free_device() after input_unregister_device()

Zhang Yanfei (1):
      x86/platform/intel/mrst: Remove cast for kmalloc() return value


 arch/x86/kernel/setup.c               | 1 -
 arch/x86/platform/mrst/mrst.c         | 3 +--
 arch/x86/platform/olpc/olpc-xo1-sci.c | 4 +---
 arch/x86/platform/uv/uv_time.c        | 3 +--
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 90d8cc9..a60b245 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -82,7 +82,6 @@
 #include <asm/timer.h>
 #include <asm/i8259.h>
 #include <asm/sections.h>
-#include <asm/dmi.h>
 #include <asm/io_apic.h>
 #include <asm/ist.h>
 #include <asm/setup_arch.h>
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index e31bcd8..a0a0a43 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -356,8 +356,7 @@ static int __init sfi_parse_gpio(struct sfi_table_header *table)
 	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
 	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
 
-	gpio_table = (struct sfi_gpio_table_entry *)
-				kmalloc(num * sizeof(*pentry), GFP_KERNEL);
+	gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);
 	if (!gpio_table)
 		return -1;
 	memcpy(gpio_table, pentry, num * sizeof(*pentry));
diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
index 74704be..9a2e590 100644
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -460,7 +460,6 @@ static int setup_power_button(struct platform_device *pdev)
 static void free_power_button(void)
 {
 	input_unregister_device(power_button_idev);
-	input_free_device(power_button_idev);
 }
 
 static int setup_ebook_switch(struct platform_device *pdev)
@@ -491,7 +490,6 @@ static int setup_ebook_switch(struct platform_device *pdev)
 static void free_ebook_switch(void)
 {
 	input_unregister_device(ebook_switch_idev);
-	input_free_device(ebook_switch_idev);
 }
 
 static int setup_lid_switch(struct platform_device *pdev)
@@ -526,6 +524,7 @@ static int setup_lid_switch(struct platform_device *pdev)
 
 err_create_attr:
 	input_unregister_device(lid_switch_idev);
+	lid_switch_idev = NULL;
 err_register:
 	input_free_device(lid_switch_idev);
 	return r;
@@ -535,7 +534,6 @@ static void free_lid_switch(void)
 {
 	device_remove_file(&lid_switch_idev->dev, &dev_attr_lid_wake_mode);
 	input_unregister_device(lid_switch_idev);
-	input_free_device(lid_switch_idev);
 }
 
 static int xo1_sci_probe(struct platform_device *pdev)
diff --git a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
index 98718f6..5c86786 100644
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
@@ -159,10 +159,9 @@ static __init int uv_rtc_allocate_timers(void)
 {
 	int cpu;
 
-	blade_info = kmalloc(uv_possible_blades * sizeof(void *), GFP_KERNEL);
+	blade_info = kzalloc(uv_possible_blades * sizeof(void *), GFP_KERNEL);
 	if (!blade_info)
 		return -ENOMEM;
-	memset(blade_info, 0, uv_possible_blades * sizeof(void *));
 
 	for_each_present_cpu(cpu) {
 		int nid = cpu_to_node(cpu);
