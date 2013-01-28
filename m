Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab3A1Eb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:31:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36991 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3A1Eb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:31:26 -0500
Date: Sun, 27 Jan 2013 20:31:06 -0800
From: tip-bot for David Woodhouse <David.Woodhouse@intel.com>
Message-ID: <tip-f791620fa7517e1045742c475a7f005db9a634b8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        matt.fleming@intel.com, stable@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com, David.Woodhouse@intel.com
In-Reply-To: <1358513837.2397.247.camel@shinybook.infradead.org>
References: <1358513837.2397.247.camel@shinybook.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi:
  Fix 32-bit EFI handover protocol entry point
Git-Commit-ID: f791620fa7517e1045742c475a7f005db9a634b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 27 Jan 2013 20:31:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f791620fa7517e1045742c475a7f005db9a634b8
Gitweb:     http://git.kernel.org/tip/f791620fa7517e1045742c475a7f005db9a634b8
Author:     David Woodhouse <David.Woodhouse@intel.com>
AuthorDate: Mon, 7 Jan 2013 22:01:50 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 27 Jan 2013 20:19:37 -0800

x86, efi: Fix 32-bit EFI handover protocol entry point

If the bootloader calls the EFI handover entry point as a standard function
call, then it'll have a return address on the stack. We need to pop that
before calling efi_main(), or the arguments will all be out of position on
the stack.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/1358513837.2397.247.camel@shinybook.infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/head_32.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index aa4aaf1..ccb2f4a 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -50,8 +50,10 @@ ENTRY(startup_32)
 	pushl	%eax
 	pushl	%esi
 	pushl	%ecx
+	sub	$0x4, %esp
 
 	.org 0x30,0x90
+	add	$0x4, %esp
 	call	efi_main
 	cmpl	$0, %eax
 	movl	%eax, %esi
