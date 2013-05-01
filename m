Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450Ab3EAPSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:18:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab3EAPRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:17:18 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/8] perf tools: Move start conditions to start of the flex file
Date: Wed,  1 May 2013 17:15:39 +0200
Message-Id: <1367421346-18257-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving start conditions to start of the flex file so it's clear
what the INITIAL condition rules are.

Plus adding default rule for INITIAL condition. This prevents
default space to be printed for events like:

$ ./perf stat -e "cycles        " kill 2>/dev/null
        $
^^^^^^^^

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/parse-events.l | 63 +++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index e9d1134..5b4ef52 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -125,6 +125,37 @@ modifier_bp	[rwx]{1,3}
 
 }
 
+<config>{
+config			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG); }
+config1			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG1); }
+config2			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
+name			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_NAME); }
+period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
+branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
+,			{ return ','; }
+"/"			{ BEGIN(INITIAL); return '/'; }
+{name_minus}		{ return str(yyscanner, PE_NAME); }
+}
+
+<mem>{
+{modifier_bp}		{ return str(yyscanner, PE_MODIFIER_BP); }
+:			{ return ':'; }
+{num_dec}		{ return value(yyscanner, 10); }
+{num_hex}		{ return value(yyscanner, 16); }
+	/*
+	 * We need to separate 'mem:' scanner part, in order to get specific
+	 * modifier bits parsed out. Otherwise we would need to handle PE_NAME
+	 * and we'd need to parse it manually. During the escape from <mem>
+	 * state we need to put the escaping char back, so we dont miss it.
+	 */
+.			{ unput(*yytext); BEGIN(INITIAL); }
+	/*
+	 * We destroy the scanner after reaching EOF,
+	 * but anyway just to be sure get back to INIT state.
+	 */
+<<EOF>>			{ BEGIN(INITIAL); }
+}
+
 cpu-cycles|cycles				{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES); }
 stalled-cycles-frontend|idle-cycles-frontend	{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND); }
 stalled-cycles-backend|idle-cycles-backend	{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BACKEND); }
@@ -160,18 +191,6 @@ speculative-read|speculative-load	|
 refs|Reference|ops|access		|
 misses|miss				{ return str(yyscanner, PE_NAME_CACHE_OP_RESULT); }
 
-<config>{
-config			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG); }
-config1			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG1); }
-config2			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
-name			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_NAME); }
-period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
-branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
-,			{ return ','; }
-"/"			{ BEGIN(INITIAL); return '/'; }
-{name_minus}		{ return str(yyscanner, PE_NAME); }
-}
-
 mem:			{ BEGIN(mem); return PE_PREFIX_MEM; }
 r{num_raw_hex}		{ return raw(yyscanner); }
 {num_dec}		{ return value(yyscanner, 10); }
@@ -187,25 +206,7 @@ r{num_raw_hex}		{ return raw(yyscanner); }
 "}"			{ return '}'; }
 =			{ return '='; }
 \n			{ }
-
-<mem>{
-{modifier_bp}		{ return str(yyscanner, PE_MODIFIER_BP); }
-:			{ return ':'; }
-{num_dec}		{ return value(yyscanner, 10); }
-{num_hex}		{ return value(yyscanner, 16); }
-	/*
-	 * We need to separate 'mem:' scanner part, in order to get specific
-	 * modifier bits parsed out. Otherwise we would need to handle PE_NAME
-	 * and we'd need to parse it manually. During the escape from <mem>
-	 * state we need to put the escaping char back, so we dont miss it.
-	 */
-.			{ unput(*yytext); BEGIN(INITIAL); }
-	/*
-	 * We destroy the scanner after reaching EOF,
-	 * but anyway just to be sure get back to INIT state.
-	 */
-<<EOF>>			{ BEGIN(INITIAL); }
-}
+.			{ }
 
 %%
 
-- 
1.7.11.7

