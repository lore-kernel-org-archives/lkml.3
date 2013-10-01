Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab3JAOq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:46:28 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:59640 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab3JAOqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:46:22 -0400
Date: Tue, 1 Oct 2013 16:46:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] perf tools: Speed up git-version test on re-make
Message-ID: <20131001144618.GA8970@gmail.com>
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


Another build speedup, while at it.

===============>
Subject: perf tools: Speed up git-version test on re-make
From: Ingo Molnar <mingo@kernel.org>
Date: Tue Oct 1 16:28:09 CEST 2013

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

So the version generation overhead is completely gone for re-builds.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: tip/tools/perf/Makefile
===================================================================
--- tip.orig/tools/perf/Makefile
+++ tip/tools/perf/Makefile
@@ -70,8 +70,9 @@ ifneq ($(OUTPUT),)
 #$(info Determined 'OUTPUT' to be $(OUTPUT))
 endif
 
-$(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
+$(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
+	@touch $(OUTPUT)PERF-VERSION-FILE
 
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
@@ -813,7 +814,17 @@ clean: $(LIBTRACEEVENT)-clean $(LIBLK)-c
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
 
