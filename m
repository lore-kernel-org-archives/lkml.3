Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbaFXUrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:47:08 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35023 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaFXUrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:47:03 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 1/2] x86,vdso: Move DISABLE_BRANCH_PROFILING into the vdso makefile
Date: Tue, 24 Jun 2014 13:46:52 -0700
Message-Id: <bf1ec29e03b2bbc081f6dcaefa64db1c3a83fb21.1403642755.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1403642755.git.luto@amacapital.net>
References: <53A9C6EB.50900@zytor.com>
 <cover.1403642755.git.luto@amacapital.net>
In-Reply-To: <cover.1403642755.git.luto@amacapital.net>
References: <cover.1403642755.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DISABLE_BRANCH_PROFILING turns off branch profiling (i.e. a
redefinition of 'if').  Branch profiling depends on a bunch of
kernel-internal symbols and generates extra output sections, none of
which are useful or functional in the vDSO.

It's currently turned off for vclock_gettime.c, but vgetcpu.c also
triggers branch profiling, so just turn it off in the makefile.

This fixes the build on some configurations: the vdso could contain
undefined symbols, and the fake section table overflowed due to
ftrace's added sections.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/Makefile         | 4 +++-
 arch/x86/vdso/vclock_gettime.c | 3 ---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 68a15c4..61b04fe 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -66,7 +66,8 @@ $(obj)/vdso-image-%.c: $(obj)/vdso%.so.dbg $(obj)/vdso2c FORCE
 #
 CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
        $(filter -g%,$(KBUILD_CFLAGS)) $(call cc-option, -fno-stack-protector) \
-       -fno-omit-frame-pointer -foptimize-sibling-calls
+       -fno-omit-frame-pointer -foptimize-sibling-calls \
+       -DDISABLE_BRANCH_PROFILING
 
 $(vobjs): KBUILD_CFLAGS += $(CFL)
 
@@ -149,6 +150,7 @@ KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
 KBUILD_CFLAGS_32 += $(call cc-option, -fno-stack-protector)
 KBUILD_CFLAGS_32 += $(call cc-option, -foptimize-sibling-calls)
 KBUILD_CFLAGS_32 += -fno-omit-frame-pointer
+KBUILD_CFLAGS_32 += -DDISABLE_BRANCH_PROFILING
 $(vdso32-images:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
 
 $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index b2e4f49..9793322 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -11,9 +11,6 @@
  * Check with readelf after changing.
  */
 
-/* Disable profiling for userspace code: */
-#define DISABLE_BRANCH_PROFILING
-
 #include <uapi/linux/time.h>
 #include <asm/vgtod.h>
 #include <asm/hpet.h>
-- 
1.9.3

