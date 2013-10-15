Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab3JOFRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:17:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab3JOFRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:17:32 -0400
Date: Mon, 14 Oct 2013 22:17:18 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-c72e3f04b45fb2e50cdd81a50c3778c6a57251d8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Speed up git-version test on re-make
Git-Commit-ID: c72e3f04b45fb2e50cdd81a50c3778c6a57251d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:17:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c72e3f04b45fb2e50cdd81a50c3778c6a57251d8
Gitweb:     http://git.kernel.org/tip/c72e3f04b45fb2e50cdd81a50c3778c6a57251d8
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Tue, 1 Oct 2013 16:28:09 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:50 +0200

tools/perf/build: Speed up git-version test on re-make

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
index 64c043b..6b5452a 100644
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
