Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaAMUvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:51:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40461 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaAMUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:11 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 29/38] perf tools: Add test for building detached source tarballs
Date: Mon, 13 Jan 2014 17:47:30 -0300
Message-Id: <1389646059-24881-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Test one of the main kernel Makefile targets to generate a perf sources
tarball suitable for build outside the full kernel sources.

This is to test that the tools/perf/MANIFEST file lists all the files
needed to be in such tarball, which sometimes gets broken when we move
files around, like when we made some files that were in tools/perf/
available to other tools/ codebases by moving it to tools/include/, etc.

Now everytime we use 'make -C tools/perf -f tests/make' this test will
be performed, helping detect such problems earlier in the devel cycle.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-gyivwbbu2j7c4j4pwpmttg2p@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/make               | 10 ++++++++--
 tools/perf/tests/perf-targz-src-pkg | 21 +++++++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)
 create mode 100755 tools/perf/tests/perf-targz-src-pkg

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index e341088de8f3..00544b8b644b 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -216,10 +216,16 @@ $(run_O):
 	rm -rf $$TMP_O \
 	rm -rf $$TMP_DEST
 
-all: $(run) $(run_O)
+tarpkg:
+	@cmd="$(PERF)/tests/perf-targz-src-pkg $(PERF)"; \
+	echo "- $@: $$cmd" && echo $$cmd > $@ && \
+	( eval $$cmd ) >> $@ 2>&1
+	
+
+all: $(run) $(run_O) tarpkg
 	@echo OK
 
 out: $(run_O)
 	@echo OK
 
-.PHONY: all $(run) $(run_O) clean
+.PHONY: all $(run) $(run_O) tarpkg clean
diff --git a/tools/perf/tests/perf-targz-src-pkg b/tools/perf/tests/perf-targz-src-pkg
new file mode 100755
index 000000000000..238aa3927c71
--- /dev/null
+++ b/tools/perf/tests/perf-targz-src-pkg
@@ -0,0 +1,21 @@
+#!/bin/sh
+# Test one of the main kernel Makefile targets to generate a perf sources tarball
+# suitable for build outside the full kernel sources.
+#
+# This is to test that the tools/perf/MANIFEST file lists all the files needed to
+# be in such tarball, which sometimes gets broken when we move files around,
+# like when we made some files that were in tools/perf/ available to other tools/
+# codebases by moving it to tools/include/, etc.
+
+PERF=$1
+cd ${PERF}/../..
+make perf-targz-src-pkg > /dev/null
+TARBALL=$(ls -rt perf-*.tar.gz)
+TMP_DEST=$(mktemp -d)
+tar xf ${TARBALL} -C $TMP_DEST
+rm -f ${TARBALL}
+cd - > /dev/null
+make -C $TMP_DEST/perf*/tools/perf > /dev/null 2>&1
+RC=$?
+rm -rf ${TMP_DEST}
+exit $RC
-- 
1.8.1.4

