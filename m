Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab3GQQFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:05:15 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:35812 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab3GQQFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:05:12 -0400
Date: Wed, 17 Jul 2013 18:05:06 +0200
From: Robert Richter <rric@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm, kbuild: make "make install" not depend on vmlinux
Message-ID: <20130717160506.GI8731@rric.localhost>
References: <20130710133742.GA29368@emu.suse.cz>
 <CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
 <20130711135445.GA21500@sepie.suse.cz>
 <CA+55aFyVjugxM7cUDWi0ASWttYthCxa6e7X3CADknBcSFxWgew@mail.gmail.com>
 <20130712105721.GF8731@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712105721.GF8731@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(trimmed cc list)

On 12.07.13 11:57:21, Robert Richter wrote:
> On 11.07.13 10:16:18, Linus Torvalds wrote:
> > On Thu, Jul 11, 2013 at 6:54 AM, Michal Marek <mmarek@suse.cz> wrote:
> > >
> > > Yeah. It also reveals another bug that we rewrite the kernel.release
> > > file each time.
> 
> The odd thing I have in a specific configuration is that depmod is
> missing the kernelrelease when I only build install rules, though I
> had built everything before and kernelrelease should be there:
> 
>  $ make <makeflags>
>  $ make <makeflags> modules_install zinstall
>  ...
>    DEPMOD  
>  Usage: .../scripts/depmod.sh /sbin/depmod <kernelrelease>
> 
> Note that makeflags include the -j option, INSTALL_MOD_PATH and
> INSTALL_PATH variables set, so no root perms required in this case.

I narrowed this down. The problem is that zinstall on ARCH=arm has a
dependency to vmlinux which does a prepare/prepare3 and finally does a
forced rebuild of kernel.release even if it exists already.

Rebuilding it removes kernel.release first and then recreates it. This
might race with another parallel make job running depmod.

So on arm and maybe other archs we need the same as for x86:

 1648e4f8 x86, kbuild: make "make install" not depend on vmlinux

The patch below fixes this for arm. It is build-tested in my
environment, but please test it in others too if possible.

Thanks,

-Robert



>From 7e751c909830af4459296e7f2e0cb2321295e661 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@linaro.org>
Date: Wed, 17 Jul 2013 16:17:20 +0200
Subject: [PATCH] arm, kbuild: make "make install" not depend on vmlinux

Install targets (install, zinstall, uinstall) on arm have a dependency
to vmlinux. This may cause parts of the kernel to be rebuilt during
installation. We must avoid this since this may run as root. Install
targets "ABSOLUTELY MUST NOT MODIFY THE SOURCE TREE." as Linus
emphasized this in:

 http://lkml.org/lkml/2013/7/10/600

So on arm and maybe other archs we need the same as for x86:

 1648e4f8 x86, kbuild: make "make install" not depend on vmlinux

This patch fixes this for arm. Dependencies are removed and instead a
check to install.sh is added for the files that are needed.

This issue was uncovered by this build error where the -j option is
used in conjunction with install targets:

 $ make <makeflags>
 $ make <makeflags> zinstall
 ...
   DEPMOD
 Usage: .../scripts/depmod.sh /sbin/depmod <kernelrelease>

(INSTALL_MOD_PATH and INSTALL_PATH variables set, so no root perms
required in this case.)

The problem is that zinstall on arm due to its dependency to vmlinux
does a prepare/prepare3 and finally does a forced rewrite of
kernel.release even if it exists already.

Rebuilding kernel.release removes it first and then recreates it. This
might race with another parallel make job running depmod.

So this patch should fix this one too.

Also quoting $(KERNELRELEASE) arg for install.sh as this messes
argument order in case it is empty (which is the case if the kernel
was not built yet).

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 arch/arm/Makefile        |    9 +++++++--
 arch/arm/boot/Makefile   |   16 ++++++++--------
 arch/arm/boot/install.sh |   14 ++++++++++++++
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index c0ac0f5..fe63986 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -295,10 +295,15 @@ archprepare:
 # Convert bzImage to zImage
 bzImage: zImage
 
-zImage Image xipImage bootpImage uImage: vmlinux
+BOOT_TARGETS	= zImage Image xipImage bootpImage uImage
+INSTALL_TARGETS	= zinstall uinstall install
+
+PHONY += bzImage $(BOOT_TARGETS) $(INSTALL_TARGETS)
+
+$(BOOT_TARGETS): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
-zinstall uinstall install: vmlinux
+$(INSTALL_TARGETS):
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
 %.dtb: | scripts
diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
index 84aa2ca..ec2f806 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -95,24 +95,24 @@ initrd:
 	@test "$(INITRD)" != "" || \
 	(echo You must specify INITRD; exit -1)
 
-install: $(obj)/Image
-	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
+install:
+	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh "$(KERNELRELEASE)" \
 	$(obj)/Image System.map "$(INSTALL_PATH)"
 
-zinstall: $(obj)/zImage
-	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
+zinstall:
+	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh "$(KERNELRELEASE)" \
 	$(obj)/zImage System.map "$(INSTALL_PATH)"
 
-uinstall: $(obj)/uImage
-	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
+uinstall:
+	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh "$(KERNELRELEASE)" \
 	$(obj)/uImage System.map "$(INSTALL_PATH)"
 
 zi:
-	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
+	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh "$(KERNELRELEASE)" \
 	$(obj)/zImage System.map "$(INSTALL_PATH)"
 
 i:
-	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
+	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh "$(KERNELRELEASE)" \
 	$(obj)/Image System.map "$(INSTALL_PATH)"
 
 subdir-	    := bootp compressed dts
diff --git a/arch/arm/boot/install.sh b/arch/arm/boot/install.sh
index 06ea7d4..2a45092 100644
--- a/arch/arm/boot/install.sh
+++ b/arch/arm/boot/install.sh
@@ -20,6 +20,20 @@
 #   $4 - default install path (blank if root directory)
 #
 
+verify () {
+	if [ ! -f "$1" ]; then
+		echo ""                                                   1>&2
+		echo " *** Missing file: $1"                              1>&2
+		echo ' *** You need to run "make" before "make install".' 1>&2
+		echo ""                                                   1>&2
+		exit 1
+	fi
+}
+
+# Make sure the files actually exist
+verify "$2"
+verify "$3"
+
 # User may have a custom install script
 if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
 if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
-- 
1.7.7.6

