Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaBHIEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 03:04:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:8677 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaBHICK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 03:02:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="451784224"
From: Andi Kleen <ak@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/17] Kbuild, lto: Add Link Time Optimization support
Date: Sat,  8 Feb 2014 09:01:18 +0100
Message-Id: <1391846481-31491-14-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With LTO gcc will do whole program optimizations for
the whole kernel and each module. This increases compile time,
but can generate faster and smaller code and allows
the compiler to do global checking.

LTO allows gcc to inline functions between different files and
do various other optimization across the whole binary.

It might also trigger bugs due to more aggressive optimization.
It allows gcc to drop unused code. It also allows it to check
types over the whole program.

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
incompatible with LTO currently. MODVERSIONS should be fixable,
but the others require setting special compiler options
for specific files, which LTO currently doesn't support.
[MODVERSIONS should in principle work with gcc 4.9, but still disabled]
- I also disable strict copy user checks because they trigger
errors with LTO.
- I had to use a hack to support the single pass kallsyms,
as gcc-nm does not support static symbols currently
- modpost symbol checking is downgraded to a warning,
as in some cases modpost runs before the final link
and it cannot resolve LTO symbols at this point.

For more information see Documentation/lto-build

Thanks to HJ Lu, Joe Mario, Honza Hubicka, Richard Guenther,
Don Zickus, Changlong Xie who helped with this project
(and probably some more who I forgot, sorry)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Makefile                 |  9 +++++-
 arch/x86/Kconfig         |  2 +-
 init/Kconfig             | 70 +++++++++++++++++++++++++++++++++++++++-
 kernel/gcov/Kconfig      |  2 +-
 scripts/Makefile.lto     | 84 ++++++++++++++++++++++++++++++++++++++++++++++++
 scripts/Makefile.modpost |  7 ++--
 scripts/gcc-ld           |  1 +
 scripts/kallsyms.c       |  4 ++-
 scripts/link-vmlinux.sh  | 28 +++++++++++++---
 9 files changed, 194 insertions(+), 13 deletions(-)
 create mode 100644 scripts/Makefile.lto

diff --git a/Makefile b/Makefile
index d1189ea..68e1528 100644
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
index f125c5f..bba793f 100644
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
index 009a797..9561935 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1241,6 +1241,70 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say N.
 
+config LTO_MENU
+	bool "Enable gcc link time optimizations"
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
+	  different files. It might also trigger bugs due to more
+	  aggressive optimization. It allows gcc to drop unused code.
+	  With this option gcc will also do some global checking over
+	  different source files.
+
+	  This requires a gcc 4.7 or later compiler and
+	  Linux binutils 2.21.51.0.3 or later.  It does not currently
+	  work with a FSF release of binutils or with gold.
+
+	  On larger configurations this may need more than 4GB of RAM.
+	  It will likely not work on those with a 32bit compiler. Also
+	  /tmp in tmpfs may lead to faster running out of RAM
+	  (in this case set the TMPDIR environment variable to a different
+	  directory directly on disk)
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
+           This option is merely here so that allyesconfig or allmodconfig does
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
+
+config LTO_CP_CLONE
+	bool "Allow aggressive cloning for constant specialization"
+	depends on LTO
+	help
+	  Allow the compiler to clone functions for specific arguments.
+	  Experimential. Will increase text size.
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
 
@@ -1317,7 +1381,10 @@ config KALLSYMS
 
 config KALLSYMS_ALL
 	bool "Include all symbols in kallsyms"
-	depends on DEBUG_KERNEL && KALLSYMS
+	# the method LTO uses to predict the symbol table
+	# only supports functions for now
+	# This can be removed once http://gcc.gnu.org/PR60016 is fixed
+	depends on DEBUG_KERNEL && KALLSYMS && !LTO
 	help
 	   Normally kallsyms only contains the symbols of functions for nicer
 	   OOPS messages and backtraces (i.e., symbols from the text and inittext
@@ -1712,6 +1779,7 @@ config MODULE_FORCE_UNLOAD
 
 config MODVERSIONS
 	bool "Module versioning support"
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
diff --git a/scripts/Makefile.lto b/scripts/Makefile.lto
new file mode 100644
index 0000000..df1d8ea
--- /dev/null
+++ b/scripts/Makefile.lto
@@ -0,0 +1,84 @@
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
 
diff --git a/scripts/gcc-ld b/scripts/gcc-ld
index cadab9a..a9161da 100644
--- a/scripts/gcc-ld
+++ b/scripts/gcc-ld
@@ -18,6 +18,7 @@ while [ "$1" != "" ] ; do
 -rpath-link|--sort-section|--section-start|-Tbss|-Tdata|-Ttext|\
 --version-script|--dynamic-list|--version-exports-symbol|--wrap|-m)
 		A="$1" ; shift ; N="-Wl,$A,$1" ;;
+	--param) shift ; N="--param $1" ;;
 	-[m]*) N="$1" ;;
 	-*) N="-Wl,$1" ;;
 	*)  N="$1" ;;
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index d0e2b56..e479076 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -247,11 +247,13 @@ static int symbol_valid(struct sym_entry *s)
 		 * the kallsyms data are added.  If these symbols move then
 		 * they may get dropped in pass 2, which breaks the kallsyms
 		 * rules.
+		 * But don't do this for predicted fake symbols with 0 value.
 		 */
-		if ((s->addr == text_range_text->end &&
+		if (((s->addr == text_range_text->end &&
 				strcmp((char *)s->sym + offset, text_range_text->etext)) ||
 		    (s->addr == text_range_inittext->end &&
 				strcmp((char *)s->sym + offset, text_range_inittext->etext)))
+			&& text_range_text->end != 0)
 			return 0;
 	}
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 0300047..4c5435f 100644
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
@@ -90,10 +90,28 @@ kallsyms()
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
 		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
 
-	${NM} -n ${1} | \
-		awk 'NF == 3 { print}' |
-		scripts/kallsyms ${kallsymopt} | \
+	# workaround for slim LTO gcc-nm not outputing static symbols
+	# http://gcc.gnu.org/PR60016
+	# generate a fake symbol table based on the LTO function sections.
+	# This unfortunately "knows" about the internal LTO file format
+	# and only works for functions
+	# needs perl for now when building for LTO
+	(
+	if $OBJDUMP --section-headers ${1} | grep -q \.gnu\.lto_ ; then
+		${OBJDUMP} --section-headers ${1} |
+		perl -ne '
+@n = split;
+next unless $n[1] =~ /\.gnu\.lto_([_a-zA-Z][^.]+)/;
+next if $n[1] eq $prev;
+$prev = $n[1];
+print "0 T ",$1,"\n"'
+	fi
+	${NM} -n ${1} | awk 'NF == 3 { print }'
+	)  > ${2}_sym
+	# run without pipe to make kallsyms errors stop the script
+	./scripts/kallsyms ${kallsymopt} < ${2}_sym |
 		${CC} ${aflags} -c -o ${2} -x assembler-with-cpp -
+
 }
 
 # Create map file with all symbols from ${1}
@@ -181,7 +199,7 @@ if [ -n "${CONFIG_KALLSYMS}" ] ; then
 	kallsymsso=.tmp_kallsyms1.o
 fi
 
-info LD vmlinux
+info LDFINAL vmlinux
 vmlinux_link "${kallsymsso}" vmlinux
 if [ -n "${CONFIG_KALLSYMS}" ] ; then
 	# Now regenerate the kallsyms table and patch it into the
-- 
1.8.5.2

