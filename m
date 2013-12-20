Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3LTTKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38552 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3LTTJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/35] tools lib traceevent: Use global QUIET_INSTALL build output
Date: Fri, 20 Dec 2013 16:08:59 -0300
Message-Id: <1387566550-3524-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Using global QUIET_INSTALL build output variable and factoring plugins
installation so we could have only single install message for plugins:

  INSTALL trace_plugins

Getting rid of local print_install.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1387460527-15030-8-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 51be8ab76f9f..8ea4368381f0 100644
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
1.8.1.4

