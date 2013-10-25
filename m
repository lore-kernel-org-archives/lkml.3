Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3JYNEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:04:00 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54520 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3JYNDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:03:54 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Jean Pihet <jean.pihet@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tip tree
Date: Fri, 25 Oct 2013 15:03:42 +0200
Message-Id: <1382706224-8859-4-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382706224-8859-1-git-send-email-treding@nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <1382706224-8859-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the tip tree got conflicts in

	tools/perf/config/Makefile
	tools/perf/config/feature-tests.mak

caused by commits 405ffbd (perf tools: Check libunwind for availability of
dwarf parsing feature) and mostly 308e1e7 (tools/perf/build: Clean up the
libunwind logic in config/Makefile) as well as various follow-up patches.

I fixed it up (see below). Please verify that the resolution looks good.
Also note that this isn't really a trivial resolution of a conflict, but
required modifying various other files. That causes rerere magic not to
work and needs part of conflict to be resolved manually. Perhaps a good
idea would be to rebase Jean's patch on top of the cleanups going on in
the tip tree? Perhaps even carry the patch in the tip tree?

Thanks,
Thierry
---
diff --cc tools/perf/config/Makefile
index 75b93d7,c516d6b..e4d06b2
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@@ -29,13 -29,9 +29,13 @@@ ifeq ($(ARCH),x86_64
    NO_PERF_REGS := 0
    LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
  endif
 +ifeq ($(ARCH),arm)
 +  NO_PERF_REGS := 0
 +  LIBUNWIND_LIBS = -lunwind -lunwind-arm
 +endif
  
  ifeq ($(NO_PERF_REGS),0)
-   CFLAGS += -DHAVE_PERF_REGS
+   CFLAGS += -DHAVE_PERF_REGS_SUPPORT
  endif
  
  ifeq ($(src-perf),)
@@@ -93,20 -85,125 +89,126 @@@ CFLAGS += -std=gnu9
  
  EXTLIBS = -lelf -lpthread -lrt -lm -ldl
  
- ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
-   CFLAGS += -fstack-protector-all
+ ifneq ($(OUTPUT),)
+   OUTPUT_FEATURES = $(OUTPUT)config/feature-checks/
+   $(shell mkdir -p $(OUTPUT_FEATURES))
  endif
  
- ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
-   CFLAGS += -Wstack-protector
+ feature_check = $(eval $(feature_check_code))
+ define feature_check_code
+   feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+ endef
+ 
+ feature_set = $(eval $(feature_set_code))
+ define feature_set_code
+   feature-$(1) := 1
+ endef
+ 
+ #
+ # Build the feature check binaries in parallel, ignore errors, ignore return value and suppress output:
+ #
+ 
+ #
+ # Note that this is not a complete list of all feature tests, just
+ # those that are typically built on a fully configured system.
+ #
+ # [ Feature tests not mentioned here have to be built explicitly in
+ #   the rule that uses them - an example for that is the 'bionic'
+ #   feature check. ]
+ #
+ CORE_FEATURE_TESTS =			\
+ 	backtrace			\
+ 	dwarf				\
+ 	fortify-source			\
+ 	glibc				\
+ 	gtk2				\
+ 	gtk2-infobar			\
+ 	libaudit			\
+ 	libbfd				\
+ 	libelf				\
+ 	libelf-getphdrnum		\
+ 	libelf-mmap			\
+ 	libnuma				\
+ 	libperl				\
+ 	libpython			\
+ 	libpython-version		\
+ 	libslang			\
+ 	libunwind			\
++	libunwind-debug-frame		\
+ 	on-exit				\
+ 	stackprotector			\
+ 	stackprotector-all
+ 
+ #
+ # So here we detect whether test-all was rebuilt, to be able
+ # to skip the print-out of the long features list if the file
+ # existed before and after it was built:
+ #
+ ifeq ($(wildcard $(OUTPUT)config/feature-checks/test-all),)
+   test-all-failed := 1
+ else
+   test-all-failed := 0
+ endif
+ 
+ #
+ # Special fast-path for the 'all features are available' case:
+ #
+ $(call feature_check,all,$(MSG))
+ 
+ #
+ # Just in case the build freshly failed, make sure we print the
+ # feature matrix:
+ #
+ ifeq ($(feature-all), 0)
+   test-all-failed := 1
+ endif
+ 
+ ifeq ($(test-all-failed),1)
+   $(info )
+   $(info Auto-detecting system features:)
+ endif
+ 
+ ifeq ($(feature-all), 1)
+   #
+   # test-all.c passed - just set all the core feature flags to 1:
+   #
+   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
+ else
+   $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
+   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
+ endif
+ 
+ #
+ # Print the result of the feature test:
+ #
+ feature_print = $(eval $(feature_print_code)) $(info $(MSG))
+ 
+ define feature_print_code
+   ifeq ($(feature-$(1)), 1)
+     MSG = $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
+   else
+     MSG = $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
+   endif
+ endef
+ 
+ #
+ # Only print out our features if we rebuilt the testcases or if a test failed:
+ #
+ ifeq ($(test-all-failed), 1)
+   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_print,$(feat)))
+   $(info )
  endif
  
- ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-Wvolatile-register-var),y)
-   CFLAGS += -Wvolatile-register-var
+ ifeq ($(feature-stackprotector-all), 1)
+   CFLAGS += -fstack-protector-all
+ endif
+ 
+ ifeq ($(feature-stackprotector), 1)
+   CFLAGS += -Wstack-protector
  endif
  
- ifndef PERF_DEBUG
-   ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
+ ifeq ($(DEBUG),0)
+   ifeq ($(feature-fortify-source), 1)
      CFLAGS += -D_FORTIFY_SOURCE=2
    endif
  endif
@@@ -179,64 -274,55 +279,59 @@@ els
  endif # NO_LIBELF
  
  ifndef NO_LIBELF
- CFLAGS += -DLIBELF_SUPPORT
- FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
- ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-   CFLAGS += -DLIBELF_MMAP
- endif
- ifeq ($(call try-cc,$(SOURCE_ELF_GETPHDRNUM),$(FLAGS_LIBELF),-DHAVE_ELF_GETPHDRNUM),y)
-   CFLAGS += -DHAVE_ELF_GETPHDRNUM
- endif
+   CFLAGS += -DHAVE_LIBELF_SUPPORT
  
- # include ARCH specific config
- -include $(src-perf)/arch/$(ARCH)/Makefile
+   ifeq ($(feature-libelf-mmap), 1)
+     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
+   endif
  
- ifndef NO_DWARF
- ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
-   msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
-   NO_DWARF := 1
- else
-   CFLAGS += -DDWARF_SUPPORT $(LIBDW_CFLAGS)
-   LDFLAGS += $(LIBDW_LDFLAGS)
-   EXTLIBS += -lelf -ldw
- endif # PERF_HAVE_DWARF_REGS
- endif # NO_DWARF
+   ifeq ($(feature-libelf-getphdrnum), 1)
+     CFLAGS += -DHAVE_ELF_GETPHDRNUM_SUPPORT
+   endif
  
- endif # NO_LIBELF
+   # include ARCH specific config
+   -include $(src-perf)/arch/$(ARCH)/Makefile
  
- ifndef NO_LIBELF
- CFLAGS += -DLIBELF_SUPPORT
- FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
- ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-   CFLAGS += -DLIBELF_MMAP
- endif # try-cc
+   ifndef NO_DWARF
+     ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
+       msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
+       NO_DWARF := 1
+     else
+       CFLAGS += -DHAVE_DWARF_SUPPORT $(LIBDW_CFLAGS)
+       LDFLAGS += $(LIBDW_LDFLAGS)
+       EXTLIBS += -lelf -ldw
+     endif # PERF_HAVE_DWARF_REGS
+   endif # NO_DWARF
  endif # NO_LIBELF
  
 -# There's only x86 (both 32 and 64) support for CFI unwind so far
 -ifneq ($(ARCH),x86)
 +ifeq ($(LIBUNWIND_LIBS),)
    NO_LIBUNWIND := 1
  endif
  
  ifndef NO_LIBUNWIND
- # for linking with debug library, run like:
- # make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
- ifdef LIBUNWIND_DIR
-   LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
-   LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
- endif
+   #
+   # For linking with debug library, run like:
+   #
+   #   make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+   #
+   ifdef LIBUNWIND_DIR
+     LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
+     LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
+   endif
  
- FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS) $(LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
- ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
-   msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
-   NO_LIBUNWIND := 1
- endif # Libunwind support
- ifneq ($(call try-cc,$(SOURCE_LIBUNWIND_DEBUG_FRAME),$(FLAGS_UNWIND),libunwind debug_frame),y)
-   msg := $(warning No debug_frame support found in libunwind);
- CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
- endif # debug_frame support in libunwind
- endif # NO_LIBUNWIND
+   ifneq ($(feature-libunwind), 1)
 -    msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
++    msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
+     NO_LIBUNWIND := 1
++  else
++    ifneq ($(feature-libunwind-debug-frame), 1)
++      msg := $(warning No debug_frame support found in libunwind);
++      CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
++    endif
+   endif
+ endif
  
  ifndef NO_LIBUNWIND
-   CFLAGS += -DLIBUNWIND_SUPPORT
+   CFLAGS += -DHAVE_LIBUNWIND_SUPPORT
    EXTLIBS += $(LIBUNWIND_LIBS)
    CFLAGS += $(LIBUNWIND_CFLAGS)
    LDFLAGS += $(LIBUNWIND_LDFLAGS)
diff --cc tools/perf/config/feature-checks/Makefile
index 0000000,452b67c..abaf8f4
mode 000000,100644..100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@@ -1,0 -1,144 +1,148 @@@
+ 
+ FILES=					\
+ 	test-all			\
+ 	test-backtrace			\
+ 	test-bionic			\
+ 	test-dwarf			\
+ 	test-fortify-source		\
+ 	test-glibc			\
+ 	test-gtk2			\
+ 	test-gtk2-infobar		\
+ 	test-hello			\
+ 	test-libaudit			\
+ 	test-libbfd			\
+ 	test-liberty			\
+ 	test-liberty-z			\
+ 	test-cplus-demangle		\
+ 	test-libelf			\
+ 	test-libelf-getphdrnum		\
+ 	test-libelf-mmap		\
+ 	test-libnuma			\
+ 	test-libperl			\
+ 	test-libpython			\
+ 	test-libpython-version		\
+ 	test-libslang			\
+ 	test-libunwind			\
++	test-libunwind-debug-frame	\
+ 	test-on-exit			\
+ 	test-stackprotector-all		\
+ 	test-stackprotector
+ 
+ CC := $(CC) -MD
+ 
+ all: $(FILES)
+ 
+ BUILD = $(CC) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
+ 
+ ###############################
+ 
+ test-all:
+ 	$(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
+ 
+ test-hello:
+ 	$(BUILD)
+ 
+ test-stackprotector-all:
+ 	$(BUILD) -Werror -fstack-protector-all
+ 
+ test-stackprotector:
+ 	$(BUILD) -Werror -fstack-protector -Wstack-protector
+ 
+ test-fortify-source:
+ 	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
+ 
+ test-bionic:
+ 	$(BUILD)
+ 
+ test-libelf:
+ 	$(BUILD) -lelf
+ 
+ test-glibc:
+ 	$(BUILD)
+ 
+ test-dwarf:
+ 	$(BUILD) -ldw
+ 
+ test-libelf-mmap:
+ 	$(BUILD) -lelf
+ 
+ test-libelf-getphdrnum:
+ 	$(BUILD) -lelf
+ 
+ test-libnuma:
+ 	$(BUILD) -lnuma
+ 
+ test-libunwind:
+ 	$(BUILD) -lunwind -lunwind-x86_64 -lelf
+ 
++test-libunwind-debug-frame:
++	$(BUILD) -lunwind -lunwind-x86_64 -lelf
++
+ test-libaudit:
+ 	$(BUILD) -laudit
+ 
+ test-libslang:
+ 	$(BUILD) -I/usr/include/slang -lslang
+ 
+ test-gtk2:
+ 	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+ 
+ test-gtk2-infobar:
+ 	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+ 
+ grep-libs  = $(filter -l%,$(1))
+ strip-libs = $(filter-out -l%,$(1))
+ 
+ PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
+ PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
+ PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
+ PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+ FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
+ 
+ test-libperl:
+ 	$(BUILD) $(FLAGS_PERL_EMBED)
+ 
+ override PYTHON := python
+ override PYTHON_CONFIG := python-config
+ 
+ escape-for-shell-sq =  $(subst ','\'',$(1))
+ shell-sq = '$(escape-for-shell-sq)'
+ 
+ PYTHON_CONFIG_SQ = $(call shell-sq,$(PYTHON_CONFIG))
+ 
+ PYTHON_EMBED_LDOPTS = $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+ PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+ PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
+ PYTHON_EMBED_CCOPTS = $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
+ FLAGS_PYTHON_EMBED = $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+ 
+ test-libpython:
+ 	$(BUILD) $(FLAGS_PYTHON_EMBED)
+ 
+ test-libpython-version:
+ 	$(BUILD) $(FLAGS_PYTHON_EMBED)
+ 
+ test-libbfd:
+ 	$(BUILD) -DPACKAGE='"perf"' -lbfd -ldl
+ 
+ test-liberty:
+ 	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='"perf"' -lbfd -ldl -liberty
+ 
+ test-liberty-z:
+ 	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='"perf"' -lbfd -ldl -liberty -lz
+ 
+ test-cplus-demangle:
+ 	$(BUILD) -liberty
+ 
+ test-on-exit:
+ 	$(BUILD)
+ 
+ test-backtrace:
+ 	$(BUILD)
+ 
+ -include *.d
+ 
+ ###############################
+ 
+ clean:
+ 	rm -f $(FILES) *.d
diff --cc tools/perf/config/feature-checks/test-all.c
index 0000000,50d4318..ed8aa7b
mode 000000,100644..100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@@ -1,0 -1,106 +1,111 @@@
+ /*
+  * test-all.c: Try to build all the main testcases at once.
+  *
+  * A well-configured system will have all the prereqs installed, so we can speed
+  * up auto-detection on such systems.
+  */
+ 
+ /*
+  * Quirk: Python and Perl headers cannot be in arbitrary places, so keep
+  * these 3 testcases at the top:
+  */
+ #define main main_test_libpython
+ # include "test-libpython.c"
+ #undef main
+ 
+ #define main main_test_libpython_version
+ # include "test-libpython-version.c"
+ #undef main
+ 
+ #define main main_test_libperl
+ # include "test-libperl.c"
+ #undef main
+ 
+ #define main main_test_hello
+ # include "test-hello.c"
+ #undef main
+ 
+ #define main main_test_libelf
+ # include "test-libelf.c"
+ #undef main
+ 
+ #define main main_test_libelf_mmap
+ # include "test-libelf-mmap.c"
+ #undef main
+ 
+ #define main main_test_glibc
+ # include "test-glibc.c"
+ #undef main
+ 
+ #define main main_test_dwarf
+ # include "test-dwarf.c"
+ #undef main
+ 
+ #define main main_test_libelf_getphdrnum
+ # include "test-libelf-getphdrnum.c"
+ #undef main
+ 
+ #define main main_test_libunwind
+ # include "test-libunwind.c"
+ #undef main
+ 
++#define main main_test_libunwind_debug_frame
++# include "test-libunwind-debug-frame.c"
++#undef main
++
+ #define main main_test_libaudit
+ # include "test-libaudit.c"
+ #undef main
+ 
+ #define main main_test_libslang
+ # include "test-libslang.c"
+ #undef main
+ 
+ #define main main_test_gtk2
+ # include "test-gtk2.c"
+ #undef main
+ 
+ #define main main_test_gtk2_infobar
+ # include "test-gtk2-infobar.c"
+ #undef main
+ 
+ #define main main_test_libbfd
+ # include "test-libbfd.c"
+ #undef main
+ 
+ #define main main_test_on_exit
+ # include "test-on-exit.c"
+ #undef main
+ 
+ #define main main_test_backtrace
+ # include "test-backtrace.c"
+ #undef main
+ 
+ #define main main_test_libnuma
+ # include "test-libnuma.c"
+ #undef main
+ 
+ int main(int argc, char *argv[])
+ {
+ 	main_test_libpython();
+ 	main_test_libpython_version();
+ 	main_test_libperl();
+ 	main_test_hello();
+ 	main_test_libelf();
+ 	main_test_libelf_mmap();
+ 	main_test_glibc();
+ 	main_test_dwarf();
+ 	main_test_libelf_getphdrnum();
+ 	main_test_libunwind();
++	main_test_libunwind_debug_frame();
+ 	main_test_libaudit();
+ 	main_test_libslang();
+ 	main_test_gtk2(argc, argv);
+ 	main_test_gtk2_infobar(argc, argv);
+ 	main_test_libbfd();
+ 	main_test_on_exit();
+ 	main_test_backtrace();
+ 	main_test_libnuma();
+ 
+ 	return 0;
+ }
diff --cc tools/perf/config/feature-checks/test-libunwind-debug-frame.c
index 0000000,0000000..0ef8087
new file mode 100644
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libunwind-debug-frame.c
@@@ -1,0 -1,0 +1,16 @@@
++#include <libunwind.h>
++#include <stdlib.h>
++
++extern int
++UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
++				 unw_word_t ip, unw_word_t segbase,
++				 const char *obj_name, unw_word_t start,
++				 unw_word_t end);
++
++#define dwarf_find_debug_frame UNW_OBJ(dwarf_find_debug_frame)
++
++int main(void)
++{
++	dwarf_find_debug_frame(0, NULL, 0, 0, NULL, 0, 0);
++	return 0;
++}
