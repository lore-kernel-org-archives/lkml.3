Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab3JBJ3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:29:03 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:40801 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3JBJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:28:59 -0400
Date: Wed, 2 Oct 2013 11:28:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tools/perf/build: Automatically build in parallel, based on
 number of CPUs in the system
Message-ID: <20131002092856.GA9360@gmail.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <20131002073140.GA6652@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002073140.GA6652@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch below fixes another tools/perf build system annoyance: that it 
does not build in parallel by default.

The effect is that for example 'make install' will build in parallel 
(dependent on number of CPUs in the system) and then install the result.

Thanks,

	Ingo

=======================>
Subject: tools/perf/build: Automatically build in parallel, based on number of CPUs in the system
From: Ingo Molnar <mingo@kernel.org>
Date: Wed Oct 2 11:18:28 CEST 2013

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
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile.parallel |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

Index: tip/tools/perf/Makefile.parallel
===================================================================
--- /dev/null
+++ tip/tools/perf/Makefile.parallel
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
