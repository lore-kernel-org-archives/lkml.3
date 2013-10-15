Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab3JOF3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:29:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33411 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab3JOF3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:29:30 -0400
Date: Mon, 14 Oct 2013 22:29:08 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-820042233bd3c1b24b5ca4c75a88a4e0de39814a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1380299398-10839-1-git-send-email-jolsa@redhat.com>
References: <1380299398-10839-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move start conditions to start of the flex file
Git-Commit-ID: 820042233bd3c1b24b5ca4c75a88a4e0de39814a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:29:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  820042233bd3c1b24b5ca4c75a88a4e0de39814a
Gitweb:     http://git.kernel.org/tip/820042233bd3c1b24b5ca4c75a88a4e0de39814a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 27 Sep 2013 18:29:58 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:31 -0300

perf tools: Move start conditions to start of the flex file

Moving start conditions to start of the flex file so it's clear what the
INITIAL condition rules are.

Plus adding default rule for INITIAL condition. This prevents default
space to be printed for events like:

$ ./perf stat -e "cycles        " kill 2>/dev/null
        $
^^^^^^^^

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1380299398-10839-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.l | 63 +++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 91346b7..3432995 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -126,6 +126,37 @@ modifier_bp	[rwx]{1,3}
 
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
@@ -162,18 +193,6 @@ speculative-read|speculative-load	|
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
@@ -189,25 +208,7 @@ r{num_raw_hex}		{ return raw(yyscanner); }
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
 
