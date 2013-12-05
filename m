Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab3LEXdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:33:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44707 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab3LEXcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:32:33 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Kim Naru <kim.naru@amd.com>, Thomas Renninger <trenn@suse.de>
Subject: [PATCH 1/4] x86, ramdisk: Export relocated ramdisk VA
Date: Fri,  6 Dec 2013 00:32:25 +0100
Message-Id: <1386286348-5144-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386286348-5144-1-git-send-email-bp@alien8.de>
References: <1386286348-5144-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

The ramdisk can possibly get relocated if the whole image is not mapped.
And since we're going over it in the microcode loader and fishing
out the relevant microcode patches, we want to access it at its new
location. Thus, export it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/setup.h |  3 ++-
 arch/x86/kernel/setup.c      | 19 ++++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 59bcf4e22418..d62c9f809bc5 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -3,7 +3,6 @@
 
 #include <uapi/asm/setup.h>
 
-
 #define COMMAND_LINE_SIZE 2048
 
 #include <linux/linkage.h>
@@ -29,6 +28,8 @@
 #include <asm/bootparam.h>
 #include <asm/x86_init.h>
 
+extern u64 relocated_ramdisk;
+
 /* Interrupt control for vSMPowered x86_64 systems */
 #ifdef CONFIG_X86_64
 void vsmp_init(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f97cf4dd4b76..488e93e763c8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -295,6 +295,8 @@ static void __init reserve_brk(void)
 	_brk_start = 0;
 }
 
+u64 relocated_ramdisk;
+
 #ifdef CONFIG_BLK_DEV_INITRD
 
 static u64 __init get_ramdisk_image(void)
@@ -321,25 +323,24 @@ static void __init relocate_initrd(void)
 	u64 ramdisk_image = get_ramdisk_image();
 	u64 ramdisk_size  = get_ramdisk_size();
 	u64 area_size     = PAGE_ALIGN(ramdisk_size);
-	u64 ramdisk_here;
 	unsigned long slop, clen, mapaddr;
 	char *p, *q;
 
 	/* We need to move the initrd down into directly mapped mem */
-	ramdisk_here = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
-						 area_size, PAGE_SIZE);
+	relocated_ramdisk = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
+						   area_size, PAGE_SIZE);
 
-	if (!ramdisk_here)
+	if (!relocated_ramdisk)
 		panic("Cannot find place for new RAMDISK of size %lld\n",
-			 ramdisk_size);
+		      ramdisk_size);
 
 	/* Note: this includes all the mem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
-	memblock_reserve(ramdisk_here, area_size);
-	initrd_start = ramdisk_here + PAGE_OFFSET;
+	memblock_reserve(relocated_ramdisk, area_size);
+	initrd_start = relocated_ramdisk + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
 	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
-			 ramdisk_here, ramdisk_here + ramdisk_size - 1);
+	       relocated_ramdisk, relocated_ramdisk + ramdisk_size - 1);
 
 	q = (char *)initrd_start;
 
@@ -363,7 +364,7 @@ static void __init relocate_initrd(void)
 	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
 		" [mem %#010llx-%#010llx]\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
-		ramdisk_here, ramdisk_here + ramdisk_size - 1);
+		relocated_ramdisk, relocated_ramdisk + ramdisk_size - 1);
 }
 
 static void __init early_reserve_initrd(void)
-- 
1.8.4

