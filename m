Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3JJHDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:03:52 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:55300 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3JJHDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:03:50 -0400
Date: Thu, 10 Oct 2013 09:03:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tools/perf/build: Remove the volatile-register-var feature
 check
Message-ID: <20131010070347.GH10246@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-8-git-send-email-mingo@kernel.org>
 <87d2ndk6tu.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2ndk6tu.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim noticed that the volatile-register-var feature check
is superfluous:

 > The gcc manpage says this warning is enabled by -Wall, and we add -Wall
 > to CFLAGS before doing feature checks.  So all gcc versions that support
 > -Wvolatile-register-var enables it by default without this check and
 > older gcc versions will always fail the feature check.

Remove it - this will further speed up feature checks.

Reported-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                | 7 +------
 tools/perf/config/feature-checks/Makefile | 8 ++------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 587dd7e..d38119f 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -132,8 +132,7 @@ CORE_FEATURE_TESTS =			\
 	libunwind			\
 	on-exit				\
 	stackprotector			\
-	stackprotector-all		\
-	volatile-register-var
+	stackprotector-all
 
 #
 # So here we detect whether test-all was rebuilt, to be able
@@ -203,10 +202,6 @@ ifeq ($(feature-stackprotector), 1)
   CFLAGS += -Wstack-protector
 endif
 
-ifeq ($(feature-volatile-register-var), 1)
-  CFLAGS += -Wvolatile-register-var
-endif
-
 ifeq ($(DEBUG),0)
   ifeq ($(feature-fortify-source), 1)
     CFLAGS += -D_FORTIFY_SOURCE=2
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index cf33596..2eb8346 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -25,8 +25,7 @@ FILES=					\
 	test-libunwind			\
 	test-on-exit			\
 	test-stackprotector-all		\
-	test-stackprotector		\
-	test-volatile-register-var
+	test-stackprotector
 
 CC := $(CC) -MD
 
@@ -37,7 +36,7 @@ BUILD = $(CC) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
 ###############################
 
 test-all:
-	$(BUILD) -Werror -fstack-protector -fstack-protector-all -Wvolatile-register-var -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
+	$(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
 
 test-hello:
 	$(BUILD)
@@ -48,9 +47,6 @@ test-stackprotector-all:
 test-stackprotector:
 	$(BUILD) -Werror -fstack-protector
 
-test-volatile-register-var:
-	$(BUILD) -Werror -Wvolatile-register-var
-
 test-fortify-source:
 	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=2
 
