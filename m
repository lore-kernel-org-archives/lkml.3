Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3A3DyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:54:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44910 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3A3DyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:54:11 -0500
Date: Tue, 29 Jan 2013 19:53:59 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-6c902b656c4a808d9c6f40a387b166455efecd62@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, alexander.h.duyck@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, alexander.h.duyck@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1359058816-7615-32-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-32-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86: Merge early kernel reserve for 32bit and 64bit
Git-Commit-ID: 6c902b656c4a808d9c6f40a387b166455efecd62
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 19:54:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c902b656c4a808d9c6f40a387b166455efecd62
Gitweb:     http://git.kernel.org/tip/6c902b656c4a808d9c6f40a387b166455efecd62
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:12 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 19:32:58 -0800

x86: Merge early kernel reserve for 32bit and 64bit

They are the same, and we could move them out from head32/64.c to setup.c.

We are using memblock, and it could handle overlapping properly, so
we don't need to reserve some at first to hold the location, and just
need to make sure we reserve them before we are using memblock to find
free mem to use.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-32-git-send-email-yinghai@kernel.org
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head32.c | 9 ---------
 arch/x86/kernel/head64.c | 9 ---------
 arch/x86/kernel/setup.c  | 9 +++++++++
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index a795b54..138463a 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -33,9 +33,6 @@ void __init i386_start_kernel(void)
 {
 	sanitize_boot_params(&boot_params);
 
-	memblock_reserve(__pa_symbol(&_text),
-			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
-
 	/* Call the subarch specific early setup function */
 	switch (boot_params.hdr.hardware_subarch) {
 	case X86_SUBARCH_MRST:
@@ -49,11 +46,5 @@ void __init i386_start_kernel(void)
 		break;
 	}
 
-	/*
-	 * At this point everything still needed from the boot loader
-	 * or BIOS or kernel text should be early reserved or marked not
-	 * RAM in e820. All other memory is free game.
-	 */
-
 	start_kernel();
 }
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 6873b07..57334f4 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -186,16 +186,7 @@ void __init x86_64_start_reservations(char *real_mode_data)
 	if (!boot_params.hdr.version)
 		copy_bootdata(__va(real_mode_data));
 
-	memblock_reserve(__pa_symbol(&_text),
-			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
-
 	reserve_ebda_region();
 
-	/*
-	 * At this point everything still needed from the boot loader
-	 * or BIOS or kernel text should be early reserved or marked not
-	 * RAM in e820. All other memory is free game.
-	 */
-
 	start_kernel();
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5dc47c3..a74701a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -805,8 +805,17 @@ early_param("reservelow", parse_reservelow);
 
 void __init setup_arch(char **cmdline_p)
 {
+	memblock_reserve(__pa_symbol(_text),
+			 (unsigned long)__bss_stop - (unsigned long)_text);
+
 	early_reserve_initrd();
 
+	/*
+	 * At this point everything still needed from the boot loader
+	 * or BIOS or kernel text should be early reserved or marked not
+	 * RAM in e820. All other memory is free game.
+	 */
+
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
