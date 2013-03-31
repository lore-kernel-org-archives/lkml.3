Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab3CaQxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 12:53:32 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:38336 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab3CaQxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 12:53:30 -0400
Date: Sun, 31 Mar 2013 18:53:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [RFC PATCH] Use target compiler for user binaries in samples/
Message-ID: <20130331165327.GA28591@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user-space binaries build in samples/ uses the installed
headers for the kernel.
Therefore it is wrong that they use the host compiler
to build the samples.

Following is an attempt to create some infrastructure
for building user-space binaries that uses the uapi headers.

As my sparc cross toolchain does not supporting building
user-space I have not been able to test this as good as I hoped...

But faking that my native gcc is a cross gcc seems to work.

This adds two new variables to the top-level Makefile:
UAPICC and UAPICFLAGS

The architectures that supports both 32 and 64 bit set the
appropriate flags in UAPICFLAGS.

scripts/Makefile.uapiprogs cantains all the infrastructure.

I updated the samples for hidraw and seccomp to use the new
infrastructure.

The file says:
+# Sample syntax (see Documentation/kbuild/makefiles.txt for reference)

But I did not bother to write this yet - awaiting feedback.

	Sam


 Makefile                   |    5 ++
 arch/s390/Makefile         |    2 +
 arch/sparc/Makefile        |    2 +
 arch/x86/Makefile          |    1 +
 samples/Makefile           |    5 ++-
 samples/hidraw/Makefile    |   10 +----
 samples/seccomp/Makefile   |   31 +---------------
 scripts/Makefile.build     |    6 ++-
 scripts/Makefile.uapiprogs |   88 ++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 109 insertions(+), 41 deletions(-)

diff --git a/Makefile b/Makefile
index 54d2b2a..b249128 100644
--- a/Makefile
+++ b/Makefile
@@ -244,6 +244,11 @@ HOSTCXX      = g++
 HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
 HOSTCXXFLAGS = -O2
 
+UAPICC       = $(CROSS_COMPILE)gcc
+UAPICFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes
+export UAPICC UAPICFLAGS
+
+
 # Decide whether to build built-in, modular, or both.
 # Normally, just do built-in.
 
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 7e3ce78..7b33550 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -18,6 +18,7 @@ LD_BFD		:= elf32-s390
 LDFLAGS		:= -m elf_s390
 KBUILD_CFLAGS	+= -m31
 KBUILD_AFLAGS	+= -m31
+UAPICFLAGS      += -m31
 UTS_MACHINE	:= s390
 STACK_SIZE	:= 8192
 CHECKFLAGS	+= -D__s390__ -msize-long
@@ -28,6 +29,7 @@ KBUILD_AFLAGS_MODULE += -fPIC
 KBUILD_CFLAGS_MODULE += -fPIC
 KBUILD_CFLAGS	+= -m64
 KBUILD_AFLAGS	+= -m64
+UAPICFLAGS      += -m64
 UTS_MACHINE	:= s390x
 STACK_SIZE	:= 16384
 CHECKFLAGS	+= -D__s390__ -D__s390x__
diff --git a/arch/sparc/Makefile b/arch/sparc/Makefile
index f489626..dea0dfe 100644
--- a/arch/sparc/Makefile
+++ b/arch/sparc/Makefile
@@ -28,6 +28,7 @@ UTS_MACHINE    := sparc
 
 KBUILD_CFLAGS  += -m32 -mcpu=v8 -pipe -mno-fpu -fcall-used-g5 -fcall-used-g7
 KBUILD_AFLAGS  += -m32 -Wa,-Av8
+UAPICFLAGS     += -m32
 
 else
 #####
@@ -44,6 +45,7 @@ KBUILD_CFLAGS += -ffixed-g4 -ffixed-g5 -fcall-used-g7 -Wno-sign-compare
 KBUILD_CFLAGS += -Wa,--undeclared-regs
 KBUILD_CFLAGS += $(call cc-option,-mtune=ultrasparc3)
 KBUILD_AFLAGS += -m64 -mcpu=ultrasparc -Wa,--undeclared-regs
+UAPICFLAGS    += -m64
 
 ifeq ($(CONFIG_MCOUNT),y)
   KBUILD_CFLAGS += -pg
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 5c47726..ee9bcec 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -56,6 +56,7 @@ else
 
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
+        UAPICFLAGS    += -m64
 
 	# Use -mpreferred-stack-boundary=3 if supported.
 	KBUILD_CFLAGS += $(call cc-option,-mno-sse -mpreferred-stack-boundary=3)
diff --git a/samples/Makefile b/samples/Makefile
index 1a60c62..e463d68 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,4 +1,7 @@
 # Makefile for Linux samples code
 
+uapiprogs-$(CONFIG_SAMPLES) += hidraw/
+uapiprogs-$(CONFIG_SAMPLES) += seccomp/
+
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ \
-			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/
+			   hw_breakpoint/ kfifo/ kdb/ rpmsg/
diff --git a/samples/hidraw/Makefile b/samples/hidraw/Makefile
index 382eeae..a1c18df 100644
--- a/samples/hidraw/Makefile
+++ b/samples/hidraw/Makefile
@@ -1,10 +1,2 @@
-# kbuild trick to avoid linker error. Can be omitted if a module is built.
-obj- := dummy.o
-
 # List of programs to build
-hostprogs-y := hid-example
-
-# Tell kbuild to always build the programs
-always := $(hostprogs-y)
-
-HOSTCFLAGS_hid-example.o += -I$(objtree)/usr/include
+uapiprogs-y := hid-example
diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
index 7203e66..0c782bc 100644
--- a/samples/seccomp/Makefile
+++ b/samples/seccomp/Makefile
@@ -1,42 +1,13 @@
-# kbuild trick to avoid linker error. Can be omitted if a module is built.
-obj- := dummy.o
 
-hostprogs-$(CONFIG_SECCOMP_FILTER) := bpf-fancy dropper bpf-direct
+uapiprogs-$(CONFIG_SECCOMP_FILTER) := bpf-fancy dropper bpf-direct
 
-HOSTCFLAGS_bpf-fancy.o += -I$(objtree)/usr/include
 HOSTCFLAGS_bpf-fancy.o += -idirafter $(objtree)/include
-HOSTCFLAGS_bpf-helper.o += -I$(objtree)/usr/include
 HOSTCFLAGS_bpf-helper.o += -idirafter $(objtree)/include
 bpf-fancy-objs := bpf-fancy.o bpf-helper.o
 
-HOSTCFLAGS_dropper.o += -I$(objtree)/usr/include
 HOSTCFLAGS_dropper.o += -idirafter $(objtree)/include
 dropper-objs := dropper.o
 
-HOSTCFLAGS_bpf-direct.o += -I$(objtree)/usr/include
 HOSTCFLAGS_bpf-direct.o += -idirafter $(objtree)/include
 bpf-direct-objs := bpf-direct.o
 
-# Try to match the kernel target.
-ifndef CONFIG_64BIT
-ifndef CROSS_COMPILE
-
-# s390 has -m31 flag to build 31 bit binaries
-ifndef CONFIG_S390
-MFLAG = -m32
-else
-MFLAG = -m31
-endif
-
-HOSTCFLAGS_bpf-direct.o += $(MFLAG)
-HOSTCFLAGS_dropper.o += $(MFLAG)
-HOSTCFLAGS_bpf-helper.o += $(MFLAG)
-HOSTCFLAGS_bpf-fancy.o += $(MFLAG)
-HOSTLOADLIBES_bpf-direct += $(MFLAG)
-HOSTLOADLIBES_bpf-fancy += $(MFLAG)
-HOSTLOADLIBES_dropper += $(MFLAG)
-endif
-endif
-
-# Tell kbuild to always build the programs
-always := $(hostprogs-y)
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 0e801c3..baafe2f 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -115,6 +115,10 @@ ifneq ($(hostprogs-y)$(hostprogs-m),)
 include scripts/Makefile.host
 endif
 
+ifdef uapiprogs-y
+include scripts/Makefile.uapiprogs
+endif
+
 ifneq ($(KBUILD_SRC),)
 # Create output directory if not already present
 _dummy := $(shell [ -d $(obj) ] || mkdir -p $(obj))
@@ -144,7 +148,7 @@ modorder-target := $(obj)/modules.order
 
 __build: $(if $(KBUILD_BUILTIN),$(builtin-target) $(lib-target) $(extra-y)) \
 	 $(if $(KBUILD_MODULES),$(obj-m) $(modorder-target)) \
-	 $(subdir-ym) $(always)
+	 $(subdir-ym) $(always) $(subdir-uapi)
 	@:
 
 # Linus' kernel sanity checking tool
diff --git a/scripts/Makefile.uapiprogs b/scripts/Makefile.uapiprogs
new file mode 100644
index 0000000..e903eca
--- /dev/null
+++ b/scripts/Makefile.uapiprogs
@@ -0,0 +1,88 @@
+# ==========================================================================
+# Building uapi binaries for ARCH on the host system using kernel
+# uapi header include files
+#
+# Sample syntax (see Documentation/kbuild/makefiles.txt for reference)
+# uapiprogs-y := hid-example
+# Will compile hid-example.c and create an executable named hid-example
+#
+# uapiprogs-y    := bpf-fancy
+# bpf-fancy-objs := bpf-fancy.o bpf-helper.o
+# Will compile bpf-fancy.c and bpf-helper.c, and then link the executable
+# bpf-fancy, based on bpf-fancy.o bpf-helper.o
+#
+
+__uapiprogs := $(sort $(uapiprogs-y))
+
+# sub-directories to visit
+# uapiprogs-y  := hidraw/ may have been specified. Retrieve directory
+subdir-uapi    := $(patsubst %/,%,$(filter %/, $(__uapiprogs)))
+
+# Drop all subdirs from list
+__uapiprogs    := $(filter-out %/, $(__uapiprogs))
+
+# Executables compiled from a single .c file
+uapi-csingle	:= $(foreach m,$(__uapiprogs),$(if $($(m)-objs),,$(m)))
+
+# Executables linked based on several .o files
+uapi-cmulti	:= $(foreach m,$(__uapiprogs), $(if $($(m)-objs),$(m)))
+
+# Object (.o) files compiled from .c files
+uapi-cobjs	:= $(sort $(foreach m,$(__uapiprogs),$($(m)-objs)))
+
+uapi-csingle	:= $(addprefix $(obj)/,$(uapi-csingle))
+uapi-cmulti	:= $(addprefix $(obj)/,$(uapi-cmulti))
+uapi-cobjs	:= $(addprefix $(obj)/,$(uapi-cobjs))
+subdir-uapi     := $(addprefix $(obj)/,$(subdir-uapi))
+
+#####
+# Handle options to gcc. Support building with separate output directory
+
+_uapic_flags   = $(UAPICFLAGS)                  \
+                 -Iusr/include                  \
+                 $(UAPI_EXTRACFLAGS)            \
+                 $(UAPICFLAGS_$(basetarget).o)
+
+ifeq ($(KBUILD_SRC),)
+__uapic_flags	= $(_uapic_flags)
+else
+__uapic_flags	= -I$(obj) $(call flags,_uapic_flags)
+endif
+
+uapic_flags    = -Wp,-MD,$(depfile) $(__uapic_flags)
+
+#####
+# Compile uapi programs on the build host
+
+# Create executable from a single .c file
+# uapi-csingle -> Executable
+quiet_cmd_uapi-csingle = UAPICC  $@
+      cmd_uapi-csingle = $(UAPICC) $(uapic_flags) -o $@ $<
+$(uapi-csingle): $(obj)/%: $(src)/%.c FORCE
+	$(call if_changed_dep,uapi-csingle)
+
+# Link an executable based on list of .o files, all plain c
+# uapi-cmulti -> executable
+quiet_cmd_uapi-cmulti	= UAPILD  $@
+      cmd_uapi-cmulti	= $(UAPICC) -o $@ \
+			  $(addprefix $(obj)/,$($(@F)-objs))
+$(uapi-cmulti): $(obj)/%: $(uapi-cobjs) $(uapi-cshlib) FORCE
+	$(call if_changed,uapi-cmulti)
+
+# Create .o file from a single .c file
+# uapi-cobjs -> .o
+quiet_cmd_uapi-cobjs	= UAPICC  $@
+      cmd_uapi-cobjs	= $(UAPICC) $(uapic_flags) -c -o $@ $<
+$(uapi-cobjs): $(obj)/%.o: $(src)/%.c FORCE
+	$(call if_changed_dep,uapi-cobjs)
+
+# Descending
+# ---------------------------------------------------------------------------
+$(info subdir=$(subdir-uapi))
+PHONY += $(subdir-uapi)
+$(subdir-uapi):
+	$(Q)$(MAKE) $(build)=$@
+
+targets += $(uapi-csingle) $(uapi-cmulti) $(uapi-cobjs)
+always += $(uapi-csingle) $(uapi-cmulti)
+
-- 
1.6.0.6

