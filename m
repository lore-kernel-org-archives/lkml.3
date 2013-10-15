Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab3JOFS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:18:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60734 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab3JOFSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:18:24 -0400
Date: Mon, 14 Oct 2013 22:18:10 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-2cfbe880f0a8eed7beabade3e06fd53f999b3e32@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Automatically build in parallel
 , based on number of CPUs in the system
Git-Commit-ID: 2cfbe880f0a8eed7beabade3e06fd53f999b3e32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:18:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cfbe880f0a8eed7beabade3e06fd53f999b3e32
Gitweb:     http://git.kernel.org/tip/2cfbe880f0a8eed7beabade3e06fd53f999b3e32
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 2 Oct 2013 11:18:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:54 +0200

tools/perf/build: Automatically build in parallel, based on number of CPUs in the system

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
