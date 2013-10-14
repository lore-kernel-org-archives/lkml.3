Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab3JNUDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:03:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38546 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531Ab3JNUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 048/161] tools/perf/build: Exclude MAKEFLAGS from nested invocation
Date: Mon, 14 Oct 2013 17:00:37 -0300
Message-Id: <1381780950-25642-49-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

In case the user specifies MAKEFLAGS as an environment variable,
or uses 'make -jN' explicitly, the options can conflict and result in:

    BUILD: Doing 'make -j8' parallel build
    make[1]: warning: -jN forced in submake: disabling jobserver mode.
    GEN common-cmds.h
    make[1]: *** write jobserver: Bad file descriptor.  Stop.

Make sure we invoke the main makefile in a pristine state.

Users who want to do something non-standard can use the:

  make -f Makefile.perf

method to invoke the makefile.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-uen6hzTvkqqngqwjma9yoEgw@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6f6f13a13bb6..74f52d8f9631 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1,3 +1,10 @@
+#
+# This is a simple wrapper Makefile that calls the main Makefile.perf
+# with a -j option to do parallel builds
+#
+# If you want to invoke the perf build in some non-standard way then
+# you can use the 'make -f Makefile.perf' method to invoke it.
+#
 
 #
 # Clear out the built-in rules GNU make defines by default (such as .o targets),
@@ -6,6 +13,11 @@
 .SUFFIXES:
 
 #
+# We don't want to pass along options like -j:
+#
+unexport MAKEFLAGS
+
+#
 # Do a parallel build with multiple jobs, based on the number of CPUs online
 # in this system: 'make -j8' on a 8-CPU system, etc.
 #
@@ -18,14 +30,12 @@ ifeq ($(JOBS),)
   endif
 endif
 
-export JOBS
-
 define print_msg
   @printf '    BUILD: Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build\n'
 endef
 
 define make
-  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) $@
+  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) O=$(O) $@
 endef
 
 #
-- 
1.8.1.4

