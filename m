Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaAOUgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:36:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48500 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaAOUdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:33:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/13] perf: tools: Fix cross building
Date: Wed, 15 Jan 2014 17:33:07 -0300
Message-Id: <1389817991-8145-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389817991-8145-1-git-send-email-acme@infradead.org>
References: <1389817991-8145-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

Currently the feature-checks Makefile does not inherit $(CC), and calls
cc rather than $(CROSS_COMPILE)gcc. Thus the feature checks invoke the
native toolchain rather than the cross toolchain, and can identify
features as available when they are not. This can break the build.

Additionally the native pkg-config is always called as opposed to
$(CROSS_COMPILE)pkg-config, so the wrong flags and paths may be passed
to the cross compiler.

This patch passes CROSS_COMPILE down to the feature-checks Makefile, and
forces its use. Additionally pkg-config is replaced with
$(CROSS_COMPILE)pkg-config via a new $(PKG_CONFIG) variable. This patch
has been build tested on x86_64 and arm.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Link: http://lkml.kernel.org/r/1389782648-4417-4-git-send-email-mark.rutland@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf                  | 1 +
 tools/perf/config/Makefile                | 6 +++---
 tools/perf/config/feature-checks/Makefile | 9 +++++----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 87d7726cee2d..7257e7e9e38a 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -76,6 +76,7 @@ $(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
 
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
+PKG_CONFIG = $(CROSS_COMPILE)pkg-config
 
 RM      = rm -f
 LN      = ln -f
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 01dd43df0d04..d604e50fc167 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -372,7 +372,7 @@ ifndef NO_SLANG
 endif
 
 ifndef NO_GTK2
-  FLAGS_GTK2=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+  FLAGS_GTK2=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null)
   ifneq ($(feature-gtk2), 1)
     msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
     NO_GTK2 := 1
@@ -381,8 +381,8 @@ ifndef NO_GTK2
       GTK_CFLAGS := -DHAVE_GTK_INFO_BAR_SUPPORT
     endif
     CFLAGS += -DHAVE_GTK2_SUPPORT
-    GTK_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
-    GTK_LIBS := $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
+    GTK_CFLAGS += $(shell $(PKG_CONFIG) --cflags gtk+-2.0 2>/dev/null)
+    GTK_LIBS := $(shell $(PKG_CONFIG) --libs gtk+-2.0 2>/dev/null)
     EXTLIBS += -ldl
   endif
 endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 7cf6fcdacebe..12e551346fa6 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -28,7 +28,8 @@ FILES=					\
 	test-stackprotector-all.bin	\
 	test-timerfd.bin
 
-CC := $(CC) -MD
+CC := $(CROSS_COMPILE)gcc -MD
+PKG_CONFIG := $(CROSS_COMPILE)pkg-config
 
 all: $(FILES)
 
@@ -37,7 +38,7 @@ BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $(patsubst %.bin,%.c,$@) $(LDFLAGS)
 ###############################
 
 test-all.bin:
-	$(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
+	$(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
 
 test-hello.bin:
 	$(BUILD)
@@ -82,10 +83,10 @@ test-libslang.bin:
 	$(BUILD) -I/usr/include/slang -lslang
 
 test-gtk2.bin:
-	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+	$(BUILD) $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null)
 
 test-gtk2-infobar.bin:
-	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+	$(BUILD) $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null)
 
 grep-libs  = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
-- 
1.8.1.4

