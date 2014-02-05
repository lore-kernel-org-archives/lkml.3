Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaBEAzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:55:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39580 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbaBEAzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:55:17 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Michael Matz <matz@suse.de>,
        Michal Hocko <mhocko@suse.cz>
Subject: [PATCH] x86: Disable generation of traditional x87 instructions
Date: Wed,  5 Feb 2014 01:55:11 +0100
Message-Id: <1391561711-3023-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We recently had the case where wrongly used floating-constant 'E' caused
the generation of traditional x87 instructions in kernel code and
wreaking all kinds of havoc.

Disable the generation of those too. This will save people a lot of time
when trying to debug such issues by erroring out of the build instead of
let them manifest themselves in very spectacular and happy-crappy ways
at runtime.

We're using -mno-fp-ret-in-387 in addition to -mno-80387 (which is ==
-msoft-float) because, as the gcc manpage says:

  On machines where a function returns floating-point results in the
  80387 register stack, some floating-point opcodes may be emitted even
  if -msoft-float is used.

so we want to turn off *all* non-integer instructions involving any
architectural FPU state, unless it is absolutely necessary (and those
cases need special handling anyway).

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Matz <matz@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index eeda43abed6e..a414b1471ffc 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -82,8 +82,8 @@ else
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 
-        # Don't autogenerate MMX or SSE instructions
-        KBUILD_CFLAGS += -mno-mmx -mno-sse
+        # Don't autogenerate traditional x87, MMX or SSE instructions
+        KBUILD_CFLAGS += -mno-mmx -mno-sse -mno-80387 -mno-fp-ret-in-387
 
 	# Use -mpreferred-stack-boundary=3 if supported.
 	KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
-- 
1.8.5.2.192.g7794a68

