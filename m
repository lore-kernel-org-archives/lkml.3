Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaKGN6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:58:17 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43530 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaKGN6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:58:10 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        srikar@linux.vnet.ibm.com, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, systemtap@sourceware.org,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi, brendan.d.gregg@gmail.com,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2] perf tools: Add record.use-buildid-cache config option
Date: Fri,  7 Nov 2014 22:57:57 +0900
Message-Id: <1415368677-3794-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1415368677-3794-1-git-send-email-namhyung@kernel.org>
References: <20141107084211.GC23531@worktop.programming.kicks-ass.net>
 <1415368677-3794-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new config option for auto-disable buildid-cache.

  $ cat ~/.perfconfig
  [record]
  use-buildid-cache = false

  $ rm -rf ~/.debug
  $ perf record -av sleep 1
  mmap size 528384B
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.439 MB perf.data (~19182 samples) ]
  Looking at the vmlinux_path (7 entries long)
  Using /proc/kallsyms for symbols

  $ tree ~/.debug
  /home/namhyung/.debug [error opening dir]

  0 directories, 0 files

Requested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 582c4da155ea..19083e715698 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -685,6 +685,12 @@ int record_callchain_opt(const struct option *opt __maybe_unused,
 
 static int perf_record_config(const char *var, const char *value, void *cb)
 {
+	struct record *rec = cb;
+
+	if (!strcmp(var, "record.use-buildid-cache")) {
+		rec->no_buildid_cache = !perf_config_bool(var, value);
+		return 0;
+	}
 	if (!strcmp(var, "record.call-graph"))
 		var = "call-graph.record-mode"; /* fall-through */
 
-- 
2.0.0

