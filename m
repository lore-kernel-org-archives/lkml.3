Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3AYWdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:33:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:48890 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab3AYWd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:33:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,541,1355126400"; 
   d="scan'208";a="252629027"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/18] tools, perf: Add a precise event qualifier v2
Date: Fri, 25 Jan 2013 14:33:05 -0800
Message-Id: <1359153192-13409-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
References: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a precise qualifier, like cpu/event=0x3c,precise=1/

This is needed so that the kernel can request enabling PEBS
for TSX events. The parser bails out on any sysfs parse errors,
so this is needed in any case to handle any event on the TSX
perf kernel.

v2: Allow 3 as value
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/parse-events.c |    6 ++++++
 tools/perf/util/parse-events.h |    1 +
 tools/perf/util/parse-events.l |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 02f6421..f6f6aaa 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -568,6 +568,12 @@ do {								\
 	case PARSE_EVENTS__TERM_TYPE_NAME:
 		CHECK_TYPE_VAL(STR);
 		break;
+	case PARSE_EVENTS__TERM_TYPE_PRECISE:
+		CHECK_TYPE_VAL(NUM);
+		if ((unsigned)term->val.num > 3)
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
1.7.7.6

