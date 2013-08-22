Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3HVOoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:44:34 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:51895 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3HVOob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:44:31 -0400
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH resent 1/4] perf tools: Rename flex conditions to avoid name conflicts
Date: Thu, 22 Aug 2013 16:44:02 +0200
Message-Id: <1377182645-12922-2-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377182645-12922-1-git-send-email-rric@kernel.org>
References: <1377182645-12922-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

These define's may cause conflicts with other definitions:

 #define INITIAL 0
 #define mem 1
 #define config 2
 #define event 3

Prefix them with cond_* to avoid this.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 tools/perf/util/parse-events.l | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 0790452..435b4e5 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -69,9 +69,9 @@ static int term(yyscan_t scanner, int type)
 
 %}
 
-%x mem
-%s config
-%x event
+%x cond_mem
+%s cond_config
+%x cond_event
 
 group		[^,{}/]*[{][^}]*[}][^,{}/]*
 event_pmu	[^,{}/]+[/][^/]*[/][^,{}/]*
@@ -95,9 +95,9 @@ modifier_bp	[rwx]{1,3}
 		start_token = parse_events_get_extra(yyscanner);
 
 		if (start_token == PE_START_TERMS)
-			BEGIN(config);
+			BEGIN(cond_config);
 		else if (start_token == PE_START_EVENTS)
-			BEGIN(event);
+			BEGIN(cond_event);
 
 		if (start_token) {
 			parse_events_set_extra(NULL, yyscanner);
@@ -106,7 +106,7 @@ modifier_bp	[rwx]{1,3}
          }
 %}
 
-<event>{
+<cond_event>{
 
 {group}		{
 			BEGIN(INITIAL); yyless(0);
@@ -161,7 +161,7 @@ speculative-read|speculative-load	|
 refs|Reference|ops|access		|
 misses|miss				{ return str(yyscanner, PE_NAME_CACHE_OP_RESULT); }
 
-<config>{
+<cond_config>{
 config			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG); }
 config1			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG1); }
 config2			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
@@ -173,23 +173,23 @@ branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE
 {name_minus}		{ return str(yyscanner, PE_NAME); }
 }
 
-mem:			{ BEGIN(mem); return PE_PREFIX_MEM; }
+mem:			{ BEGIN(cond_mem); return PE_PREFIX_MEM; }
 r{num_raw_hex}		{ return raw(yyscanner); }
 {num_dec}		{ return value(yyscanner, 10); }
 {num_hex}		{ return value(yyscanner, 16); }
 
 {modifier_event}	{ return str(yyscanner, PE_MODIFIER_EVENT); }
 {name}			{ return str(yyscanner, PE_NAME); }
-"/"			{ BEGIN(config); return '/'; }
+"/"			{ BEGIN(cond_config); return '/'; }
 -			{ return '-'; }
-,			{ BEGIN(event); return ','; }
+,			{ BEGIN(cond_event); return ','; }
 :			{ return ':'; }
-"{"			{ BEGIN(event); return '{'; }
+"{"			{ BEGIN(cond_event); return '{'; }
 "}"			{ return '}'; }
 =			{ return '='; }
 \n			{ }
 
-<mem>{
+<cond_mem>{
 {modifier_bp}		{ return str(yyscanner, PE_MODIFIER_BP); }
 :			{ return ':'; }
 {num_dec}		{ return value(yyscanner, 10); }
-- 
1.8.3.2

