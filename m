Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3HaIRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:17:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59688 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab3HaIPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:15:03 -0400
Date: Sat, 31 Aug 2013 01:14:24 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-5b95a4a3b52a1de84022dfaf580df4b5251f4a15@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1377591794-30553-9-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-9-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add missing 'abi' member to '
 struct regs_dump'
Git-Commit-ID: 5b95a4a3b52a1de84022dfaf580df4b5251f4a15
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 31 Aug 2013 01:14:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b95a4a3b52a1de84022dfaf580df4b5251f4a15
Gitweb:     http://git.kernel.org/tip/5b95a4a3b52a1de84022dfaf580df4b5251f4a15
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 27 Aug 2013 11:23:10 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Aug 2013 16:10:58 -0300

perf tools: Add missing 'abi' member to 'struct regs_dump'

And store the parsed value there.  Note that the 'abi' is 0 (no
registers), 1 (32-bit registers) or 2 (64-bit registers), but the
registers are anyway copied one-by-one as 64-bit values onto the event
i.e. see 'perf_output_sample_regs()'

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377591794-30553-9-git-send-email-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h | 1 +
 tools/perf/util/evsel.c | 7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 4913339..f959801 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -62,6 +62,7 @@ struct sample_event {
 };
 
 struct regs_dump {
+	u64 abi;
 	u64 *regs;
 };
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index db4e431..1184188 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1416,13 +1416,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	}
 
 	if (type & PERF_SAMPLE_REGS_USER) {
-		u64 avail;
-
 		/* First u64 tells us if we have any regs in sample. */
 		OVERFLOW_CHECK_u64(array);
-		avail = *array++;
+		data->user_regs.abi = *array;
+		array++;
 
-		if (avail) {
+		if (data->user_regs.abi) {
 			u64 regs_user = evsel->attr.sample_regs_user;
 
 			sz = hweight_long(regs_user) * sizeof(u64);
