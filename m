Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaJPFYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:24:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaJPFYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:24:06 -0400
Date: Wed, 15 Oct 2014 22:23:39 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-0cdccac6fe4b1316f04f0dbfcc4efab51932014a@git.kernel.org>
Cc: tglx@linutronix.de, acme@redhat.com, hpa@zytor.com, paulus@samba.org,
        jolsa@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        jean.pihet@linaro.org, jolsa@kernel.org, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, namhyung@kernel.org, mingo@kernel.org,
        namhyung.kim@lge.com
Reply-To: jean.pihet@linaro.org, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
        mingo@kernel.org, dsahern@gmail.com, namhyung@kernel.org,
        namhyung.kim@lge.com, jolsa@kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jolsa@redhat.com, acme@redhat.com, hpa@zytor.com,
        paulus@samba.org
In-Reply-To: <1412556363-26229-2-git-send-email-namhyung@kernel.org>
References: <1412556363-26229-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf report:
  Set callchain_param.record_mode for future use
Git-Commit-ID: 0cdccac6fe4b1316f04f0dbfcc4efab51932014a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0cdccac6fe4b1316f04f0dbfcc4efab51932014a
Gitweb:     http://git.kernel.org/tip/0cdccac6fe4b1316f04f0dbfcc4efab51932014a
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 6 Oct 2014 09:45:59 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Oct 2014 16:20:03 -0300

perf report: Set callchain_param.record_mode for future use

Normally the callchain_param.record_mode is used only for record path.
But as it might need to prepare something for dwarf unwinding, setup
this info for perf report too.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1412556363-26229-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c     | 7 +++++++
 tools/perf/tests/dwarf-unwind.c | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2cfc4b93..140a6cd 100644
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
index 96adb73..fc25e57 100644
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
