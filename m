Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3KYJE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:04:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab3KYJC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:02:58 -0500
Message-Id: <20131125090037.951515290@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 16:56:38 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com,
        Dave Young <dyoung@redhat.com>
Subject: [patch 08/12 v4] x86: add xloadflags bit for efi runtime support on kexec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
References: <20131125085630.417850406@dhcp-16-126.nay.redhat.com>
Content-Disposition: inline; filename=08-add-xloadflags-for-kexec-efi-runtime-feature.patch

Old kexec-tools can not load new kernel. The reason is previously kexec-tools
do not fill efi_info in x86 setup header thus efi init fail and switch
to noefi boot. In new kexec-tools it will by default fill efi_info and
pass other efi required infomation to 2nd kernel so kexec kernel efi
initialization will success finally.

To prevent from breaking userspace, add a new xloadflags bit so kexec-tools
will check the flag and switch to old logic.

changelog:
Matt: +&& defined(CONFIG_KEXEC)
HPA: document the flag.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 Documentation/x86/boot.txt            |    3 +++
 arch/x86/boot/header.S                |    9 ++++++++-
 arch/x86/include/uapi/asm/bootparam.h |    1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

--- efi.orig/arch/x86/boot/header.S
+++ efi/arch/x86/boot/header.S
@@ -391,7 +391,14 @@ xloadflags:
 #else
 # define XLF23 0
 #endif
-			.word XLF0 | XLF1 | XLF23
+
+#if defined(CONFIG_X86_64) && defined(CONFIG_EFI) && defined(CONFIG_KEXEC)
+# define XLF4 XLF_EFI_KEXEC
+#else
+# define XLF4 0
+#endif
+
+			.word XLF0 | XLF1 | XLF23 | XLF4
 
 cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
                                                 #added with boot protocol
--- efi.orig/arch/x86/include/uapi/asm/bootparam.h
+++ efi/arch/x86/include/uapi/asm/bootparam.h
@@ -24,6 +24,7 @@
 #define XLF_CAN_BE_LOADED_ABOVE_4G	(1<<1)
 #define XLF_EFI_HANDOVER_32		(1<<2)
 #define XLF_EFI_HANDOVER_64		(1<<3)
+#define XLF_EFI_KEXEC			(1<<4)
 
 #ifndef __ASSEMBLY__
 
--- efi.orig/Documentation/x86/boot.txt
+++ efi/Documentation/x86/boot.txt
@@ -608,6 +608,9 @@ Protocol:       2.12+
 	- If 1, the kernel supports the 64-bit EFI handoff entry point
           given at handover_offset + 0x200.
 
+  Bit 4 (read): XLF_EFI_KEXEC
+	- If 1, the kernel supports kexec EFI boot with EFI runtime support.
+
 Field name:	cmdline_size
 Type:		read
 Offset/size:	0x238/4

