Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaHDWwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:52:21 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41333 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaHDWwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:52:19 -0400
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86/efi: Fix 3DNow optimization build failure in EFI stub
Date: Mon,  4 Aug 2014 23:52:15 +0100
Message-Id: <1407192735-26368-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Building a 32-bit kernel with CONFIG_X86_USE_3DNOW and CONFIG_EFI_STUB
leads to the following build error,

  drivers/firmware/efi/libstub/lib.a(efi-stub-helper.o): In function `efi_relocate_kernel':
  efi-stub-helper.c:(.text+0xda5): undefined reference to `_mmx_memcpy'

This is due to the fact that the EFI boot stub pulls in the 3DNow
optimized versions of the memcpy() prototype from
arch/x86/include/asm/string_32.h, even though the _mmx_memcpy()
implementation isn't available in the EFI stub.

For now, predicate CONFIG_EFI on !CONFIG_X86_USE_3DNOW. This is most
definitely a temporary fix. A complete solution will involve selectively
including kernel headers/symbols into the early-boot execution
environment of the EFI boot stub, i.e. something analogous to the way
that the _SETUP symbol is used.

Previous attempts have been made to fix this kind of problem, though
none seem to have ever been merged,

  http://lkml.kernel.org/r/20120329104822.GA17233@x1.osrc.amd.com

Clearly, this problem has been around for a long time.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 801ed36c2e49..fcad2e15e92a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1520,7 +1520,7 @@ config X86_SMAP
 
 config EFI
 	bool "EFI runtime service support"
-	depends on ACPI
+	depends on ACPI && !X86_USE_3DNOW
 	select UCS2_STRING
 	select EFI_RUNTIME_WRAPPERS
 	---help---
-- 
1.9.0

