Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab3IQEQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 00:16:00 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55737 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3IQELs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 00:11:48 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 01/17] EFI stub documentation updates
Date: Mon, 16 Sep 2013 21:11:17 -0700
Message-Id: <1379391093-27948-2-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move efi-stub.txt out of x86 directory and into common directory
in preparation for adding ARM EFI stub support.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 Documentation/efi-stub.txt     |   65 ++++++++++++++++++++++++++++++++++++++++
 Documentation/x86/efi-stub.txt |   65 ----------------------------------------
 arch/x86/Kconfig               |    2 +-
 3 files changed, 66 insertions(+), 66 deletions(-)
 create mode 100644 Documentation/efi-stub.txt
 delete mode 100644 Documentation/x86/efi-stub.txt

diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
new file mode 100644
index 0000000..44e6bb6
--- /dev/null
+++ b/Documentation/efi-stub.txt
@@ -0,0 +1,65 @@
+			  The EFI Boot Stub
+		     ---------------------------
+
+On the x86 platform, a bzImage can masquerade as a PE/COFF image,
+thereby convincing EFI firmware loaders to load it as an EFI
+executable. The code that modifies the bzImage header, along with the
+EFI-specific entry point that the firmware loader jumps to are
+collectively known as the "EFI boot stub", and live in
+arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
+respectively.
+
+By using the EFI boot stub it's possible to boot a Linux kernel
+without the use of a conventional EFI boot loader, such as grub or
+elilo. Since the EFI boot stub performs the jobs of a boot loader, in
+a certain sense it *IS* the boot loader.
+
+The EFI boot stub is enabled with the CONFIG_EFI_STUB kernel option.
+
+
+**** How to install bzImage.efi
+
+The bzImage located in arch/x86/boot/bzImage must be copied to the EFI
+System Partiion (ESP) and renamed with the extension ".efi". Without
+the extension the EFI firmware loader will refuse to execute it. It's
+not possible to execute bzImage.efi from the usual Linux file systems
+because EFI firmware doesn't have support for them.
+
+
+**** Passing kernel parameters from the EFI shell
+
+Arguments to the kernel can be passed after bzImage.efi, e.g.
+
+	fs0:> bzImage.efi console=ttyS0 root=/dev/sda4
+
+
+**** The "initrd=" option
+
+Like most boot loaders, the EFI stub allows the user to specify
+multiple initrd files using the "initrd=" option. This is the only EFI
+stub-specific command line parameter, everything else is passed to the
+kernel when it boots.
+
+The path to the initrd file must be an absolute path from the
+beginning of the ESP, relative path names do not work. Also, the path
+is an EFI-style path and directory elements must be separated with
+backslashes (\). For example, given the following directory layout,
+
+fs0:>
+	Kernels\
+			bzImage.efi
+			initrd-large.img
+
+	Ramdisks\
+			initrd-small.img
+			initrd-medium.img
+
+to boot with the initrd-large.img file if the current working
+directory is fs0:\Kernels, the following command must be used,
+
+	fs0:\Kernels> bzImage.efi initrd=\Kernels\initrd-large.img
+
+Notice how bzImage.efi can be specified with a relative path. That's
+because the image we're executing is interpreted by the EFI shell,
+which understands relative paths, whereas the rest of the command line
+is passed to bzImage.efi.
diff --git a/Documentation/x86/efi-stub.txt b/Documentation/x86/efi-stub.txt
deleted file mode 100644
index 44e6bb6..0000000
--- a/Documentation/x86/efi-stub.txt
+++ /dev/null
@@ -1,65 +0,0 @@
-			  The EFI Boot Stub
-		     ---------------------------
-
-On the x86 platform, a bzImage can masquerade as a PE/COFF image,
-thereby convincing EFI firmware loaders to load it as an EFI
-executable. The code that modifies the bzImage header, along with the
-EFI-specific entry point that the firmware loader jumps to are
-collectively known as the "EFI boot stub", and live in
-arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
-respectively.
-
-By using the EFI boot stub it's possible to boot a Linux kernel
-without the use of a conventional EFI boot loader, such as grub or
-elilo. Since the EFI boot stub performs the jobs of a boot loader, in
-a certain sense it *IS* the boot loader.
-
-The EFI boot stub is enabled with the CONFIG_EFI_STUB kernel option.
-
-
-**** How to install bzImage.efi
-
-The bzImage located in arch/x86/boot/bzImage must be copied to the EFI
-System Partiion (ESP) and renamed with the extension ".efi". Without
-the extension the EFI firmware loader will refuse to execute it. It's
-not possible to execute bzImage.efi from the usual Linux file systems
-because EFI firmware doesn't have support for them.
-
-
-**** Passing kernel parameters from the EFI shell
-
-Arguments to the kernel can be passed after bzImage.efi, e.g.
-
-	fs0:> bzImage.efi console=ttyS0 root=/dev/sda4
-
-
-**** The "initrd=" option
-
-Like most boot loaders, the EFI stub allows the user to specify
-multiple initrd files using the "initrd=" option. This is the only EFI
-stub-specific command line parameter, everything else is passed to the
-kernel when it boots.
-
-The path to the initrd file must be an absolute path from the
-beginning of the ESP, relative path names do not work. Also, the path
-is an EFI-style path and directory elements must be separated with
-backslashes (\). For example, given the following directory layout,
-
-fs0:>
-	Kernels\
-			bzImage.efi
-			initrd-large.img
-
-	Ramdisks\
-			initrd-small.img
-			initrd-medium.img
-
-to boot with the initrd-large.img file if the current working
-directory is fs0:\Kernels, the following command must be used,
-
-	fs0:\Kernels> bzImage.efi initrd=\Kernels\initrd-large.img
-
-Notice how bzImage.efi can be specified with a relative path. That's
-because the image we're executing is interpreted by the EFI shell,
-which understands relative paths, whereas the rest of the command line
-is passed to bzImage.efi.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..ec65b51 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1579,7 +1579,7 @@ config EFI_STUB
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
 
-	  See Documentation/x86/efi-stub.txt for more information.
+	  See Documentation/efi-stub.txt for more information.
 
 config SECCOMP
 	def_bool y
-- 
1.7.10.4

