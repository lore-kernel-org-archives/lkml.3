Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3JaQ2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:28:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49584 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab3JaQZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:25:21 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: [PATCH 11/11] efi: Check krealloc return value
Date: Thu, 31 Oct 2013 17:25:09 +0100
Message-Id: <1383236709-19716-12-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383236709-19716-1-git-send-email-bp@alien8.de>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Check it just in case. We might just as well panic there because runtime
won't be functioning anyway.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b453069236fd..3fac4dee492f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -860,6 +860,9 @@ void __init efi_enter_virtual_mode(void)
 		new_memmap = krealloc(new_memmap,
 				      (count + 1) * memmap.desc_size,
 				      GFP_KERNEL);
+		if (!new_memmap)
+			goto err_out;
+
 		memcpy(new_memmap + (count * memmap.desc_size), md,
 		       memmap.desc_size);
 		count++;
@@ -914,6 +917,11 @@ void __init efi_enter_virtual_mode(void)
 			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
 			 EFI_VARIABLE_RUNTIME_ACCESS,
 			 0, NULL);
+
+	return;
+
+ err_out:
+	pr_err("Error reallocating memory, EFI runtime non-functional!\n");
 }
 
 /*
-- 
1.8.4

