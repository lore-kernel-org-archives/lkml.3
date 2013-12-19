Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3LSNmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:42:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784Ab3LSNmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:42:39 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 7/9] tools lib traceevent: Use global QUIET_INSTALL build output
Date: Thu, 19 Dec 2013 14:42:05 +0100
Message-Id: <1387460527-15030-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using global QUIET_INSTALL build output variable and
factoring plugins installation so we could have only
single install message for plugins:
  INSTALL trace_plugins

Getting rid of local print_install.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/Makefile | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 51be8ab..8ea4368 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -152,10 +152,8 @@ override CFLAGS += $(udis86-flags) -D_GNU_SOURCE
 
 ifeq ($(VERBOSE),1)
   Q =
-  print_install =
 else
   Q = @
-  print_install =		echo '  INSTALL  '$1;
 endif
 
 do_compile_shared_library =			\
@@ -307,22 +305,25 @@ TAGS:	force
 	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'
 
 define do_install
-	$(print_install)				\
 	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
 	fi;						\
 	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
 endef
 
-install_lib: all_cmd install_plugins
-	$(Q)$(call do_install,$(LIB_FILE),$(bindir_SQ))
-
-PLUGINS_INSTALL = $(subst .so,.install,$(PLUGINS))
+define do_install_plugins
+	for plugin in $1; do				\
+	  $(call do_install,$$plugin,$(plugin_dir_SQ));	\
+	done
+endef
 
-$(PLUGINS_INSTALL): %.install : %.so force
-	$(Q)$(call do_install,$<,$(plugin_dir_SQ))
+install_lib: all_cmd install_plugins
+	$(call QUIET_INSTALL, $(LIB_FILE)) \
+		$(call do_install,$(LIB_FILE),$(bindir_SQ))
 
-install_plugins: $(PLUGINS_INSTALL)
+install_plugins: $(PLUGINS)
+	$(call QUIET_INSTALL, trace_plugins) \
+		$(call do_install_plugins, $(PLUGINS))
 
 install: install_lib
 
-- 
1.8.3.1

