Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3LJJSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:18:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3LJJSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:18:16 -0500
Date: Tue, 10 Dec 2013 01:17:46 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-e0e96d03f004e8953a731053b61e275f276fff01@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1386076182-14484-4-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Add plugin build support
Git-Commit-ID: e0e96d03f004e8953a731053b61e275f276fff01
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:17:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0e96d03f004e8953a731053b61e275f276fff01
Gitweb:     http://git.kernel.org/tip/e0e96d03f004e8953a731053b61e275f276fff01
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 3 Dec 2013 14:09:17 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:17:16 -0300

tools lib traceevent: Add plugin build support

Backporting missing pieces of plugin building infrastructure:

  - Adding Makefile 'plugins' target to build all
    defined plugins

  - Adding Makefile 'install_plugins' target as 'install_lib'
    target dependency

  - Link plugin objects with shared object building

Backported from Steven Rostedt's trace-cmd repo (HEAD 0f2c2fb):
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

Plugins are by default installed into following locations:

  '$(HOME)/.traceevent/plugins'
     - If we are installing under $(HOME)

  '$(prefix)/lib/traceevent/plugins'
     - Otherwise

This path is propagated to the plugin object as a plugins search path.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386076182-14484-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 52 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 5 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 2ccb5bc..1526798 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -43,6 +43,30 @@ man_dir_SQ = '$(subst ','\'',$(man_dir))'
 export man_dir man_dir_SQ INSTALL
 export DESTDIR DESTDIR_SQ
 
+set_plugin_dir := 1
+
+# Set plugin_dir to preffered global plugin location
+# If we install under $HOME directory we go under
+# $(HOME)/.traceevent/plugins
+#
+# We dont set PLUGIN_DIR in case we install under $HOME
+# directory, because by default the code looks under:
+# $(HOME)/.traceevent/plugins by default.
+#
+ifeq ($(plugin_dir),)
+ifeq ($(prefix),$(HOME))
+override plugin_dir = $(HOME)/.traceevent/plugins
+set_plugin_dir := 0
+else
+override plugin_dir = $(prefix)/lib/traceevent/plugins
+endif
+endif
+
+ifeq ($(set_plugin_dir),1)
+PLUGIN_DIR = -DPLUGIN_DIR="$(DESTDIR)/$(plugin_dir)"
+PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
+endif
+
 # copy a bit from Linux kbuild
 
 ifeq ("$(origin V)", "command line")
@@ -96,6 +120,7 @@ export prefix bindir src obj
 # Shell quotes
 bindir_SQ = $(subst ','\'',$(bindir))
 bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
+plugin_dir_SQ = $(subst ','\'',$(plugin_dir))
 
 LIB_FILE = libtraceevent.a libtraceevent.so
 
@@ -138,8 +163,8 @@ else
   print_app_build =		echo '  BUILD    '$(OBJ);
   print_fpic_compile =		echo '  CC FPIC  '$(OBJ);
   print_shared_lib_compile =	echo '  BUILD    SHARED LIB '$(OBJ);
-  print_plugin_obj_compile =	echo '  BUILD    PLUGIN OBJ '$(OBJ);
-  print_plugin_build =		echo '  BUILD    PLUGIN     '$(OBJ);
+  print_plugin_obj_compile =	echo '  CC FPIC  '$(OBJ);
+  print_plugin_build =		echo '  BUILD    PLUGIN '$(OBJ);
   print_static_lib_build =	echo '  BUILD    STATIC LIB '$(OBJ);
   print_install =		echo '  INSTALL  '$1'	to	$(DESTDIR_SQ)$2';
 endif
@@ -187,9 +212,11 @@ PEVENT_LIB_OBJS += parse-filter.o
 PEVENT_LIB_OBJS += parse-utils.o
 PEVENT_LIB_OBJS += kbuffer-parse.o
 
-ALL_OBJS = $(PEVENT_LIB_OBJS)
+PLUGINS := $(PLUGIN_OBJS:.o=.so)
+
+ALL_OBJS = $(PEVENT_LIB_OBJS) $(PLUGIN_OBJS)
 
-CMD_TARGETS = $(LIB_FILE)
+CMD_TARGETS = $(LIB_FILE) $(PLUGINS)
 
 TARGETS = $(CMD_TARGETS)
 
@@ -204,9 +231,17 @@ libtraceevent.so: $(PEVENT_LIB_OBJS)
 libtraceevent.a: $(PEVENT_LIB_OBJS)
 	$(Q)$(do_build_static_lib)
 
+plugins: $(PLUGINS)
+
 $(PEVENT_LIB_OBJS): %.o: $(src)/%.c TRACEEVENT-CFLAGS
 	$(Q)$(do_fpic_compile)
 
+$(PLUGIN_OBJS): %.o : $(src)/%.c
+	$(Q)$(do_compile_plugin_obj)
+
+$(PLUGINS): %.so: %.o
+	$(Q)$(do_plugin_build)
+
 define make_version.h
 	(echo '/* This file is automatically generated. Do not modify. */';		\
 	echo \#define VERSION_CODE $(shell						\
@@ -294,9 +329,16 @@ define do_install
 	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
 endef
 
-install_lib: all_cmd
+install_lib: all_cmd install_plugins
 	$(Q)$(call do_install,$(LIB_FILE),$(bindir_SQ))
 
+PLUGINS_INSTALL = $(subst .so,.install,$(PLUGINS))
+
+$(PLUGINS_INSTALL): %.install : %.so force
+	$(Q)$(call do_install,$<,$(plugin_dir_SQ))
+
+install_plugins: $(PLUGINS_INSTALL)
+
 install: install_lib
 
 clean:
