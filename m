Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaJFAqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 20:46:32 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:41499 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaJFAqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 20:46:08 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 1/5] perf report: Set callchain_param.record_mode for future use
Date: Mon,  6 Oct 2014 09:45:59 +0900
Message-Id: <1412556363-26229-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412556363-26229-1-git-send-email-namhyung@kernel.org>
References: <1412556363-26229-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally the callchain_param.record_mode is used only for record path.
But as it might need to prepare something for dwarf unwinding, setup
this info for perf report too.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c     | 7 +++++++
 tools/perf/tests/dwarf-unwind.c | 3 +++
 tools/perf/util/callchain.h     | 2 ++
 tools/perf/util/hist.h          | 2 --
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ac145fae0521..f9a9ee7b2646 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -257,6 +257,13 @@ static int report__setup_sample_type(struct report *rep)
 		}
 	}
 
+	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain) {
+		if ((sample_type & PERF_SAMPLE_REGS_USER) &&
+		    (sample_type & PERF_SAMPLE_STACK_USER))
+			callchain_param.record_mode = CALLCHAIN_DWARF;
+		else
+			callchain_param.record_mode = CALLCHAIN_FP;
+	}
 	return 0;
 }
 
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index 96adb730b744..fc25e57f4a5d 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -9,6 +9,7 @@
 #include "perf_regs.h"
 #include "map.h"
 #include "thread.h"
+#include "callchain.h"
 
 static int mmap_handler(struct perf_tool *tool __maybe_unused,
 			union perf_event *event,
@@ -120,6 +121,8 @@ int test__dwarf_unwind(void)
 		return -1;
 	}
 
+	callchain_param.record_mode = CALLCHAIN_DWARF;
+
 	if (init_live_machine(machine)) {
 		pr_err("Could not init machine\n");
 		goto out;
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 2a1f5a46543a..94cfefddf4db 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -65,6 +65,8 @@ struct callchain_param {
 	enum chain_key		key;
 };
 
+extern struct callchain_param callchain_param;
+
 struct callchain_list {
 	u64			ip;
 	struct map_symbol	ms;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 8c9c70e18cbb..ac1ee82c6c7e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -8,8 +8,6 @@
 #include "color.h"
 #include "ui/progress.h"
 
-extern struct callchain_param callchain_param;
-
 struct hist_entry;
 struct addr_location;
 struct symbol;
-- 
2.1.0

