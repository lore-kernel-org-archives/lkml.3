Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbbATR2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:28:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbbATR2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 15/36] perf build: Add gtk objects building
Date: Tue, 20 Jan 2015 17:39:12 +0100
Message-Id: <1421771973-6022-16-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the gtk objects building under build framework.

Add new gtk build object so it's separated from
the rest of the code and could be librarized.

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
 tools/perf/Build           |  2 ++
 tools/perf/Makefile.perf   | 17 +++++------------
 tools/perf/config/Makefile |  1 +
 tools/perf/ui/gtk/Build    |  9 +++++++++
 4 files changed, 17 insertions(+), 12 deletions(-)
 create mode 100644 tools/perf/ui/gtk/Build

diff --git a/tools/perf/Build b/tools/perf/Build
index e84ced325147..a9ff8fd0bff9 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -35,3 +35,5 @@ CFLAGS_builtin-timechart.o += $(paths)
 libperf-y += util/
 libperf-y += arch/
 libperf-y += ui/
+
+gtk-y += ui/gtk/
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 603940d5f53b..472dfd6b766f 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -341,14 +341,7 @@ endif
 
 ifndef NO_GTK2
   ALL_PROGRAMS += $(OUTPUT)libperf-gtk.so
-
-  GTK_OBJS += $(OUTPUT)ui/gtk/browser.o
-  GTK_OBJS += $(OUTPUT)ui/gtk/hists.o
-  GTK_OBJS += $(OUTPUT)ui/gtk/setup.o
-  GTK_OBJS += $(OUTPUT)ui/gtk/util.o
-  GTK_OBJS += $(OUTPUT)ui/gtk/helpline.o
-  GTK_OBJS += $(OUTPUT)ui/gtk/progress.o
-  GTK_OBJS += $(OUTPUT)ui/gtk/annotate.o
+  GTK_IN := $(OUTPUT)gtk-in.o
 
 install-gtk: $(OUTPUT)libperf-gtk.so
 	$(call QUIET_INSTALL, 'GTK UI') \
@@ -416,10 +409,10 @@ $(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS) $(PERF_IN)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
                $(BUILTIN_OBJS) $(PERF_IN) $(LIBS) -o $@
 
-$(GTK_OBJS): $(OUTPUT)%.o: %.c $(LIB_H)
-	$(QUIET_CC)$(CC) -o $@ -c -fPIC $(CFLAGS) $(GTK_CFLAGS) $<
+$(GTK_IN): FORCE
+	@$(MAKE) $(build)=gtk
 
-$(OUTPUT)libperf-gtk.so: $(GTK_OBJS) $(PERFLIBS)
+$(OUTPUT)libperf-gtk.so: $(GTK_IN) $(PERFLIBS)
 	$(QUIET_LINK)$(CC) -o $@ -shared $(LDFLAGS) $(filter %.o,$^) $(GTK_LIBS)
 
 $(OUTPUT)common-cmds.h: util/generate-cmdlist.sh command-list.txt
@@ -699,7 +692,7 @@ config-clean:
 	@$(MAKE) -C config/feature-checks clean >/dev/null
 
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
-	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
+	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(OUTPUT)perf.o $(LANG_BINDINGS)
 	@find . -name '*.o' -delete -o -name '\.*.cmd' -delete -o -name '\.*.d' -delete
 	@$(RM) .config-detected
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 perf-read-vdsox32
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 4e5f080e2a22..05b6724fdb19 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -840,3 +840,4 @@ $(call detected_var,ETC_PERFCONFIG_SQ)
 $(call detected_var,prefix_SQ)
 $(call detected_var,perfexecdir_SQ)
 $(call detected_var,LIBDIR)
+$(call detected_var,GTK_CFLAGS)
diff --git a/tools/perf/ui/gtk/Build b/tools/perf/ui/gtk/Build
new file mode 100644
index 000000000000..ec22e899a224
--- /dev/null
+++ b/tools/perf/ui/gtk/Build
@@ -0,0 +1,9 @@
+CFLAGS_gtk += -fPIC $(GTK_CFLAGS)
+
+gtk-y += browser.o
+gtk-y += hists.o
+gtk-y += setup.o
+gtk-y += util.o
+gtk-y += helpline.o
+gtk-y += progress.o
+gtk-y += annotate.o
-- 
1.9.3

