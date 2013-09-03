Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab3ICHPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:15:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3ICHPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:15:51 -0400
Date: Tue, 3 Sep 2013 00:15:26 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-d22d1a2a2c224b3b378d873589ced27add7ebde4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1377975053-3811-3-git-send-email-adrian.hunter@intel.com>
References: <1377975053-3811-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add support for PERF_COUNT_SW_DUMMY
Git-Commit-ID: d22d1a2a2c224b3b378d873589ced27add7ebde4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 03 Sep 2013 00:15:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d22d1a2a2c224b3b378d873589ced27add7ebde4
Gitweb:     http://git.kernel.org/tip/d22d1a2a2c224b3b378d873589ced27add7ebde4
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Sat, 31 Aug 2013 21:50:52 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Sep 2013 14:58:20 -0300

perf tools: Add support for PERF_COUNT_SW_DUMMY

Add support for the new dummy software event PERF_COUNT_SW_DUMMY.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377975053-3811-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c        | 1 +
 tools/perf/util/parse-events.c | 4 ++++
 tools/perf/util/parse-events.l | 1 +
 tools/perf/util/python.c       | 1 +
 4 files changed, 7 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e8745fb..3612183 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -323,6 +323,7 @@ const char *perf_evsel__sw_names[PERF_COUNT_SW_MAX] = {
 	"major-faults",
 	"alignment-faults",
 	"emulation-faults",
+	"dummy",
 };
 
 static const char *__perf_evsel__sw_name(u64 config)
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9cba923..b2dd077 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -108,6 +108,10 @@ static struct event_symbol event_symbols_sw[PERF_COUNT_SW_MAX] = {
 		.symbol = "emulation-faults",
 		.alias  = "",
 	},
+	[PERF_COUNT_SW_DUMMY] = {
+		.symbol = "dummy",
+		.alias  = "",
+	},
 };
 
 #define __PERF_EVENT_FIELD(config, name) \
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 0790452..91346b7 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -145,6 +145,7 @@ context-switches|cs				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW
 cpu-migrations|migrations			{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_MIGRATIONS); }
 alignment-faults				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_ALIGNMENT_FAULTS); }
 emulation-faults				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_EMULATION_FAULTS); }
+dummy						{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_DUMMY); }
 
 L1-dcache|l1-d|l1d|L1-data		|
 L1-icache|l1-i|l1i|L1-instruction	|
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 381f4fd..71b5412 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -987,6 +987,7 @@ static struct {
 	{ "COUNT_SW_PAGE_FAULTS_MAJ",  PERF_COUNT_SW_PAGE_FAULTS_MAJ },
 	{ "COUNT_SW_ALIGNMENT_FAULTS", PERF_COUNT_SW_ALIGNMENT_FAULTS },
 	{ "COUNT_SW_EMULATION_FAULTS", PERF_COUNT_SW_EMULATION_FAULTS },
+	{ "COUNT_SW_DUMMY",            PERF_COUNT_SW_DUMMY },
 
 	{ "SAMPLE_IP",	      PERF_SAMPLE_IP },
 	{ "SAMPLE_TID",	      PERF_SAMPLE_TID },
