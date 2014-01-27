Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaA0QiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:38:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39863 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaA0QiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:38:08 -0500
Date: Mon, 27 Jan 2014 17:37:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Michael Matz <matz@suse.de>,
        Michal Hocko <mhocko@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Subject: [RFC] x86: Disable traditional FPU instructions too
Message-ID: <20140127163758.GC6839@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys,

should we do the below? It looks like we don't disable the generation of
*all* FPU instructions on x86_64 (commit message below has the rationale
why).

We do -msoft-float on 32-bit only and Micha says that -msoft-float and
-mno-80387 are the same and the gcc manpage says:

           On machines where a function returns floating-point results in the 80387
           register stack, some floating-point opcodes may be emitted even if
           -msoft-float is used.

and right after, it has also

       -mno-fp-ret-in-387
           Do not use the FPU registers for return values of functions.

           The usual calling convention has functions return values of types "float"
           and "double" in an FPU register, even if there is no FPU.  The idea is that
           the operating system should emulate an FPU.

           The option -mno-fp-ret-in-387 causes such values to be returned in ordinary
           CPU registers instead.

Btw, there's this -mno-fp-regs switch too which forces passing of FP
results of functions in integer registers...

So maybe we should do this:

---
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86: Disable generation of traditional x87 instructions

We recently had the case where wrongly used constant caused the
generation of x87 instructions in kernel code unknowingly, wreaking all
kinds of havoc. Disable the generation of those too. This will save
people a lot of time when trying to debug such issues by erroring out
of the build and not manifesting itself in all kinds of spectacular and
funny ways at runtime.

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Matz <matz@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 13b22e0f681d..dbd31182669c 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -61,7 +61,7 @@ else
         KBUILD_CFLAGS += -m64
 
         # Don't autogenerate MMX or SSE instructions
-        KBUILD_CFLAGS += -mno-mmx -mno-sse
+        KBUILD_CFLAGS += -mno-mmx -mno-sse -mno-80387 -mno-fp-ret-in-387
 
 	# Use -mpreferred-stack-boundary=3 if supported.
 	KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
-- 
1.8.5.2.192.g7794a68


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
