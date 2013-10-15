Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab3JOFTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:19:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab3JOFTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:19:12 -0400
Date: Mon, 14 Oct 2013 22:18:57 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-1e3f30fae797660a014ac159d93fff9952ec1bf0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Clean up various testcases
Git-Commit-ID: 1e3f30fae797660a014ac159d93fff9952ec1bf0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:19:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e3f30fae797660a014ac159d93fff9952ec1bf0
Gitweb:     http://git.kernel.org/tip/1e3f30fae797660a014ac159d93fff9952ec1bf0
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 2 Oct 2013 15:48:49 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:58 +0200

tools/perf/build: Clean up various testcases

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
