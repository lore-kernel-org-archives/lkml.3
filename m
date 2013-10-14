Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab3JNUnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:43:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38568 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257Ab3JNUCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 044/161] tools/perf/build: Clean up various testcases
Date: Mon, 14 Oct 2013 17:00:33 -0300
Message-Id: <1381780950-25642-45-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Prepare to include them into test-all.c directly, by making sure
that they build cleanly and without warnings.

Also make sure they make a certain amount of sense and don't crash
when executed.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-Mn9gsdutzopoowk3xurqpsxE@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/feature-checks/test-backtrace.c      |  8 ++++++--
 tools/perf/config/feature-checks/test-cplus-demangle.c |  9 +++++++--
 tools/perf/config/feature-checks/test-gtk2-infobar.c   |  3 ++-
 tools/perf/config/feature-checks/test-gtk2.c           |  2 +-
 tools/perf/config/feature-checks/test-libaudit.c       |  2 ++
 tools/perf/config/feature-checks/test-libbfd.c         | 11 ++++++++++-
 tools/perf/config/feature-checks/test-libunwind.c      |  9 ++++++++-
 tools/perf/config/feature-checks/test-on-exit.c        | 11 ++++++++++-
 8 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/tools/perf/config/feature-checks/test-backtrace.c b/tools/perf/config/feature-checks/test-backtrace.c
index 5b79468bea2a..5b33bcf12c27 100644
--- a/tools/perf/config/feature-checks/test-backtrace.c
+++ b/tools/perf/config/feature-checks/test-backtrace.c
@@ -3,8 +3,12 @@
 
 int main(void)
 {
-	backtrace(NULL, 0);
-	backtrace_symbols(NULL, 0);
+	void *backtrace_fns[10];
+	size_t entries;
+
+	entries = backtrace(backtrace_fns, 10);
+	backtrace_symbols_fd(backtrace_fns, entries, 1);
 
 	return 0;
 }
+
diff --git a/tools/perf/config/feature-checks/test-cplus-demangle.c b/tools/perf/config/feature-checks/test-cplus-demangle.c
index 5202f5038ad8..ab29f80570af 100644
--- a/tools/perf/config/feature-checks/test-cplus-demangle.c
+++ b/tools/perf/config/feature-checks/test-cplus-demangle.c
@@ -1,9 +1,14 @@
-
+extern int printf(const char *format, ...);
 extern char *cplus_demangle(const char *, int);
 
 int main(void)
 {
-	cplus_demangle(0, 0);
+	char symbol[4096] = "FieldName__9ClassNameFd";
+	char *tmp;
+
+	tmp = cplus_demangle(symbol, 0);
+
+	printf("demangled symbol: {%s}\n", tmp);
 
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-gtk2-infobar.c b/tools/perf/config/feature-checks/test-gtk2-infobar.c
index eebcfbc45120..397b4646d066 100644
--- a/tools/perf/config/feature-checks/test-gtk2-infobar.c
+++ b/tools/perf/config/feature-checks/test-gtk2-infobar.c
@@ -2,8 +2,9 @@
 #include <gtk/gtk.h>
 #pragma GCC diagnostic error "-Wstrict-prototypes"
 
-int main(void)
+int main(int argc, char *argv[])
 {
+	gtk_init(&argc, &argv);
 	gtk_info_bar_new();
 
 	return 0;
diff --git a/tools/perf/config/feature-checks/test-gtk2.c b/tools/perf/config/feature-checks/test-gtk2.c
index 1ac6d8a1fb14..6bd80e509439 100644
--- a/tools/perf/config/feature-checks/test-gtk2.c
+++ b/tools/perf/config/feature-checks/test-gtk2.c
@@ -4,7 +4,7 @@
 
 int main(int argc, char *argv[])
 {
-        gtk_init(&argc, &argv);
+	gtk_init(&argc, &argv);
 
         return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-libaudit.c b/tools/perf/config/feature-checks/test-libaudit.c
index 854a65d3cc78..f7e791efa6d1 100644
--- a/tools/perf/config/feature-checks/test-libaudit.c
+++ b/tools/perf/config/feature-checks/test-libaudit.c
@@ -1,5 +1,7 @@
 #include <libaudit.h>
 
+extern int printf(const char *format, ...);
+
 int main(void)
 {
 	printf("error message: %s\n", audit_errno_to_name(0));
diff --git a/tools/perf/config/feature-checks/test-libbfd.c b/tools/perf/config/feature-checks/test-libbfd.c
index d03339c995d7..1886c78c30e7 100644
--- a/tools/perf/config/feature-checks/test-libbfd.c
+++ b/tools/perf/config/feature-checks/test-libbfd.c
@@ -1,7 +1,16 @@
 #include <bfd.h>
 
+extern int printf(const char *format, ...);
+
 int main(void)
 {
-	bfd_demangle(0, 0, 0);
+	char symbol[4096] = "FieldName__9ClassNameFd";
+	char *tmp;
+
+	tmp = bfd_demangle(0, symbol, 0);
+
+	printf("demangled symbol: {%s}\n", tmp);
+
 	return 0;
 }
+
diff --git a/tools/perf/config/feature-checks/test-libunwind.c b/tools/perf/config/feature-checks/test-libunwind.c
index 562274695c76..43b9369bcab7 100644
--- a/tools/perf/config/feature-checks/test-libunwind.c
+++ b/tools/perf/config/feature-checks/test-libunwind.c
@@ -10,11 +10,18 @@ extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
 
 #define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
 
+static unw_accessors_t accessors;
+
 int main(void)
 {
 	unw_addr_space_t addr_space;
-	addr_space = unw_create_addr_space(NULL, 0);
+
+	addr_space = unw_create_addr_space(&accessors, 0);
+	if (addr_space)
+		return 0;
+
 	unw_init_remote(NULL, addr_space, NULL);
 	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
+
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-on-exit.c b/tools/perf/config/feature-checks/test-on-exit.c
index 473f1dea5316..8f64ed3a58d9 100644
--- a/tools/perf/config/feature-checks/test-on-exit.c
+++ b/tools/perf/config/feature-checks/test-on-exit.c
@@ -1,6 +1,15 @@
 #include <stdio.h>
 
+static void exit_fn(int status, void *__data)
+{
+	printf("exit status: %d, data: %d\n", status, *(int *)__data);
+}
+
+static int data = 123;
+
 int main(void)
 {
-	return on_exit(NULL, NULL);
+	on_exit(exit_fn, &data);
+
+	return 321;
 }
-- 
1.8.1.4

