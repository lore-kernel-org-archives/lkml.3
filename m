Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaAMUtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:49:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40477 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaAMUsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 37/38] perf probe: Fix build when DWARF support libraries not present
Date: Mon, 13 Jan 2014 17:47:38 -0300
Message-Id: <1389646059-24881-38-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

On a freshly installed system, after libelf-dev is installed we get:

    CC       /tmp/build/perf/util/probe-event.o
  util/probe-event.c: In function ‘try_to_find_probe_trace_events’:
  util/probe-event.c:753:46: error: unused parameter ‘target’ [-Werror=unused-parameter]
       int max_tevs __maybe_unused, const char *target)
                                                ^
    CC       /tmp/build/perf/util/cgroup.o
  util/probe-event.c: At top level:
  util/probe-event.c:193:12: error: ‘get_text_start_address’ defined but not used [-Werror=unused-function]
   static int get_text_start_address(const char *exec, unsigned long *address)
            ^
  cc1: all warnings being treated as errors
  make[1]: *** [/tmp/build/perf/util/probe-event.o] Error 1
  make[1]: *** Waiting for unfinished jobs....
  make: *** [install] Error 2

Fix it by enclosing functions only used when those libraries are installed
under the suitable preprocessor define and using __maybe_unused to a function
that is only built when DWARF support is disabled.

Problem introduced in this changeset:

  commit fb7345bbf7fad9bf72ef63a19c707970b9685812
  Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
  Date:   Thu Dec 26 05:41:53 2013 +0000

      perf probe: Support basic dwarf-based operations on uprobe events

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-73kc2fopt81517hrdgdra18o@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 86ed8580c3cb..a4ee6b4a840f 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -172,6 +172,7 @@ const char *kernel_get_module_path(const char *module)
 	return (dso) ? dso->long_name : NULL;
 }
 
+#ifdef HAVE_DWARF_SUPPORT
 /* Copied from unwind.c */
 static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 				    GElf_Shdr *shp, const char *name)
@@ -217,6 +218,7 @@ out:
 	elf_end(elf);
 	return ret;
 }
+#endif
 
 static int init_user_exec(void)
 {
@@ -750,7 +752,8 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 				struct probe_trace_event **tevs __maybe_unused,
-				int max_tevs __maybe_unused, const char *target)
+				int max_tevs __maybe_unused,
+				const char *target __maybe_unused)
 {
 	if (perf_probe_event_need_dwarf(pev)) {
 		pr_warning("Debuginfo-analysis is not supported.\n");
-- 
1.8.1.4

