Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaFXWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:16:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFXWQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:16:56 -0400
Date: Tue, 24 Jun 2014 15:16:26 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-46b57a76930f01ebf31230ed35af5beeccb5ad95@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <bf1ec29e03b2bbc081f6dcaefa64db1c3a83fb21.1403642755.git.luto@amacapital.net>
References: <bf1ec29e03b2bbc081f6dcaefa64db1c3a83fb21.1403642755.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/vdso:
  Move DISABLE_BRANCH_PROFILING into the vdso makefile
Git-Commit-ID: 46b57a76930f01ebf31230ed35af5beeccb5ad95
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46b57a76930f01ebf31230ed35af5beeccb5ad95
Gitweb:     http://git.kernel.org/tip/46b57a76930f01ebf31230ed35af5beeccb5ad95
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue, 24 Jun 2014 13:46:52 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 24 Jun 2014 13:53:00 -0700

x86/vdso: Move DISABLE_BRANCH_PROFILING into the vdso makefile

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
Link: http://lkml.kernel.org/r/bf1ec29e03b2bbc081f6dcaefa64db1c3a83fb21.1403642755.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
