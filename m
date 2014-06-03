Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965649AbaFCWPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:15:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53359 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965145AbaFCWIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:08:52 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 10/32] perf kbuild: update kbuild files according to last changes
Date: Wed,  4 Jun 2014 00:06:03 +0200
Message-Id: <1401833185-10347-11-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/perf/Kbuild             |  2 +-
 tools/perf/Makefile.kbuild    | 30 +++++++++++++-----------------
 tools/perf/ui/browsers/Kbuild |  1 +
 tools/perf/util/Kbuild        |  1 +
 4 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Kbuild b/tools/perf/Kbuild
index 80b9184..16cb804 100644
--- a/tools/perf/Kbuild
+++ b/tools/perf/Kbuild
@@ -26,6 +26,7 @@ obj-$(CONFIG_BUILTIN_MEM)           += builtin-mem.o
 obj-$(CONFIG_BUILTIN_TEST)          += tests/
 
 obj-y += ../../lib/rbtree.o
+obj-y += ../lib/symbol/kallsyms.o
 
 obj-y += util/
 obj-y += ui/
@@ -34,7 +35,6 @@ obj-y += arch/
 obj-$(CONFIG_LIBPERL)   += scripts/perl/Perf-Trace-Util/
 obj-$(CONFIG_LIBPYTHON) += scripts/python/Perf-Trace-Util/
 
-
 CFLAGS_rbtree.o += -Wno-unused-parameter
 
 CFLAGS_perf.o += -D"PERF_HTML_PATH=KBUILD_STR($(htmldir_SQ))"
diff --git a/tools/perf/Makefile.kbuild b/tools/perf/Makefile.kbuild
index e82615f..e56eb47 100644
--- a/tools/perf/Makefile.kbuild
+++ b/tools/perf/Makefile.kbuild
@@ -102,8 +102,9 @@ HOSTCC  = gcc
 FLEX    = flex
 BISON   = bison
 INSTALL = install
+PKG_CONFIG = pkg-config
 
-export AS LD CC CPP HOSTCC FLEX BISON
+export AS LD CC CPP HOSTCC FLEX BISON PKG_CONFIG
 
 # kbuild related config
 CONFIG_SHELL          := /bin/sh
@@ -126,14 +127,11 @@ CONFIG_DETECTED := $(obj-perf)/.config-detected
 export CONFIG_DETECTED
 
 # external .a libs
-LK_DIR          := $(srctree)/tools/lib/lk/
-TRACE_EVENT_DIR := $(srctree)/tools/lib/traceevent/
-
 LIBTRACEEVENT   := $(obj-kernel)/tools/lib/traceevent/libtraceevent.a
-LIBLK           := $(obj-kernel)/tools/lib/lk/liblk.a
-LIBS_A          := $(LIBTRACEEVENT) $(LIBLK)
+LIBAPIKFS       := $(obj-kernel)/tools/lib/api/libapikfs.a
+LIBS_A          := $(LIBTRACEEVENT) $(LIBAPIKFS)
 
-export TRACE_EVENT_DIR LK_DIR LIBTRACEEVENT LIBLK
+export LIBTRACEEVENT LIBAPIKFS
 
 all:
 
@@ -168,7 +166,7 @@ clean-dirs := $(addprefix _clean_, tools/perf/)
 $(clean-dirs):
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.clean obj=$(patsubst _clean_%,%,$@)
 
-clean: $(clean-dirs) $(LIBTRACEEVENT)-clean $(LIBLK)-clean
+clean: $(clean-dirs) $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean
 	$(Q)$(QUIET_CLEAN)
 	$(Q)rm -f $(obj-perf)/perf
 	$(Q)rm -f $(obj-perf)/common-cmds.h
@@ -275,15 +273,13 @@ $(LIBTRACEEVENT)-clean: FORCE
 	@mkdir -p $(obj-kernel)/tools/lib/traceevent
 	$(Q)$(MAKE) -sC $(srctree)/tools/lib/traceevent O=$(obj-kernel)/tools/lib/traceevent clean
 
-PHONY += $(TRACE_EVENT_DIR) $(TRACE_EVENT_DIR)-clean
-
-$(LIBLK): FORCE
-	@mkdir -p $(obj-kernel)/tools/lib/lk
-	$(Q)$(MAKE) -C $(srctree)/tools/lib/lk O=$(obj-kernel)/tools/lib/lk
+$(LIBAPIKFS): FORCE
+	@mkdir -p $(obj-kernel)/tools/lib/api
+	$(Q)$(MAKE) -C $(srctree)/tools/lib/api O=$(obj-kernel)/tools/lib/api
 
-$(LIBLK)-clean: FORCE
-	@mkdir -p $(obj-kernel)/tools/lib/lk
-	$(Q)$(MAKE) -sC $(srctree)/tools/lib/lk O=$(obj-kernel)/tools/lib/lk clean
+$(LIBAPIKFS)-clean: FORCE
+	@mkdir -p $(obj-kernel)/tools/lib/api
+	$(Q)$(MAKE) -sC $(srctree)/tools/lib/api O=$(obj-kernel)/tools/lib/api clean
 
 tools/perf/PERF-VERSION-FILE: FORCE
 	$(QUIET_GEN)$(SHELL_PATH) $(src-perf)/util/PERF-VERSION-GEN $(obj-perf)/
@@ -401,7 +397,7 @@ dummy := $(info DEBUG KCONFIG_TRISTATE      $(KCONFIG_TRISTATE))
 dummy := $(info DEBUG KCONFIG_AUTOHEADER    $(KCONFIG_AUTOHEADER))
 dummy := $(info DEBUG KCONFIG_AUTOCONFIG    $(KCONFIG_AUTOCONFIG))
 dummy := $(info DEBUG TRACE_EVENT_DIR       $(TRACE_EVENT_DIR))
-dummy := $(info DEBUG LK_DIR                $(LK_DIR))
+dummy := $(info DEBUG LIBAPIKFS             $(LIBAPIKFS))
 endif
 
 endif  # skip-makefile
diff --git a/tools/perf/ui/browsers/Kbuild b/tools/perf/ui/browsers/Kbuild
index 03938aa..3a5fd55 100644
--- a/tools/perf/ui/browsers/Kbuild
+++ b/tools/perf/ui/browsers/Kbuild
@@ -1,4 +1,5 @@
 obj-$(CONFIG_TUI) += annotate.o
+obj-$(CONFIG_TUI) += header.o
 obj-$(CONFIG_TUI) += hists.o
 obj-$(CONFIG_TUI) += map.o
 obj-$(CONFIG_TUI) += scripts.o
diff --git a/tools/perf/util/Kbuild b/tools/perf/util/Kbuild
index 6fb42a6..4d0b6da 100644
--- a/tools/perf/util/Kbuild
+++ b/tools/perf/util/Kbuild
@@ -69,6 +69,7 @@ obj-y += values.o
 obj-y += xyarray.o
 obj-y += vdso.o
 obj-y += wrapper.o
+obj-y += trace-event.o
 obj-y += trace-event-info.o
 obj-y += trace-event-parse.o
 obj-$(CONFIG_BUILTIN_SCRIPT) += trace-event-scripting.o
-- 
1.9.3

