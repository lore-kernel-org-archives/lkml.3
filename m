Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3A3BeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:34:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3A3BeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:34:13 -0500
Date: Tue, 29 Jan 2013 17:34:01 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-a8a51a88d5152aa40e5e07dcdd939c7fafc42224@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-16-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-16-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86: Add get_ramdisk_image/size()
Git-Commit-ID: a8a51a88d5152aa40e5e07dcdd939c7fafc42224
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:34:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8a51a88d5152aa40e5e07dcdd939c7fafc42224
Gitweb:     http://git.kernel.org/tip/a8a51a88d5152aa40e5e07dcdd939c7fafc42224
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:56 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:21:05 -0800

x86: Add get_ramdisk_image/size()

There are several places to find ramdisk information early for reserving
and relocating.

Use accessor functions to make code more readable and consistent.

Later will add ext_ramdisk_image/size in those functions to support
loading ramdisk above 4g.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-16-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 8e35692..83b3861 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -294,12 +294,25 @@ static void __init reserve_brk(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
+static u64 __init get_ramdisk_image(void)
+{
+	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
+
+	return ramdisk_image;
+}
+static u64 __init get_ramdisk_size(void)
+{
+	u64 ramdisk_size = boot_params.hdr.ramdisk_size;
+
+	return ramdisk_size;
+}
+
 #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
 static void __init relocate_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
-	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_image = get_ramdisk_image();
+	u64 ramdisk_size  = get_ramdisk_size();
 	u64 area_size     = PAGE_ALIGN(ramdisk_size);
 	u64 ramdisk_here;
 	unsigned long slop, clen, mapaddr;
@@ -338,8 +351,8 @@ static void __init relocate_initrd(void)
 		ramdisk_size  -= clen;
 	}
 
-	ramdisk_image = boot_params.hdr.ramdisk_image;
-	ramdisk_size  = boot_params.hdr.ramdisk_size;
+	ramdisk_image = get_ramdisk_image();
+	ramdisk_size  = get_ramdisk_size();
 	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
 		" [mem %#010llx-%#010llx]\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
@@ -363,8 +376,8 @@ static u64 __init get_mem_size(unsigned long limit_pfn)
 static void __init early_reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
-	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_image = get_ramdisk_image();
+	u64 ramdisk_size  = get_ramdisk_size();
 	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 
 	if (!boot_params.hdr.type_of_loader ||
@@ -376,8 +389,8 @@ static void __init early_reserve_initrd(void)
 static void __init reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
-	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_image = get_ramdisk_image();
+	u64 ramdisk_size  = get_ramdisk_size();
 	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 	u64 mapped_size;
 
