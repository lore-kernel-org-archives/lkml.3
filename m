Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaDGPHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:07:06 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:48394 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaDGPF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:05:26 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>
Cc: Robert Richter <robert.richter@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 13/16] perf tools: Rename flex conditions to avoid name conflicts
Date: Mon,  7 Apr 2014 17:04:35 +0200
Message-Id: <1396883078-25320-14-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
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
Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/util/parse-events.l | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 3432995..a5808d1 100644
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
@@ -126,7 +126,7 @@ modifier_bp	[rwx]{1,3}
 
 }
 
-<config>{
+<cond_config>{
 config			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG); }
 config1			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG1); }
 config2			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
@@ -138,7 +138,7 @@ branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE
 {name_minus}		{ return str(yyscanner, PE_NAME); }
 }
 
-<mem>{
+<cond_mem>{
 {modifier_bp}		{ return str(yyscanner, PE_MODIFIER_BP); }
 :			{ return ':'; }
 {num_dec}		{ return value(yyscanner, 10); }
@@ -146,7 +146,7 @@ branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE
 	/*
 	 * We need to separate 'mem:' scanner part, in order to get specific
 	 * modifier bits parsed out. Otherwise we would need to handle PE_NAME
-	 * and we'd need to parse it manually. During the escape from <mem>
+	 * and we'd need to parse it manually. During the escape from <cond_mem>
 	 * state we need to put the escaping char back, so we dont miss it.
 	 */
 .			{ unput(*yytext); BEGIN(INITIAL); }
@@ -193,18 +193,18 @@ speculative-read|speculative-load	|
 refs|Reference|ops|access		|
 misses|miss				{ return str(yyscanner, PE_NAME_CACHE_OP_RESULT); }
 
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
-- 
1.7.11.7

