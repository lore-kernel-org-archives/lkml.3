Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab3EXMi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:38:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680Ab3EXMh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:37:26 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>, Sam Ravnborg <sam@ravnborg.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 16/25] perf tools: Move paths config into config/Makefile
Date: Fri, 24 May 2013 14:35:19 +0200
Message-Id: <1369398928-9809-17-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving paths config into config/Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile        | 58 ----------------------------------------------
 tools/perf/config/Makefile | 52 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 11525ac..240bf88 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -99,39 +99,6 @@ ifeq ($(config),1)
 include config/Makefile
 endif
 
-# Among the variables below, these:
-#   perfexecdir
-#   template_dir
-#   mandir
-#   infodir
-#   htmldir
-#   ETC_PERFCONFIG (but not sysconfdir)
-# can be specified as a relative path some/where/else;
-# this is interpreted as relative to $(prefix) and "perf" at
-# runtime figures out where they are based on the path to the executable.
-# This can help installing the suite in a relocatable way.
-
-# Make the path relative to DESTDIR, not to prefix
-ifndef DESTDIR
-prefix = $(HOME)
-endif
-bindir_relative = bin
-bindir = $(prefix)/$(bindir_relative)
-mandir = share/man
-infodir = share/info
-perfexecdir = libexec/perf-core
-sharedir = $(prefix)/share
-template_dir = share/perf-core/templates
-htmldir = share/doc/perf-doc
-ifeq ($(prefix),/usr)
-sysconfdir = /etc
-ETC_PERFCONFIG = $(sysconfdir)/perfconfig
-else
-sysconfdir = $(prefix)/etc
-ETC_PERFCONFIG = etc/perfconfig
-endif
-lib = lib
-
 export prefix bindir sharedir sysconfdir
 
 # sparse is architecture-neutral, which means that we need to tell it
@@ -555,23 +522,6 @@ endif
 endif # MAKECMDGOALS != tags
 endif # MAKECMDGOALS != clean
 
-# Shell quote (do not use $(call) to accommodate ancient setups);
-
-ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
-
-DESTDIR_SQ = $(subst ','\'',$(DESTDIR))
-bindir_SQ = $(subst ','\'',$(bindir))
-bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
-mandir_SQ = $(subst ','\'',$(mandir))
-infodir_SQ = $(subst ','\'',$(infodir))
-perfexecdir_SQ = $(subst ','\'',$(perfexecdir))
-template_dir_SQ = $(subst ','\'',$(template_dir))
-htmldir_SQ = $(subst ','\'',$(htmldir))
-prefix_SQ = $(subst ','\'',$(prefix))
-sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
-
-SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
-
 LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
 ALL_CFLAGS += $(BASIC_CFLAGS)
@@ -580,7 +530,6 @@ ALL_LDFLAGS += $(BASIC_LDFLAGS)
 
 export INSTALL SHELL_PATH
 
-
 ### Build rules
 
 SHELL = $(SHELL_PATH)
@@ -822,13 +771,6 @@ check: $(OUTPUT)common-cmds.h
 
 ### Installation rules
 
-ifneq ($(filter /%,$(firstword $(perfexecdir))),)
-perfexec_instdir = $(perfexecdir)
-else
-perfexec_instdir = $(prefix)/$(perfexecdir)
-endif
-perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
-
 install-bin: all
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index b559693..a0dbc24 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -390,3 +390,55 @@ ifndef NO_LIBNUMA
 		EXTLIBS += -lnuma
 	endif
 endif
+
+# Among the variables below, these:
+#   perfexecdir
+#   template_dir
+#   mandir
+#   infodir
+#   htmldir
+#   ETC_PERFCONFIG (but not sysconfdir)
+# can be specified as a relative path some/where/else;
+# this is interpreted as relative to $(prefix) and "perf" at
+# runtime figures out where they are based on the path to the executable.
+# This can help installing the suite in a relocatable way.
+
+# Make the path relative to DESTDIR, not to prefix
+ifndef DESTDIR
+prefix = $(HOME)
+endif
+bindir_relative = bin
+bindir = $(prefix)/$(bindir_relative)
+mandir = share/man
+infodir = share/info
+perfexecdir = libexec/perf-core
+sharedir = $(prefix)/share
+template_dir = share/perf-core/templates
+htmldir = share/doc/perf-doc
+ifeq ($(prefix),/usr)
+sysconfdir = /etc
+ETC_PERFCONFIG = $(sysconfdir)/perfconfig
+else
+sysconfdir = $(prefix)/etc
+ETC_PERFCONFIG = etc/perfconfig
+endif
+lib = lib
+
+# Shell quote (do not use $(call) to accommodate ancient setups);
+ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
+DESTDIR_SQ = $(subst ','\'',$(DESTDIR))
+bindir_SQ = $(subst ','\'',$(bindir))
+mandir_SQ = $(subst ','\'',$(mandir))
+infodir_SQ = $(subst ','\'',$(infodir))
+perfexecdir_SQ = $(subst ','\'',$(perfexecdir))
+template_dir_SQ = $(subst ','\'',$(template_dir))
+htmldir_SQ = $(subst ','\'',$(htmldir))
+prefix_SQ = $(subst ','\'',$(prefix))
+sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
+
+ifneq ($(filter /%,$(firstword $(perfexecdir))),)
+perfexec_instdir = $(perfexecdir)
+else
+perfexec_instdir = $(prefix)/$(perfexecdir)
+endif
+perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
-- 
1.7.11.7

