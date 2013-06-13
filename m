Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab3FMNLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:11:47 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:52081 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab3FMNLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:11:14 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mundt <lethal@linux-sh.org>
Cc: David McCullough <david_mccullough@au.securecomputing.com>,
        Thorsten Glaser <tg@mirbsd.org>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH 0/3] Use POSIX "$((..))" instead of bashism "$[...]"
Date: Thu, 13 Jun 2013 15:10:49 +0200
Message-Id: <1371129052-31506-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series replaces the bash-specific "$[...]" by POSIX "$((..))"
for arithmetic expansion, and gets rid of some dependencies on bash.

  [1/3] h8300/boot: Use POSIX "$((..))" instead of bashism "$[...]"
  [2/3] ARM: shmobile: Use POSIX "$((..))" instead of bashism "$[...]"
  [3/3] sh/boot: Use POSIX "$((..))" instead of bashism "$[...]"

The first one is a build fix on systems where /bin/sh is not bash, as it
uses the bashism without forcing bash.

This series was tested using the patch at the bottom, and running

    make ARCH=h8300 clean
    make ARCH=arm clean
    make ARCH=sh clean

with an optional "SHELL=/bin/..." appended, to test difference shells,
on Ubuntu 10.04.4 LTS.

It works fine with bash (4.1-2ubuntu3) and dash (0.5.5.1-3ubuntu2).

With mksh (39.3-1ubuntu3), 32-bit integers seem to be sign-extended to
64-bit integers, e.g.

arch/sh/boot/Makefile: KERNEL_MEMORY = 0x0c000000
arch/sh/boot/Makefile: KERNEL_LOAD = 0xffffffff8c001000
arch/sh/boot/Makefile: KERNEL_ENTRY = 0xffffffff8c002000
arch/sh/boot/compressed/Makefile: IMAGE_OFFSET = 0xffffffff8c800000

Should these be truncated to 32-bit explicitly, or is this a bug in mksh?

Thanks for your comments!

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 1ba358b..5029108 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -319,3 +319,5 @@ define archhelp
   echo  '                  (distribution) /sbin/$(INSTALLKERNEL) or'
   echo  '                  install to $$(INSTALL_PATH) and run lilo'
 endef
+
+include arch/arm/mach-shmobile/Makefile.boot
diff --git a/arch/arm/mach-shmobile/Makefile.boot b/arch/arm/mach-shmobile/Makefile.boot
index 498efd9..95ebc7c 100644
--- a/arch/arm/mach-shmobile/Makefile.boot
+++ b/arch/arm/mach-shmobile/Makefile.boot
@@ -7,3 +7,5 @@ __ZRELADDR	:= $(shell /bin/bash -c 'printf "0x%08x" \
 #
 #params_phys-y (Instead: Pass atags pointer in r2)
 #initrd_phys-y (Instead: Use compiled-in initramfs)
+
+XXX := $(shell echo arch/arm/mach-shmobile/Makefile.boot: __ZRELADDR = $(__ZRELADDR) >> /tmp/loggy)
diff --git a/arch/h8300/boot/compressed/Makefile b/arch/h8300/boot/compressed/Makefile
index 6745cb1..94faad1 100644
--- a/arch/h8300/boot/compressed/Makefile
+++ b/arch/h8300/boot/compressed/Makefile
@@ -35,3 +35,5 @@ OBJCOPYFLAGS := -O binary
 
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.gz FORCE
 	$(call if_changed,ld)
+
+XXX := $(shell echo arch/h8300/boot/compressed/Makefile: IMAGE_OFFSET = $(IMAGE_OFFSET) >> /tmp/loggy)
diff --git a/arch/sh/boot/Makefile b/arch/sh/boot/Makefile
index 58592df..4ab2ba5 100644
--- a/arch/sh/boot/Makefile
+++ b/arch/sh/boot/Makefile
@@ -113,3 +113,7 @@ $(obj)/uImage: $(obj)/uImage.$(suffix-y)
 export CONFIG_PAGE_OFFSET CONFIG_MEMORY_START CONFIG_BOOT_LINK_OFFSET \
        CONFIG_PHYSICAL_START CONFIG_ZERO_PAGE_OFFSET CONFIG_ENTRY_OFFSET \
        KERNEL_MEMORY suffix-y
+
+XXX := $(shell echo arch/sh/boot/Makefile: KERNEL_MEMORY = $(KERNEL_MEMORY) >> /tmp/loggy)
+XXX := $(shell echo arch/sh/boot/Makefile: KERNEL_LOAD = $(KERNEL_LOAD) >> /tmp/loggy)
+XXX := $(shell echo arch/sh/boot/Makefile: KERNEL_ENTRY = $(KERNEL_ENTRY) >> /tmp/loggy)
diff --git a/arch/sh/boot/compressed/Makefile b/arch/sh/boot/compressed/Makefile
index 23bc849..43d1b9a 100644
--- a/arch/sh/boot/compressed/Makefile
+++ b/arch/sh/boot/compressed/Makefile
@@ -79,3 +79,5 @@ LDFLAGS_piggy.o := -r --format binary --oformat $(ld-bfd) -T
 
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix-y) FORCE
 	$(call if_changed,ld)
+
+XXX := $(shell echo arch/sh/boot/compressed/Makefile: IMAGE_OFFSET = $(IMAGE_OFFSET) >> /tmp/loggy)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
In-Reply-To: 

