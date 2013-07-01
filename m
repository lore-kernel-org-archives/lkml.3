Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3GAKlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:41:40 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:45646 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab3GAKli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:41:38 -0400
Date: Mon, 1 Jul 2013 12:41:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform changes for v3.11
Message-ID: <20130701104134.GA18454@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   HEAD: cb7b80237a9f41edf2ebd899bc6a443db05578c5 x86/platform: Make X86_GOLDFISH depend on X86_EXTENDED_PLATFORM

Two changes:

 - A Kconfig dependency fix/cleanup

 - Introduce the 'make kvmconfig' KVM configuration helper utility that 
   turns the current .config into a KVM-bootable config. Useful for 
   debugging specific native kernel configs that have no KVM config 
   options enabled on VM setups.

 Thanks,

	Ingo

------------------>
Ben Hutchings (1):
      x86/platform: Make X86_GOLDFISH depend on X86_EXTENDED_PLATFORM

Borislav Petkov (2):
      x86, platform, kvm, kconfig: Turn existing .config's into KVM-capable configs
      x86/platform: Add kvmconfig to the phony targets


 arch/x86/Kconfig                  |  2 ++
 arch/x86/Makefile                 |  7 +++++++
 arch/x86/configs/kvm_guest.config | 28 ++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+)
 create mode 100644 arch/x86/configs/kvm_guest.config

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 685692c..9359d23 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -336,6 +336,7 @@ config X86_EXTENDED_PLATFORM
 
 	  If you enable this option then you'll be able to select support
 	  for the following (non-PC) 32 bit x86 platforms:
+		Goldfish (Android emulator)
 		AMD Elan
 		NUMAQ (IBM/Sequent)
 		RDC R-321x SoC
@@ -410,6 +411,7 @@ config X86_UV
 config X86_GOLDFISH
        bool "Goldfish (Virtual Platform)"
        depends on X86_32
+       depends on X86_EXTENDED_PLATFORM
        ---help---
 	 Enable support for the Goldfish virtual platform used primarily
 	 for Android development. Unless you are building for the Android
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 5c47726..07639c6 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -220,6 +220,12 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=arch/x86/tools
 
+PHONY += kvmconfig
+kvmconfig:
+	$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config arch/x86/configs/kvm_guest.config
+	$(Q)yes "" | $(MAKE) oldconfig
+
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
   echo  '  install      - Install kernel using'
@@ -233,4 +239,5 @@ define archhelp
   echo  '                  bzdisk/fdimage*/isoimage also accept:'
   echo  '                  FDARGS="..."  arguments for the booted kernel'
   echo  '                  FDINITRD=file initrd for the booted kernel'
+  echo  '  kvmconfig	- Enable additional options for guest kernel support'
 endef
diff --git a/arch/x86/configs/kvm_guest.config b/arch/x86/configs/kvm_guest.config
new file mode 100644
index 0000000..f9affcc
--- /dev/null
+++ b/arch/x86/configs/kvm_guest.config
@@ -0,0 +1,28 @@
+CONFIG_NET=y
+CONFIG_NET_CORE=y
+CONFIG_NETDEVICES=y
+CONFIG_BLOCK=y
+CONFIG_BLK_DEV=y
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_INET=y
+CONFIG_TTY=y
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+CONFIG_BINFMT_ELF=y
+CONFIG_PCI=y
+CONFIG_PCI_MSI=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_VIRTUALIZATION=y
+CONFIG_HYPERVISOR_GUEST=y
+CONFIG_PARAVIRT=y
+CONFIG_KVM_GUEST=y
+CONFIG_VIRTIO=y
+CONFIG_VIRTIO_PCI=y
+CONFIG_VIRTIO_BLK=y
+CONFIG_VIRTIO_CONSOLE=y
+CONFIG_VIRTIO_NET=y
+CONFIG_9P_FS=y
+CONFIG_NET_9P=y
+CONFIG_NET_9P_VIRTIO=y
