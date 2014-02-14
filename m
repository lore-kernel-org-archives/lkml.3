Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaBNVWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:22:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:38604 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbaBNVWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:22:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="481803178"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 16/19] Kbuild, lto: Add Link Time Optimization support v2
Date: Fri, 14 Feb 2014 22:21:40 +0100
Message-Id: <1392412903-25733-17-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With LTO gcc will do whole program optimizations for
the whole kernel and each module. This increases compile time,
but can generate faster and smaller code and allows
the compiler to do global checking. For example the compiler
can complain now about type mismatches for symbols between
different files.

LTO allows gcc to inline functions between different files and
do various other optimization across the whole binary.

It might also trigger bugs due to more aggressive optimizations.
It allows gcc to drop unused code. It also allows it to check
types over the whole program.

The compile time is definitely slower. For gcc 4.8 on a
typical monolithic config it is about 58% slower. 4.9
drastically improved performance, with slowdown being
38% or so. Also incremenential rebuilds are somewhat
slower, as the whole kernel always needs to be reoptimized.
Very modular kernels have less build time slow down, as
the LTO will run for each module individually.

This adds the basic Kbuild plumbing for LTO:

- In Kbuild add a new scripts/Makefile.lto that checks
the tool chain (note the checks may not be fully bulletproof)
and when the tests pass sets the LTO options
Currently LTO is very finicky about the tool chain.
- Add a new LDFINAL variable that controls the final link
for vmlinux or module. In this case we call gcc-ld instead
of ld, to run the LTO step.
- For slim LTO builds (object files containing no backup
executable) force AR to gcc-ar
- Theoretically LTO should pass through compiler options from
the compiler to the link step, but this doesn't work for all options.
So the Makefile sets most of these options manually.
- Kconfigs:
Since LTO with allyesconfig needs more than 4G of memory (~8G)
and has the potential to makes people's system swap to death.
I used a nested config that ensures that a simple
allyesconfig disables LTO. It has to be explicitely
enabled.
- Some depencies on other Kconfigs:
MODVERSIONS, GCOV, FUNCTION_TRACER, KALLSYMS_ALL, single chain WCHAN are
incompatible with LTO currently, mostly because they
they require setting special compiler options
for specific files, which LTO currently doesn't support.
MODVERSIONS should in principle work with gcc 4.9, but still disabled.
FUNCTION_TRACER/GCOV can be fixed with a unmerged gcc patch.
- Also disable strict copy user checks because they trigger
errors with LTO.
- modpost symbol checking is downgraded to a warning,
as in some cases modpost runs before the final link
and it cannot resolve LTO symbols at this point.

For more information see Documentation/lto-build

Thanks to HJ Lu, Joe Mario, Honza Hubicka, Richard Guenther,
Don Zickus, Changlong Xie who helped with this project
(and probably some more who I forgot, sorry)

v2:
Merge documentation file into this patch
Improve documentation and Kconfig, fix a lot of obsolete comments.
Exclude READABLE_ASM
Some random fixes
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/lto-build  | 173 +++++++++++++++++++++++++++++++++++++++++++++++
 Makefile                 |   9 ++-
 arch/x86/Kconfig         |   2 +-
 init/Kconfig             |  81 ++++++++++++++++++++++
 kernel/gcov/Kconfig      |   2 +-
 lib/Kconfig.debug        |   2 +-
 scripts/Makefile.lto     |  85 +++++++++++++++++++++++
 scripts/Makefile.modpost |   7 +-
 scripts/link-vmlinux.sh  |   2 +-
 9 files changed, 355 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/lto-build
 create mode 100644 scripts/Makefile.lto

diff --git a/Documentation/lto-build b/Documentation/lto-build
new file mode 100644
index 0000000..5dcce1e
--- /dev/null
+++ b/Documentation/lto-build
@@ -0,0 +1,173 @@
+Link time optimization (LTO) for the Linux kernel
+
+This is an experimental feature.
+
+Link Time Optimization allows the compiler to optimize the complete program
+instead of just each file.  LTO requires at least gcc 4.8 (but
+works more efficiently with 4.9+) LTO requires Linux binutils (the normal FSF
+releases used in many distributions do not work at the moment)
+
+The compiler can inline functions between files and do various other global
+optimizations, like specializing functions for common parameters,
+determing when global variables are clobbered, making functions pure/const,
+propagating constants globally, removing unneeded data and others.
+
+It will also drop unused functions which can make the kernel
+image smaller in some circumstances, in particular for small kernel
+configurations.
+
+For small monolithic kernels it can throw away unused code very effectively
+(especially when modules are disabled) and usually shrinks
+the code size.
+
+Build time and memory consumption at build time will increase, depending
+on the size of the largest binary. Modular kernels are less affected.
+With LTO incremental builds are less incremental, as always the whole
+binary needs to be re-optimized (but not re-parsed)
+
+Oops can be somewhat more difficult to read, due to the more aggressive
+inlining.
+
+Normal "reasonable" builds work with less than 4GB of RAM, but very large
+configurations like allyesconfig may need more memory. The actual
+memory needed depends on the available memory (gcc sizes its garbage
+collector pools based on that or on the ulimit -m limits) and
+the compiler version.
+
+gcc 4.9+ has much better build performance and less memory consumption
+
+- A few kernel features are currently incompatible with LTO, in particular
+function tracing, because they require special compiler flags for
+specific files, which is not supported in LTO right now.
+- Jobserver control for -j does not work correctly for the final
+LTO phase due to some problems with the kernel's pipe code.
+The makefiles hard codes -j<number of online cpus> for the final
+LTO phase to work around for this
+
+Configuration:
+- Enable CONFIG_LTO_MENU and then disable CONFIG_LTO_DISABLE.
+This is mainly to not have allyesconfig default to LTO.
+- FUNCTION_TRACER, STACK_TRACER, FUNCTION_GRAPH_TRACER, KALLSYMS_ALL, GCOV
+have to disabled because they are currently incompatible with LTO.
+- MODVERSIONS have to be disabled (may work with 4.9+)
+
+Requirements:
+- Enough memory: 4GB for a standard build, more for allyesconfig
+The peak memory usage happens single threaded (when lto-wpa merges types),
+so dialing back -j options will not help much.
+
+A 32bit compiler is unlikely to work due to the memory requirements.
+You can however build a kernel targeted at 32bit on a 64bit host.
+
+Example build procedure:
+
+Simplified procedure for distributions that have gcc 4.8, but not
+the Linux binutils (for example openSUSE 13.1 or FC20):
+
+The LTO builds requires gcc-nm/gcc-ar. Some distributions ship
+those in separate packages, which may need to be explicitely installed.
+
+- Get the latest Linux binutils from
+http://www.kernel.org/pub/linux/devel/binutils/
+and unpack it.
+
+We install it in a separate directory to not overwrite the system binutils.
+
+# replace VERSION with respective version numbers
+
+cd binutils*
+# don't forget the --enable-plugins!
+./configure --prefix=/opt/binutils-VERSION --enable-plugins
+make -j $(getconf _NPROCESSORS_ONLN) && sudo make install
+
+Fix up the kernel configuration to allow LTO:
+
+<start with a suitable kernel configuration>
+./source/scripts/config --disable function_tracer \
+			--disable function_graph_tracer \
+			--disable stack_tracer --enable lto_menu \
+                        --disable lto_disable \
+			--disable gcov \
+			--disable kallsyms_all \
+			--disable modversions
+make oldconfig
+
+Then you can build with
+
+# The COMPILER_PATH is needed to let gcc use the new binutils
+# as the LTO plugin linker
+# if you installed gcc in a separate directory like below also
+# add it to the PATH line below before the regular $PATH
+# The COMPILER_PATH setting is only needed if the gcc was not built
+# with --with-plugin-ld pointing to the Linux binutils ld
+# The AR/NM setting works around a Makefile bug
+COMPILER_PATH=/opt/binutils-VERSION/bin PATH=$COMPILER_PATH:$PATH \
+make -j$(getconf _NPROCESSORS_ONLN) AR=gcc-ar NM=gcc-nm
+
+If you don't have gcc 4.8+ as system compiler you would also need
+to install that compiler. In this case I recommend getting
+a gcc 4.9+ snapshot from http://gcc.gnu.org (or release when available),
+as it builds much faster for LTO than 4.8.
+
+Here's an example build procedure:
+
+Assuming gcc is unpacked in gcc-VERSION
+
+cd gcc-VERSION
+./contrib/download_preqrequisites
+cd ..
+
+mkdir obj-gcc
+# please don't skip this cd. the build will not work correctly in the
+# source dir, you have to use the separate object dir
+cd obj-gcc
+../gcc-VERSION/configure --prefix=/opt/gcc-VERSION --enable-lto \
+--with-plugin-ld=/opt/binutils-VERSION/bin/ld
+--disable-nls --enable-languages=c,c++ \
+--disable-libstdcxx-pch
+make -j$(getconf _NPROCESSORS_ONLN)
+sudo make install-no-fixedincludes
+
+FAQs:
+
+Q: I get a section type attribute conflict
+A: Usually because of someone doing
+const __initdata (should be const __initconst) or const __read_mostly
+(should be just const). Check both symbols reported by gcc.
+
+Q: I see lots of undefined symbols for memcmp etc.
+A: Usually because NM=gcc-nm AR=gcc-ar are missing.
+The Makefile tries to set those automatically, but it doesn't always
+work. Better to set it manually on the make command line.
+
+Q: It's quite slow / uses too much memory.
+A: Consider a gcc 4.9 snapshot/release (not released yet)
+The main problem in 4.8 is the type merging in the single threaded WPA pass,
+which has been improved considerably in 4.9 by running it distributed.
+
+Q: It's still slow
+A: It'll always be somewhat slower than non LTO sorry.
+
+Q: What's up with .XXXXX numeric post fixes
+A: This is due LTO turning (near) all symbols to static
+Use gcc 4.9, it avoids them in most cases. They are also filtered out
+in kallsyms.
+
+References:
+
+Presentation on Kernel LTO
+(note, performance numbers/details outdated.  In particular gcc 4.9 fixed
+most of the build time problems):
+http://halobates.de/kernel-lto.pdf
+
+Generic gcc LTO:
+http://www.ucw.cz/~hubicka/slides/labs2013.pdf
+http://www.hipeac.net/system/files/barcelona.pdf
+
+Somewhat outdated too:
+http://gcc.gnu.org/projects/lto/lto.pdf
+http://gcc.gnu.org/projects/lto/whopr.pdf
+
+Happy Link-Time-Optimizing!
+
+Andi Kleen
diff --git a/Makefile b/Makefile
index 23629a9..9767026 100644
--- a/Makefile
+++ b/Makefile
@@ -335,9 +335,14 @@ include $(srctree)/scripts/Kbuild.include
 
 AS		= $(CROSS_COMPILE)as
 LD		= $(CROSS_COMPILE)ld
+LDFINAL	= $(LD)
 CC		= $(CROSS_COMPILE)gcc
 CPP		= $(CC) -E
+ifdef CONFIG_LTO_SLIM
+AR		= $(CROSS_COMPILE)gcc-ar
+else
 AR		= $(CROSS_COMPILE)ar
+endif
 NM		= $(CROSS_COMPILE)nm
 STRIP		= $(CROSS_COMPILE)strip
 OBJCOPY		= $(CROSS_COMPILE)objcopy
@@ -396,7 +401,7 @@ KERNELVERSION = $(VERSION)$(if $(PATCHLEVEL),.$(PATCHLEVEL)$(if $(SUBLEVEL),.$(S
 
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
 export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
-export CPP AR NM STRIP OBJCOPY OBJDUMP
+export CPP AR NM STRIP OBJCOPY OBJDUMP LDFINAL
 export MAKE AWK GENKSYMS INSTALLKERNEL PERL UTS_MACHINE
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
@@ -707,6 +712,8 @@ ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
 	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
 endif
 
+include ${srctree}/scripts/Makefile.lto
+
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 KBUILD_CPPFLAGS += $(KCPPFLAGS)
 KBUILD_AFLAGS += $(KAFLAGS)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..a5928cd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -577,7 +577,7 @@ config X86_32_IRIS
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
-	prompt "Single-depth WCHAN output"
+	prompt "Single-depth WCHAN output" if !LTO && !FRAME_POINTER
 	depends on X86
 	---help---
 	  Calculate simpler /proc/<PID>/wchan values. If this option
diff --git a/init/Kconfig b/init/Kconfig
index ea00c0e..7e8910d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1241,6 +1241,85 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say N.
 
+config LTO_MENU
+	bool "Enable gcc link time optimization (LTO)"
+	# Only tested on X86 for now. For other architectures you likely
+	# have to fix some things first, like adding asmlinkages etc.
+	depends on X86
+	# lto does not support excluding flags for specific files
+	# right now. Can be removed if that is fixed.
+	depends on !FUNCTION_TRACER
+	help
+	  With this option gcc will do whole program optimizations for
+	  the whole kernel and module. This increases compile time, but can
+	  lead to better code. It allows gcc to inline functions between
+	  different files and do other optimization.  It might also trigger
+	  bugs due to more aggressive optimization. It allows gcc to drop unused
+	  code. On smaller monolithic kernel configurations
+	  it usually leads to smaller kernels, especially when modules
+	  are disabled.
+
+	  With this option gcc will also do some global checking over
+	  different source files. It also disables a number of kernel
+	  features.
+
+	  This option is recommended for release builds. With LTO
+	  the kernel always has to be re-optimized (but not re-parsed)
+	  on each build.
+
+	  This requires a gcc 4.8 or later compiler and
+	  Linux binutils 2.21.51.0.3 or later.  gcc 4.9 builds significantly
+	  faster than 4.8 It does not currently work with a FSF release of
+	  binutils or with the gold linker.
+
+	  On larger configurations this may need more than 4GB of RAM.
+	  It will likely not work on those with a 32bit compiler.
+
+	  When the toolchain support is not available this will (hopefully)
+	  be automatically disabled.
+
+	  For more information see Documentation/lto-build
+
+config LTO_DISABLE
+         bool "Disable LTO again"
+         depends on LTO_MENU
+         default n
+         help
+           This option is merely here so that allyesconfig or allmodconfig do
+           not enable LTO. If you want to actually use LTO do not enable.
+
+config LTO
+	bool
+	default y
+	depends on LTO_MENU && !LTO_DISABLE
+
+config LTO_DEBUG
+	bool "Enable LTO compile time debugging"
+	depends on LTO
+	help
+	  Enable LTO debugging in the compiler. The compiler dumps
+	  some log files that make it easier to figure out LTO
+	  behavior. The log files also allow to reconstruct
+	  the global inlining and a global callgraph.
+	  They however add some (single threaded) cost to the
+	  compilation.  When in doubt do not enable.
+
+config LTO_CP_CLONE
+	bool "Allow aggressive cloning for function specialization"
+	depends on LTO
+	help
+	  Allow the compiler to clone and specialize functions for specific
+	  arguments when it determines these arguments are very commonly
+	  called.  Experimential. Will increase text size.
+
+config LTO_SLIM
+	#bool "Use slim lto"
+	def_bool y
+	depends on LTO
+	help
+	  Do not generate all code twice. The object files will only contain
+	  LTO information. This lowers build time.
+
 config SYSCTL
 	bool
 
@@ -1715,6 +1794,8 @@ config MODULE_FORCE_UNLOAD
 
 config MODVERSIONS
 	bool "Module versioning support"
+	# LTO should work with gcc 4.9
+	depends on !LTO
 	help
 	  Usually, you have to use modules compiled with your kernel.
 	  Saying Y here makes it sometimes possible to use modules
diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index d04ce8a..32f65b7 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -2,7 +2,7 @@ menu "GCOV-based kernel profiling"
 
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
-	depends on DEBUG_FS
+	depends on DEBUG_FS && !LTO
 	select CONSTRUCTORS if !UML
 	default n
 	---help---
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 5cbf0c5..40e8a3b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -180,7 +180,7 @@ config STRIP_ASM_SYMS
 
 config READABLE_ASM
         bool "Generate readable assembler code"
-        depends on DEBUG_KERNEL
+        depends on DEBUG_KERNEL && !LTO
         help
           Disable some compiler optimizations that tend to generate human unreadable
           assembler output. This may make the kernel slightly slower, but it helps
diff --git a/scripts/Makefile.lto b/scripts/Makefile.lto
new file mode 100644
index 0000000..0beeba1
--- /dev/null
+++ b/scripts/Makefile.lto
@@ -0,0 +1,85 @@
+#
+# Support for gcc link time optimization
+#
+
+DISABLE_LTO :=
+LTO_CFLAGS :=
+
+export DISABLE_LTO
+export LTO_CFLAGS
+
+ifdef CONFIG_LTO
+# 4.7 works mostly, but it sometimes loses symbols on large builds
+# This can be worked around by marking those symbols visible,
+# but that is fairly ugly and the problem is gone with 4.8
+# So only allow it with 4.8 for now.
+ifeq ($(call cc-ifversion, -ge, 0408,y),y)
+ifneq ($(call cc-option,${LTO_CFLAGS},n),n)
+# We need HJ Lu's Linux binutils because mainline binutils does not
+# support mixing assembler and LTO code in the same ld -r object.
+# XXX check if the gcc plugin ld is the expected one too
+# XXX some Fedora binutils should also support it. How to check for that?
+ifeq ($(call ld-ifversion,-ge,22710001,y),y)
+        LTO_CFLAGS := -flto -fno-toplevel-reorder
+	LTO_FINAL_CFLAGS := -fuse-linker-plugin
+
+# the -fno-toplevel-reorder is to preserve the order of initcalls
+# everything else should tolerate reordering
+        LTO_FINAL_CFLAGS +=-fno-toplevel-reorder
+
+# enable LTO and set the jobs used by the LTO phase
+# this should be -flto=jobserver to coordinate with the
+# parent make, but work around
+# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=50639
+# use as many jobs as processors are online for now
+# this actually seems to be a kernel bug with the pipe code
+	LTO_FINAL_CFLAGS := -flto=$(shell getconf _NPROCESSORS_ONLN)
+	#LTO_FINAL_CFLAGS := -flto=jobserver
+
+ifdef CONFIG_LTO_SLIM
+	# requires plugin ar passed and very recent HJ binutils
+        LTO_CFLAGS += -fno-fat-lto-objects
+endif
+# Used to disable LTO for specific files (e.g. vdso)
+	DISABLE_LTO := -fno-lto
+
+	LTO_FINAL_CFLAGS += ${LTO_CFLAGS} -fwhole-program
+
+ifdef CONFIG_LTO_DEBUG
+	LTO_FINAL_CFLAGS += -dH -fdump-ipa-cgraph -fdump-ipa-inline-details
+	# -Wl,-plugin-save-temps -save-temps
+	LTO_CFLAGS +=
+endif
+ifdef CONFIG_LTO_CP_CLONE
+	LTO_FINAL_CFLAGS += -fipa-cp-clone
+	LTO_CFLAGS += -fipa-cp-clone
+endif
+
+	# In principle gcc should pass through options in the object files,
+	# but it doesn't always work. So do it here manually
+	# Note that special options for individual files does not
+	# work currently (except for some special cases that only
+	# affect the compiler frontend)
+	# The main offenders are FTRACE and GCOV -- we exclude
+	# those in the config.
+	LTO_FINAL_CFLAGS += $(filter -g%,${KBUILD_CFLAGS})
+	LTO_FINAL_CFLAGS += $(filter -O%,${KBUILD_CFLAGS})
+	LTO_FINAL_CFLAGS += $(filter -f%,${KBUILD_CFLAGS})
+	LTO_FINAL_CFLAGS += $(filter -m%,${KBUILD_CFLAGS})
+	LTO_FINAL_CFLAGS += $(filter -W%,${KBUILD_CFLAGS})
+
+	KBUILD_CFLAGS += ${LTO_CFLAGS}
+
+	LDFINAL := ${CONFIG_SHELL} ${srctree}/scripts/gcc-ld \
+                  ${LTO_FINAL_CFLAGS}
+
+else
+        $(warning "WARNING: Too old linker version $(call ld-version) for kernel LTO. You need Linux binutils. CONFIG_LTO disabled.")
+endif
+else
+        $(warning "WARNING: Compiler/Linker does not support LTO/WHOPR with linker plugin. CONFIG_LTO disabled.")
+endif
+else
+        $(warning "WARNING: GCC $(call cc-version) too old for LTO/WHOPR. CONFIG_LTO disabled")
+endif
+endif
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 69f0a14..9c40dae 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -77,7 +77,8 @@ modpost = scripts/mod/modpost                    \
  $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(KBUILD_EXTRA_SYMBOLS))) \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
- $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
+ $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w) \
+ $(if $(CONFIG_LTO),-w)
 
 MODPOST_OPT=$(subst -i,-n,$(filter -i,$(MAKEFLAGS)))
 
@@ -115,8 +116,8 @@ $(modules:.ko=.mod.o): %.mod.o: %.mod.c FORCE
 targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
-quiet_cmd_ld_ko_o = LD [M]  $@
-      cmd_ld_ko_o = $(LD) -r $(LDFLAGS)                                 \
+quiet_cmd_ld_ko_o = LDFINAL [M]  $@
+      cmd_ld_ko_o = $(LDFINAL) -r $(LDFLAGS)                            \
                              $(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE) \
                              -o $@ $(filter-out FORCE,$^)
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 5a28f2a..177034b 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -53,7 +53,7 @@ vmlinux_link()
 	local lds="${objtree}/${KBUILD_LDS}"
 
 	if [ "${SRCARCH}" != "um" ]; then
-		${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${2}                  \
+		${LDFINAL} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${2}                  \
 			-T ${lds} ${KBUILD_VMLINUX_INIT}                     \
 			--start-group ${KBUILD_VMLINUX_MAIN} --end-group ${1}
 	else
-- 
1.8.5.2

