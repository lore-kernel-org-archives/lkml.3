Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3KULEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:04:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab3KULCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:02:43 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 17/22] perf tools: Add build and install plugins targets
Date: Thu, 21 Nov 2013 12:01:15 +0100
Message-Id: <1385031680-9014-18-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding 'plugins' target along with the libtraceevent.a,
so plugins are built together with traceevent library.

Adding 'install-traceevent-plugins' Makefile install target,
instructing perf to install plugins into:
  $(HOME)/libexec/perf-core/traceevent/plugins
    - if installed localy under $HOME
  $(DESTDIR)/$(prefix)/$(perfexecdir)/traceevent/plugins
    - if installed globally

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile.perf   | 15 ++++++++++-----
 tools/perf/config/Makefile |  2 ++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index e416ccc..b4f8910 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -105,7 +105,7 @@ ifeq ($(config),1)
 include config/Makefile
 endif
 
-export prefix bindir sharedir sysconfdir
+export prefix bindir sharedir sysconfdir DESTDIR
 
 # sparse is architecture-neutral, which means that we need to tell it
 # explicitly what architecture to check for. Fix this up for yours..
@@ -710,13 +710,18 @@ $(LIB_FILE): $(LIB_OBJS)
 # libtraceevent.a
 TE_SOURCES = $(wildcard $(TRACE_EVENT_DIR)*.[ch])
 
-$(LIBTRACEEVENT): $(TE_SOURCES)
-	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) CFLAGS="-g -Wall $(EXTRA_CFLAGS)" libtraceevent.a
+LIBTRACEEVENT_FLAGS=$(QUIET_SUBDIR1) O=$(OUTPUT) CFLAGS="-g -Wall $(EXTRA_CFLAGS)" plugin_dir=$(plugindir_SQ)
+
+$(LIBTRACEEVENT): $(TE_SOURCES) $(OUTPUT)PERF-CFLAGS
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) libtraceevent.a plugins
 
 $(LIBTRACEEVENT)-clean:
 	$(call QUIET_CLEAN, libtraceevent)
 	@$(MAKE) -C $(TRACE_EVENT_DIR) O=$(OUTPUT) clean >/dev/null
 
+install-traceevent-plugins:
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) install_plugins
+
 LIBLK_SOURCES = $(wildcard $(LK_PATH)*.[ch])
 
 # if subdir is set, we've been called from above so target has been built
@@ -785,7 +790,7 @@ cscope:
 
 ### Detect prefix changes
 TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
-             $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)
+             $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ):$(plugindir_SQ)
 
 $(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
 	@FLAGS='$(TRACK_CFLAGS)'; \
@@ -849,7 +854,7 @@ endif
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'; \
 		$(INSTALL) tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
 
-install: install-bin try-install-man
+install: install-bin try-install-man install-traceevent-plugins
 
 install-python_ext:
 	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f7d11a8..8c8a205 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -578,6 +578,7 @@ else
 lib = lib
 endif
 libdir = $(prefix)/$(lib)
+plugindir=$(perfexecdir)/traceevent/plugins
 
 # Shell quote (do not use $(call) to accommodate ancient setups);
 ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
@@ -598,3 +599,4 @@ else
 perfexec_instdir = $(prefix)/$(perfexecdir)
 endif
 perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
+plugindir_SQ= $(subst ','\'',$(prefix)/$(plugindir))
-- 
1.8.3.1

