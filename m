Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3LCNK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:10:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab3LCNKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:10:16 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 03/28] tools lib traceevent: Add plugin build support
Date: Tue,  3 Dec 2013 14:09:17 +0100
Message-Id: <1386076182-14484-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backporting missing pieces of plugin building infrastructure:
  - adding Makefile 'plugins' target to build all
    defined plugins
  - adding Makefile 'install_plugins' target as 'install_lib'
    target dependency
  - link plugin objects with shared object building

Backported from Steven Rostedt's trace-cmd repo (HEAD 0f2c2fb):
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

Plugins are by default installed into following locations:
  '$(HOME)/.traceevent/plugins'
     - if we are installing under $(HOME)
  '$(prefix)/lib/traceevent/plugins'
     - otherwise

This path is propagated to the plugin object as
a plugins search path.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
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
-- 
1.8.3.1

