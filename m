Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935119Ab3BNXdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:33:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57409 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935089Ab3BNXdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:33:06 -0500
Date: Thu, 14 Feb 2013 15:31:56 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-0y9dqmmsousf69wutxwl3kkf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm:
  Move reserving low memory later in initialization
Git-Commit-ID: 95c9608478d639dcffc14ea47b31bff021a99ed1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 14 Feb 2013 15:32:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95c9608478d639dcffc14ea47b31bff021a99ed1
Gitweb:     http://git.kernel.org/tip/95c9608478d639dcffc14ea47b31bff021a99ed1
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 14 Feb 2013 14:02:52 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 14 Feb 2013 15:21:25 -0800

x86, mm: Move reserving low memory later in initialization

Move the reservation of low memory, except for the 4K which actually
does belong to the BIOS, later in the initialization; in particular,
after we have already reserved the trampoline.

The current code locates the trampoline as high as possible, so by
deferring the allocation we will still be able to reserve as much
memory as is possible.  This allows us to run with reservelow=640k
without getting a crash on system startup.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/n/tip-0y9dqmmsousf69wutxwl3kkf@git.kernel.org
---
 arch/x86/kernel/setup.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 8354399..0aebd77 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -608,8 +608,6 @@ static __init void reserve_ibft_region(void)
 		memblock_reserve(addr, size);
 }
 
-static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
-
 static bool __init snb_gfx_workaround_needed(void)
 {
 #ifdef CONFIG_PCI
@@ -698,8 +696,7 @@ static void __init trim_bios_range(void)
 	 * since some BIOSes are known to corrupt low memory.  See the
 	 * Kconfig help text for X86_RESERVE_LOW.
 	 */
-	e820_update_range(0, ALIGN(reserve_low, PAGE_SIZE),
-			  E820_RAM, E820_RESERVED);
+	e820_update_range(0, PAGE_SIZE, E820_RAM, E820_RESERVED);
 
 	/*
 	 * special case: Some BIOSen report the PC BIOS
@@ -711,6 +708,8 @@ static void __init trim_bios_range(void)
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
+static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
+
 static int __init parse_reservelow(char *p)
 {
 	unsigned long long size;
@@ -733,6 +732,11 @@ static int __init parse_reservelow(char *p)
 
 early_param("reservelow", parse_reservelow);
 
+static void __init trim_low_memory_range(void)
+{
+	memblock_reserve(0, ALIGN(reserve_low, PAGE_SIZE));
+}
+	
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -987,6 +991,7 @@ void __init setup_arch(char **cmdline_p)
 	setup_real_mode();
 
 	trim_platform_memory_ranges();
+	trim_low_memory_range();
 
 	init_gbpages();
 
