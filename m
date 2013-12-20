Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3LTTJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:09:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38535 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3LTTJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:32 -0500
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
Subject: [PATCH 22/35] tools lib traceevent: Add global QUIET_CC_FPIC build output
Date: Fri, 20 Dec 2013 16:08:57 -0300
Message-Id: <1387566550-3524-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding global QUIET_CC_FPIC build output variable and getting rid of
local print_fpic_compile and print_plugin_obj_compile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1387460527-15030-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile  | 16 ++--------------
 tools/scripts/Makefile.include |  1 +
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index e852a8d54d84..24203cc14649 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -152,33 +152,21 @@ override CFLAGS += $(udis86-flags) -D_GNU_SOURCE
 
 ifeq ($(VERBOSE),1)
   Q =
-  print_fpic_compile =
   print_shared_lib_compile =
-  print_plugin_obj_compile =
   print_plugin_build =
   print_install =
 else
   Q = @
-  print_fpic_compile =		echo '  CC FPIC  '$(OBJ);
   print_shared_lib_compile =	echo '  BUILD    SHARED LIB '$(OBJ);
-  print_plugin_obj_compile =	echo '  CC FPIC  '$(OBJ);
   print_plugin_build =		echo '  BUILD    PLUGIN '$(OBJ);
   print_static_lib_build =	echo '  BUILD    STATIC LIB '$(OBJ);
   print_install =		echo '  INSTALL  '$1;
 endif
 
-do_fpic_compile =					\
-	($(print_fpic_compile)				\
-	$(CC) -c $(CFLAGS) $(EXT) -fPIC $< -o $@)
-
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
 	$(CC) --shared $^ -o $@)
 
-do_compile_plugin_obj =				\
-	($(print_plugin_obj_compile)		\
-	$(CC) -c $(CFLAGS) -fPIC -o $@ $<)
-
 do_plugin_build =				\
 	($(print_plugin_build)			\
 	$(CC) $(CFLAGS) -shared -nostartfiles -o $@ $<)
@@ -236,10 +224,10 @@ libtraceevent.a: $(PEVENT_LIB_OBJS)
 plugins: $(PLUGINS)
 
 $(PEVENT_LIB_OBJS): %.o: $(src)/%.c TRACEEVENT-CFLAGS
-	$(Q)$(do_fpic_compile)
+	$(QUIET_CC_FPIC)$(CC) -c $(CFLAGS) $(EXT) -fPIC $< -o $@
 
 $(PLUGIN_OBJS): %.o : $(src)/%.c
-	$(Q)$(do_compile_plugin_obj)
+	$(QUIET_CC_FPIC)$(CC) -c $(CFLAGS) -fPIC -o $@ $<
 
 $(PLUGINS): %.so: %.o
 	$(Q)$(do_plugin_build)
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index e4cfbedcaf11..8abbef164b4e 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -61,6 +61,7 @@ QUIET_SUBDIR1  =
 ifneq ($(findstring $(MAKEFLAGS),s),s)
   ifneq ($(V),1)
 	QUIET_CC       = @echo '  CC       '$@;
+	QUIET_CC_FPIC  = @echo '  CC FPIC  '$@;
 	QUIET_AR       = @echo '  AR       '$@;
 	QUIET_LINK     = @echo '  LINK     '$@;
 	QUIET_MKDIR    = @echo '  MKDIR    '$@;
-- 
1.8.1.4

