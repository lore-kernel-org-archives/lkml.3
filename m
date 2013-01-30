Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab3A3Dsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:48:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44830 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3A3Ds2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:48:28 -0500
Date: Tue, 29 Jan 2013 19:48:12 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-8ee2f2dfdbdfe1851fcc0191b2d4faa4c26a39fb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, matt.fleming@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, rob@landley.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com, rob@landley.net
In-Reply-To: <1359058816-7615-27-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-27-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, boot:
  Update comments about entries for 64bit image
Git-Commit-ID: 8ee2f2dfdbdfe1851fcc0191b2d4faa4c26a39fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 19:48:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ee2f2dfdbdfe1851fcc0191b2d4faa4c26a39fb
Gitweb:     http://git.kernel.org/tip/8ee2f2dfdbdfe1851fcc0191b2d4faa4c26a39fb
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:07 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 19:32:57 -0800

x86, boot: Update comments about entries for 64bit image

Now 64bit entry is fixed on 0x200, can not be changed anymore.

Update the comments to reflect that.

Also put info about it in boot.txt

-v2: fix some grammar error

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-27-git-send-email-yinghai@kernel.org
Cc: Rob Landley <rob@landley.net>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/x86/boot.txt         | 38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/head_64.S | 22 +++++++++++++---------
 2 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 3edb4c2..0e38316 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -1054,6 +1054,44 @@ must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
 must be __BOOT_DS; interrupt must be disabled; %esi must hold the base
 address of the struct boot_params; %ebp, %edi and %ebx must be zero.
 
+**** 64-bit BOOT PROTOCOL
+
+For machine with 64bit cpus and 64bit kernel, we could use 64bit bootloader
+and we need a 64-bit boot protocol.
+
+In 64-bit boot protocol, the first step in loading a Linux kernel
+should be to setup the boot parameters (struct boot_params,
+traditionally known as "zero page"). The memory for struct boot_params
+could be allocated anywhere (even above 4G) and initialized to all zero.
+Then, the setup header at offset 0x01f1 of kernel image on should be
+loaded into struct boot_params and examined. The end of setup header
+can be calculated as follows:
+
+	0x0202 + byte value at offset 0x0201
+
+In addition to read/modify/write the setup header of the struct
+boot_params as that of 16-bit boot protocol, the boot loader should
+also fill the additional fields of the struct boot_params as described
+in zero-page.txt.
+
+After setting up the struct boot_params, the boot loader can load
+64-bit kernel in the same way as that of 16-bit boot protocol, but
+kernel could be loaded above 4G.
+
+In 64-bit boot protocol, the kernel is started by jumping to the
+64-bit kernel entry point, which is the start address of loaded
+64-bit kernel plus 0x200.
+
+At entry, the CPU must be in 64-bit mode with paging enabled.
+The range with setup_header.init_size from start address of loaded
+kernel and zero page and command line buffer get ident mapping;
+a GDT must be loaded with the descriptors for selectors
+__BOOT_CS(0x10) and __BOOT_DS(0x18); both descriptors must be 4G flat
+segment; __BOOT_CS must have execute/read permission, and __BOOT_DS
+must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
+must be __BOOT_DS; interrupt must be disabled; %rsi must hold the base
+address of the struct boot_params.
+
 **** EFI HANDOVER PROTOCOL
 
 This protocol allows boot loaders to defer initialisation to the EFI
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 5c80b94..d9ae9a4 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -37,6 +37,12 @@
 	__HEAD
 	.code32
 ENTRY(startup_32)
+	/*
+	 * 32bit entry is 0 and it is ABI so immutable!
+	 * If we come here directly from a bootloader,
+	 * kernel(text+data+bss+brk) ramdisk, zero_page, command line
+	 * all need to be under the 4G limit.
+	 */
 	cld
 	/*
 	 * Test KEEP_SEGMENTS flag to see if the bootloader is asking
@@ -182,20 +188,18 @@ ENTRY(startup_32)
 	lret
 ENDPROC(startup_32)
 
-	/*
-	 * Be careful here startup_64 needs to be at a predictable
-	 * address so I can export it in an ELF header.  Bootloaders
-	 * should look at the ELF header to find this address, as
-	 * it may change in the future.
-	 */
 	.code64
 	.org 0x200
 ENTRY(startup_64)
 	/*
+	 * 64bit entry is 0x200 and it is ABI so immutable!
 	 * We come here either from startup_32 or directly from a
-	 * 64bit bootloader.  If we come here from a bootloader we depend on
-	 * an identity mapped page table being provied that maps our
-	 * entire text+data+bss and hopefully all of memory.
+	 * 64bit bootloader.
+	 * If we come here from a bootloader, kernel(text+data+bss+brk),
+	 * ramdisk, zero_page, command line could be above 4G.
+	 * We depend on an identity mapped page table being provided
+	 * that maps our entire kernel(text+data+bss+brk), zero page
+	 * and command line.
 	 */
 #ifdef CONFIG_EFI_STUB
 	/*
