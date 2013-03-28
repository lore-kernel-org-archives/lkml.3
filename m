Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab3C1RIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:08:17 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47753
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756900Ab3C1RCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 35/36] perf tools: Remove dependency on libnewt
Date: Thu, 28 Mar 2013 14:02:35 -0300
Message-Id: <1364490156-32064-36-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now that the map browser shares the input routine with the hists
browser, there is no need for using any libnewt routine, so remove all
traces except for honouring NO_NEWT=1 on the makefile command line as an
indication that TUI support is not needed, in fact it just sets
NO_SLANG=1.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-wae5o7xca9m52bj1re28jc5j@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |   20 +++++++++++++-------
 tools/perf/builtin-report.c         |    6 +++---
 tools/perf/config/feature-tests.mak |   12 +++++-------
 tools/perf/ui/browser.c             |    9 +++++++--
 tools/perf/ui/browser.h             |    1 +
 tools/perf/ui/browsers/annotate.c   |    1 -
 tools/perf/ui/browsers/hists.c      |    1 -
 tools/perf/ui/browsers/scripts.c    |    1 -
 tools/perf/ui/tui/setup.c           |   21 +++++++++++----------
 tools/perf/ui/ui.h                  |    2 +-
 tools/perf/util/annotate.h          |    2 +-
 tools/perf/util/hist.h              |    2 +-
 12 files changed, 43 insertions(+), 35 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8b4c952..b0f164b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -35,7 +35,9 @@ include config/utilities.mak
 #
 # Define WERROR=0 to disable treating any warnings as errors.
 #
-# Define NO_NEWT if you do not want TUI support.
+# Define NO_NEWT if you do not want TUI support. (deprecated)
+#
+# Define NO_SLANG if you do not want TUI support.
 #
 # Define NO_GTK2 if you do not want GTK+ GUI support.
 #
@@ -104,6 +106,10 @@ ifdef PARSER_DEBUG
 	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
 endif
 
+ifdef NO_NEWT
+	NO_SLANG=1
+endif
+
 CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
@@ -680,15 +686,15 @@ ifndef NO_LIBAUDIT
 	endif
 endif
 
-ifndef NO_NEWT
-	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
-	ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT),libnewt),y)
-		msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
+ifndef NO_SLANG
+	FLAGS_SLANG=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -I/usr/include/slang -lslang
+	ifneq ($(call try-cc,$(SOURCE_SLANG),$(FLAGS_SLANG),libslang),y)
+		msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
 	else
 		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
 		BASIC_CFLAGS += -I/usr/include/slang
-		BASIC_CFLAGS += -DNEWT_SUPPORT
-		EXTLIBS += -lnewt -lslang
+		BASIC_CFLAGS += -DSLANG_SUPPORT
+		EXTLIBS += -lslang
 		LIB_OBJS += $(OUTPUT)ui/browser.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a20550c..bd0ca81 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -111,7 +111,7 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 		return -ENOMEM;
 
 	/*
-	 * In the newt browser, we are doing integrated annotation,
+	 * In the TUI browser, we are doing integrated annotation,
 	 * so we don't allocate the extra space needed because the stdio
 	 * code will not use it.
 	 */
@@ -263,7 +263,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 			return err;
 	}
 	/*
-	 * Only in the newt browser we are doing integrated annotation,
+	 * Only in the TUI browser we are doing integrated annotation,
 	 * so we don't allocated the extra space needed because the stdio
 	 * code will not use it.
 	 */
@@ -877,7 +877,7 @@ repeat:
 		usage_with_options(report_usage, options);
 
 	/*
-	 * Only in the newt browser we are doing integrated annotation,
+	 * Only in the TUI browser we are doing integrated annotation,
 	 * so don't allocate extra space that won't be used in the stdio
 	 * implementation.
 	 */
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index b4eabb4..708fb8e 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -61,15 +61,13 @@ int main(void)
 }
 endef
 
-ifndef NO_NEWT
-define SOURCE_NEWT
-#include <newt.h>
+ifndef NO_SLANG
+define SOURCE_SLANG
+#include <slang.h>
 
 int main(void)
 {
-	newtInit();
-	newtCls();
-	return newtFinished();
+	return SLsmg_init_smg();
 }
 endef
 endif
@@ -235,4 +233,4 @@ int main(void)
 	numa_available();
 	return 0;
 }
-endef
\ No newline at end of file
+endef
diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 809ea46..bbc782e 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -2,7 +2,6 @@
 #include "../cache.h"
 #include "../../perf.h"
 #include "libslang.h"
-#include <newt.h>
 #include "ui.h"
 #include "util.h"
 #include <linux/compiler.h>
@@ -234,7 +233,7 @@ void ui_browser__reset_index(struct ui_browser *browser)
 void __ui_browser__show_title(struct ui_browser *browser, const char *title)
 {
 	SLsmg_gotorc(0, 0);
-	ui_browser__set_color(browser, NEWT_COLORSET_ROOT);
+	ui_browser__set_color(browser, HE_COLORSET_ROOT);
 	slsmg_write_nstring(title, browser->width + 1);
 }
 
@@ -514,6 +513,12 @@ static struct ui_browser_colorset {
 		.bg	  = "default",
 	},
 	{
+		.colorset = HE_COLORSET_ROOT,
+		.name	  = "root",
+		.fg	  = "white",
+		.bg	  = "blue",
+	},
+	{
 		.name = NULL,
 	}
 };
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index af70314..404ff66 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -11,6 +11,7 @@
 #define HE_COLORSET_SELECTED	53
 #define HE_COLORSET_CODE	54
 #define HE_COLORSET_ADDR	55
+#define HE_COLORSET_ROOT	56
 
 struct ui_browser {
 	u64	      index, top_idx;
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index f56247a..cc64d3f 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -10,7 +10,6 @@
 #include "../../util/symbol.h"
 #include "../../util/evsel.h"
 #include <pthread.h>
-#include <newt.h>
 
 struct browser_disasm_line {
 	struct rb_node	rb_node;
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index a5843fd..d88a2d0 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -2,7 +2,6 @@
 #include "../libslang.h"
 #include <stdlib.h>
 #include <string.h>
-#include <newt.h>
 #include <linux/rbtree.h>
 
 #include "../../util/evsel.h"
diff --git a/tools/perf/ui/browsers/scripts.c b/tools/perf/ui/browsers/scripts.c
index cbbd44b..12f009e 100644
--- a/tools/perf/ui/browsers/scripts.c
+++ b/tools/perf/ui/browsers/scripts.c
@@ -1,5 +1,4 @@
 #include <elf.h>
-#include <newt.h>
 #include <inttypes.h>
 #include <sys/ttydefaults.h>
 #include <string.h>
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index 81efa19..b940148 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -1,4 +1,3 @@
-#include <newt.h>
 #include <signal.h>
 #include <stdbool.h>
 
@@ -88,13 +87,6 @@ int ui__getch(int delay_secs)
 	return SLkp_getkey();
 }
 
-static void newt_suspend(void *d __maybe_unused)
-{
-	newtSuspend();
-	raise(SIGTSTP);
-	newtResume();
-}
-
 static void ui__signal(int sig)
 {
 	ui__exit(false);
@@ -106,7 +98,17 @@ int ui__init(void)
 {
 	int err;
 
-	newtInit();
+	SLutf8_enable(-1);
+	SLtt_get_terminfo();
+	SLtt_get_screen_size();
+
+	err = SLsmg_init_smg();
+	if (err < 0)
+		goto out;
+	err = SLang_init_tty(0, 0, 0);
+	if (err < 0)
+		goto out;
+
 	err = SLkp_init();
 	if (err < 0) {
 		pr_err("TUI initialization failed.\n");
@@ -115,7 +117,6 @@ int ui__init(void)
 
 	SLkp_define_keysym((char *)"^(kB)", SL_KEY_UNTAB);
 
-	newtSetSuspendCallback(newt_suspend, NULL);
 	ui_helpline__init();
 	ui_browser__init();
 	ui_progress__init();
diff --git a/tools/perf/ui/ui.h b/tools/perf/ui/ui.h
index d86359c..70cb0d4 100644
--- a/tools/perf/ui/ui.h
+++ b/tools/perf/ui/ui.h
@@ -12,7 +12,7 @@ extern int use_browser;
 void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 
-#ifdef NEWT_SUPPORT
+#ifdef SLANG_SUPPORT
 int ui__init(void);
 void ui__exit(bool wait_for_ok);
 #else
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 6f3c16f..af75515 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -150,7 +150,7 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map,
 			 struct perf_evsel *evsel, bool print_lines,
 			 bool full_paths, int min_pcnt, int max_lines);
 
-#ifdef NEWT_SUPPORT
+#ifdef SLANG_SUPPORT
 int symbol__tui_annotate(struct symbol *sym, struct map *map,
 			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index fd63134..14c2fe2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -192,7 +192,7 @@ struct hist_browser_timer {
 	int refresh;
 };
 
-#ifdef NEWT_SUPPORT
+#ifdef SLANG_SUPPORT
 #include "../ui/keysyms.h"
 int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 			     struct hist_browser_timer *hbt);
-- 
1.7.1

