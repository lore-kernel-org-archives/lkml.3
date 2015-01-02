Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbbABPhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:37:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbbABPhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:37:18 -0500
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
Subject: [PATCH 02/30] perf build: Add detected config framework support
Date: Fri,  2 Jan 2015 16:35:44 +0100
Message-Id: <1420212972-21595-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to include detected configuration makefile
into the build process. This will allow the Build objects
to be configurable based on the config data, like:

  perf-$(CONFIG_KRAVA) += krava.o

The configuration is stored in '.config-detected' file,
which is generated for each compilation.

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
 tools/perf/Makefile.build  | 3 +++
 tools/perf/Makefile.perf   | 1 +
 tools/perf/config/Makefile | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/tools/perf/Makefile.build b/tools/perf/Makefile.build
index 123de33e163d..68556874ea86 100644
--- a/tools/perf/Makefile.build
+++ b/tools/perf/Makefile.build
@@ -15,6 +15,9 @@ endif
 # Generic definitions
 include Build.include
 
+# do not force detected configuration
+-include .config-detected
+
 # Init all relevant variables used in build files so
 # 1) they have correct type
 # 2) they do not inherit any value from the environment
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 54edd4ac9409..f578e1a91250 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -988,6 +988,7 @@ config-clean:
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
 	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
 	@find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o | xargs $(RM)
+	@$(RM) .config-detected
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 perf-read-vdsox32
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5d4b039fe1ed..f6538544c740 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -11,6 +11,10 @@ ifneq ($(obj-perf),)
 obj-perf := $(abspath $(obj-perf))/
 endif
 
+$(shell echo -n > .config-detected)
+detected     = $(shell echo "$(1)=y"       >> .config-detected)
+detected_var = $(shell echo "$(1)=$($(1))" >> .config-detected)
+
 LIB_INCLUDE := $(srctree)/tools/lib/
 CFLAGS := $(EXTRA_CFLAGS) $(EXTRA_WARNINGS)
 
-- 
1.9.3

