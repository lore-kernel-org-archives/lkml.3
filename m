Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab3JHKQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:16:34 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:61620 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab3JHKMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:44 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 44/52] tools/perf/build: Clean up various testcases
Date: Tue,  8 Oct 2013 12:11:14 +0200
Message-Id: <1381227082-22039-45-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 5b79468..5b33bcf 100644
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
index 5202f50..ab29f80 100644
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
index eebcfbc..397b464 100644
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
index 1ac6d8a..6bd80e5 100644
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
index 854a65d..f7e791e 100644
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
index d03339c..1886c78 100644
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
index 5622746..43b9369 100644
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
index 473f1de..8f64ed3 100644
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
1.8.3.1

