Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab3A1Ec2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:32:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37004 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab3A1Ec1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:32:27 -0500
Date: Sun, 27 Jan 2013 20:32:15 -0800
From: tip-bot for David Woodhouse <David.Woodhouse@intel.com>
Message-ID: <tip-b607e2126705ca28ecf21aa051172882bbdaae8a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        matt.fleming@intel.com, stable@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com, David.Woodhouse@intel.com
In-Reply-To: <1358513837.2397.247.camel@shinybook.infradead.org>
References: <1358513837.2397.247.camel@shinybook.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Fix PCI ROM handing in EFI boot stub,
  in 32-bit mode
Git-Commit-ID: b607e2126705ca28ecf21aa051172882bbdaae8a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 27 Jan 2013 20:32:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b607e2126705ca28ecf21aa051172882bbdaae8a
Gitweb:     http://git.kernel.org/tip/b607e2126705ca28ecf21aa051172882bbdaae8a
Author:     David Woodhouse <David.Woodhouse@intel.com>
AuthorDate: Mon, 7 Jan 2013 22:09:49 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 27 Jan 2013 20:19:37 -0800

x86, efi: Fix PCI ROM handing in EFI boot stub, in 32-bit mode

The 'Attributes' argument to pci->Attributes() function is 64-bit. So
when invoking in 32-bit mode it takes two registers, not just one.

This fixes memory corruption when booting via the 32-bit EFI boot stub.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/1358513837.2397.247.camel@shinybook.infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 448a86e..b7f2208 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -295,10 +295,15 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		if (!pci)
 			continue;
 
+#ifdef CONFIG_X86_64
 		status = efi_call_phys4(pci->attributes, pci,
 					EfiPciIoAttributeOperationGet, 0,
 					&attributes);
-
+#else
+		status = efi_call_phys5(pci->attributes, pci,
+					EfiPciIoAttributeOperationGet, 0, 0,
+					&attributes);
+#endif
 		if (status != EFI_SUCCESS)
 			continue;
 
