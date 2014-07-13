Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaGMSn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 14:43:29 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:60625 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaGMSnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 14:43:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/6] kbuild: add support for building userspace api programs
Date: Sun, 13 Jul 2014 20:42:49 +0200
Message-Id: <1405276974-17323-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <20140713183636.GA17241@ravnborg.org>
References: <20140713183636.GA17241@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dedicated support for building the usersapce api sample
programs that is located in samples/
The dedicated kbuild support allows us to use much simpler
Makefile fragments while building the userspace programs for
the same host as the kernel.

The syntax looks like this:

    uapiprogs-y := hid-example

This will build the userspace program hid-example from
hid-example.c and include files will be preferred from
the exported uapi headers.

The userspace sample programs rely on the exported uapi
header files and thus are supposed to be built for the
same architecture as the kernel. Bit bit-size will be the
same as used for the kernel so there is no support for
building 32 bit binaries for a 64 bit kernel.

To build the userspace programs the toolchain needs to
include support for this - so this change will break
the build for the setups that rely on toolchain without
any libc included.

One fix for this would be to add a libc to the kernel,
but this seems to be a rather drastic measure just to support
building a few sample programs.
The better fix is to use toolchains with libc support.

This patch introduces only the infrastructure - including
the setup for various architectures to specify -m option.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 Documentation/kbuild/kbuild.txt    |   5 ++
 Documentation/kbuild/makefiles.txt | 132 ++++++++++++++++++++++++-------------
 Makefile                           |   4 ++
 arch/s390/Makefile                 |   2 +
 arch/sparc/Makefile                |   2 +
 arch/x86/Makefile                  |   2 +
 scripts/Makefile.build             |   4 ++
 scripts/Makefile.clean             |   9 +--
 scripts/Makefile.uapiprogs         |  63 ++++++++++++++++++
 9 files changed, 172 insertions(+), 51 deletions(-)
 create mode 100644 scripts/Makefile.uapiprogs

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 6466704..6b691d3b 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -233,3 +233,8 @@ KBUILD_VMLINUX_MAIN
 All object files for the main part of vmlinux.
 KBUILD_VMLINUX_INIT and KBUILD_VMLINUX_MAIN together specify
 all the object files used to link vmlinux.
+
+UAPICFLAGS
+--------------------------------------------------
+Arch specific flags used when building sample binaries.
+This is usually the machine size (32 versus 64 bit).
diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index c600e2f..713ea10 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -29,30 +29,32 @@ This document describes the Linux kernel Makefiles.
 	   --- 4.6 When host programs are actually built
 	   --- 4.7 Using hostprogs-$(CONFIG_FOO)
 
-	=== 5 Kbuild clean infrastructure
-
-	=== 6 Architecture Makefiles
-	   --- 6.1 Set variables to tweak the build to the architecture
-	   --- 6.2 Add prerequisites to archheaders:
-	   --- 6.3 Add prerequisites to archprepare:
-	   --- 6.4 List directories to visit when descending
-	   --- 6.5 Architecture-specific boot images
-	   --- 6.6 Building non-kbuild targets
-	   --- 6.7 Commands useful for building a boot image
-	   --- 6.8 Custom kbuild commands
-	   --- 6.9 Preprocessing linker scripts
-	   --- 6.10 Generic header files
-
-	=== 7 Kbuild syntax for exported headers
-		--- 7.1 header-y
-		--- 7.2 genhdr-y
-		--- 7.3 destination-y
-		--- 7.4 generic-y
-
-	=== 8 Kbuild Variables
-	=== 9 Makefile language
-	=== 10 Credits
-	=== 11 TODO
+	=== 5 Samples support (uapiprogs-y)
+
+	=== 6 Kbuild clean infrastructure
+
+	=== 7 Architecture Makefiles
+	   --- 7.1 Set variables to tweak the build to the architecture
+	   --- 7.2 Add prerequisites to archheaders:
+	   --- 7.3 Add prerequisites to archprepare:
+	   --- 7.4 List directories to visit when descending
+	   --- 7.5 Architecture-specific boot images
+	   --- 7.6 Building non-kbuild targets
+	   --- 7.7 Commands useful for building a boot image
+	   --- 7.8 Custom kbuild commands
+	   --- 7.9 Preprocessing linker scripts
+	   --- 7.10 Generic header files
+
+	=== 8 Kbuild syntax for exported headers
+		--- 8.1 header-y
+		--- 8.2 genhdr-y
+		--- 8.3 destination-y
+		--- 8.4 generic-y
+
+	=== 9 Kbuild Variables
+	=== 10 Makefile language
+	=== 11 Credits
+	=== 12 TODO
 
 === 1 Overview
 
@@ -761,7 +763,43 @@ Both possibilities are described in the following.
 	like hostprogs-y. But only hostprogs-y is recommended to be used
 	when no CONFIG symbols are involved.
 
-=== 5 Kbuild clean infrastructure
+=== 5 Samples support (uapiprogs-y)
+
+Kbuild support building sample modules and sample binaries.
+To build sample modules the existing infrastructure is used, but
+to build sample binaries kbuild adds dedicated suppport.
+
+The sample binaries are build for the same host and bit-size as the kernel.
+
+The samples may demonstrate facilities not yet available
+in the installed libc therefore they are build so they include
+headers from the exported uapi headers before the libc headers
+are searched.
+
+The sample binaries are usually placed in sub-directories
+below samples/ and specified in samples/Makefile.
+The directories containing sample binaries are listed using
+subdir-y - usually like this: subdir-$(CONFIG_SAMPLES) += dir
+
+The individual binaries may be defined as single .c file per binary
+or several .c files for a single binary.
+See the following examples.
+
+	Example:
+		# samples/hid/Makefile
+		uapiprogs-y := hid-example
+
+	This will compile hid-example.c and create an executable named hid-example.
+
+	Example:
+		# samples/seccomp/Makefile
+		uapiprogs-y := bpf-fancy
+		bpf-fancy-y := bpf-fancy.o bpf-helper.o
+
+This will compile bpf-fancy.c and bpf-helper.c, and then link the executable
+bpf-fancy, based on bpf-fancy.o bpf-helper.o.
+
+=== 6 Kbuild clean infrastructure
 
 "make clean" deletes most generated files in the obj tree where the kernel
 is compiled. This includes generated files such as host programs.
@@ -828,7 +866,7 @@ is not operational at that point.
 Note 2: All directories listed in core-y, libs-y, drivers-y and net-y will
 be visited during "make clean".
 
-=== 6 Architecture Makefiles
+=== 7 Architecture Makefiles
 
 The top level Makefile sets up the environment and does the preparation,
 before starting to descend down in the individual directories.
@@ -857,7 +895,7 @@ When kbuild executes, the following steps are followed (roughly):
    - Preparing initrd images and the like
 
 
---- 6.1 Set variables to tweak the build to the architecture
+--- 7.1 Set variables to tweak the build to the architecture
 
     LDFLAGS		Generic $(LD) options
 
@@ -976,7 +1014,7 @@ When kbuild executes, the following steps are followed (roughly):
 	$(KBUILD_ARFLAGS) set by the top level Makefile to "D" (deterministic
 	mode) if this option is supported by $(AR).
 
---- 6.2 Add prerequisites to archheaders:
+--- 7.2 Add prerequisites to archheaders:
 
 	The archheaders: rule is used to generate header files that
 	may be installed into user space by "make header_install" or
@@ -989,7 +1027,7 @@ When kbuild executes, the following steps are followed (roughly):
 	architecture itself.
 
 
---- 6.3 Add prerequisites to archprepare:
+--- 7.3 Add prerequisites to archprepare:
 
 	The archprepare: rule is used to list prerequisites that need to be
 	built before starting to descend down in the subdirectories.
@@ -1005,7 +1043,7 @@ When kbuild executes, the following steps are followed (roughly):
 	generating offset header files.
 
 
---- 6.4 List directories to visit when descending
+--- 7.4 List directories to visit when descending
 
 	An arch Makefile cooperates with the top Makefile to define variables
 	which specify how to build the vmlinux file.  Note that there is no
@@ -1034,7 +1072,7 @@ When kbuild executes, the following steps are followed (roughly):
 		drivers-$(CONFIG_OPROFILE)  += arch/sparc64/oprofile/
 
 
---- 6.5 Architecture-specific boot images
+--- 7.5 Architecture-specific boot images
 
 	An arch Makefile specifies goals that take the vmlinux file, compress
 	it, wrap it in bootstrapping code, and copy the resulting files
@@ -1085,7 +1123,7 @@ When kbuild executes, the following steps are followed (roughly):
 
 	When "make" is executed without arguments, bzImage will be built.
 
---- 6.6 Building non-kbuild targets
+--- 7.6 Building non-kbuild targets
 
     extra-y
 
@@ -1105,7 +1143,7 @@ When kbuild executes, the following steps are followed (roughly):
 	shall be built, but shall not be linked as part of built-in.o.
 
 
---- 6.7 Commands useful for building a boot image
+--- 7.7 Commands useful for building a boot image
 
 	Kbuild provides a few macros that are useful when building a
 	boot image.
@@ -1127,7 +1165,7 @@ When kbuild executes, the following steps are followed (roughly):
 	always be built.
 	Assignments to $(targets) are without $(obj)/ prefix.
 	if_changed may be used in conjunction with custom commands as
-	defined in 6.8 "Custom kbuild commands".
+	defined in 7.8 "Custom kbuild commands".
 
 	Note: It is a typical mistake to forget the FORCE prerequisite.
 	Another common pitfall is that whitespace is sometimes
@@ -1210,7 +1248,7 @@ When kbuild executes, the following steps are followed (roughly):
 	A central rule exists to create $(obj)/%.dtb from $(src)/%.dtsp;
 	architecture Makefiles do no need to explicitly write out that rule.
 
---- 6.8 Custom kbuild commands
+--- 7.8 Custom kbuild commands
 
 	When kbuild is executing with KBUILD_VERBOSE=0, then only a shorthand
 	of a command is normally displayed.
@@ -1237,7 +1275,7 @@ When kbuild executes, the following steps are followed (roughly):
 	will be displayed with "make KBUILD_VERBOSE=0".
 
 
---- 6.9 Preprocessing linker scripts
+--- 7.9 Preprocessing linker scripts
 
 	When the vmlinux image is built, the linker script
 	arch/$(ARCH)/kernel/vmlinux.lds is used.
@@ -1267,15 +1305,15 @@ When kbuild executes, the following steps are followed (roughly):
 	The kbuild infrastructure for *lds file are used in several
 	architecture-specific files.
 
---- 6.10 Generic header files
+--- 7.10 Generic header files
 
 	The directory include/asm-generic contains the header files
 	that may be shared between individual architectures.
 	The recommended approach how to use a generic header file is
 	to list the file in the Kbuild file.
-	See "7.4 generic-y" for further info on syntax etc.
+	See "8.4 generic-y" for further info on syntax etc.
 
-=== 7 Kbuild syntax for exported headers
+=== 8 Kbuild syntax for exported headers
 
 The kernel include a set of headers that is exported to userspace.
 Many headers can be exported as-is but other headers require a
@@ -1289,7 +1327,7 @@ Each relevant directory contains a file name "Kbuild" which specifies the
 headers to be exported.
 See subsequent chapter for the syntax of the Kbuild file.
 
-	--- 7.1 header-y
+	--- 8.1 header-y
 
 	header-y specify header files to be exported.
 
@@ -1307,7 +1345,7 @@ See subsequent chapter for the syntax of the Kbuild file.
 
 	Subdirectories are visited before their parent directories.
 
-	--- 7.2 genhdr-y
+	--- 8.2 genhdr-y
 
 	genhdr-y specifies generated files to be exported.
 	Generated files are special as they need to be looked
@@ -1317,7 +1355,7 @@ See subsequent chapter for the syntax of the Kbuild file.
 			#include/linux/Kbuild
 			genhdr-y += version.h
 
-	--- 7.3 destination-y
+	--- 8.3 destination-y
 
 	When an architecture have a set of exported headers that needs to be
 	exported to a different directory destination-y is used.
@@ -1331,7 +1369,7 @@ See subsequent chapter for the syntax of the Kbuild file.
 	In the example above all exported headers in the Kbuild file
 	will be located in the directory "include/linux" when exported.
 
-	--- 7.4 generic-y
+	--- 8.4 generic-y
 
 	If an architecture uses a verbatim copy of a header from
 	include/asm-generic then this is listed in the file
@@ -1358,7 +1396,7 @@ See subsequent chapter for the syntax of the Kbuild file.
 		Example: termios.h
 			#include <asm-generic/termios.h>
 
-=== 8 Kbuild Variables
+=== 9 Kbuild Variables
 
 The top Makefile exports the following variables:
 
@@ -1421,7 +1459,7 @@ The top Makefile exports the following variables:
 	command.
 
 
-=== 9 Makefile language
+=== 10 Makefile language
 
 The kernel Makefiles are designed to be run with GNU Make.  The Makefiles
 use only the documented features of GNU Make, but they do use many
@@ -1440,14 +1478,14 @@ time the left-hand side is used.
 There are some cases where "=" is appropriate.  Usually, though, ":="
 is the right choice.
 
-=== 10 Credits
+=== 11 Credits
 
 Original version made by Michael Elizabeth Chastain, <mailto:mec@shout.net>
 Updates by Kai Germaschewski <kai@tp1.ruhr-uni-bochum.de>
 Updates by Sam Ravnborg <sam@ravnborg.org>
 Language QA by Jan Engelhardt <jengelh@gmx.de>
 
-=== 11 TODO
+=== 12 TODO
 
 - Describe how kbuild supports shipped files with _shipped.
 - Generating offset header files.
diff --git a/Makefile b/Makefile
index 4d75b4b..7fda2ba 100644
--- a/Makefile
+++ b/Makefile
@@ -935,8 +935,12 @@ prepare1: prepare2 $(version_h) include/generated/utsrelease.h \
 
 archprepare: archheaders archscripts prepare1 scripts_basic
 
+# To build userspace samples the uapi headers needs to be exported
 prepare0: archprepare FORCE
 	$(Q)$(MAKE) $(build)=.
+ifdef CONFIG_SAMPLES
+	$(Q)$(MAKE) KBUILD_SRC= headers_install
+endif
 
 # All the preparing..
 prepare: prepare0
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 874e6d6..4b32933 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -18,6 +18,7 @@ LD_BFD		:= elf32-s390
 LDFLAGS		:= -m elf_s390
 KBUILD_CFLAGS	+= -m31
 KBUILD_AFLAGS	+= -m31
+UAPICFLAGS	+= -m31
 UTS_MACHINE	:= s390
 STACK_SIZE	:= 8192
 CHECKFLAGS	+= -D__s390__ -msize-long
@@ -28,6 +29,7 @@ KBUILD_AFLAGS_MODULE += -fPIC
 KBUILD_CFLAGS_MODULE += -fPIC
 KBUILD_CFLAGS	+= -m64
 KBUILD_AFLAGS	+= -m64
+UAPICFLAGS	+= -m64
 UTS_MACHINE	:= s390x
 STACK_SIZE	:= 16384
 CHECKFLAGS	+= -D__s390__ -D__s390x__
diff --git a/arch/sparc/Makefile b/arch/sparc/Makefile
index 9ff4236..08a5f78 100644
--- a/arch/sparc/Makefile
+++ b/arch/sparc/Makefile
@@ -26,6 +26,7 @@ UTS_MACHINE    := sparc
 
 KBUILD_CFLAGS  += -m32 -mcpu=v8 -pipe -mno-fpu -fcall-used-g5 -fcall-used-g7
 KBUILD_AFLAGS  += -m32 -Wa,-Av8
+UAPICFLAGS     += -m32
 
 else
 #####
@@ -42,6 +43,7 @@ KBUILD_CFLAGS += -ffixed-g4 -ffixed-g5 -fcall-used-g7 -Wno-sign-compare
 KBUILD_CFLAGS += -Wa,--undeclared-regs
 KBUILD_CFLAGS += $(call cc-option,-mtune=ultrasparc3)
 KBUILD_AFLAGS += -m64 -mcpu=ultrasparc -Wa,--undeclared-regs
+UAPICFLAGS    += -m64
 
 ifeq ($(CONFIG_MCOUNT),y)
   KBUILD_CFLAGS += -pg
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 33f71b0..4f21420 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -50,6 +50,7 @@ ifeq ($(CONFIG_X86_32),y)
         biarch := $(call cc-option,-m32)
         KBUILD_AFLAGS += $(biarch)
         KBUILD_CFLAGS += $(biarch)
+        UAPICFLAGS    += $(biarch)
 
         KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
 
@@ -82,6 +83,7 @@ else
         biarch := -m64
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
+        UAPICFLAGS    += -m64
 
         # Don't autogenerate traditional x87, MMX or SSE instructions
         KBUILD_CFLAGS += -mno-mmx -mno-sse
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index bf3e677..5526769 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -64,6 +64,10 @@ ifneq ($(hostprogs-y)$(hostprogs-m),)
 include scripts/Makefile.host
 endif
 
+ifdef uapiprogs-y
+include scripts/Makefile.uapiprogs
+endif
+
 ifneq ($(KBUILD_SRC),)
 # Create output directory if not already present
 _dummy := $(shell [ -d $(obj) ] || mkdir -p $(obj))
diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
index 686cb0d..aee43fa 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -40,10 +40,11 @@ subdir-ymn	:= $(addprefix $(obj)/,$(subdir-ymn))
 # build a list of files to remove, usually relative to the current
 # directory
 
-__clean-files	:= $(extra-y) $(always)                  \
-		   $(targets) $(clean-files)             \
-		   $(host-progs)                         \
-		   $(hostprogs-y) $(hostprogs-m) $(hostprogs-)
+__clean-files	:= $(extra-y) $(always)                        \
+		   $(targets) $(clean-files)                   \
+		   $(host-progs)                               \
+		   $(hostprogs-y) $(hostprogs-m) $(hostprogs-) \
+		   $(uapiprogs-y) $(uapiprogs-)
 
 __clean-files   := $(filter-out $(no-clean-files), $(__clean-files))
 
diff --git a/scripts/Makefile.uapiprogs b/scripts/Makefile.uapiprogs
new file mode 100644
index 0000000..63c09d0
--- /dev/null
+++ b/scripts/Makefile.uapiprogs
@@ -0,0 +1,63 @@
+# ==========================================================================
+# Building uapi binaries for ARCH on the host system using kernel
+# uapi header include files
+#
+# Sample syntax (see Documentation/kbuild/makefiles.txt for reference)
+# uapiprogs-y := hid-example
+# Will compile hid-example.c and create an executable named hid-example
+#
+# uapiprogs-y := bpf-fancy
+# bpf-fancy-y := bpf-fancy.o bpf-helper.o
+# Will compile bpf-fancy.c and bpf-helper.c, and then link the executable
+# bpf-fancy, based on bpf-fancy.o bpf-helper.o
+#
+
+__uapiprogs := $(sort $(uapiprogs-y))
+
+# Executables compiled from a single .c file
+uapi-csingle := $(foreach m,$(__uapiprogs),$(if $($(m)-y),,$(m)))
+
+# Executables linked based on several .o files
+uapi-cmulti := $(foreach m,$(__uapiprogs), $(if $($(m)-y),$(m)))
+
+# Object (.o) files compiled from .c files
+uapi-cobjs := $(sort $(foreach m,$(__uapiprogs),$($(m)-y)))
+
+# Add $(obj) prefix to all paths
+uapi-csingle := $(addprefix $(obj)/,$(uapi-csingle))
+uapi-cmulti  := $(addprefix $(obj)/,$(uapi-cmulti))
+uapi-cobjs   := $(addprefix $(obj)/,$(uapi-cobjs))
+
+# Options to uapicc.
+uapic_flags = -Wp,-MD,$(depfile) -isystem $(INSTALL_HDR_PATH)/include \
+              $(UAPICFLAGS) -Wall
+
+#####
+# Compile uapi programs on the build host
+
+# Create executable from a single .c file
+# uapi-csingle -> executable
+quiet_cmd_uapi-csingle = UAPICC  $@
+      cmd_uapi-csingle = $(CC) $(uapic_flags) -o $@ $<
+$(uapi-csingle): $(obj)/%: $(src)/%.c FORCE
+	$(call if_changed_dep,uapi-csingle)
+
+# Create .o file from a single .c file
+# uapi-cobjs -> .o
+quiet_cmd_uapi-cobjs	= UAPICC  $@
+      cmd_uapi-cobjs	= $(CC) $(uapic_flags) -c -o $@ $<
+$(uapi-cobjs): $(obj)/%.o: $(src)/%.c FORCE
+	$(call if_changed_dep,uapi-cobjs)
+
+# Link an executable based on list of .o files
+# uapi-cmulti -> executable
+quiet_cmd_uapi-cmulti	= UAPILD  $@
+      cmd_uapi-cmulti	= $(CC) -o $@ \
+			  $(addprefix $(obj)/,$($(@F)-y))
+$(uapi-cmulti): $(obj)/%: $(uapi-cobjs) FORCE
+	$(call if_changed,uapi-cmulti)
+
+# Clean support
+targets += $(uapi-csingle) $(uapi-cmulti) $(uapi-cobjs)
+always += $(uapi-csingle) $(uapi-cmulti)
+
-- 
1.9.3

