Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3LKMkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:40:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:10658 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab3LKMkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:40:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450498192"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 36/71] perf tools: Add support for parsing pmu itrace_config
Date: Wed, 11 Dec 2013 14:36:48 +0200
Message-Id: <1386765443-26966-37-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Instruction Tracing uses a new perf_event_attr member
named itrace_config.  Add support for parsing pmu format
values and term types based on itrace_config.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/parse-events.c | 4 ++++
 tools/perf/util/parse-events.h | 1 +
 tools/perf/util/parse-events.l | 1 +
 tools/perf/util/pmu.c          | 3 +++
 tools/perf/util/pmu.h          | 1 +
 tools/perf/util/pmu.l          | 1 +
 tools/perf/util/pmu.y          | 9 ++++++++-
 7 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 464dafd..d494a5a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -576,6 +576,10 @@ do {								\
 	case PARSE_EVENTS__TERM_TYPE_NAME:
 		CHECK_TYPE_VAL(STR);
 		break;
+	case PARSE_EVENTS__TERM_TYPE_ITRACE_CONFIG:
+		CHECK_TYPE_VAL(NUM);
+		attr->itrace_config = term->val.num;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index f1cb4c4..86a2721 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -49,6 +49,7 @@ enum {
 	PARSE_EVENTS__TERM_TYPE_NAME,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
 	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
+	PARSE_EVENTS__TERM_TYPE_ITRACE_CONFIG,
 };
 
 struct parse_events_term {
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 3432995..85106c4 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -133,6 +133,7 @@ config2			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
 name			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_NAME); }
 period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
+itrace_config		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_ITRACE_CONFIG); }
 ,			{ return ','; }
 "/"			{ BEGIN(INITIAL); return '/'; }
 {name_minus}		{ return str(yyscanner, PE_NAME); }
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index c6c240f..e308dfe 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -547,6 +547,9 @@ static int pmu_config_term(struct list_head *formats,
 	case PERF_PMU_FORMAT_VALUE_CONFIG2:
 		vp = &attr->config2;
 		break;
+	case PERF_PMU_FORMAT_VALUE_ITRACE_CONFIG:
+		vp = &attr->itrace_config;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index d5266d1..52e4d30 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -9,6 +9,7 @@ enum {
 	PERF_PMU_FORMAT_VALUE_CONFIG,
 	PERF_PMU_FORMAT_VALUE_CONFIG1,
 	PERF_PMU_FORMAT_VALUE_CONFIG2,
+	PERF_PMU_FORMAT_VALUE_ITRACE_CONFIG,
 };
 
 #define PERF_PMU_FORMAT_BITS 64
diff --git a/tools/perf/util/pmu.l b/tools/perf/util/pmu.l
index a15d9fb..c94ee8cd 100644
--- a/tools/perf/util/pmu.l
+++ b/tools/perf/util/pmu.l
@@ -29,6 +29,7 @@ num_dec         [0-9]+
 config		{ return PP_CONFIG; }
 config1		{ return PP_CONFIG1; }
 config2		{ return PP_CONFIG2; }
+itrace_config	{ return PP_ITRACE_CONFIG; }
 -		{ return '-'; }
 :		{ return ':'; }
 ,		{ return ','; }
diff --git a/tools/perf/util/pmu.y b/tools/perf/util/pmu.y
index bfd7e85..caa190e 100644
--- a/tools/perf/util/pmu.y
+++ b/tools/perf/util/pmu.y
@@ -20,7 +20,7 @@ do { \
 
 %}
 
-%token PP_CONFIG PP_CONFIG1 PP_CONFIG2
+%token PP_CONFIG PP_CONFIG1 PP_CONFIG2 PP_ITRACE_CONFIG
 %token PP_VALUE PP_ERROR
 %type <num> PP_VALUE
 %type <bits> bit_term
@@ -60,6 +60,13 @@ PP_CONFIG2 ':' bits
 				      PERF_PMU_FORMAT_VALUE_CONFIG2,
 				      $3));
 }
+|
+PP_ITRACE_CONFIG ':' bits
+{
+	ABORT_ON(perf_pmu__new_format(format, name,
+				      PERF_PMU_FORMAT_VALUE_ITRACE_CONFIG,
+				      $3));
+}
 
 bits:
 bits ',' bit_term
-- 
1.8.5.1

