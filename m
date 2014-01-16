Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaAPNi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:38:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38305 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaAPNiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:38:54 -0500
Date: Thu, 16 Jan 2014 05:38:23 -0800
From: tip-bot for Mark Rutland <tipbot@zytor.com>
Message-ID: <tip-a8a5cd8b472ca20e5b8fa649c43b3756867322f8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, mingo@kernel.org, will.deacon@arm.com,
        mark.rutland@arm.com, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, will.deacon@arm.com,
        mark.rutland@arm.com, jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1389782648-4417-4-git-send-email-mark.rutland@arm.com>
References: <1389782648-4417-4-git-send-email-mark.rutland@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: tools: Fix cross building
Git-Commit-ID: a8a5cd8b472ca20e5b8fa649c43b3756867322f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:38:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8a5cd8b472ca20e5b8fa649c43b3756867322f8
Gitweb:     http://git.kernel.org/tip/a8a5cd8b472ca20e5b8fa649c43b3756867322f8
Author:     Mark Rutland <mark.rutland@arm.com>
AuthorDate: Wed, 15 Jan 2014 10:44:08 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Jan 2014 15:15:05 -0300

perf: tools: Fix cross building

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
index 87d7726..7257e7e 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -76,6 +76,7 @@ $(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
 
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
+PKG_CONFIG = $(CROSS_COMPILE)pkg-config
 
 RM      = rm -f
 LN      = ln -f
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 01dd43d..d604e50 100644
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
index 7cf6fcd..12e5513 100644
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
