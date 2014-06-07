Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaFGQeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 12:34:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45842 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaFGQeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 12:34:08 -0400
Date: Sat, 7 Jun 2014 09:33:36 -0700
From: tip-bot for Matt Fleming <tipbot@zytor.com>
Message-ID: <tip-745c51673e289acf4d9ffc2835524de73ef923fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dyoung@redhat.com, tglx@linutronix.de, vgoyal@redhat.com,
        matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dyoung@redhat.com, matt.fleming@intel.com,
        vgoyal@redhat.com
In-Reply-To: <1402140380-15377-1-git-send-email-matt@console-pimps.org>
References: <1402140380-15377-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/boot:
  EFI_MIXED should not prohibit loading above 4G
Git-Commit-ID: 745c51673e289acf4d9ffc2835524de73ef923fd
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

Commit-ID:  745c51673e289acf4d9ffc2835524de73ef923fd
Gitweb:     http://git.kernel.org/tip/745c51673e289acf4d9ffc2835524de73ef923fd
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Sat, 7 Jun 2014 12:26:20 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 7 Jun 2014 09:31:00 -0700

x86/boot: EFI_MIXED should not prohibit loading above 4G

commit 7d453eee36ae ("x86/efi: Wire up CONFIG_EFI_MIXED") introduced a
regression for the functionality to load kernels above 4G. The relevant
(incorrect) reasoning behind this change can be seen in the commit
message,

  "The xloadflags field in the bzImage header is also updated to reflect
  that the kernel supports both entry points by setting both of
  XLF_EFI_HANDOVER_32 and XLF_EFI_HANDOVER_64 when CONFIG_EFI_MIXED=y.
  XLF_CAN_BE_LOADED_ABOVE_4G is disabled so that the kernel text is
  guaranteed to be addressable with 32-bits."

This is obviously bogus since 32-bit EFI loaders will never place the
kernel above the 4G mark. So this restriction is entirely unnecessary.

But things are worse than that - since we want to encourage people to
always compile with CONFIG_EFI_MIXED=y so that their kernels work out of
the box for both 32-bit and 64-bit firmware, commit 7d453eee36ae
effectively disables XLF_CAN_BE_LOADED_ABOVE_4G completely.

Remove the overzealous and superfluous restriction and restore the
XLF_CAN_BE_LOADED_ABOVE_4G functionality.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1402140380-15377-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/header.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 0ca9a5c..84c2234 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -375,8 +375,7 @@ xloadflags:
 # define XLF0 0
 #endif
 
-#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64) && \
-	!defined(CONFIG_EFI_MIXED)
+#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64)
    /* kernel/boot_param/ramdisk could be loaded above 4g */
 # define XLF1 XLF_CAN_BE_LOADED_ABOVE_4G
 #else
