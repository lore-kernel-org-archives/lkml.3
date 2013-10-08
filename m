Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab3JHK0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:26:37 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36682 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3JHKMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:08 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 04/52] tools/perf/build: Split out feature check: 'libnuma'
Date: Tue,  8 Oct 2013 12:10:34 +0200
Message-Id: <1381227082-22039-5-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index daefe2d..f39fc22 100644
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
index 4708cca..6a42ad2 100644
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
index 0000000..70510a9
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
1.8.3.1

