Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3FDWlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:41:24 -0400
Received: from 1wt.eu ([62.212.114.60]:35169 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3FDWkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:40:53 -0400
Message-Id: <20130604172130.635957117@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jean Delvare <jdelvare@suse.de>, Bernhard Walle <bernhard@bwalle.de>,
        Michal Marek <mmarek@suse.cz>, Ralf Baechle <ralf@linux-mips.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 008/184] kbuild: Fix gcc -x syntax
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

This is upstream commit b1e0d8b70fa31821ebca3965f2ef8619d7c5e316
backported to the 2.6.32.x stable branch.

The correct syntax for gcc -x is "gcc -x assembler", not
"gcc -xassembler". Even though the latter happens to work, the former
is what is documented in the manual page and thus what gcc wrappers
such as icecream do expect.

This isn't a cosmetic change. The missing space prevents icecream from
recognizing compilation tasks it can't handle, leading to silent kernel
miscompilations.

Besides me, credits go to Michael Matz and Dirk Mueller for
investigating the miscompilation issue and tracking it down to this
incorrect -x parameter syntax.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@vger.kernel.org
Cc: Bernhard Walle <bernhard@bwalle.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/mips/Makefile                         |  2 +-
 arch/mips/kernel/Makefile                  |  2 +-
 scripts/Kbuild.include                     | 12 ++++++------
 scripts/gcc-version.sh                     |  6 +++---
 scripts/gcc-x86_32-has-stack-protector.sh  |  2 +-
 scripts/gcc-x86_64-has-stack-protector.sh  |  2 +-
 scripts/kconfig/check.sh                   |  2 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh |  2 +-
 8 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 77f5021..57ff855 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -657,7 +657,7 @@ KBUILD_CPPFLAGS += -D"DATAOFFSET=$(if $(dataoffset-y),$(dataoffset-y),0)"
 LDFLAGS			+= -m $(ld-emul)
 
 ifdef CONFIG_MIPS
-CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -xc /dev/null | \
+CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
 	egrep -vw '__GNUC_(|MINOR_|PATCHLEVEL_)_' | \
 	sed -e 's/^\#define /-D/' -e "s/ /='/" -e "s/$$/'/")
 ifdef CONFIG_64BIT
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index eecd2a9..700dc14 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -88,7 +88,7 @@ obj-$(CONFIG_GPIO_TXX9)		+= gpio_txx9.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
-CFLAGS_cpu-bugs64.o	= $(shell if $(CC) $(KBUILD_CFLAGS) -Wa,-mdaddi -c -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-DHAVE_AS_SET_DADDI"; fi)
+CFLAGS_cpu-bugs64.o	= $(shell if $(CC) $(KBUILD_CFLAGS) -Wa,-mdaddi -c -o /dev/null -x c /dev/null >/dev/null 2>&1; then echo "-DHAVE_AS_SET_DADDI"; fi)
 
 obj-$(CONFIG_HAVE_STD_PC_SERIAL_PORT)	+= 8250-platform.o
 
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 92b62a8..5405ff17 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -94,24 +94,24 @@ try-run = $(shell set -e;		\
 # Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
 
 as-option = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -c -xassembler /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CFLAGS) $(1) -c -x assembler /dev/null -o "$$TMP",$(1),$(2))
 
 # as-instr
 # Usage: cflags-y += $(call as-instr,instr,option1,option2)
 
 as-instr = $(call try-run,\
-	/bin/echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
+	/bin/echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -x assembler -o "$$TMP" -,$(2),$(3))
 
 # cc-option
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
 
 cc-option = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
 cc-option-yn = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",y,n)
 
 # cc-option-align
 # Prefix align with either -falign or -malign
@@ -121,7 +121,7 @@ cc-option-align = $(subst -functions=0,,\
 # cc-disable-warning
 # Usage: cflags-y += $(call cc-disable-warning,unused-but-set-variable)
 cc-disable-warning = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -xc /dev/null -o "$$TMP",-Wno-$(strip $(1)))
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))
 
 # cc-version
 # Usage gcc-ver := $(call cc-version)
@@ -139,7 +139,7 @@ cc-ifversion = $(shell [ $(call cc-version, $(CC)) $(1) $(2) ] && echo $(3))
 # cc-ldoption
 # Usage: ldflags += $(call cc-ldoption, -Wl$(comma)--hash-style=both)
 cc-ldoption = $(call try-run,\
-	$(CC) $(1) -nostdlib -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(1) -nostdlib -x c /dev/null -o "$$TMP",$(1),$(2))
 
 # ld-option
 # Usage: LDFLAGS += $(call ld-option, -X)
diff --git a/scripts/gcc-version.sh b/scripts/gcc-version.sh
index debecb5..7f2126d 100644
--- a/scripts/gcc-version.sh
+++ b/scripts/gcc-version.sh
@@ -22,10 +22,10 @@ if [ ${#compiler} -eq 0 ]; then
 	exit 1
 fi
 
-MAJOR=$(echo __GNUC__ | $compiler -E -xc - | tail -n 1)
-MINOR=$(echo __GNUC_MINOR__ | $compiler -E -xc - | tail -n 1)
+MAJOR=$(echo __GNUC__ | $compiler -E -x c - | tail -n 1)
+MINOR=$(echo __GNUC_MINOR__ | $compiler -E -x c - | tail -n 1)
 if [ "x$with_patchlevel" != "x" ] ; then
-	PATCHLEVEL=$(echo __GNUC_PATCHLEVEL__ | $compiler -E -xc - | tail -n 1)
+	PATCHLEVEL=$(echo __GNUC_PATCHLEVEL__ | $compiler -E -x c - | tail -n 1)
 	printf "%02d%02d%02d\\n" $MAJOR $MINOR $PATCHLEVEL
 else
 	printf "%02d%02d\\n" $MAJOR $MINOR
diff --git a/scripts/gcc-x86_32-has-stack-protector.sh b/scripts/gcc-x86_32-has-stack-protector.sh
index 29493dc..12dbd0b 100644
--- a/scripts/gcc-x86_32-has-stack-protector.sh
+++ b/scripts/gcc-x86_32-has-stack-protector.sh
@@ -1,6 +1,6 @@
 #!/bin/sh
 
-echo "int foo(void) { char X[200]; return 3; }" | $* -S -xc -c -O0 -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
+echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -c -O0 -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
 if [ "$?" -eq "0" ] ; then
 	echo y
 else
diff --git a/scripts/gcc-x86_64-has-stack-protector.sh b/scripts/gcc-x86_64-has-stack-protector.sh
index afaec61..973e8c1 100644
--- a/scripts/gcc-x86_64-has-stack-protector.sh
+++ b/scripts/gcc-x86_64-has-stack-protector.sh
@@ -1,6 +1,6 @@
 #!/bin/sh
 
-echo "int foo(void) { char X[200]; return 3; }" | $* -S -xc -c -O0 -mcmodel=kernel -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
+echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -c -O0 -mcmodel=kernel -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
 if [ "$?" -eq "0" ] ; then
 	echo y
 else
diff --git a/scripts/kconfig/check.sh b/scripts/kconfig/check.sh
index fa59cbf..854d9c7 100755
--- a/scripts/kconfig/check.sh
+++ b/scripts/kconfig/check.sh
@@ -1,6 +1,6 @@
 #!/bin/sh
 # Needed for systems without gettext
-$* -xc -o /dev/null - > /dev/null 2>&1 << EOF
+$* -x c -o /dev/null - > /dev/null 2>&1 << EOF
 #include <libintl.h>
 int main()
 {
diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index fcef0f5..4bab9e2 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -36,7 +36,7 @@ trap "rm -f $tmp" 0 1 2 3 15
 
 # Check if we can link to ncurses
 check() {
-        $cc -xc - -o $tmp 2>/dev/null <<'EOF'
+        $cc -x c - -o $tmp 2>/dev/null <<'EOF'
 #include CURSES_LOC
 main() {}
 EOF
-- 
1.7.12.2.21.g234cd45.dirty



