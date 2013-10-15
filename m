Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab3JOFNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:13:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60399 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab3JOFM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:12:57 -0400
Date: Mon, 14 Oct 2013 22:12:41 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-b6aa9979416e2e98a800925d60ad00e83bc7cb7a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Add feature check core code
Git-Commit-ID: b6aa9979416e2e98a800925d60ad00e83bc7cb7a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:12:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b6aa9979416e2e98a800925d60ad00e83bc7cb7a
Gitweb:     http://git.kernel.org/tip/b6aa9979416e2e98a800925d60ad00e83bc7cb7a
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 10:08:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:28 +0200

tools/perf/build: Add feature check core code

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
