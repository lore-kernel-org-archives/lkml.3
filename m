Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3JHKML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:12:11 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:57715 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3JHKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:07 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 02/52] tools/perf/build: Add feature check core code
Date: Tue,  8 Oct 2013 12:10:32 +0200
Message-Id: <1381227082-22039-3-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 34be743..daefe2d 100644
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
index 0000000..b3f6372
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
index 0000000..c9f398d
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
1.8.3.1

