Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaFMGZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:25:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaFMGZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:25:24 -0400
Date: Thu, 12 Jun 2014 23:24:50 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0c4e774fad0202b91dea8d99c04e9bdf2c2c6647@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1401892622-30848-2-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Cache register accesses for unwind processing
Git-Commit-ID: 0c4e774fad0202b91dea8d99c04e9bdf2c2c6647
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

Commit-ID:  0c4e774fad0202b91dea8d99c04e9bdf2c2c6647
Gitweb:     http://git.kernel.org/tip/0c4e774fad0202b91dea8d99c04e9bdf2c2c6647
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 17 Apr 2014 19:39:10 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 12 Jun 2014 16:53:19 +0200

perf tools: Cache register accesses for unwind processing

Caching registers value into an array. Got about 4% speed up
of perf_reg_value function for report command processing
dwarf unwind stacks.

Output from report over 1.5 GB data with DWARF unwind stacks:
(TODO fix perf diff)

  current code:
   5.84%     perf  perf                       [.] perf_reg_value
  change:
   1.94%     perf  perf                       [.] perf_reg_value

And little bit of overall speed up:
(perf stat -r 5 -e '{cycles,instructions}:u' ...)

  current code:
   310,298,611,754      cycles                     ( +-  0.33% )
   439,669,689,341      instructions               ( +-  0.03% )

     188.656753166 seconds time elapsed            ( +-  0.82% )

  change:
   291,315,329,878      cycles                     ( +-  0.22% )
   391,763,485,304      instructions               ( +-  0.03%  )

     180.742249687 seconds time elapsed            ( +-  0.64% )

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401892622-30848-2-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/event.h     |  5 +++++
 tools/perf/util/perf_regs.c | 10 +++++++++-
 tools/perf/util/perf_regs.h |  4 +++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 9ba2eb3..e5dd40a 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -7,6 +7,7 @@
 #include "../perf.h"
 #include "map.h"
 #include "build-id.h"
+#include "perf_regs.h"
 
 struct mmap_event {
 	struct perf_event_header header;
@@ -89,6 +90,10 @@ struct regs_dump {
 	u64 abi;
 	u64 mask;
 	u64 *regs;
+
+	/* Cached values/mask filled by first register access. */
+	u64 cache_regs[PERF_REGS_MAX];
+	u64 cache_mask;
 };
 
 struct stack_dump {
diff --git a/tools/perf/util/perf_regs.c b/tools/perf/util/perf_regs.c
index a3539ef..43168fb 100644
--- a/tools/perf/util/perf_regs.c
+++ b/tools/perf/util/perf_regs.c
@@ -1,11 +1,15 @@
 #include <errno.h>
 #include "perf_regs.h"
+#include "event.h"
 
 int perf_reg_value(u64 *valp, struct regs_dump *regs, int id)
 {
 	int i, idx = 0;
 	u64 mask = regs->mask;
 
+	if (regs->cache_mask & (1 << id))
+		goto out;
+
 	if (!(mask & (1 << id)))
 		return -EINVAL;
 
@@ -14,6 +18,10 @@ int perf_reg_value(u64 *valp, struct regs_dump *regs, int id)
 			idx++;
 	}
 
-	*valp = regs->regs[idx];
+	regs->cache_mask |= (1 << id);
+	regs->cache_regs[id] = regs->regs[idx];
+
+out:
+	*valp = regs->cache_regs[id];
 	return 0;
 }
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index 79c78f7..980dbf7 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -2,7 +2,8 @@
 #define __PERF_REGS_H
 
 #include <linux/types.h>
-#include "event.h"
+
+struct regs_dump;
 
 #ifdef HAVE_PERF_REGS_SUPPORT
 #include <perf_regs.h>
@@ -11,6 +12,7 @@ int perf_reg_value(u64 *valp, struct regs_dump *regs, int id);
 
 #else
 #define PERF_REGS_MASK	0
+#define PERF_REGS_MAX	0
 
 static inline const char *perf_reg_name(int id __maybe_unused)
 {
