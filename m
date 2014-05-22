Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaEVPbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:31:31 -0400
Received: from smtp1.digia.com ([82.118.214.156]:35213 "EHLO smtp1.digia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbaEVPba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:31:30 -0400
X-Greylist: delayed 1251 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 May 2014 11:31:29 EDT
Message-ID: <537E1380.7040604@digia.com>
Date: Thu, 22 May 2014 17:10:56 +0200
From: Ulf Hermann <ulf.hermann@digia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf tool: Allow mixed static/dynamic linking
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.78.82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Listen to a STATIC_LDFLAGS environment variable which will be
appended to a -Wl,-Bstatic in each link step. Remove its contents
from the regular link flags to avoid linking conflicts. Like that
some of the libraries can be statically linked while others are
linked dynamically.

Signed-off-by: Ulf Hermann <ulf.hermann@digia.com>

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 895edd3..b1c1ff4 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -29,7 +29,10 @@ include config/utilities.mak
  #
  # Define DOCBOOK_XSL_172 if you want to format man pages with DocBook XSL v1.72.
  #
-# Define LDFLAGS=-static to build a static binary.
+# Define LDFLAGS=-static to build a completely static binary.
+#
+# Define STATIC_LDFLAGS to specify link flags that should follow a -Wl,-Bstatic.
+# Those flags will be removed from the automatically determined, dynamic flags.
  #
  # Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
  #
@@ -558,7 +561,9 @@ ifdef ASCIIDOC8
    export ASCIIDOC8
  endif
  
-LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
+LDFLAGS := $(filter-out $(STATIC_LDFLAGS), $(LDFLAGS))
+LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive\
+	-Wl,--start-group $(filter-out $(STATIC_LDFLAGS) $(LDFLAGS), $(EXTLIBS)) -Wl,--end-group
  
  export INSTALL SHELL_PATH
  
@@ -582,8 +587,8 @@ $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
  		$(CFLAGS) -c $(filter %.c,$^) -o $@
  
  $(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
-	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
-               $(BUILTIN_OBJS) $(LIBS) -o $@
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(OUTPUT)perf.o $(BUILTIN_OBJS) \
+		$(LIBS) -Wl,-Bstatic $(STATIC_LDFLAGS) -Wl,-Bdynamic $(LDFLAGS) -o $@
  
  $(GTK_OBJS): $(OUTPUT)%.o: %.c $(LIB_H)
  	$(QUIET_CC)$(CC) -o $@ -c -fPIC $(CFLAGS) $(GTK_CFLAGS) $<
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 2da103c..62f6060 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -34,60 +34,72 @@ PKG_CONFIG := $(CROSS_COMPILE)pkg-config
  
  all: $(FILES)
  
-BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $(patsubst %.bin,%.c,$@) $(LDFLAGS)
+define build
+	$(CC) $(CFLAGS) -o $(OUTPUT)$@ $(patsubst %.bin,%.c,$@) -Wl,-Bstatic $(STATIC_LDFLAGS)\
+		-Wl,-Bdynamic $(filter-out $(STATIC_LDFLAGS), $(LDFLAGS) $(1))
+endef
+
+define build-spefic-source
+	$(CC) $(CFLAGS) -o $(OUTPUT)$@ $(1) -Wl,-Bstatic $(STATIC_LDFLAGS)\
+		-Wl,-Bdynamic $(filter-out $(STATIC_LDFLAGS), $(LDFLAGS) $(2))
+endef
+
  
  ###############################
  
  test-all.bin:
-	$(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
+	$(call build, -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -I/usr/include/slang\
+		-ldw -lelf -lnuma -laudit -lslang -lbfd -ldl\
+		$(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null)\
+		$(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"')
  
  test-hello.bin:
-	$(BUILD)
+	$(call build)
  
  test-stackprotector-all.bin:
-	$(BUILD) -Werror -fstack-protector-all
+	$(call build, -Werror -fstack-protector-all)
  
  test-fortify-source.bin:
-	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
+	$(call build, -O2 -Werror -D_FORTIFY_SOURCE=2)
  
  test-bionic.bin:
-	$(BUILD)
+	$(call build)
  
  test-libelf.bin:
-	$(BUILD) -lelf
+	$(call build, -lelf)
  
  test-glibc.bin:
-	$(BUILD)
+	$(call build)
  
  test-dwarf.bin:
-	$(BUILD) -ldw
+	$(call build, -ldw)
  
  test-libelf-mmap.bin:
-	$(BUILD) -lelf
+	$(call build, -lelf)
  
  test-libelf-getphdrnum.bin:
-	$(BUILD) -lelf
+	$(call build, -lelf)
  
  test-libnuma.bin:
-	$(BUILD) -lnuma
+	$(call build, -lnuma)
  
  test-libunwind.bin:
-	$(BUILD) -lelf
+	$(call build, -lelf)
  
  test-libunwind-debug-frame.bin:
-	$(BUILD) -lelf
+	$(call build, -lelf)
  
  test-libaudit.bin:
-	$(BUILD) -laudit
+	$(call build, -laudit)
  
  test-libslang.bin:
-	$(BUILD) -I/usr/include/slang -lslang
+	$(call build, -I/usr/include/slang -lslang)
  
  test-gtk2.bin:
-	$(BUILD) $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null)
+	$(call build, $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null))
  
  test-gtk2-infobar.bin:
-	$(BUILD) $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null)
+	$(call build, $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null))
  
  grep-libs  = $(filter -l%,$(1))
  strip-libs = $(filter-out -l%,$(1))
@@ -99,7 +111,7 @@ PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
  FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
  
  test-libperl.bin:
-	$(BUILD) $(FLAGS_PERL_EMBED)
+	$(call build, $(FLAGS_PERL_EMBED))
  
  override PYTHON := python
  override PYTHON_CONFIG := python-config
@@ -116,34 +128,34 @@ PYTHON_EMBED_CCOPTS = $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
  FLAGS_PYTHON_EMBED = $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
  
  test-libpython.bin:
-	$(BUILD) $(FLAGS_PYTHON_EMBED)
+	$(call build, $(FLAGS_PYTHON_EMBED))
  
  test-libpython-version.bin:
-	$(BUILD) $(FLAGS_PYTHON_EMBED)
+	$(call build, $(FLAGS_PYTHON_EMBED))
  
  test-libbfd.bin:
-	$(BUILD) -DPACKAGE='"perf"' -lbfd -lz -liberty -ldl
+	$(call build, -DPACKAGE='"perf"' -lbfd -lz -liberty -ldl)
  
  test-liberty.bin:
-	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='"perf"' -lbfd -ldl -liberty
+	$(call build-specific-source, test-libbfd.c, -DPACKAGE='"perf"' -lbfd -ldl -liberty)
  
  test-liberty-z.bin:
-	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='"perf"' -lbfd -ldl -liberty -lz
+	$(call build-specific-source, test-libbfd.c, -DPACKAGE='"perf"' -lbfd -ldl -liberty -lz)
  
  test-cplus-demangle.bin:
-	$(BUILD) -liberty
+	$(call build, -liberty)
  
  test-on-exit.bin:
-	$(BUILD)
+	$(call build)
  
  test-backtrace.bin:
-	$(BUILD)
+	$(call build)
  
  test-timerfd.bin:
-	$(BUILD)
+	$(call build)
  
  test-libdw-dwarf-unwind.bin:
-	$(BUILD)
+	$(call build)
  
  -include *.d
  
