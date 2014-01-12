Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaALShH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:37:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaALShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:37:03 -0500
Date: Sun, 12 Jan 2014 10:34:44 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-02a82c7bcd353b8cc4d4f8b3c872b527fbac7c31@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1387460527-15030-8-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-8-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Use global QUIET_INSTALL build output
Git-Commit-ID: 02a82c7bcd353b8cc4d4f8b3c872b527fbac7c31
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:34:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02a82c7bcd353b8cc4d4f8b3c872b527fbac7c31
Gitweb:     http://git.kernel.org/tip/02a82c7bcd353b8cc4d4f8b3c872b527fbac7c31
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 19 Dec 2013 14:42:05 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 16:18:11 -0300

tools lib traceevent: Use global QUIET_INSTALL build output

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
 
