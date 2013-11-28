Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab3K1Ld4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:33:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab3K1Ldy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:33:54 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 01/29] perf tools: Remove stackprotector feature check
Date: Thu, 28 Nov 2013 12:33:00 +0100
Message-Id: <1385638408-23519-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use -fstack-protector-all option to enable stack protecting
for all available functions. There's no reason for enabling
-Wstack-protector to get warning for unprotected functions.

Removing stackprotector feature check which was used to
enable the -Wstack-protector option.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/config/Makefile                             | 5 -----
 tools/perf/config/feature-checks/Makefile              | 6 +-----
 tools/perf/config/feature-checks/test-stackprotector.c | 6 ------
 3 files changed, 1 insertion(+), 16 deletions(-)
 delete mode 100644 tools/perf/config/feature-checks/test-stackprotector.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 80ea6d8..38f388c2 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -161,7 +161,6 @@ CORE_FEATURE_TESTS =			\
 	libslang			\
 	libunwind			\
 	on-exit				\
-	stackprotector			\
 	stackprotector-all		\
 	timerfd
 
@@ -229,10 +228,6 @@ ifeq ($(feature-stackprotector-all), 1)
   CFLAGS += -fstack-protector-all
 endif
 
-ifeq ($(feature-stackprotector), 1)
-  CFLAGS += -Wstack-protector
-endif
-
 ifeq ($(DEBUG),0)
   ifeq ($(feature-fortify-source), 1)
     CFLAGS += -D_FORTIFY_SOURCE=2
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 8dffb62..fc78699 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -26,7 +26,6 @@ FILES=					\
 	test-libunwind-debug-frame	\
 	test-on-exit			\
 	test-stackprotector-all		\
-	test-stackprotector		\
 	test-timerfd
 
 CC := $(CC) -MD
@@ -38,7 +37,7 @@ BUILD = $(CC) $(CFLAGS) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
 ###############################
 
 test-all:
-	$(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
+	$(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
 
 test-hello:
 	$(BUILD)
@@ -46,9 +45,6 @@ test-hello:
 test-stackprotector-all:
 	$(BUILD) -Werror -fstack-protector-all
 
-test-stackprotector:
-	$(BUILD) -Werror -fstack-protector -Wstack-protector
-
 test-fortify-source:
 	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
 
diff --git a/tools/perf/config/feature-checks/test-stackprotector.c b/tools/perf/config/feature-checks/test-stackprotector.c
deleted file mode 100644
index c9f398d..0000000
--- a/tools/perf/config/feature-checks/test-stackprotector.c
+++ /dev/null
@@ -1,6 +0,0 @@
-#include <stdio.h>
-
-int main(void)
-{
-	return puts("hi");
-}
-- 
1.8.3.1

