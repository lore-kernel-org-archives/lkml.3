Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab3JNUmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:42:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38582 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab3JNUCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 042/161] tools/perf/build: Split out feature checks: 'liberty', 'liberty-z', 'cplus-demangle'
Date: Mon, 14 Oct 2013 17:00:31 -0300
Message-Id: <1381780950-25642-43-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Note that these are rarely executed tests, so we call feature_check() explicitly
and don't have them in CORE_FEATURE_CHECKS.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-pvumlx6mbtfxffgrlwO2mRcx@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                             | 16 ++++++----------
 tools/perf/config/feature-checks/Makefile              | 12 ++++++++++++
 tools/perf/config/feature-checks/test-cplus-demangle.c | 10 ++++++++++
 3 files changed, 28 insertions(+), 10 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-cplus-demangle.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 62d02cd03f29..89b2d47d2e4b 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -472,23 +472,19 @@ else
     EXTLIBS += -liberty
     CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
   else
-    FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
     ifeq ($(feature-libbfd), 1)
       EXTLIBS += -lbfd
     else
-      FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
-      has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
-      ifeq ($(has_bfd_iberty),y)
+      $(feature_check,liberty)
+      ifeq ($(feature-liberty), 1)
         EXTLIBS += -lbfd -liberty
       else
-        FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
-        has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z),libz)
-        ifeq ($(has_bfd_iberty_z),y)
+        $(feature_check,liberty-z)
+        ifeq ($(feature-liberty-z), 1)
           EXTLIBS += -lbfd -liberty -lz
         else
-          FLAGS_CPLUS_DEMANGLE=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -liberty
-          has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
-          ifeq ($(has_cplus_demangle),y)
+          $(feature_check,cplus-demangle)
+          ifeq ($(feature-cplus-demangle), 1)
             EXTLIBS += -liberty
             CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
           else
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index d4c55acc82bb..e21bceb80bf2 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -11,6 +11,9 @@ FILES=					\
 	test-hello			\
 	test-libaudit			\
 	test-libbfd			\
+	test-liberty			\
+	test-liberty-z			\
+	test-cplus-demangle		\
 	test-libelf			\
 	test-libelf-getphdrnum		\
 	test-libelf-mmap		\
@@ -122,6 +125,15 @@ test-libpython-version:
 test-libbfd:
 	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
 
+test-liberty:
+	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl -liberty
+
+test-liberty-z:
+	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl -liberty -lz
+
+test-cplus-demangle:
+	$(BUILD) -liberty
+
 test-on-exit:
 	$(BUILD)
 
diff --git a/tools/perf/config/feature-checks/test-cplus-demangle.c b/tools/perf/config/feature-checks/test-cplus-demangle.c
new file mode 100644
index 000000000000..5202f5038ad8
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-cplus-demangle.c
@@ -0,0 +1,10 @@
+
+extern char *cplus_demangle(const char *, int);
+
+int main(void)
+{
+	cplus_demangle(0, 0);
+
+	return 0;
+}
+
-- 
1.8.1.4

