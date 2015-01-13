Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbbAMCSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:18:17 -0500
Received: from smtp.outflux.net ([198.145.64.163]:49967 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbbAMCSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:18:16 -0500
Date: Mon, 12 Jan 2015 18:17:50 -0800
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Anca Emanuel <anca.emanuel@gmail.com>,
        Junjie Mao <eternal.n08@gmail.com>
Subject: [PATCH] x86, build: replace Perl script with Shell script
Message-ID: <20150113021750.GA24160@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
added Perl to the required build environment. This reimplements in shell
the Perl script used to find the size of the kernel with bss and brk added.

Reported-by: Rob Landley <rob@landley.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
---
Instead of the proposed "remove recently added perl build requirement" in
-mm right now.
---
 arch/x86/boot/compressed/Makefile |  2 +-
 arch/x86/tools/calc_run_size.pl   | 39 ------------------------------------
 arch/x86/tools/calc_run_size.sh   | 42 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 40 deletions(-)
 delete mode 100644 arch/x86/tools/calc_run_size.pl
 create mode 100755 arch/x86/tools/calc_run_size.sh

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index d999398928bc..ad754b4411f7 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -90,7 +90,7 @@ suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
 
 RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \
-	     perl $(srctree)/arch/x86/tools/calc_run_size.pl)
+	     $(CONFIG_SHELL) $(srctree)/arch/x86/tools/calc_run_size.sh)
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
 
diff --git a/arch/x86/tools/calc_run_size.pl b/arch/x86/tools/calc_run_size.pl
deleted file mode 100644
index 23210baade2d..000000000000
--- a/arch/x86/tools/calc_run_size.pl
+++ /dev/null
@@ -1,39 +0,0 @@
-#!/usr/bin/perl
-#
-# Calculate the amount of space needed to run the kernel, including room for
-# the .bss and .brk sections.
-#
-# Usage:
-# objdump -h a.out | perl calc_run_size.pl
-use strict;
-
-my $mem_size = 0;
-my $file_offset = 0;
-
-my $sections=" *[0-9]+ \.(?:bss|brk) +";
-while (<>) {
-	if (/^$sections([0-9a-f]+) +(?:[0-9a-f]+ +){2}([0-9a-f]+)/) {
-		my $size = hex($1);
-		my $offset = hex($2);
-		$mem_size += $size;
-		if ($file_offset == 0) {
-			$file_offset = $offset;
-		} elsif ($file_offset != $offset) {
-			# BFD linker shows the same file offset in ELF.
-			# Gold linker shows them as consecutive.
-			next if ($file_offset + $mem_size == $offset + $size);
-
-			printf STDERR "file_offset: 0x%lx\n", $file_offset;
-			printf STDERR "mem_size: 0x%lx\n", $mem_size;
-			printf STDERR "offset: 0x%lx\n", $offset;
-			printf STDERR "size: 0x%lx\n", $size;
-
-			die ".bss and .brk are non-contiguous\n";
-		}
-	}
-}
-
-if ($file_offset == 0) {
-	die "Never found .bss or .brk file offset\n";
-}
-printf("%d\n", $mem_size + $file_offset);
diff --git a/arch/x86/tools/calc_run_size.sh b/arch/x86/tools/calc_run_size.sh
new file mode 100755
index 000000000000..1a4c17bb3910
--- /dev/null
+++ b/arch/x86/tools/calc_run_size.sh
@@ -0,0 +1,42 @@
+#!/bin/sh
+#
+# Calculate the amount of space needed to run the kernel, including room for
+# the .bss and .brk sections.
+#
+# Usage:
+# objdump -h a.out | sh calc_run_size.sh
+
+NUM='\([0-9a-fA-F]*[ \t]*\)'
+OUT=$(sed -n 's/^[ \t0-9]*.b[sr][sk][ \t]*'"$NUM$NUM$NUM$NUM"'.*/\1\4/p')
+if [ -z "$OUT" ] ; then
+	echo "Never found .bss or .brk file offset" >&2
+	exit 1
+fi
+
+OUT=$(echo ${OUT# })
+sizeA=$(printf "%d" 0x${OUT%% *})
+OUT=${OUT#* }
+offsetA=$(printf "%d" 0x${OUT%% *})
+OUT=${OUT#* }
+sizeB=$(printf "%d" 0x${OUT%% *})
+OUT=${OUT#* }
+offsetB=$(printf "%d" 0x${OUT%% *})
+
+run_size=$(( $offsetA + $sizeA + $sizeB ))
+
+# BFD linker shows the same file offset in ELF.
+if [ "$offsetA" -ne "$offsetB" ] ; then
+	# Gold linker shows them as consecutive.
+	endB=$(( $offsetB + $sizeB ))
+	if [ "$endB" != "$run_size" ] ; then
+		printf "sizeA: 0x%x\n" $sizeA >&2
+		printf "offsetA: 0x%x\n" $offsetA >&2
+		printf "sizeB: 0x%x\n" $sizeB >&2
+		printf "offsetB: 0x%x\n" $offsetB >&2
+		echo ".bss and .brk are non-contiguous" >&2
+		exit 1
+	fi
+fi
+
+printf "%d\n" $run_size
+exit 0
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
