Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3LPJdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:33:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab3LPJdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:33:42 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com, akpm@linux-foundation.org,
        mingo@kernel.org, msalter@redhat.com, leif.lindholm@linaro.org
Subject: [PATCH v6 11/14] x86: add xloadflags bit for efi runtime support on kexec
Date: Mon, 16 Dec 2013 17:30:32 +0800
Message-Id: <1387186235-15972-12-git-send-email-dyoung@redhat.com>
In-Reply-To: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old kexec-tools can not load new kernel. The reason is kexec-tools do not fill
efi_info in x86 setup header previously, thus efi failed to initialize.
In new kexec-tools it will by default fill efi_info and pass other efi required
infomation to 2nd kernel so kexec kernel efi initialization can succeed finally.

To prevent from breaking userspace, add a new xloadflags bit so kexec-tools
can check the flag and switch to old logic.

changelog:
Matt: +&& defined(CONFIG_KEXEC)
      improve patch description.
HPA: document the flag.

Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 Documentation/x86/boot.txt            | 3 +++
 arch/x86/boot/header.S                | 9 ++++++++-
 arch/x86/include/uapi/asm/bootparam.h | 1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index f4f268c..cb81741d 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -608,6 +608,9 @@ Protocol:       2.12+
 	- If 1, the kernel supports the 64-bit EFI handoff entry point
           given at handover_offset + 0x200.
 
+  Bit 4 (read): XLF_EFI_KEXEC
+	- If 1, the kernel supports kexec EFI boot with EFI runtime support.
+
 Field name:	cmdline_size
 Type:		read
 Offset/size:	0x238/4
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 9ec06a1..ec3b8ba 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
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
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index 64fe421..225b098 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -24,6 +24,7 @@
 #define XLF_CAN_BE_LOADED_ABOVE_4G	(1<<1)
 #define XLF_EFI_HANDOVER_32		(1<<2)
 #define XLF_EFI_HANDOVER_64		(1<<3)
+#define XLF_EFI_KEXEC			(1<<4)
 
 #ifndef __ASSEMBLY__
 
-- 
1.8.3.1

