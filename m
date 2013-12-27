Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3L0UrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:47:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35657 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab3L0UrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:47:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Chunwei Chen <tuxoko@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 41/49] perf config: Ignore generated files in feature-checks
Date: Fri, 27 Dec 2013 17:46:57 -0300
Message-Id: <1388177225-17349-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1388177225-17349-1-git-send-email-acme@infradead.org>
References: <1388177225-17349-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chunwei Chen <tuxoko@gmail.com>

1. Rename the test-* binary files to test-*.bin for easier pattern matching as
   suggested by Ingo.
2. Ignore *.bin and *.d files.

Signed-off-by: Chunwei Chen <tuxoko@gmail.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/52B52B9B.50708@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile                  |   6 +-
 tools/perf/config/feature-checks/.gitignore |   2 +
 tools/perf/config/feature-checks/Makefile   | 110 ++++++++++++++--------------
 3 files changed, 60 insertions(+), 58 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/.gitignore

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5a1f4df3c3a8..14faeeb0d752 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -126,7 +126,7 @@ endif
 
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C config/feature-checks test-$1.bin >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))
@@ -173,7 +173,7 @@ CORE_FEATURE_TESTS =			\
 # to skip the print-out of the long features list if the file
 # existed before and after it was built:
 #
-ifeq ($(wildcard $(OUTPUT)config/feature-checks/test-all),)
+ifeq ($(wildcard $(OUTPUT)config/feature-checks/test-all.bin),)
   test-all-failed := 1
 else
   test-all-failed := 0
@@ -203,7 +203,7 @@ ifeq ($(feature-all), 1)
   #
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
 else
-  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
+  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(EXTRA_CFLAGS)" LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(addsuffix .bin,$(CORE_FEATURE_TESTS)) >/dev/null 2>&1)
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
 endif
 
diff --git a/tools/perf/config/feature-checks/.gitignore b/tools/perf/config/feature-checks/.gitignore
new file mode 100644
index 000000000000..80f3da0c3515
--- /dev/null
+++ b/tools/perf/config/feature-checks/.gitignore
@@ -0,0 +1,2 @@
+*.d
+*.bin
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index bc86462e80a2..7cf6fcdacebe 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -1,90 +1,90 @@
 
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
+	test-timerfd.bin
 
 CC := $(CC) -MD
 
 all: $(FILES)
 
-BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $@.c $(LDFLAGS)
+BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $(patsubst %.bin,%.c,$@) $(LDFLAGS)
 
 ###############################
 
-test-all:
+test-all.bin:
 	$(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
 
-test-hello:
+test-hello.bin:
 	$(BUILD)
 
-test-stackprotector-all:
+test-stackprotector-all.bin:
 	$(BUILD) -Werror -fstack-protector-all
 
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
 	$(BUILD) -lelf
 
-test-libunwind-debug-frame:
+test-libunwind-debug-frame.bin:
 	$(BUILD) -lelf
 
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
@@ -96,7 +96,7 @@ PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
 PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
 FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
-test-libperl:
+test-libperl.bin:
 	$(BUILD) $(FLAGS_PERL_EMBED)
 
 override PYTHON := python
@@ -113,31 +113,31 @@ PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
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
1.8.1.4

