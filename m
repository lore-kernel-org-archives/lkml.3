Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab3JNUCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:02:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38419 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab3JNUCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 004/161] tools/perf/build: Split out feature check: 'libnuma'
Date: Mon, 14 Oct 2013 16:59:53 -0300
Message-Id: <1381780950-25642-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-vixsrpggxFjhz7kppqgrGr6s@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                      | 7 ++++---
 tools/perf/config/feature-checks/Makefile       | 7 ++++++-
 tools/perf/config/feature-checks/test-libnuma.c | 8 ++++++++
 3 files changed, 18 insertions(+), 4 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-libnuma.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index daefe2dfacad..f39fc224b52e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -101,7 +101,9 @@ $(info Testing features:)
 $(shell make -i -j -C config/feature-checks >/dev/null 2>&1)
 $(info done)
 
-FEATURE_TESTS = hello
+FEATURE_TESTS =				\
+	hello				\
+	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
 
@@ -434,8 +436,7 @@ ifndef NO_BACKTRACE
 endif
 
 ifndef NO_LIBNUMA
-  FLAGS_LIBNUMA = $(CFLAGS) $(LDFLAGS) -lnuma
-  ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
+  ifeq ($(feature-libnuma), 0)
     msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
     NO_LIBNUMA := 1
   else
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 4708ccadfc54..6a42ad24d64f 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -1,5 +1,7 @@
 
-FILES=test-hello
+FILES=					\
+	test-hello			\
+	test-libnuma
 
 CC := $(CC) -MD
 
@@ -12,6 +14,9 @@ BUILD = $(CC) -o $(OUTPUT)$@ $@.c
 test-hello:
 	$(BUILD)
 
+test-libnuma:
+	$(BUILD) -lnuma
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libnuma.c b/tools/perf/config/feature-checks/test-libnuma.c
new file mode 100644
index 000000000000..70510a923e5a
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libnuma.c
@@ -0,0 +1,8 @@
+#include <numa.h>
+#include <numaif.h>
+
+int main(void)
+{
+	numa_available();
+	return 0;
+}
-- 
1.8.1.4

