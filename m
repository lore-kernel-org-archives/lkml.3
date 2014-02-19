Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaBSKWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:22:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbaBSKWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:22:06 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/3] perf tools: Fix bison OUTPUT directories dependency
Date: Wed, 19 Feb 2014 11:21:40 +0100
Message-Id: <1392805300-14610-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1392805300-14610-1-git-send-email-jolsa@redhat.com>
References: <1392805300-14610-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bison and flex C objects don't have dependency
for creating output directories.

This could lead to build failure if the one of those
objects is picked up by make to be build as the first
one (reported by Arnaldo).

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

Adding bison objects dependency for output directories
(flex objects depends on bisons').

This fixies the make_util_pmu_bison_o_O make test.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile.perf | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 869b34a..947918b 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -713,9 +713,15 @@ $(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
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
-- 
1.8.3.1

