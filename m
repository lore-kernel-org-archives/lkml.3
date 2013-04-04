Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765155Ab3DDXr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:47:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43383 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764867Ab3DDXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:47:55 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 01/22] x86: Change get_ramdisk_image() to global
Date: Thu,  4 Apr 2013 16:46:05 -0700
Message-Id: <1365119186-23487-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need to use get_ramdisk_image() with early microcode_updating in other file.
Change it to global.

Also make it to take boot_params pointer, as head_32.S need to access it via
phys address during 32bit flat mode.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/setup.h |  3 +++
 arch/x86/kernel/setup.c      | 28 ++++++++++++++--------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index b7bf350..4f71d48 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -106,6 +106,9 @@ void *extend_brk(size_t size, size_t align);
 	RESERVE_BRK(name, sizeof(type) * entries)
 
 extern void probe_roms(void);
+u64 get_ramdisk_image(struct boot_params *bp);
+u64 get_ramdisk_size(struct boot_params *bp);
+
 #ifdef __i386__
 
 void __init i386_start_kernel(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 90d8cc9..1629577 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -300,19 +300,19 @@ static void __init reserve_brk(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-static u64 __init get_ramdisk_image(void)
+u64 __init get_ramdisk_image(struct boot_params *bp)
 {
-	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
+	u64 ramdisk_image = bp->hdr.ramdisk_image;
 
-	ramdisk_image |= (u64)boot_params.ext_ramdisk_image << 32;
+	ramdisk_image |= (u64)bp->ext_ramdisk_image << 32;
 
 	return ramdisk_image;
 }
-static u64 __init get_ramdisk_size(void)
+u64 __init get_ramdisk_size(struct boot_params *bp)
 {
-	u64 ramdisk_size = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_size = bp->hdr.ramdisk_size;
 
-	ramdisk_size |= (u64)boot_params.ext_ramdisk_size << 32;
+	ramdisk_size |= (u64)bp->ext_ramdisk_size << 32;
 
 	return ramdisk_size;
 }
@@ -321,8 +321,8 @@ static u64 __init get_ramdisk_size(void)
 static void __init relocate_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = get_ramdisk_image();
-	u64 ramdisk_size  = get_ramdisk_size();
+	u64 ramdisk_image = get_ramdisk_image(&boot_params);
+	u64 ramdisk_size  = get_ramdisk_size(&boot_params);
 	u64 area_size     = PAGE_ALIGN(ramdisk_size);
 	u64 ramdisk_here;
 	unsigned long slop, clen, mapaddr;
@@ -361,8 +361,8 @@ static void __init relocate_initrd(void)
 		ramdisk_size  -= clen;
 	}
 
-	ramdisk_image = get_ramdisk_image();
-	ramdisk_size  = get_ramdisk_size();
+	ramdisk_image = get_ramdisk_image(&boot_params);
+	ramdisk_size  = get_ramdisk_size(&boot_params);
 	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
 		" [mem %#010llx-%#010llx]\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
@@ -372,8 +372,8 @@ static void __init relocate_initrd(void)
 static void __init early_reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = get_ramdisk_image();
-	u64 ramdisk_size  = get_ramdisk_size();
+	u64 ramdisk_image = get_ramdisk_image(&boot_params);
+	u64 ramdisk_size  = get_ramdisk_size(&boot_params);
 	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 
 	if (!boot_params.hdr.type_of_loader ||
@@ -385,8 +385,8 @@ static void __init early_reserve_initrd(void)
 static void __init reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = get_ramdisk_image();
-	u64 ramdisk_size  = get_ramdisk_size();
+	u64 ramdisk_image = get_ramdisk_image(&boot_params);
+	u64 ramdisk_size  = get_ramdisk_size(&boot_params);
 	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 	u64 mapped_size;
 
-- 
1.8.1.4

