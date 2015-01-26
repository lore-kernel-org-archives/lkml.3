Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbbAZKWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:22:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbbAZKOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:14:33 -0500
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
Subject: [PATCH 13/36] perf build: Add ui objects building
Date: Mon, 26 Jan 2015 11:12:13 +0100
Message-Id: <1422267156-13873-14-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the ui objects building under build framework
to be included in the libperf build object.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Tested-by: Will Deacon <will.deacon@arm.com>
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
 tools/perf/Build           |  1 +
 tools/perf/Makefile.perf   | 10 ----------
 tools/perf/config/Makefile |  1 +
 tools/perf/ui/Build        |  8 ++++++++
 4 files changed, 10 insertions(+), 10 deletions(-)
 create mode 100644 tools/perf/ui/Build

diff --git a/tools/perf/Build b/tools/perf/Build
index 170e4563bb24..e84ced325147 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -34,3 +34,4 @@ CFLAGS_builtin-timechart.o += $(paths)
 
 libperf-y += util/
 libperf-y += arch/
+libperf-y += ui/
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index c680f8a5a4b4..c06e64077633 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -327,13 +327,6 @@ LIB_H += util/data.h
 LIB_H += util/kvm-stat.h
 LIB_H += util/thread-stack.h
 
-LIB_OBJS += $(OUTPUT)ui/setup.o
-LIB_OBJS += $(OUTPUT)ui/helpline.o
-LIB_OBJS += $(OUTPUT)ui/progress.o
-LIB_OBJS += $(OUTPUT)ui/util.o
-LIB_OBJS += $(OUTPUT)ui/hist.o
-LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
-
 PERFLIBS = $(LIB_FILE) $(LIBAPIKFS) $(LIBTRACEEVENT)
 
 # We choose to avoid "if .. else if .. else .. endif endif"
@@ -491,9 +484,6 @@ $(OUTPUT)%.o: %.S
 $(OUTPUT)%.s: %.S
 	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
 
-$(OUTPUT)ui/setup.o: ui/setup.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DLIBDIR='"$(libdir_SQ)"' $<
-
 $(OUTPUT)ui/browser.o: ui/browser.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 2b4b273cf804..e7d1b46b7d31 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -838,3 +838,4 @@ $(call detected_var,mandir_SQ)
 $(call detected_var,ETC_PERFCONFIG_SQ)
 $(call detected_var,prefix_SQ)
 $(call detected_var,perfexecdir_SQ)
+$(call detected_var,LIBDIR)
diff --git a/tools/perf/ui/Build b/tools/perf/ui/Build
new file mode 100644
index 000000000000..077b6a448ddc
--- /dev/null
+++ b/tools/perf/ui/Build
@@ -0,0 +1,8 @@
+libperf-y += setup.o
+libperf-y += helpline.o
+libperf-y += progress.o
+libperf-y += util.o
+libperf-y += hist.o
+libperf-y += stdio/hist.o
+
+CFLAGS_setup.o += -DLIBDIR="BUILD_STR($(LIBDIR))"
-- 
1.9.3

