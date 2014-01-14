Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaANQlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:41:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52874 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaANQlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:41:51 -0500
Date: Tue, 14 Jan 2014 08:41:06 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-gyivwbbu2j7c4j4pwpmttg2p@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add test for building detached source tarballs
Git-Commit-ID: 4887805384751717ef62a8f41439d1d3e4268b39
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:41:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4887805384751717ef62a8f41439d1d3e4268b39
Gitweb:     http://git.kernel.org/tip/4887805384751717ef62a8f41439d1d3e4268b39
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 10 Jan 2014 16:46:45 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:26 -0300

perf tools: Add test for building detached source tarballs

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

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index e341088..00544b8 100644
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
index 0000000..238aa39
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
