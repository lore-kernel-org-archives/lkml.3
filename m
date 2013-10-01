Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3JAP2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:28:13 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:45413 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3JAP2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:28:01 -0400
Date: Tue, 1 Oct 2013 17:27:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] perf autodep: Remove strlcpy feature check, add __weak
 strlcpy implementation
Message-ID: <20131001152757.GB8970@gmail.com>
References: <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20130930171220.GC10293@ghostprotocols.net>
 <CA+55aFyjtFo2GVAvvUD_BQBN-F6QzOVWzcFo5v_MLhEwpGa03w@mail.gmail.com>
 <20130930175342.GI10293@ghostprotocols.net>
 <20130930190434.GA3427@gmail.com>
 <20131001113456.GA31331@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001113456.GA31331@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, this should be my final perf-build speedup patch.

With this patch and all the other patches applied perf delta-builds very 
fast now - an empty re-build takes just 0.2 seconds:

  comet:~/tip/tools/perf> time make

  real    0m0.207s
  user    0m0.130s
  sys     0m0.034s

and the rebuild after a single .c file was changed is just 1.8 seconds:

  comet:~/tip/tools/perf> touch perf.c; time make

  real    0m1.892s
  user    0m1.495s
  sys     0m0.337s

Without the changes this used to be 9.4 seconds:

  comet:~/tip/tools/perf> touch perf.c; time make

  real    0m9.418s
  user    0m8.251s
  sys     0m0.996s

which was an eternity! :-)

Thanks,

	Ingo

------------------------>
Subject: perf tools: Speed up the final link
From: Ingo Molnar <mingo@kernel.org>
Date: Tue Oct 1 17:17:22 CEST 2013

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

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: tip/tools/perf/Makefile
===================================================================
--- tip.orig/tools/perf/Makefile
+++ tip/tools/perf/Makefile
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
@@ -824,7 +828,7 @@ else
     GIT-HEAD-PHONY =
 endif
 
-.PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
+.PHONY: all install clean strip
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS
 

