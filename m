Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaHDXbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 19:31:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaHDXbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 19:31:39 -0400
Date: Mon, 4 Aug 2014 16:31:14 -0700
From: tip-bot for Matt Fleming <tipbot@zytor.com>
Message-ID: <tip-b16d8c231e4d03fefc7de1b8b62bad5659ee8070@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de,
        matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, matt.fleming@intel.com, bp@suse.de,
        hpa@linux.intel.com
In-Reply-To: <1407193939-27813-1-git-send-email-matt@console-pimps.org>
References: <1407193939-27813-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86/efi:
  Fix 3DNow optimization build failure in EFI stub
Git-Commit-ID: b16d8c231e4d03fefc7de1b8b62bad5659ee8070
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b16d8c231e4d03fefc7de1b8b62bad5659ee8070
Gitweb:     http://git.kernel.org/tip/b16d8c231e4d03fefc7de1b8b62bad5659ee8070
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Tue, 5 Aug 2014 00:12:19 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 4 Aug 2014 16:26:46 -0700

x86/efi: Fix 3DNow optimization build failure in EFI stub

Building a 32-bit kernel with CONFIG_X86_USE_3DNOW and CONFIG_EFI_STUB
leads to the following build error,

  drivers/firmware/efi/libstub/lib.a(efi-stub-helper.o): In function `efi_relocate_kernel':
  efi-stub-helper.c:(.text+0xda5): undefined reference to `_mmx_memcpy'

This is due to the fact that the EFI boot stub pulls in the 3DNow
optimized versions of the memcpy() prototype from
arch/x86/include/asm/string_32.h, even though the _mmx_memcpy()
implementation isn't available in the EFI stub.

For now, predicate CONFIG_EFI_STUB on !CONFIG_X86_USE_3DNOW. This is
most definitely a temporary fix. A complete solution will involve
selectively including kernel headers/symbols into the early-boot
execution environment of the EFI boot stub, i.e. something analogous to
the way that the _SETUP symbol is used.

Previous attempts have been made to fix this kind of problem, though
none seem to have ever been merged,

  http://lkml.kernel.org/r/20120329104822.GA17233@x1.osrc.amd.com

Clearly, this problem has been around for a long time.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1407193939-27813-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 801ed36..7ea8aaa 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1536,7 +1536,7 @@ config EFI
 
 config EFI_STUB
        bool "EFI stub support"
-       depends on EFI
+       depends on EFI && !X86_USE_3DNOW
        ---help---
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
