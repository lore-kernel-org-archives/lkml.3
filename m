Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab3DATTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:19:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759302Ab3DATTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:19:33 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/27] perf tools: Add automated make test suite
Date: Mon,  1 Apr 2013 21:18:24 +0200
Message-Id: <1364843930-17974-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automatd test for testing the build process.
To run it you needto be in perf directory or specify
one with PERF variable. It's also possible to specify
optional Makefile to test via MK variable.

Whole suite is executed twice, the second time with
O=/tmp/xxx option added.

To run the whole suite:
  $ make -f tests/make
  MAKE_PURE: cd . && make -f Makefile
  TEST: test -x ./perf
  MAKE_DEBUG: cd . && make -f Makefile DEBUG=1
  TEST: test -x ./perf
  ...

You see command line for 'MAKE_PURE' test right away,
and the output is stored into MAKE_PURE file.

To run simple test:
  $ make -f tests/make MAKE_DEBUG
  MAKE_DEBUG: cd . && make -f Makefile DEBUG=1
  TEST: test -x ./perf

At this moment tests checks for succesfull build
and for existence of several built files. Additional
after-build checks could be added.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/tests/make | 122 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)
 create mode 100644 tools/perf/tests/make

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
new file mode 100644
index 0000000..0cc64ea
--- /dev/null
+++ b/tools/perf/tests/make
@@ -0,0 +1,122 @@
+ifndef PERF
+PERF := .
+endif
+
+ifndef MK
+MK := Makefile
+endif
+
+MAKE_DEBUG          := DEBUG=1
+MAKE_NO_LIBPERL     := NO_LIBPERL=1
+MAKE_NO_LIBPYTHON   := NO_LIBPYTHON=1
+MAKE_NO_SCRIPTS     := NO_LIBPYTHON=1 NO_LIBPERL=1
+MAKE_NO_NEWT        := NO_NEWT=1
+MAKE_NO_SLANG       := NO_SLANG=1
+MAKE_NO_GTK2        := NO_GTK2=1
+MAKE_NO_UI          := NO_NEWT=1 NO_SLANG=1 NO_GTK2=1
+MAKE_NO_DEMANGLE    := NO_DEMANGLE=1
+MAKE_NO_LIBELF      := NO_LIBELF=1
+MAKE_NO_LIBUNWIND   := NO_LIBUNWIND=1
+MAKE_NO_BACKTRACE   := NO_BACKTRACE=1
+MAKE_NO_LIBNUMA     := NO_LIBNUMA=1
+MAKE_NO_LIBAUDIT    := NO_LIBAUDIT=1
+MAKE_NO_LIBBIONIC   := NO_LIBBIONIC=1
+MAKE_MINIMAL        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1 NO_DEMANGLE=1 NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1 NO_LIBNUMA=1 NO_LIBAUDIT=1 NO_LIBBIONIC=1
+MAKE_TAGS           := tags
+MAKE_CSCOPE         := cscope
+MAKE_HELP           := help
+MAKE_DOC            := doc
+MAKE_PERF_O         := perf.o
+MAKE_UTIL_MAP_O     := util/map.o
+
+RUN := \
+	MAKE_PURE \
+	MAKE_DEBUG \
+	MAKE_NO_LIBPERL \
+	MAKE_NO_LIBPYTHON \
+	MAKE_NO_SCRIPTS \
+	MAKE_NO_NEWT \
+	MAKE_NO_SLANG \
+	MAKE_NO_GTK2 \
+	MAKE_NO_UI \
+	MAKE_NO_DEMANGLE \
+	MAKE_NO_LIBELF \
+	MAKE_NO_LIBUNWIND \
+	MAKE_NO_BACKTRACE \
+	MAKE_NO_LIBNUMA \
+	MAKE_NO_LIBAUDIT \
+	MAKE_NO_LIBBIONIC \
+	MAKE_MINIMAL \
+	MAKE_TAGS \
+	MAKE_CSCOPE \
+	MAKE_HELP \
+	MAKE_DOC \
+	MAKE_PERF_O \
+	MAKE_UTIL_MAP_O
+
+RUN_O := $(addsuffix _O,$(RUN))
+
+TEST_MAKE_TAGS   = test -f tags
+TEST_MAKE_CSCOPE = test -f cscope.out
+
+TEST_MAKE_TAGS_O   := $(TEST_MAKE_TAGS)
+TEST_MAKE_CSCOPE_O := $(TEST_MAKE_CSCOPE)
+
+TEST_OK := true
+TEST_MAKE_HELP   := $(TEST_OK)
+TEST_MAKE_DOC    := $(TEST_OK)
+TEST_MAKE_HELP_O := $(TEST_OK)
+TEST_MAKE_DOC_O  := $(TEST_OK)
+
+TEST_MAKE_PERF_O     := test -f $(PERF)/perf.o
+TEST_MAKE_UTIL_MAP_O := test -f $(PERF)/util/map.o
+
+# Kbuild tests only
+#TEST_MAKE_PERF_O_O     := test -f $$TMP/tools/perf/perf.o
+#TEST_MAKE_UTIL_MAP_O_O := test -f $$TMP/tools/perf/util/map.o
+
+TEST_MAKE_PERF_O_O     := true
+TEST_MAKE_UTIL_MAP_O_O := true
+
+TEST_DEFAULT = test -x $(PERF)/perf
+test = $(if $(TEST_$1),$(TEST_$1),$(TEST_DEFAULT))
+
+TEST_DEFAULT_O = test -x $$TMP/perf
+test_o = $(if $(TEST_$1),$(TEST_$1),$(TEST_DEFAULT_O))
+
+all:
+
+ifdef DEBUG
+d := $(info RUN   $(RUN))
+d := $(info RUN_O $(RUN_O))
+endif
+
+MAKEFLAGS := --no-print-directory
+
+clean := @cd $(PERF); make -s -f $(MK) clean >/dev/null
+
+$(RUN):
+	$(call clean) && \
+	cmd="cd $(PERF) && make -f $(MK) $($@)"; \
+	echo "$@: $$cmd" && echo $$cmd > $@ && \
+	( eval $$cmd ) >> $@ 2>&1; \
+	echo "TEST: $(call test,$@)"; \
+	$(call test,$@)
+
+$(RUN_O):
+	$(call clean) && \
+	TMP=$$(mktemp -d); \
+	cmd="cd $(PERF) && make -f $(MK) $($(patsubst %_O,%,$@)) O=$$TMP"; \
+	echo "$@: $$cmd" && echo $$cmd > $@ && \
+	( eval $$cmd ) >> $@ 2>&1 && \
+	echo "TEST: $(call test_o,$@)"; \
+	$(call test_o,$@) && \
+	rm -rf $$TMP
+
+all: $(RUN) $(RUN_O)
+	@echo OK
+
+out: $(RUN_O)
+	@echo OK
+
+.PHONY: all $(RUN) $(RUN_O) clean
-- 
1.7.11.7

