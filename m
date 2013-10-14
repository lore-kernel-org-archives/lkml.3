Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3JNULD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:11:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39296 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3JNUHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:07:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 033/161] tools/perf/build: Speed up git-version test on re-make
Date: Mon, 14 Oct 2013 17:00:22 -0300
Message-Id: <1381780950-25642-34-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

util/PERF-VERSION-GEN is currently executed on every build attempt,
and this script can take a lot of time on trees that are at a
significant git-distance from Linus's tree:

  $ time util/PERF-VERSION-GEN

  real    0m4.343s
  user    0m4.176s
  sys     0m0.140s

It also takes a lot of time if the Git repository is network attached, etc.,
because the commands it uses:

        TAG=$(git describe --abbrev=0 --match "v[0-9].[0-9]*" 2>/dev/null )

has to count commits from the nearest tag and thus has to access (and
decompress) every git commit blob on the relevant version path.

Even on Linus's tree it takes 0.28 seconds on a fast box to count all the
commits and get the git version string:

  $ time util/PERF-VERSION-GEN

  real    0m0.279s
  user    0m0.247s
  sys     0m0.025s

But the version string only has to be regenerated if the git repository's
head commit changes. So add a dependency of ../../.git/HEAD and touch
the file every time it's regenerated, so that Make's build rules can
pick it up and cache the result:

  make: `PERF-VERSION-FILE' is up to date.

  real    0m0.184s
  user    0m0.117s
  sys     0m0.026s

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-wvmlrurufuk6mo1ovtNigguT@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 64c043b7a438..6b5452a120af 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -70,8 +70,9 @@ ifneq ($(OUTPUT),)
 #$(info Determined 'OUTPUT' to be $(OUTPUT))
 endif
 
-$(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
+$(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
+	@touch $(OUTPUT)PERF-VERSION-FILE
 
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
@@ -814,6 +815,16 @@ clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean
 	$(RM) $(OUTPUT)util/*-flex*
 	$(python-clean)
 
+#
+# Trick: if ../../.git does not exist - we are building out of tree for example,
+# then force version regeneration:
+#
+ifeq ($(wildcard ../../.git/HEAD),)
+    GIT-HEAD-PHONY = ../../.git/HEAD
+else
+    GIT-HEAD-PHONY =
+endif
+
 .PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
-.PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
+.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS
-- 
1.8.1.4

