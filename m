Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbaGELWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 07:22:49 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:52947 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaGELWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 07:22:47 -0400
Subject: [PATCH] checkstack: use $UTS_MACHINE as target architecture
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-kbuild@vger.kernel.org
Date: Sat, 05 Jul 2014 15:22:38 +0400
Message-ID: <20140705112238.16142.42735.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes command # make checkstack for i386/x86_64.
Looks like $UTS_MACHINE is exactly what scripts/checkstack.pl needs.

By default $UTS_MACHINE is equal to $ARCH, but some arch/${ARCH}/Makefile
overrides it. This patch updates it also in arch/x86/Makefile.um

broken in ffee0de ("x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT")

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 Makefile             |   11 +----------
 arch/x86/Makefile.um |    2 ++
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/Makefile b/Makefile
index b0ee945..50fb690 100644
--- a/Makefile
+++ b/Makefile
@@ -1416,18 +1416,9 @@ endif #ifeq ($(mixed-targets),1)
 
 PHONY += checkstack kernelrelease kernelversion image_name
 
-# UML needs a little special treatment here.  It wants to use the host
-# toolchain, so needs $(SUBARCH) passed to checkstack.pl.  Everyone
-# else wants $(ARCH), including people doing cross-builds, which means
-# that $(SUBARCH) doesn't work here.
-ifeq ($(ARCH), um)
-CHECKSTACK_ARCH := $(SUBARCH)
-else
-CHECKSTACK_ARCH := $(ARCH)
-endif
 checkstack:
 	$(OBJDUMP) -d vmlinux $$(find . -name '*.ko') | \
-	$(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
+	$(PERL) $(src)/scripts/checkstack.pl $(UTS_MACHINE)
 
 kernelrelease:
 	@echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))"
diff --git a/arch/x86/Makefile.um b/arch/x86/Makefile.um
index 36b62bc..8fc912b 100644
--- a/arch/x86/Makefile.um
+++ b/arch/x86/Makefile.um
@@ -3,6 +3,7 @@ core-y += arch/x86/crypto/
 ifeq ($(CONFIG_X86_32),y)
 START := 0x8048000
 
+UTS_MACHINE		:= i386
 LDFLAGS			+= -m elf_i386
 ELF_ARCH		:= i386
 ELF_FORMAT 		:= elf32-i386
@@ -47,6 +48,7 @@ KBUILD_AFLAGS += -m64
 LDFLAGS += -m elf_x86_64
 KBUILD_CPPFLAGS += -m64
 
+UTS_MACHINE := x86_64
 ELF_ARCH := i386:x86-64
 ELF_FORMAT := elf64-x86-64
 

