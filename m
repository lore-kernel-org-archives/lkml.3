Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab3HGIrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:47:55 -0400
Received: from ozlabs.org ([203.10.76.45]:58927 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab3HGIrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:47:53 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <penberg@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm tools: Fix build of guest init with biarch powerpc compilers
Date: Wed,  7 Aug 2013 18:46:47 +1000
Message-Id: <1375865207-11794-1-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On powerpc we build kvmtool as a 64bit binary. We do that by setting
-m64 in our CFLAGS. For most things we just call $(CC) and it passes
that info onto the linker.

However there is one place where we explicitly call the linker, in the
build of guest/init - and in that case we need to tell the linker to
build 64bit.

We have gotten away with this so far because we have been building with
a 64bit only toolchain. However if you build with a biarch toolchain,
which generally defaults to 32bit, we fail to link.

The fix is to defined LDFLAGS appropriately and pass it to LD.

Tested on powerpc and x86-64.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/kvm/Makefile b/tools/kvm/Makefile
index 8f996cd..b614aab 100644
--- a/tools/kvm/Makefile
+++ b/tools/kvm/Makefile
@@ -150,6 +150,7 @@ ifeq ($(ARCH), powerpc)
 	OBJS	+= powerpc/xics.o
 	ARCH_INCLUDE := powerpc/include
 	CFLAGS 	+= -m64
+	LDFLAGS += -m elf64ppc
 
 	ARCH_WANT_LIBFDT := y
 endif
@@ -348,7 +349,7 @@ $(PROGRAM_ALIAS): $(PROGRAM)
 $(GUEST_INIT): guest/init.c
 	$(E) "  LINK    " $@
 	$(Q) $(CC) -static guest/init.c -o $@
-	$(Q) $(LD) -r -b binary -o guest/guest_init.o $(GUEST_INIT)
+	$(Q) $(LD) $(LDFLAGS) -r -b binary -o guest/guest_init.o $(GUEST_INIT)
 
 $(DEPS):
 
-- 
1.8.1.2

