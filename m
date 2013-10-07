Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab3JGL6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:58:25 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:57738 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3JGL6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:20 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 33/50] tools/perf/build: Speed up the final link
Date: Mon,  7 Oct 2013 13:56:26 +0200
Message-Id: <1381147003-2574-34-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index b2f27ea..45df85e 100644
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
@@ -824,6 +828,6 @@ else
     GIT-HEAD-PHONY =
 endif
 
-.PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
+.PHONY: all install clean strip
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS
-- 
1.7.11.7

