Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3FMNLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:11:16 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:36027 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab3FMNLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:11:13 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mundt <lethal@linux-sh.org>
Cc: David McCullough <david_mccullough@au.securecomputing.com>,
        Thorsten Glaser <tg@mirbsd.org>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] sh/boot: Use POSIX "$((..))" instead of bashism "$[...]"
Date: Thu, 13 Jun 2013 15:10:52 +0200
Message-Id: <1371129052-31506-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371129052-31506-1-git-send-email-geert@linux-m68k.org>
References: <1371129052-31506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the bash 4.1 manpage, "$[...]" is deprecated, and will be
removed in upcoming versions of bash.
Hence replace the bash-specific "$[...]" by POSIX "$((..))" for arithmetic
expansion, which also allows to drop the forced use of bash.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/sh/boot/Makefile            |   24 ++++++++++++------------
 arch/sh/boot/compressed/Makefile |   14 +++++++-------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/sh/boot/Makefile b/arch/sh/boot/Makefile
index 4ab2ba5..e10fb9b 100644
--- a/arch/sh/boot/Makefile
+++ b/arch/sh/boot/Makefile
@@ -46,18 +46,18 @@ $(obj)/romImage: $(obj)/romimage/vmlinux FORCE
 $(obj)/romimage/vmlinux: $(obj)/zImage FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/romimage $@
 
-KERNEL_MEMORY	:= $(shell /bin/bash -c 'printf "0x%08x" \
-		     $$[$(CONFIG_PHYSICAL_START) & 0x1fffffff]')
-
-KERNEL_LOAD	:= $(shell /bin/bash -c 'printf "0x%08x" \
-		     $$[$(CONFIG_PAGE_OFFSET)  + \
-			$(KERNEL_MEMORY) + \
-			$(CONFIG_ZERO_PAGE_OFFSET)]')
-
-KERNEL_ENTRY	:= $(shell /bin/bash -c 'printf "0x%08x" \
-		     $$[$(CONFIG_PAGE_OFFSET)  + \
-			$(KERNEL_MEMORY) + \
-			$(CONFIG_ZERO_PAGE_OFFSET) + $(CONFIG_ENTRY_OFFSET)]')
+KERNEL_MEMORY	:= $(shell printf "0x%08x" \
+		     $$(($(CONFIG_PHYSICAL_START) & 0x1fffffff)))
+
+KERNEL_LOAD	:= $(shell printf "0x%08x" \
+		     $$(($(CONFIG_PAGE_OFFSET) + \
+			 $(KERNEL_MEMORY) + \
+			 $(CONFIG_ZERO_PAGE_OFFSET))))
+
+KERNEL_ENTRY	:= $(shell printf "0x%08x" \
+		     $$(($(CONFIG_PAGE_OFFSET) + \
+			 $(KERNEL_MEMORY) + \
+			 $(CONFIG_ZERO_PAGE_OFFSET) + $(CONFIG_ENTRY_OFFSET))))
 
 UIMAGE_LOADADDR = $(KERNEL_LOAD)
 UIMAGE_ENTRYADDR = $(KERNEL_ENTRY)
diff --git a/arch/sh/boot/compressed/Makefile b/arch/sh/boot/compressed/Makefile
index 43d1b9a..0330ba7 100644
--- a/arch/sh/boot/compressed/Makefile
+++ b/arch/sh/boot/compressed/Makefile
@@ -17,14 +17,14 @@ GCOV_PROFILE := n
 # IMAGE_OFFSET is the load offset of the compression loader
 #
 ifeq ($(CONFIG_32BIT),y)
-IMAGE_OFFSET	:= $(shell /bin/bash -c 'printf "0x%08x" \
-		     $$[$(CONFIG_MEMORY_START)  + \
-			$(CONFIG_BOOT_LINK_OFFSET)]')
+IMAGE_OFFSET	:= $(shell printf "0x%08x" \
+		     $$(($(CONFIG_MEMORY_START) + \
+			 $(CONFIG_BOOT_LINK_OFFSET))))
 else
-IMAGE_OFFSET	:= $(shell /bin/bash -c 'printf "0x%08x" \
-		     $$[$(CONFIG_PAGE_OFFSET)  + \
-			$(KERNEL_MEMORY) + \
-			$(CONFIG_BOOT_LINK_OFFSET)]')
+IMAGE_OFFSET	:= $(shell printf "0x%08x" \
+		     $$(($(CONFIG_PAGE_OFFSET) + \
+		         $(KERNEL_MEMORY) + \
+			 $(CONFIG_BOOT_LINK_OFFSET))))
 endif
 
 ifeq ($(CONFIG_MCOUNT),y)
-- 
1.7.0.4

