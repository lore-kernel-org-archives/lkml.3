Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab3JNUxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:53:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38408 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab3JNUCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 002/161] tools/perf/build: Add feature check core code
Date: Mon, 14 Oct 2013 16:59:51 -0300
Message-Id: <1381780950-25642-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Start the split-out of the feature check code by adding a list of features to be
tested, and rules to process that list by building its matching feature-check
file in config/feature-checks/test-<feature>.c.

Add 'hello' as the initial feature.

This structure will allow us to build split-out feature checks in parallel and
thus speed up feature detection dramatically.

No change in functionality: no feature check is used by the build rules yet.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-pixkihgscFaohfFigq5yt9gs@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                    | 16 ++++++++++++++++
 tools/perf/config/feature-checks/Makefile     | 16 ++++++++++++++++
 tools/perf/config/feature-checks/test-hello.c |  6 ++++++
 3 files changed, 38 insertions(+)
 create mode 100644 tools/perf/config/feature-checks/Makefile
 create mode 100644 tools/perf/config/feature-checks/test-hello.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 34be7432d567..daefe2dfacad 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -89,6 +89,22 @@ CFLAGS += -std=gnu99
 
 EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
+feature_check = $(eval $(feature_check_code)); $(info CHK: config/feature-checks/test-$(1))
+define feature_check_code
+  feature-$(2) := $(shell make -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
+endef
+
+#
+# Build the feature check binaries in parallel, ignore errors, ignore return value and suppress output:
+#
+$(info Testing features:)
+$(shell make -i -j -C config/feature-checks >/dev/null 2>&1)
+$(info done)
+
+FEATURE_TESTS = hello
+
+$(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
+
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
   CFLAGS += -fstack-protector-all
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
new file mode 100644
index 000000000000..b3f6372ad8b0
--- /dev/null
+++ b/tools/perf/config/feature-checks/Makefile
@@ -0,0 +1,16 @@
+
+FILES=test-hello
+
+all: $(FILES)
+
+BUILD = $(CC) -o $(OUTPUT)$@ $@.c
+
+###############################
+
+test-hello: test-hello.c
+	$(BUILD)
+
+###############################
+
+clean:
+	rm -f $(FILES)
diff --git a/tools/perf/config/feature-checks/test-hello.c b/tools/perf/config/feature-checks/test-hello.c
new file mode 100644
index 000000000000..c9f398d87868
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-hello.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
-- 
1.8.1.4

