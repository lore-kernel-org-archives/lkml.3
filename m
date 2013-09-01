Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab3IAKuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:50:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3IAKuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:50:04 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 21/24] perf tools: Add traceevents Makefile install rule
Date: Sun,  1 Sep 2013 12:48:46 +0200
Message-Id: <1378032529-18498-22-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instructing perf to install plugins into:
  $HOME/.traceevent/plugins
     - if installed localy under $HOME
  $(perfexecdir)/traceevent/plugins
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
 tools/perf/Makefile        | 11 ++++++++---
 tools/perf/config/Makefile |  2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f5998da..140462a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -665,12 +665,14 @@ $(sort $(dir $(DIRECTORY_DEPS))):
 $(LIB_FILE): $(LIB_OBJS)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
 
+LIBTRACEEVENT_FLAGS=$(QUIET_SUBDIR1) O=$(OUTPUT) plugin_dir=$(plugindir_SQ)
+
 # libtraceevent.a
 $(LIBTRACEEVENT):
-	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libtraceevent.a
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) libtraceevent.a plugins
 
 $(LIBTRACEEVENT)-clean:
-	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) clean
 
 # if subdir is set, we've been called from above so target has been built
 # already
@@ -684,6 +686,9 @@ ifeq ($(subdir),)
 	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
 endif
 
+install-traceevent-plugins:
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) install_plugins
+
 help:
 	@echo 'Perf make targets:'
 	@echo '  doc		- make *all* documentation (see below)'
@@ -791,7 +796,7 @@ endif
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
 	$(INSTALL) tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
 
-install: install-bin try-install-man
+install: install-bin try-install-man install-traceevent-plugins
 
 install-python_ext:
 	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f6d720d..5e967b9 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -457,6 +457,7 @@ sysconfdir = $(prefix)/etc
 ETC_PERFCONFIG = etc/perfconfig
 endif
 lib = lib
+plugindir=$(perfexecdir)/traceevent/plugins
 
 # Shell quote (do not use $(call) to accommodate ancient setups);
 ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
@@ -476,3 +477,4 @@ else
 perfexec_instdir = $(prefix)/$(perfexecdir)
 endif
 perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
+plugindir_SQ= $(subst ','\'',$(prefix)/$(plugindir))
-- 
1.7.11.7

