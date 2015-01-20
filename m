Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbbATR2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:28:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbbATR2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:28:52 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/36] perf build: Add perf.o object building
Date: Tue, 20 Jan 2015 17:39:16 +0100
Message-Id: <1421771973-6022-20-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the perf object building under build framework
to be included in the perf build object.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Build         |  3 +++
 tools/perf/Makefile.perf | 16 +++++-----------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Build b/tools/perf/Build
index 133ec649e5a2..976e03849f6d 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -25,12 +25,15 @@ perf-$(CONFIG_LIBELF) += builtin-probe.o
 perf-y += bench/
 perf-y += tests/
 
+perf-y += perf.o
+
 paths += -DPERF_HTML_PATH="BUILD_STR($(htmldir_SQ))"
 paths += -DPERF_INFO_PATH="BUILD_STR($(infodir_SQ))"
 paths += -DPERF_MAN_PATH="BUILD_STR($(mandir_SQ))"
 
 CFLAGS_builtin-help.o      += $(paths)
 CFLAGS_builtin-timechart.o += $(paths)
+CFLAGS_perf.o              += -DPERF_HTML_PATH="BUILD_STR($(htmldir_SQ))" -include $(OUTPUT)PERF-VERSION-FILE
 
 libperf-y += util/
 libperf-y += arch/
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index bd90164bfd11..c68ff5fa8504 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -376,16 +376,11 @@ PERF_IN := $(OUTPUT)perf-in.o
 export srctree OUTPUT RM CC LD AR CFLAGS V BISON FLEX
 build := -f $(srctree)/tools/build/Makefile.build dir=. obj
 
-$(PERF_IN): FORCE
+$(PERF_IN): $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h FORCE
 	@$(MAKE) $(build)=perf
 
-$(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -include $(OUTPUT)PERF-VERSION-FILE \
-		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
-		$(CFLAGS) -c $(filter %.c,$^) -o $@
-
-$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS) $(PERF_IN)
-	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
+$(OUTPUT)perf: $(BUILTIN_OBJS) $(PERFLIBS) $(PERF_IN)
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) \
                $(BUILTIN_OBJS) $(PERF_IN) $(LIBS) -o $@
 
 $(GTK_IN): FORCE
@@ -403,8 +398,7 @@ $(SCRIPTS) : % : %.sh
 	$(QUIET_GEN)$(INSTALL) '$@.sh' '$(OUTPUT)$@'
 
 # These can record PERF_VERSION
-$(OUTPUT)perf.o perf.spec \
-	$(SCRIPTS) \
+perf.spec $(SCRIPTS) \
 	: $(OUTPUT)PERF-VERSION-FILE
 
 .SUFFIXES:
@@ -659,7 +653,7 @@ config-clean:
 	@$(MAKE) -C config/feature-checks clean >/dev/null
 
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
-	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(OUTPUT)perf.o $(LANG_BINDINGS)
+	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(LANG_BINDINGS)
 	@find . -name '*.o' -delete -o -name '\.*.cmd' -delete -o -name '\.*.d' -delete
 	@$(RM) .config-detected
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 perf-read-vdsox32
-- 
1.9.3

