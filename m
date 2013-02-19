Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab3BSPPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:15:09 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54990 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3BSPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:15:08 -0500
Date: Tue, 19 Feb 2013 16:15:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/build changes for v3.9
Message-ID: <20130219151504.GA14503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-build-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus

   HEAD: 63a3f603413ffe82ad775f2d62a5afff87fd94a0 timeconst.pl: Eliminate Perl warning

The first change modifies how 'make oldconfig' works on 
cross-bitness situations on x86. It was felt the new behavior of 
preserving the bitness of the .config is more logical. This is a 
leftover of the merge.

The second change eliminates a Perl warning. (There's another, 
more complete fix resulting of this warning fix, which second 
fix in flight to you via the kbuild tree, which will remove the 
timeconst.pl script altogether.)

out-of-topic modifications in x86-build-for-linus:
--------------------------------------------------
Makefile                           # ffee0de: x86: Default to ARCH=x86 to avoid
kernel/timeconst.pl                # 63a3f60: timeconst.pl: Eliminate Perl warn

 Thanks,

	Ingo

------------------>
David Woodhouse (1):
      x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT

H. Peter Anvin (1):
      timeconst.pl: Eliminate Perl warning


 Makefile                        | 3 ++-
 arch/x86/Kconfig                | 2 +-
 arch/x86/Makefile               | 4 ++++
 arch/x86/configs/i386_defconfig | 1 +
 kernel/timeconst.pl             | 6 ++----
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 540f7b2..9a07340 100644
--- a/Makefile
+++ b/Makefile
@@ -165,7 +165,8 @@ export srctree objtree VPATH
 # then ARCH is assigned, getting whatever value it gets normally, and 
 # SUBARCH is subsequently ignored.
 
-SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
+				  -e s/sun4u/sparc64/ \
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..9084c7b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1,7 +1,7 @@
 # Select 32 or 64 bit
 config 64BIT
 	bool "64-bit kernel" if ARCH = "x86"
-	default ARCH = "x86_64"
+	default ARCH != "i386"
 	---help---
 	  Say yes to build a 64-bit kernel - formerly known as x86_64
 	  Say no to build a 32-bit kernel - formerly known as i386
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 05afcca..fa981ca 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -2,7 +2,11 @@
 
 # select defconfig based on actual architecture
 ifeq ($(ARCH),x86)
+  ifeq ($(shell uname -m),x86_64)
+        KBUILD_DEFCONFIG := x86_64_defconfig
+  else
         KBUILD_DEFCONFIG := i386_defconfig
+  endif
 else
         KBUILD_DEFCONFIG := $(ARCH)_defconfig
 endif
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 5598547..9444708 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -1,3 +1,4 @@
+# CONFIG_64BIT is not set
 CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
diff --git a/kernel/timeconst.pl b/kernel/timeconst.pl
index eb51d76..3f42652 100644
--- a/kernel/timeconst.pl
+++ b/kernel/timeconst.pl
@@ -369,10 +369,8 @@ if ($hz eq '--can') {
 		die "Usage: $0 HZ\n";
 	}
 
-	@val = @{$canned_values{$hz}};
-	if (!defined(@val)) {
-		@val = compute_values($hz);
-	}
+	$cv = $canned_values{$hz};
+	@val = defined($cv) ? @$cv : compute_values($hz);
 	output($hz, @val);
 }
 exit 0;
