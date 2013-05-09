Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3EINdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:33:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab3EINc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:32:57 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/9] perf tools: Add a precise event qualifier
Date: Thu,  9 May 2013 15:32:19 +0200
Message-Id: <1368106344-23383-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
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
Cc: Stephane Eranian <eranian@google.com>
[ nit: changed subject line a bit]
[ nit: fixed util/parse-events.l rebase fuzz ]
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c | 6 ++++++
 tools/perf/util/parse-events.h | 1 +
 tools/perf/util/parse-events.l | 1 +
 3 files changed, 8 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 8b712761..2e3ef10 100644
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
index 8a48593..13d7c66 100644
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
index b36115f..11d4df3 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -167,6 +167,7 @@ config2			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
 name			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_NAME); }
 period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
+precise			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_PRECISE); }
 ,			{ return ','; }
 "/"			{ BEGIN(INITIAL); return '/'; }
 {name_minus}		{ return str(yyscanner, PE_NAME); }
-- 
1.7.11.7

