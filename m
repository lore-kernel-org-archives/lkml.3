Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbbAHM5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:57:02 -0500
Received: from mga14.intel.com ([192.55.52.115]:35459 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828AbbAHMzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:55:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="437999876"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V4 17/23] perf script: Always allow fields 'addr' and 'cpu' for itrace
Date: Thu,  8 Jan 2015 14:52:21 +0200
Message-Id: <1420721547-26470-18-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420721547-26470-1-git-send-email-adrian.hunter@intel.com>
References: <1420721547-26470-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a file contains Instruction Tracing data then always allow
fields 'addr' and 'cpu' to be selected as options for perf
script.  This is necessary because Instruction Trace decoding
may synthesize events with that information.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-script.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index dbffd00..8976d9b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -147,9 +147,10 @@ static const char *output_field2str(enum perf_output_field field)
 
 #define PRINT_FIELD(x)  (output[attr->type].fields & PERF_OUTPUT_##x)
 
-static int perf_evsel__check_stype(struct perf_evsel *evsel,
-				   u64 sample_type, const char *sample_msg,
-				   enum perf_output_field field)
+static int perf_evsel__do_check_stype(struct perf_evsel *evsel,
+				      u64 sample_type, const char *sample_msg,
+				      enum perf_output_field field,
+				      bool allow_user_set)
 {
 	struct perf_event_attr *attr = &evsel->attr;
 	int type = attr->type;
@@ -159,6 +160,8 @@ static int perf_evsel__check_stype(struct perf_evsel *evsel,
 		return 0;
 
 	if (output[type].user_set) {
+		if (allow_user_set)
+			return 0;
 		evname = perf_evsel__name(evsel);
 		pr_err("Samples for '%s' event do not have %s attribute set. "
 		       "Cannot print '%s' field.\n",
@@ -176,10 +179,21 @@ static int perf_evsel__check_stype(struct perf_evsel *evsel,
 	return 0;
 }
 
+static int perf_evsel__check_stype(struct perf_evsel *evsel,
+				   u64 sample_type, const char *sample_msg,
+				   enum perf_output_field field)
+{
+	return perf_evsel__do_check_stype(evsel, sample_type, sample_msg, field,
+					  false);
+}
+
 static int perf_evsel__check_attr(struct perf_evsel *evsel,
 				  struct perf_session *session)
 {
 	struct perf_event_attr *attr = &evsel->attr;
+	bool allow_user_set;
+
+	allow_user_set = perf_header__has_feat(&session->header, HEADER_ITRACE);
 
 	if (PRINT_FIELD(TRACE) &&
 		!perf_session__has_traces(session, "record -R"))
@@ -192,8 +206,8 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 	}
 
 	if (PRINT_FIELD(ADDR) &&
-		perf_evsel__check_stype(evsel, PERF_SAMPLE_ADDR, "ADDR",
-					PERF_OUTPUT_ADDR))
+		perf_evsel__do_check_stype(evsel, PERF_SAMPLE_ADDR, "ADDR",
+					   PERF_OUTPUT_ADDR, allow_user_set))
 		return -EINVAL;
 
 	if (PRINT_FIELD(SYM) && !PRINT_FIELD(IP) && !PRINT_FIELD(ADDR)) {
@@ -230,8 +244,8 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 		return -EINVAL;
 
 	if (PRINT_FIELD(CPU) &&
-		perf_evsel__check_stype(evsel, PERF_SAMPLE_CPU, "CPU",
-					PERF_OUTPUT_CPU))
+		perf_evsel__do_check_stype(evsel, PERF_SAMPLE_CPU, "CPU",
+					   PERF_OUTPUT_CPU, allow_user_set))
 		return -EINVAL;
 
 	if (PRINT_FIELD(PERIOD) &&
-- 
1.9.1

