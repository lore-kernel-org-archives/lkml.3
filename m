Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3A3BdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:33:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43753 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3A3BdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:33:03 -0500
Date: Tue, 29 Jan 2013 17:32:52 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-1b8c78be01203e1c95ec5dfef6db307796fe0bc7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1359058816-7615-15-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-15-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86: Merge early_reserve_initrd for 32bit and 64bit
Git-Commit-ID: 1b8c78be01203e1c95ec5dfef6db307796fe0bc7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:32:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b8c78be01203e1c95ec5dfef6db307796fe0bc7
Gitweb:     http://git.kernel.org/tip/1b8c78be01203e1c95ec5dfef6db307796fe0bc7
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:55 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:20:41 -0800

x86: Merge early_reserve_initrd for 32bit and 64bit

They are the same, could move them out from head32/64.c to setup.c.

We are using memblock, and it could handle overlapping properly, so
we don't need to reserve some at first to hold the location, and just
need to make sure we reserve them before we are using memblock to find
free mem to use.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-15-git-send-email-yinghai@kernel.org
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head32.c | 11 -----------
 arch/x86/kernel/head64.c | 11 -----------
 arch/x86/kernel/setup.c  | 22 ++++++++++++++++++----
 3 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 6773c91..a795b54 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -36,17 +36,6 @@ void __init i386_start_kernel(void)
 	memblock_reserve(__pa_symbol(&_text),
 			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
 
-#ifdef CONFIG_BLK_DEV_INITRD
-	/* Reserve INITRD */
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
-		/* Assume only end is not page aligned */
-		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
-		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-		u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-		memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
-	}
-#endif
-
 	/* Call the subarch specific early setup function */
 	switch (boot_params.hdr.hardware_subarch) {
 	case X86_SUBARCH_MRST:
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index f3b1968..b88a1fa 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -178,17 +178,6 @@ void __init x86_64_start_reservations(char *real_mode_data)
 	memblock_reserve(__pa_symbol(&_text),
 			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
 
-#ifdef CONFIG_BLK_DEV_INITRD
-	/* Reserve INITRD */
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
-		/* Assume only end is not page aligned */
-		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
-		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-		unsigned long ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-		memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
-	}
-#endif
-
 	reserve_ebda_region();
 
 	/*
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d58083a..8e35692 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -360,6 +360,19 @@ static u64 __init get_mem_size(unsigned long limit_pfn)
 
 	return mapped_pages << PAGE_SHIFT;
 }
+static void __init early_reserve_initrd(void)
+{
+	/* Assume only end is not page aligned */
+	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
+	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
+
+	if (!boot_params.hdr.type_of_loader ||
+	    !ramdisk_image || !ramdisk_size)
+		return;		/* No initrd provided by bootloader */
+
+	memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
+}
 static void __init reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
@@ -386,10 +399,6 @@ static void __init reserve_initrd(void)
 	if (pfn_range_is_mapped(PFN_DOWN(ramdisk_image),
 				PFN_DOWN(ramdisk_end))) {
 		/* All are mapped, easy case */
-		/*
-		 * don't need to reserve again, already reserved early
-		 * in i386_start_kernel
-		 */
 		initrd_start = ramdisk_image + PAGE_OFFSET;
 		initrd_end = initrd_start + ramdisk_size;
 		return;
@@ -400,6 +409,9 @@ static void __init reserve_initrd(void)
 	memblock_free(ramdisk_image, ramdisk_end - ramdisk_image);
 }
 #else
+static void __init early_reserve_initrd(void)
+{
+}
 static void __init reserve_initrd(void)
 {
 }
@@ -760,6 +772,8 @@ early_param("reservelow", parse_reservelow);
 
 void __init setup_arch(char **cmdline_p)
 {
+	early_reserve_initrd();
+
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
