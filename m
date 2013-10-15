Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab3JOFTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:19:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3JOFTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:19:46 -0400
Date: Mon, 14 Oct 2013 22:19:32 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-684f434cc05a122938b75e055d7d799f1dd58d55@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Exclude MAKEFLAGS from nested invocation
Git-Commit-ID: 684f434cc05a122938b75e055d7d799f1dd58d55
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:19:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  684f434cc05a122938b75e055d7d799f1dd58d55
Gitweb:     http://git.kernel.org/tip/684f434cc05a122938b75e055d7d799f1dd58d55
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Fri, 4 Oct 2013 11:11:32 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:49:01 +0200

tools/perf/build: Exclude MAKEFLAGS from nested invocation

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
index 6f6f13a..74f52d8 100644
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
