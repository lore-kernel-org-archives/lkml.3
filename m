Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab3JNUxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:53:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38418 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab3JNUCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 009/161] tools/perf/build: Split out feature check: 'bionic'
Date: Mon, 14 Oct 2013 16:59:58 -0300
Message-Id: <1381780950-25642-10-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/n/tip-xjfVewprrfhlo2wuzbnpVb1k@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                     | 12 +++++++-----
 tools/perf/config/feature-checks/Makefile      |  4 ++++
 tools/perf/config/feature-checks/test-bionic.c |  6 ++++++
 3 files changed, 17 insertions(+), 5 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-bionic.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 7a614f92ce8c..09e2ecc4b056 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -107,6 +107,7 @@ FEATURE_TESTS =				\
 	stackprotector			\
 	volatile-register-var		\
 	fortify-source			\
+	bionic				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -150,12 +151,13 @@ CFLAGS += -I$(LIB_INCLUDE)
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
 ifndef NO_BIONIC
-ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
-  BIONIC := 1
-  EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
-  EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+  $(feature_check,bionic)
+  ifeq ($(feature-bionic), 1)
+    BIONIC := 1
+    EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
+    EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+  endif
 endif
-endif # NO_BIONIC
 
 ifdef NO_LIBELF
   NO_DWARF := 1
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 529317e6009b..191df97a031d 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -5,6 +5,7 @@ FILES=					\
 	test-stackprotector		\
 	test-volatile-register-var	\
 	test-fortify-source		\
+	test-bionic			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -30,6 +31,9 @@ test-volatile-register-var:
 test-fortify-source:
 	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
 
+test-bionic:
+	$(BUILD)
+
 test-libnuma:
 	$(BUILD) -lnuma
 
diff --git a/tools/perf/config/feature-checks/test-bionic.c b/tools/perf/config/feature-checks/test-bionic.c
new file mode 100644
index 000000000000..eac24e9513eb
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-bionic.c
@@ -0,0 +1,6 @@
+#include <android/api-level.h>
+
+int main(void)
+{
+	return __ANDROID_API__;
+}
-- 
1.8.1.4

