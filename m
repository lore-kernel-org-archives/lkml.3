Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3FNVbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:31:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3FNVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:31:31 -0400
Date: Fri, 14 Jun 2013 14:30:57 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-d9518cb78d6d5ee6b24eb7ee2f4b108ec30e174e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tj@kernel.org, tangchen@cn.fujitsu.com,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tangchen@cn.fujitsu.com,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com
In-Reply-To: <1371128589-8953-2-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-2-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Change get_ramdisk_{image|size}() to global
Git-Commit-ID: d9518cb78d6d5ee6b24eb7ee2f4b108ec30e174e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:31:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9518cb78d6d5ee6b24eb7ee2f4b108ec30e174e
Gitweb:     http://git.kernel.org/tip/d9518cb78d6d5ee6b24eb7ee2f4b108ec30e174e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:02:48 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:03:26 -0700

x86: Change get_ramdisk_{image|size}() to global

This patch does two things:
1. Change get_ramdisk_image() and get_ramdisk_size() to global.
2. Make get_ramdisk_image() and get_ramdisk_size() take a
   boot_params pointer parameter.

The whole patch-set tries to split ACPI initrd table override
procedure into two steps: finding and copying.
The finding step is done at head_32.S and head64.c stage. So we
need to call get_ramdisk_image() and get_ramdisk_size() in these
two files.

And also, in head_32.S, it can only access boot_params via physical
address during 32bit flat mode, so make get_ramdisk_image() and
get_ramdisk_size() take a boot_params pointer, so that we can pass
a physical address to code in head_32.S.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-2-git-send-email-tangchen@cn.fujitsu.com
Acked-by: Tejun Heo <tj@kernel.org>
Tested-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index 56f7fcf..66ab495 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -297,19 +297,19 @@ static void __init reserve_brk(void)
 
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
@@ -318,8 +318,8 @@ static u64 __init get_ramdisk_size(void)
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
@@ -358,8 +358,8 @@ static void __init relocate_initrd(void)
 		ramdisk_size  -= clen;
 	}
 
-	ramdisk_image = get_ramdisk_image();
-	ramdisk_size  = get_ramdisk_size();
+	ramdisk_image = get_ramdisk_image(&boot_params);
+	ramdisk_size  = get_ramdisk_size(&boot_params);
 	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
 		" [mem %#010llx-%#010llx]\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
@@ -369,8 +369,8 @@ static void __init relocate_initrd(void)
 static void __init early_reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = get_ramdisk_image();
-	u64 ramdisk_size  = get_ramdisk_size();
+	u64 ramdisk_image = get_ramdisk_image(&boot_params);
+	u64 ramdisk_size  = get_ramdisk_size(&boot_params);
 	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 
 	if (!boot_params.hdr.type_of_loader ||
@@ -382,8 +382,8 @@ static void __init early_reserve_initrd(void)
 static void __init reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
-	u64 ramdisk_image = get_ramdisk_image();
-	u64 ramdisk_size  = get_ramdisk_size();
+	u64 ramdisk_image = get_ramdisk_image(&boot_params);
+	u64 ramdisk_size  = get_ramdisk_size(&boot_params);
 	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 	u64 mapped_size;
 
