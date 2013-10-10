Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3JJGKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:10:53 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:45100 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3JJGKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:10:52 -0400
Date: Thu, 10 Oct 2013 08:10:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] tools/perf/build: Pass through DEBUG parameter
Message-ID: <20131010061048.GB23716@gmail.com>
References: <20131009070149.GA32023@gmail.com>
 <20131009143830.GA28369@ghostprotocols.net>
 <20131009145157.GA27139@gmail.com>
 <20131009191626.GD28369@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009191626.GD28369@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/Makefile        | 15 ++++++++++++++-
 tools/perf/config/Makefile |  7 ++-----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9147044..4835618 100644
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
index f5d661f..3227107 100644
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
