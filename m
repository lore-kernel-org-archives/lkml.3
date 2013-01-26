Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3AZR2q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 12:28:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab3AZR2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 12:28:21 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/9] perf tools: Add a precise event qualifier
Date: Sat, 26 Jan 2013 18:27:50 +0100
Message-Id: <1359221275-24254-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
References: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a precise qualifier, like cpu/event=0x3c,precise=1/

This is needed so that the kernel can request enabling PEBS
for TSX events. The parser bails out on any sysfs parse errors,
so this is needed in any case to handle any event on the TSX
perf kernel.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
[ nit: changed subject line a bit]
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c | 6 ++++++
 tools/perf/util/parse-events.h | 1 +
 tools/perf/util/parse-events.l | 1 +
 3 files changed, 8 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 02f6421..217ce56 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -568,6 +568,12 @@ do {								\
 	case PARSE_EVENTS__TERM_TYPE_NAME:
 		CHECK_TYPE_VAL(STR);
 		break;
+	case PARSE_EVENTS__TERM_TYPE_PRECISE:
+		CHECK_TYPE_VAL(NUM);
+		if ((unsigned)term->val.num > 2)
+			return -EINVAL;
+		attr->precise_ip = term->val.num;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 2cd2c42..9d526cf 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -48,6 +48,7 @@ enum {
 	PARSE_EVENTS__TERM_TYPE_NAME,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
 	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
+	PARSE_EVENTS__TERM_TYPE_PRECISE,
 };
 
 struct parse_events_term {
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index e9d1134..32a9000 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -169,6 +169,7 @@ period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 ,			{ return ','; }
 "/"			{ BEGIN(INITIAL); return '/'; }
+precise			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_PRECISE); }
 {name_minus}		{ return str(yyscanner, PE_NAME); }
 }
 
-- 
1.7.11.7

