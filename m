Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965139Ab3E2IRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:17:06 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:53085 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab3E2IRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:17:00 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC] sh: Always link in helper functions extracted from libgcc
Date: Wed, 29 May 2013 10:16:48 +0200
Message-Id: <1369815408-12719-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

E.g. landisk_defconfig, which has CONFIG_NTFS_FS=m:

ERROR: "__ashrdi3" [fs/ntfs/ntfs.ko] undefined!

For "lib-y", if no symbols in a compilation unit are referenced by other
units, the compilation unit will not be included in vmlinux.
This breaks modules that do reference those symbols.

Use "obj-y" instead to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/8838077/

This doesn't fix all cases. There are others, e.g. udivsi3.
This is also not limited to sh, many architectures handle this in the same
way.

A simple solution is to unconditionally include all helper functions.
A more complex solution is to make the choice of "lib-y" or "obj-y" depend
on CONFIG_MODULES:
  obj-$(CONFIG_MODULES) += ...
  lib-y($CONFIG_MODULES) += ...
  
What do you think?
Thanks for your comments!

 arch/sh/lib/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/lib/Makefile b/arch/sh/lib/Makefile
index 7b95f29..3baff31 100644
--- a/arch/sh/lib/Makefile
+++ b/arch/sh/lib/Makefile
@@ -6,7 +6,7 @@ lib-y  = delay.o memmove.o memchr.o \
 	 checksum.o strlen.o div64.o div64-generic.o
 
 # Extracted from libgcc
-lib-y += movmem.o ashldi3.o ashrdi3.o lshrdi3.o \
+obj-y += movmem.o ashldi3.o ashrdi3.o lshrdi3.o \
 	 ashlsi3.o ashrsi3.o ashiftrt.o lshrsi3.o \
 	 udiv_qrnnd.o
 
-- 
1.7.0.4

