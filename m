Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3EaLzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:55:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3EaLzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:55:06 -0400
Date: Fri, 31 May 2013 04:54:31 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-095ae69b890c5b9cc87a3160b489a617554d9848@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, sam@ravnborg.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, bp@alien8.de,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, sam@ravnborg.org, bp@alien8.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1369398928-9809-2-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add automated make test suite
Git-Commit-ID: 095ae69b890c5b9cc87a3160b489a617554d9848
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  095ae69b890c5b9cc87a3160b489a617554d9848
Gitweb:     http://git.kernel.org/tip/095ae69b890c5b9cc87a3160b489a617554d9848
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 29 Mar 2013 16:11:02 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:05 +0300

perf tools: Add automated make test suite

Adding automated test for testing the build process.

To run it you need to be in perf directory or specify one with PERF
variable. It's also possible to specify optional Makefile to test via MK
variable.

Whole suite is executed twice, the second time with O=/tmp/xxx option
added.

To run the whole suite:
  $ make -f tests/make
  - make_pure: cd . && make -f Makefile
    test: test -x ./perf
  - make_clean_all: cd . && make -f Makefile clean all
    test: test -x ./perf
  - make_python_perf_so: cd . && make -f Makefile python/perf.so
    test: test -f ./python/perf.so
  - make_debug: cd . && make -f Makefile DEBUG=1
    test: test -x ./perf
  - make_no_libperl: cd . && make -f Makefile NO_LIBPERL=1
    test: test -x ./perf

You see command line for 'make_pure' test right away, and the output is
stored into 'make_pure' file.

To run simple test:
  $ make -f tests/make make_debug
  - make_debug: cd . && make -f Makefile DEBUG=1
    test: test -x ./perf

At this moment tests checks for successfull build and for existence of
several built files. Additional after-build checks could be added.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369398928-9809-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/make | 138 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
new file mode 100644
index 0000000..c441a28
--- /dev/null
+++ b/tools/perf/tests/make
@@ -0,0 +1,138 @@
+PERF := .
+MK   := Makefile
+
+# standard single make variable specified
+make_clean_all      := clean all
+make_python_perf_so := python/perf.so
+make_debug          := DEBUG=1
+make_no_libperl     := NO_LIBPERL=1
+make_no_libpython   := NO_LIBPYTHON=1
+make_no_scripts     := NO_LIBPYTHON=1 NO_LIBPERL=1
+make_no_newt        := NO_NEWT=1
+make_no_slang       := NO_SLANG=1
+make_no_gtk2        := NO_GTK2=1
+make_no_ui          := NO_NEWT=1 NO_SLANG=1 NO_GTK2=1
+make_no_demangle    := NO_DEMANGLE=1
+make_no_libelf      := NO_LIBELF=1
+make_no_libunwind   := NO_LIBUNWIND=1
+make_no_backtrace   := NO_BACKTRACE=1
+make_no_libnuma     := NO_LIBNUMA=1
+make_no_libaudit    := NO_LIBAUDIT=1
+make_no_libbionic   := NO_LIBBIONIC=1
+make_tags           := tags
+make_cscope         := cscope
+make_help           := help
+make_doc            := doc
+make_perf_o         := perf.o
+make_util_map_o     := util/map.o
+
+# all the NO_* variable combined
+make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
+make_minimal        += NO_DEMANGLE=1 NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1
+make_minimal        += NO_LIBNUMA=1 NO_LIBAUDIT=1 NO_LIBBIONIC=1
+
+# $(run) contains all available tests
+run := make_pure
+run += make_clean_all
+run += make_python_perf_so
+run += make_debug
+run += make_no_libperl
+run += make_no_libpython
+run += make_no_scripts
+run += make_no_newt
+run += make_no_slang
+run += make_no_gtk2
+run += make_no_ui
+run += make_no_demangle
+run += make_no_libelf
+run += make_no_libunwind
+run += make_no_backtrace
+run += make_no_libnuma
+run += make_no_libaudit
+run += make_no_libbionic
+run += make_tags
+run += make_cscope
+run += make_help
+run += make_doc
+run += make_perf_o
+run += make_util_map_o
+run += make_minimal
+
+# $(run_O) contains same portion of $(run) tests with '_O' attached
+# to distinguish O=... tests
+run_O := $(addsuffix _O,$(run))
+
+# disable some tests for O=...
+run_O := $(filter-out make_python_perf_so_O,$(run_O))
+
+# define test for each compile as 'test_NAME' variable
+# with the test itself as a value
+test_make_tags   = test -f tags
+test_make_cscope = test -f cscope.out
+
+test_make_tags_O   := $(test_make_tags)
+test_make_cscope_O := $(test_make_cscope)
+
+test_ok          := true
+test_make_help   := $(test_ok)
+test_make_doc    := $(test_ok)
+test_make_help_O := $(test_ok)
+test_make_doc_O  := $(test_ok)
+
+test_make_python_perf_so := test -f $(PERF)/python/perf.so
+
+test_make_perf_o     := test -f $(PERF)/perf.o
+test_make_util_map_o := test -f $(PERF)/util/map.o
+
+# Kbuild tests only
+#test_make_python_perf_so_O := test -f $$TMP/tools/perf/python/perf.so
+#test_make_perf_o_O         := test -f $$TMP/tools/perf/perf.o
+#test_make_util_map_o_O     := test -f $$TMP/tools/perf/util/map.o
+
+test_make_perf_o_O     := true
+test_make_util_map_o_O := true
+
+test_default = test -x $(PERF)/perf
+test = $(if $(test_$1),$(test_$1),$(test_default))
+
+test_default_O = test -x $$TMP/perf
+test_O = $(if $(test_$1),$(test_$1),$(test_default_O))
+
+all:
+
+ifdef DEBUG
+d := $(info run   $(run))
+d := $(info run_O $(run_O))
+endif
+
+MAKEFLAGS := --no-print-directory
+
+clean := @(cd $(PERF); make -s -f $(MK) clean >/dev/null)
+
+$(run):
+	$(call clean)
+	@cmd="cd $(PERF) && make -f $(MK) $($@)"; \
+	echo "- $@: $$cmd" && echo $$cmd > $@ && \
+	( eval $$cmd ) >> $@ 2>&1; \
+	echo "  test: $(call test,$@)"; \
+	$(call test,$@) && \
+	rm -f $@
+
+$(run_O):
+	$(call clean)
+	@TMP=$$(mktemp -d); \
+	cmd="cd $(PERF) && make -f $(MK) $($(patsubst %_O,%,$@)) O=$$TMP"; \
+	echo "- $@: $$cmd" && echo $$cmd > $@ && \
+	( eval $$cmd ) >> $@ 2>&1 && \
+	echo "  test: $(call test_O,$@)"; \
+	$(call test_O,$@) && \
+	rm -f $@ && \
+	rm -rf $$TMP
+
+all: $(run) $(run_O)
+	@echo OK
+
+out: $(run_O)
+	@echo OK
+
+.PHONY: all $(run) $(run_O) clean
