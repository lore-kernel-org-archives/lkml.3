Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3AXUYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:24:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50748 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab3AXUW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:22:26 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH 31/35] x86: Merge early kernel reserve for 32bit and 64bit
Date: Thu, 24 Jan 2013 12:20:12 -0800
Message-Id: <1359058816-7615-32-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are the same, and we could move them out from head32/64.c to setup.c.

We are using memblock, and it could handle overlapping properly, so
we don't need to reserve some at first to hold the location, and just
need to make sure we reserve them before we are using memblock to find
free mem to use.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
---
 arch/x86/kernel/head32.c |    9 ---------
 arch/x86/kernel/head64.c |    9 ---------
 arch/x86/kernel/setup.c  |    9 +++++++++
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index b071d41..17f7792 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -30,9 +30,6 @@ static void __init i386_default_early_setup(void)
 
 void __init i386_start_kernel(void)
 {
-	memblock_reserve(__pa_symbol(_text),
-			 (unsigned long)__bss_stop - (unsigned long)_text);
-
 	/* Call the subarch specific early setup function */
 	switch (boot_params.hdr.hardware_subarch) {
 	case X86_SUBARCH_MRST:
@@ -46,11 +43,5 @@ void __init i386_start_kernel(void)
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
index e63d29a..d9d7c75 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -184,16 +184,7 @@ void __init x86_64_start_reservations(char *real_mode_data)
 	if (!boot_params.hdr.version)
 		copy_bootdata(__va(real_mode_data));
 
-	memblock_reserve(__pa_symbol(_text),
-			 (unsigned long)__bss_stop - (unsigned long)_text);
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
index 4d6179f..be6e435 100644
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
-- 
1.7.10.4

