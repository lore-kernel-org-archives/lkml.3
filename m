Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab3JOFTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:19:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60758 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3JOFSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:18:54 -0400
Date: Mon, 14 Oct 2013 22:18:39 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-1c47661a93fe6f729c80ed18a1f9ab1c7fb0cac2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature checks: '
 liberty', 'liberty-z', 'cplus-demangle'
Git-Commit-ID: 1c47661a93fe6f729c80ed18a1f9ab1c7fb0cac2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:18:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c47661a93fe6f729c80ed18a1f9ab1c7fb0cac2
Gitweb:     http://git.kernel.org/tip/1c47661a93fe6f729c80ed18a1f9ab1c7fb0cac2
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 2 Oct 2013 15:15:09 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:56 +0200

tools/perf/build: Split out feature checks: 'liberty', 'liberty-z', 'cplus-demangle'

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

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 62d02cd..89b2d47 100644
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
index d4c55ac..e21bceb 100644
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
index 0000000..5202f50
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
