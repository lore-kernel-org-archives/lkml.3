Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3JHKMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:12:20 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51633 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab3JHKMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:14 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 09/52] tools/perf/build: Split out feature check: 'bionic'
Date: Tue,  8 Oct 2013 12:10:39 +0200
Message-Id: <1381227082-22039-10-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-xjfVewprrfhlo2wuzbnpVb1k@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                     | 12 +++++++-----
 tools/perf/config/feature-checks/Makefile      |  4 ++++
 tools/perf/config/feature-checks/test-bionic.c |  6 ++++++
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 7a614f9..09e2ecc 100644
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
index 529317e..191df97 100644
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
index 0000000..eac24e9
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
1.8.3.1

