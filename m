Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3JGMCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:02:06 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:44335 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3JGL6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:24 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 38/50] tools/perf/build: Automatically build in parallel, based on number of CPUs in the system
Date: Mon,  7 Oct 2013 13:56:31 +0200
Message-Id: <1381147003-2574-39-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement automatic parallel builds when building in tools/perf:

  $ time make

  # [ perf build: Doing 'make -j12' parallel build. ]

  Auto-detecting system features:

  ...

  real    0m9.265s
  user    0m59.888s
  sys     0m6.082s

On GNU make achieving this is not particularly easy, it requires a separate
makefile, which then invokes the main Makefile.

( Note: this patch adds Makefile.parallel to show the concept - the two
  makefiles will be flipped in the next patch to avoid having to specify -f
  to get parallelism in the default build. )

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-dvBjwqiTyzrufzkz8oanhpf9@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile.parallel | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/perf/Makefile.parallel b/tools/perf/Makefile.parallel
new file mode 100644
index 0000000..ec5e08b
--- /dev/null
+++ b/tools/perf/Makefile.parallel
@@ -0,0 +1,26 @@
+#
+# Do a parallel build with multiple jobs, based on the number of CPUs online
+# in this system: 'make -j8' on a 8-CPU system, etc.
+#
+# (To override it, run 'make JOBS=1' and similar.)
+#
+ifeq ($(JOBS),)
+  JOBS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
+  ifeq ($(JOBS),)
+    JOBS := 1
+  endif
+endif
+
+export JOBS
+
+$(info $(shell printf '# [ perf build: Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build. ]\n'))
+
+#
+# Needed if no target specified:
+#
+all:
+	@$(MAKE) --no-print-directory -j$(JOBS) $@
+
+%:
+	@$(MAKE) --no-print-directory -j$(JOBS) $@
+
-- 
1.7.11.7

