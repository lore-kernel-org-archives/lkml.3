Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaJAOgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:36:41 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33411 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaJAOgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:36:38 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/11] perf stat: Fix AGGR_CORE segfault on multi-socket system
Date: Wed,  1 Oct 2014 15:36:22 +0100
Message-Id: <1412174192-7010-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
References: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

When printing the stats associated with a counter in AGGR_MODE mode, the
'cpu' argument represents an encoded socket and core_id, not a 'cpu'.
Using it as an index into the any of the *_stats[MAX_NR_CPUS] arrays
generates a SIGSEGV if the encoded socket id is non-zero.

Follow the AGGR_GLOBAL case and reset the cpu index to 0.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 tools/perf/builtin-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b22c62f80078..53bd6b729498 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -965,7 +965,7 @@ static void abs_printout(int id, int nr, struct perf_evsel *evsel, double avg)
 
 	aggr_printout(evsel, id, nr);
 
-	if (aggr_mode == AGGR_GLOBAL)
+	if (aggr_mode == AGGR_GLOBAL || aggr_mode == AGGR_CORE)
 		cpu = 0;
 
 	fprintf(output, fmt, avg, csv_sep);
-- 
1.9.3

