Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab3JNUDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:03:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38543 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3JNUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 034/161] tools/perf/build: Speed up the final link
Date: Mon, 14 Oct 2013 17:00:23 -0300
Message-Id: <1381780950-25642-35-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

libtraceevent.a and liblk.a rules have always-missed dependencies,
which causes python.so to be relinked at every build attempt - even
if none of the affected code changes.

This slows down re-builds unnecessarily, by adding more than a second
to the build time:

  comet:~/tip/tools/perf> time make

  ...

    SUBDIR /fast/mingo/tip/tools/lib/lk/
    make[1]: `liblk.a' is up to date.
    SUBDIR /fast/mingo/tip/tools/lib/traceevent/
    LINK perf
    GEN python/perf.so

  real    0m1.701s
  user    0m1.338s
  sys     0m0.301s

Add the (trivial) dependencies to not force a re-link.

This speeds up an empty re-build enormously:

  comet:~/tip/tools/perf> time make

  ...

  real    0m0.207s
  user    0m0.134s
  sys     0m0.028s

[ This adds some coupling between the build dependencies of
  libtraceevent and liblk - but until those stay relatively
  simple this should not be an issue. ]

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-wvmlrurufuk6mo1ovtNigguT@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6b5452a120af..df76198d45d4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -669,15 +669,19 @@ $(LIB_FILE): $(LIB_OBJS)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
 
 # libtraceevent.a
-$(LIBTRACEEVENT):
+TE_SOURCES = $(wildcard $(TRACE_EVENT_DIR)*.[ch])
+
+$(LIBTRACEEVENT): $(TE_SOURCES)
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libtraceevent.a
 
 $(LIBTRACEEVENT)-clean:
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
 
+LIBLK_SOURCES = $(wildcard $(LK_PATH)*.[ch])
+
 # if subdir is set, we've been called from above so target has been built
 # already
-$(LIBLK):
+$(LIBLK): $(LIBLK_SOURCES)
 ifeq ($(subdir),)
 	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) liblk.a
 endif
@@ -825,6 +829,6 @@ else
     GIT-HEAD-PHONY =
 endif
 
-.PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
+.PHONY: all install clean strip
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS
-- 
1.8.1.4

