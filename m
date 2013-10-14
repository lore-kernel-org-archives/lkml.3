Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab3JNUJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:09:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39320 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab3JNUHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:07:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 148/161] tools/perf/build: Pass through DEBUG parameter
Date: Mon, 14 Oct 2013 17:02:17 -0300
Message-Id: <1381780950-25642-149-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Arnaldo reported that 'make DEBUG=1' does not work anymore.

The reason is that 'Makefile' only passes it through to
'Makefile.perf' via the environment, but 'Makefile.perf'
checks that it's a command line option:

    ifeq ("$(origin DEBUG)", "command line")
      PERF_DEBUG = $(DEBUG)
    endif

So pass it through properly, and also clean up DEBUG parameter
handling while at it and fix a couple of annoyances:

 - DEBUG=0 used to be interpreted as 'debugging on'. Turn it
   into 'debugging off' instead.

 - Same was the case for 'DEBUG=' - turn that into debug-off
   as well.

 - Pass in just a clean, sanitized 'DEBUG' value and get rid of
   the intermediate, unnecessary PERF_DEBUG variable.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 15 ++++++++++++++-
 tools/perf/config/Makefile |  7 ++-----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 914704495166..4835618a5608 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -37,12 +37,25 @@ ifneq ($(O),)
   FULL_O := $(shell readlink -f $(O) || echo $(O))
 endif
 
+#
+# Only accept the 'DEBUG' variable from the command line:
+#
+ifeq ("$(origin DEBUG)", "command line")
+  ifeq ($(DEBUG),)
+    override DEBUG = 0
+  else
+    SET_DEBUG = "DEBUG=$(DEBUG)"
+  endif
+else
+  override DEBUG = 0
+endif
+
 define print_msg
   @printf '  BUILD:   Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build\n'
 endef
 
 define make
-  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) O=$(FULL_O) $@
+  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) O=$(FULL_O) $(SET_DEBUG) $@
 endef
 
 #
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 96804247df08..9524c0c4e88f 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -66,10 +66,7 @@ ifneq ($(WERROR),0)
   CFLAGS += -Werror
 endif
 
-ifeq ("$(origin DEBUG)", "command line")
-  PERF_DEBUG = $(DEBUG)
-endif
-ifndef PERF_DEBUG
+ifeq ($(DEBUG),0)
   CFLAGS += -O6
 endif
 
@@ -210,7 +207,7 @@ ifeq ($(feature-volatile-register-var), 1)
   CFLAGS += -Wvolatile-register-var
 endif
 
-ifndef PERF_DEBUG
+ifeq ($(DEBUG),0)
   ifeq ($(feature-fortify-source), 1)
     CFLAGS += -D_FORTIFY_SOURCE=2
   endif
-- 
1.8.1.4

