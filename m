Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab3JOFRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:17:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60692 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3JOFRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:17:40 -0400
Date: Mon, 14 Oct 2013 22:17:26 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-c9404c6650d8f58ce8cf98d4c5581fc5c9e37faf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Speed up the final link
Git-Commit-ID: c9404c6650d8f58ce8cf98d4c5581fc5c9e37faf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:17:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9404c6650d8f58ce8cf98d4c5581fc5c9e37faf
Gitweb:     http://git.kernel.org/tip/c9404c6650d8f58ce8cf98d4c5581fc5c9e37faf
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Tue, 1 Oct 2013 17:17:22 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:51 +0200

tools/perf/build: Speed up the final link

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
index 6b5452a..df76198 100644
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
