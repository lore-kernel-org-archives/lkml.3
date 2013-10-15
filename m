Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab3JOFNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:13:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60413 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3JOFNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:13:14 -0400
Date: Mon, 14 Oct 2013 22:12:59 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-3ae069cfda88349fa61de9631f878d39ab60764f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 libnuma'
Git-Commit-ID: 3ae069cfda88349fa61de9631f878d39ab60764f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:13:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ae069cfda88349fa61de9631f878d39ab60764f
Gitweb:     http://git.kernel.org/tip/3ae069cfda88349fa61de9631f878d39ab60764f
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 13:37:10 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:30 +0200

tools/perf/build: Split out feature check: 'libnuma'

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
