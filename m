Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab3HGDs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 23:48:27 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:51296 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab3HGDpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 23:45:22 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 01/17] EFI stub documentation updates
Date: Tue,  6 Aug 2013 20:44:57 -0700
Message-Id: <1375847113-24884-2-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM kernel also has an EFI stub which works largely the same way
as the x86 stub, so move the documentation out of x86 directory and
update to reflect that it is generic, and add ARM specific text.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 Documentation/efi-stub.txt     |   78 ++++++++++++++++++++++++++++++++++++++++
 Documentation/x86/efi-stub.txt |   65 ---------------------------------
 arch/x86/Kconfig               |    2 +-
 3 files changed, 79 insertions(+), 66 deletions(-)
 create mode 100644 Documentation/efi-stub.txt
 delete mode 100644 Documentation/x86/efi-stub.txt

diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
new file mode 100644
index 0000000..19e897c
--- /dev/null
+++ b/Documentation/efi-stub.txt
@@ -0,0 +1,78 @@
+			  The EFI Boot Stub
+		     ---------------------------
+
+On the x86 and ARM platforms, a kernel zImage/bzImage can masquerade
+as a PE/COFF image, thereby convincing EFI firmware loaders to load
+it as an EFI executable. The code that modifies the bzImage header,
+along with the EFI-specific entry point that the firmware loader
+jumps to are collectively known as the "EFI boot stub", and live in
+arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
+respectively.  For ARM the EFI stub is implemented in
+arch/arm/boot/compressed/efi-header.S and
+arch/arm/boot/compressed/efi-stub.c.  EFI stub code that is shared
+between architectures is in drivers/firmware/efi/efi-stub-helper.c.
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
+because EFI firmware doesn't have support for them.  For ARM the
+arch/arm/boot/zImage should be copied to the system partition, and it
+may not need to be renamed.
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
+
+
+**** The "dtb=" option
+
+For the ARM architecture, we also need to be able to provide a device
+tree to the kernel.  This is done with the "dtb=" command line option,
+and is process in the same manner as the "initrd=" option that is described
+above.
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

