Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439Ab3DBDy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:54:59 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:53172 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760419Ab3DBDy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:54:56 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/23] perf: make gtk2 support based on CONFIG_GTK2
Date: Mon,  1 Apr 2013 21:54:18 -0600
Message-Id: <1364874877-5618-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile                 |   39 ++++++++++++++++-------------------
 tools/perf/Pconfig                  |    3 +++
 tools/perf/config/feature-tests.mak |    2 +-
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2225c3d..01e2abf 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -36,8 +36,6 @@ include config/utilities.mak
 #
 # Define NO_NEWT if you do not want TUI support.
 #
-# Define NO_GTK2 if you do not want GTK+ GUI support.
-#
 # Define NO_DEMANGLE if you do not want C++ symbol demangling.
 #
 # Define NO_LIBELF if you do not want libelf dependency (e.g. cross-builds)
@@ -693,25 +691,24 @@ ifndef NO_NEWT
 	endif
 endif
 
-ifndef NO_GTK2
-	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
-	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
-		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
-	else
-		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
-			BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
-		endif
-		BASIC_CFLAGS += -DGTK2_SUPPORT
-		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
-		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
-		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/hists.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
-	endif
+ifdef CONFIG_GTK2
+    FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+    ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
+        $(error GTK2 not found. Please install gtk2-devel or libgtk2.0-dev or unset CONFIG_GTK2)
+    endif
+    ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
+        BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
+    endif
+    BASIC_CFLAGS += -DGTK2_SUPPORT
+    BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
+    EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
+    LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
+    LIB_OBJS += $(OUTPUT)ui/gtk/hists.o
+    LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
+    LIB_OBJS += $(OUTPUT)ui/gtk/util.o
+    LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
+    LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
+    LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
 endif
 
 ifdef CONFIG_LIBPERL
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
index 67ae110..79e1fc3 100644
--- a/tools/perf/Pconfig
+++ b/tools/perf/Pconfig
@@ -1,3 +1,6 @@
+config GTK2
+    bool "Enable GTK-based UI"
+
 config LIBPERL
     bool "Enable support for perl scripting engine"
 
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 2a2fa3b..bf906e8 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -74,7 +74,7 @@ int main(void)
 endef
 endif
 
-ifndef NO_GTK2
+ifdef CONFIG_GTK2
 define SOURCE_GTK2
 #pragma GCC diagnostic ignored \"-Wstrict-prototypes\"
 #include <gtk/gtk.h>
-- 
1.7.10.1

