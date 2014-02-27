Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaB0N2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:28:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54679 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaB0N2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:28:31 -0500
Date: Thu, 27 Feb 2014 05:28:00 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-da237ed07c5144b0330a38b9b68be167231255d0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1392805300-14610-3-git-send-email-jolsa@redhat.com>
References: <1392805300-14610-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix bison OUTPUT directories dependency
Git-Commit-ID: da237ed07c5144b0330a38b9b68be167231255d0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da237ed07c5144b0330a38b9b68be167231255d0
Gitweb:     http://git.kernel.org/tip/da237ed07c5144b0330a38b9b68be167231255d0
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 19 Feb 2014 11:21:40 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Feb 2014 09:29:35 -0300

perf tools: Fix bison OUTPUT directories dependency

The bison and flex C objects don't have dependency for creating output
directories.

This could lead to build failure if the one of those objects is picked
up by make to be build as the first one (reported by Arnaldo).

Also following make fails:
  $ rm -rf /tmp/krava; mkdir /tmp/krava; make O=/tmp/krava util/pmu-bison.o
  BUILD:   Doing 'make -j4' parallel build
  [ SNIP ]
  BISON    /tmp/krava/util/pmu-bison.c
  FLAGS:   * new build flags or prefix
bison: /tmp/krava/util/pmu-bison.output: cannot open: No such file or directory
make[1]: *** [/tmp/krava/util/pmu-bison.c] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [util/pmu-bison.o] Error 2

Adding bison objects dependency for output directories (flex objects
depends on bisons').

This fixies the make_util_pmu_bison_o_O make test.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392805300-14610-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 77b153f..5fedd69 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -712,9 +712,15 @@ $(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 # we depend the various files onto their directories.
 DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(GTK_OBJS)
 DIRECTORY_DEPS += $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
-$(DIRECTORY_DEPS): | $(sort $(dir $(DIRECTORY_DEPS)))
+# no need to add flex objects, because they depend on bison ones
+DIRECTORY_DEPS += $(OUTPUT)util/parse-events-bison.c
+DIRECTORY_DEPS += $(OUTPUT)util/pmu-bison.c
+
+OUTPUT_DIRECTORIES := $(sort $(dir $(DIRECTORY_DEPS)))
+
+$(DIRECTORY_DEPS): | $(OUTPUT_DIRECTORIES)
 # In the second step, we make a rule to actually create these directories
-$(sort $(dir $(DIRECTORY_DEPS))):
+$(OUTPUT_DIRECTORIES):
 	$(QUIET_MKDIR)$(MKDIR) -p $@ 2>/dev/null
 
 $(LIB_FILE): $(LIB_OBJS)
