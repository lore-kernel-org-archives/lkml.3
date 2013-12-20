Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3LTEQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:16:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54682 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3LTEQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 23:16:44 -0500
Message-ID: <52B3C4A8.3070809@gmail.com>
Date: Fri, 20 Dec 2013 12:16:40 +0800
From: Chunwei Chen <tuxoko@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf config: ignore generated files in feature-checks
References: <1387441761-2153-1-git-send-email-tuxoko@gmail.com> <20131219115833.GA11279@gmail.com> <CAK1sfuYn1iLUHWwUTdm755D0YpuAcROsj5rp=4-Vg5qc57bFfw@mail.gmail.com> <20131219154642.GA24658@gmail.com> <CAK1sfubfVtqfoKMpeB1h+ooq0+ogJvM0FFDu1Wyc9i16CqGfaw@mail.gmail.com> <20131219171027.GD30382@gmail.com>
In-Reply-To: <20131219171027.GD30382@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 362201bf3259cc01c99531766395fdba0c0f3789 Mon Sep 17 00:00:00 2001
From: Chunwei Chen <tuxoko@gmail.com>
Date: Thu, 19 Dec 2013 15:41:22 +0800
Subject: [PATCH] perf config: ignore generated files in feature-checks

1. Rename the test-* binary files to test-*.bin for easier pattern matching as
   suggested by Ingo.
2. Ignore *.bin and *.d files.

Signed-off-by: Chunwei Chen <tuxoko@gmail.com>
---
 tools/perf/config/Makefile                  |   6 +-
 tools/perf/config/feature-checks/.gitignore |   2 +
 tools/perf/config/feature-checks/Makefile   | 114 ++++++++++++++--------------
 3 files changed, 62 insertions(+), 60 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/.gitignore

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f7d11a8..40e08d1 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -102,7 +102,7 @@ endif
 
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS="$(LDFLAGS)" LIBUNWIND_LIBS="$(LIBUNWIND_LIBS)" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS="$(LDFLAGS)" LIBUNWIND_LIBS="$(LIBUNWIND_LIBS)" -C config/feature-checks test-$1.bin >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))
@@ -150,7 +150,7 @@ CORE_FEATURE_TESTS =			\
 # to skip the print-out of the long features list if the file
 # existed before and after it was built:
 #
-ifeq ($(wildcard $(OUTPUT)config/feature-checks/test-all),)
+ifeq ($(wildcard $(OUTPUT)config/feature-checks/test-all.bin),)
   test-all-failed := 1
 else
   test-all-failed := 0
@@ -180,7 +180,7 @@ ifeq ($(feature-all), 1)
   #
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
 else
-  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
+  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(addsuffix .bin,$(CORE_FEATURE_TESTS)) >/dev/null 2>&1)
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
 endif
 
diff --git a/tools/perf/config/feature-checks/.gitignore b/tools/perf/config/feature-checks/.gitignore
new file mode 100644
index 0000000..80f3da0
--- /dev/null
+++ b/tools/perf/config/feature-checks/.gitignore
@@ -0,0 +1,2 @@
+*.d
+*.bin
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 87e7900..e2bc0ed 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -1,94 +1,94 @@
 
 FILES=					\
-	test-all			\
-	test-backtrace			\
-	test-bionic			\
-	test-dwarf			\
-	test-fortify-source		\
-	test-glibc			\
-	test-gtk2			\
-	test-gtk2-infobar		\
-	test-hello			\
-	test-libaudit			\
-	test-libbfd			\
-	test-liberty			\
-	test-liberty-z			\
-	test-cplus-demangle		\
-	test-libelf			\
-	test-libelf-getphdrnum		\
-	test-libelf-mmap		\
-	test-libnuma			\
-	test-libperl			\
-	test-libpython			\
-	test-libpython-version		\
-	test-libslang			\
-	test-libunwind			\
-	test-libunwind-debug-frame	\
-	test-on-exit			\
-	test-stackprotector-all		\
-	test-stackprotector		\
-	test-timerfd
+	test-all.bin			\
+	test-backtrace.bin		\
+	test-bionic.bin			\
+	test-dwarf.bin			\
+	test-fortify-source.bin		\
+	test-glibc.bin			\
+	test-gtk2.bin			\
+	test-gtk2-infobar.bin		\
+	test-hello.bin			\
+	test-libaudit.bin		\
+	test-libbfd.bin			\
+	test-liberty.bin		\
+	test-liberty-z.bin		\
+	test-cplus-demangle.bin		\
+	test-libelf.bin			\
+	test-libelf-getphdrnum.bin	\
+	test-libelf-mmap.bin		\
+	test-libnuma.bin		\
+	test-libperl.bin		\
+	test-libpython.bin		\
+	test-libpython-version.bin	\
+	test-libslang.bin		\
+	test-libunwind.bin		\
+	test-libunwind-debug-frame.bin	\
+	test-on-exit.bin		\
+	test-stackprotector-all.bin	\
+	test-stackprotector.bin		\
+	test-timerfd.bin
 
 CC := $(CC) -MD
 
 all: $(FILES)
 
-BUILD = $(CC) $(CFLAGS) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
+BUILD = $(CC) $(CFLAGS) $(LDFLAGS) -o $(OUTPUT)$@ $(patsubst %.bin,%.c,$@)
 
 ###############################
 
-test-all:
+test-all.bin:
 	$(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma $(LIBUNWIND_LIBS) -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
 
-test-hello:
+test-hello.bin:
 	$(BUILD)
 
-test-stackprotector-all:
+test-stackprotector-all.bin:
 	$(BUILD) -Werror -fstack-protector-all
 
-test-stackprotector:
+test-stackprotector.bin:
 	$(BUILD) -Werror -fstack-protector -Wstack-protector
 
-test-fortify-source:
+test-fortify-source.bin:
 	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
 
-test-bionic:
+test-bionic.bin:
 	$(BUILD)
 
-test-libelf:
+test-libelf.bin:
 	$(BUILD) -lelf
 
-test-glibc:
+test-glibc.bin:
 	$(BUILD)
 
-test-dwarf:
+test-dwarf.bin:
 	$(BUILD) -ldw
 
-test-libelf-mmap:
+test-libelf-mmap.bin:
 	$(BUILD) -lelf
 
-test-libelf-getphdrnum:
+test-libelf-getphdrnum.bin:
 	$(BUILD) -lelf
 
-test-libnuma:
+test-libnuma.bin:
 	$(BUILD) -lnuma
 
-test-libunwind:
+test-libunwind.bin:
 	$(BUILD) $(LIBUNWIND_LIBS) -lelf
 
-test-libunwind-debug-frame:
+test-libunwind-debug-frame.bin:
 	$(BUILD) $(LIBUNWIND_LIBS) -lelf
 
-test-libaudit:
+test-libaudit.bin:
 	$(BUILD) -laudit
 
-test-libslang:
+test-libslang.bin:
 	$(BUILD) -I/usr/include/slang -lslang
 
-test-gtk2:
+test-gtk2.bin:
 	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
 
-test-gtk2-infobar:
+test-gtk2-infobar.bin:
 	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
 
 grep-libs  = $(filter -l%,$(1))
@@ -100,7 +100,7 @@ PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
 PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
 FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
-test-libperl:
+test-libperl.bin:
 	$(BUILD) $(FLAGS_PERL_EMBED)
 
 override PYTHON := python
@@ -117,31 +117,31 @@ PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
 PYTHON_EMBED_CCOPTS = $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
 FLAGS_PYTHON_EMBED = $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
 
-test-libpython:
+test-libpython.bin:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
-test-libpython-version:
+test-libpython-version.bin:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
-test-libbfd:
+test-libbfd.bin:
 	$(BUILD) -DPACKAGE='"perf"' -lbfd -ldl
 
-test-liberty:
+test-liberty.bin:
 	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='"perf"' -lbfd -ldl -liberty
 
-test-liberty-z:
+test-liberty-z.bin:
 	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='"perf"' -lbfd -ldl -liberty -lz
 
-test-cplus-demangle:
+test-cplus-demangle.bin:
 	$(BUILD) -liberty
 
-test-on-exit:
+test-on-exit.bin:
 	$(BUILD)
 
-test-backtrace:
+test-backtrace.bin:
 	$(BUILD)
 
-test-timerfd:
+test-timerfd.bin:
 	$(BUILD)
 
 -include *.d
-- 
1.8.5.2
