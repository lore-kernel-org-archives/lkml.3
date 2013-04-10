Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936926Ab3DJJYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:24:50 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:48712 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934872Ab3DJJYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:24:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC] m68k: Add -ffreestanding to KBUILD_CFLAGS
Date: Wed, 10 Apr 2013 11:24:39 +0200
Message-Id: <1365585879-5321-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without -ffreestanding, gcc may replace calls to standard C library
functions by calls to other standard C library functions and/or inline
code.  This may cause link errors if the replacement code calls a standard
C library function that's implemented as a macro in the kernel.

E.g. gcc turned

    strncat(name, "%d", 2);

into a call to strlen() and a 16-bit store, causing a link failure, as
arch/m68k/include/asm/string.h provides strlen() using a macro:

    ERROR: "strlen" [net/ipv4/ip_tunnel.ko] undefined!

In addition, this saves ca. 64 bytes of text on a typical kernel build.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/8462108/

QUESTION: Should we re-enable -ffreestanding in the main Makefile instead?

It was removed in

commit 6edfba1b33c701108717f4e036320fc39abe1912
Author: Andi Kleen <ak@suse.de>
Date:   Sat Mar 25 16:29:49 2006 +0100

    [PATCH] x86_64: Don't define string functions to builtin

    gcc should handle this anyways, and it causes problems when
    sprintf is turned into strcpy by gcc behind our backs and
    the C fallback version of strcpy is actually defining __builtin_strcpy

    Then drop -ffreestanding from the main Makefile because it isn't
    needed anymore and implies -fno-builtin, which is wrong now.
    (it was only added for x86-64, so dropping it should be safe)

    Noticed by Roman Zippel

    Cc: Roman Zippel <zippel@linux-m68k.org>
    Signed-off-by: Andi Kleen <ak@suse.de>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

Subsequently, it got re-enabled for mips, sh, x86-32, um/x86, xtensa, and
score.

 arch/m68k/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
index 2f02acf..8e06a38 100644
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -58,7 +58,7 @@ cpuflags-$(CONFIG_M5206e)	:= $(call cc-option,-mcpu=5206e,-m5200)
 cpuflags-$(CONFIG_M5206)	:= $(call cc-option,-mcpu=5206,-m5200)
 
 KBUILD_AFLAGS += $(cpuflags-y)
-KBUILD_CFLAGS += $(cpuflags-y) -pipe
+KBUILD_CFLAGS += $(cpuflags-y) -pipe -ffreestanding
 ifdef CONFIG_MMU
 # without -fno-strength-reduce the 53c7xx.c driver fails ;-(
 KBUILD_CFLAGS += -fno-strength-reduce -ffixed-a2
-- 
1.7.0.4

