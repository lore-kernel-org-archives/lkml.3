Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965618AbaFCWOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:14:40 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55311 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192AbaFCWI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:08:57 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 15/32] perf kbuild: remove legacy timerfd-related build variable
Date: Wed,  4 Jun 2014 00:06:08 +0200
Message-Id: <1401833185-10347-16-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove HAVE_TIMERFD_SUPPORT (replaced by CONFIG_TIMERFD)
---
 tools/perf/Kconfig         |  8 +++++++-
 tools/perf/builtin-kvm.c   | 13 +++++++------
 tools/perf/config/Makefile | 10 ++++++----
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 5ca0527..9b75649 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -151,7 +151,7 @@ config BUILTIN_TEST
 
 endmenu
 
-menu "Libraries"
+menu "Libraries / Dependencies"
 
 config LIBSLANG
 	bool "Slang (libslang)"
@@ -190,6 +190,12 @@ config LIBPYTHON
         ---help---
 	  Libpython dependency needed by the perf script feature.
 
+config TIMERFD
+	bool "Timer via file descriptor"
+	default n
+        ---help---
+	  Timer via file descriptor
+
 choice
 	prompt "Elf library"
 	default LIBELF
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 0f1e5a2..d035253 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1,3 +1,4 @@
+#include "generated/autoconf.h"
 #include "builtin.h"
 #include "perf.h"
 
@@ -20,7 +21,7 @@
 #include "util/data.h"
 
 #include <sys/prctl.h>
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 #include <sys/timerfd.h>
 #endif
 
@@ -339,7 +340,7 @@ static void init_kvm_event_record(struct perf_kvm_stat *kvm)
 		INIT_LIST_HEAD(&kvm->kvm_events_cache[i]);
 }
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 static void clear_events_cache_stats(struct list_head *kvm_events_cache)
 {
 	struct list_head *head;
@@ -788,7 +789,7 @@ static void print_result(struct perf_kvm_stat *kvm)
 		pr_info("\nLost events: %" PRIu64 "\n\n", kvm->lost_events);
 }
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 static int process_lost_event(struct perf_tool *tool,
 			      union perf_event *event __maybe_unused,
 			      struct perf_sample *sample __maybe_unused,
@@ -879,7 +880,7 @@ static bool verify_vcpu(int vcpu)
 	return true;
 }
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 /* keeping the max events to a modest level to keep
  * the processing of samples per mmap smooth.
  */
@@ -1386,7 +1387,7 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 	return kvm_events_report_vcpu(kvm);
 }
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 static struct perf_evlist *kvm_live_event_list(void)
 {
 	struct perf_evlist *evlist;
@@ -1601,7 +1602,7 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 	if (!strncmp(argv[1], "rep", 3))
 		return kvm_events_report(&kvm, argc - 1 , argv + 1);
 
-#ifdef HAVE_TIMERFD_SUPPORT
+#ifdef CONFIG_TIMERFD
 	if (!strncmp(argv[1], "live", 4))
 		return kvm_events_live(&kvm, argc - 1 , argv + 1);
 #endif
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 93c3321..33843b7 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -445,10 +445,12 @@ ifdef CONFIG_LIBPERL
   endif
 endif
 
-ifeq ($(feature-timerfd), 1)
-  CFLAGS += -DHAVE_TIMERFD_SUPPORT
-else
-  msg := $(warning No timerfd support. Disables 'perf kvm stat live');
+ifdef CONFIG_TIMERFD
+  ifneq ($(feature-timerfd), 1)
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_TIMERFD)
+  else
+    msg := $(warning No timerfd support. Disables 'perf kvm stat live');
+  endif
 endif
 
 disable-python = $(eval $(disable-python_code))
-- 
1.9.3

