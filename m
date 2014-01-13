Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaAMOnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:43:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51478 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaAMO0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 65/96] sh: always link in helper functions extracted from libgcc
Date: Mon, 13 Jan 2014 14:24:28 +0000
Message-Id: <1389623099-18783-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 84ed8a99058e61567f495cc43118344261641c5f upstream.

E.g. landisk_defconfig, which has CONFIG_NTFS_FS=m:

  ERROR: "__ashrdi3" [fs/ntfs/ntfs.ko] undefined!

For "lib-y", if no symbols in a compilation unit are referenced by other
units, the compilation unit will not be included in vmlinux.  This
breaks modules that do reference those symbols.

Use "obj-y" instead to fix this.

http://kisskb.ellerman.id.au/kisskb/buildresult/8838077/

This doesn't fix all cases. There are others, e.g. udivsi3.
This is also not limited to sh, many architectures handle this in the
same way.

A simple solution is to unconditionally include all helper functions.
A more complex solution is to make the choice of "lib-y" or "obj-y" depend
on CONFIG_MODULES:

  obj-$(CONFIG_MODULES) += ...
  lib-y($CONFIG_MODULES) += ...

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Tested-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sh/lib/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
1.8.3.2

