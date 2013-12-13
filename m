Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab3LMAPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 19:15:51 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60884 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3LMAPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 19:15:49 -0500
X-AuditID: 9c93017d-b7c5eae000004296-07-52aa51b2b98e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 13/14] tools lib traceevent: Get rid of die() in some string conversion funcitons
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
	<1386833777-3790-14-git-send-email-namhyung@kernel.org>
	<20131212184147.GE8164@ghostprotocols.net>
Date: Fri, 13 Dec 2013 09:15:46 +0900
In-Reply-To: <20131212184147.GE8164@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Thu, 12 Dec 2013 15:41:47 -0300")
Message-ID: <87y53phah9.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Thu, 12 Dec 2013 15:41:47 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 12, 2013 at 04:36:16PM +0900, Namhyung Kim escreveu:
>> Those functions are for stringify filter arguments.  As caller of
>> those functions handles NULL string properly, it seems that it's
>> enough to return NULL rather than calling die().
>> 
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/lib/traceevent/parse-filter.c | 58 +++++++++++++++++++++++--------------
>>  1 file changed, 36 insertions(+), 22 deletions(-)
>> 
>> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
>> index 9303c55128db..32ab4396653c 100644
>> --- a/tools/lib/traceevent/parse-filter.c
>> +++ b/tools/lib/traceevent/parse-filter.c
>> @@ -1361,8 +1361,10 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
>>  		if (ret >= 0 && pevent->test_filters) {
>>  			char *test;
>>  			test = pevent_filter_make_string(filter, event->event->id);
>> -			printf(" '%s: %s'\n", event->event->name, test);
>> -			free(test);
>> +			if (test) {
>> +				printf(" '%s: %s'\n", event->event->name, test);
>> +				free(test);
>> +			}
>>  		}
>>  	}
>>  
>> @@ -2097,7 +2099,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
>>  				default:
>>  					break;
>>  				}
>> -				str = malloc_or_die(6);
>> +				str = malloc(6);
>> +				if (str == NULL)
>> +					break;
>>  				if (val)
>>  					strcpy(str, "TRUE");
>>  				else
>> @@ -2120,7 +2124,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
>>  		}
>>  
>>  		len = strlen(left) + strlen(right) + strlen(op) + 10;
>> -		str = malloc_or_die(len);
>> +		str = malloc(len);
>> +		if (str == NULL)
>> +			break;
>>  		snprintf(str, len, "(%s) %s (%s)",
>>  			 left, op, right);
>
> Why note:
>
> 		str = NULL;
> 		if (asprintf(&str, "(%s) %s (%s)", left, op, right);
> 			break;
>
> instead?
>
> Ditto for other places here, also there is a typo in the subject line.
>
> I've applied all the previous patches, thanks!

Thank you very much!

Here is the updated patch:


>From d775295fb53930b1e3d946e145e9a6172773d4f5 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Sat, 7 Dec 2013 15:13:35 +0000
Subject: [PATCH v2.1 13/14] tools lib traceevent: Get rid of die() in some string
 conversion functions

Those functions are for stringify filter arguments.  As caller of
those functions handles NULL string properly, it seems that it's
enough to return NULL rather than calling die().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 59 +++++++++++++++----------------------
 1 file changed, 24 insertions(+), 35 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 9303c55128db..72fe16562546 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1361,8 +1361,10 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 		if (ret >= 0 && pevent->test_filters) {
 			char *test;
 			test = pevent_filter_make_string(filter, event->event->id);
-			printf(" '%s: %s'\n", event->event->name, test);
-			free(test);
+			if (test) {
+				printf(" '%s: %s'\n", event->event->name, test);
+				free(test);
+			}
 		}
 	}
 
@@ -2050,7 +2052,6 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 	int left_val = -1;
 	int right_val = -1;
 	int val;
-	int len;
 
 	switch (arg->op.type) {
 	case FILTER_OP_AND:
@@ -2097,7 +2098,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 				default:
 					break;
 				}
-				str = malloc_or_die(6);
+				str = malloc(6);
+				if (str == NULL)
+					break;
 				if (val)
 					strcpy(str, "TRUE");
 				else
@@ -2119,10 +2122,7 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 			break;
 		}
 
-		len = strlen(left) + strlen(right) + strlen(op) + 10;
-		str = malloc_or_die(len);
-		snprintf(str, len, "(%s) %s (%s)",
-			 left, op, right);
+		asprintf(&str, "(%s) %s (%s)", left, op, right);
 		break;
 
 	case FILTER_OP_NOT:
@@ -2138,16 +2138,16 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 			right_val = 0;
 		if (right_val >= 0) {
 			/* just return the opposite */
-			str = malloc_or_die(6);
+			str = malloc(6);
+			if (str == NULL)
+				break;
 			if (right_val)
 				strcpy(str, "FALSE");
 			else
 				strcpy(str, "TRUE");
 			break;
 		}
-		len = strlen(right) + strlen(op) + 3;
-		str = malloc_or_die(len);
-		snprintf(str, len, "%s(%s)", op, right);
+		asprintf(&str, "%s(%s)", op, right);
 		break;
 
 	default:
@@ -2161,11 +2161,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 
 static char *val_to_str(struct event_filter *filter, struct filter_arg *arg)
 {
-	char *str;
-
-	str = malloc_or_die(30);
+	char *str = NULL;
 
-	snprintf(str, 30, "%lld", arg->value.val);
+	asprintf(&str, "%lld", arg->value.val);
 
 	return str;
 }
@@ -2181,7 +2179,6 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
 	char *rstr;
 	char *op;
 	char *str = NULL;
-	int len;
 
 	lstr = arg_to_str(filter, arg->exp.left);
 	rstr = arg_to_str(filter, arg->exp.right);
@@ -2220,12 +2217,11 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
 		op = "^";
 		break;
 	default:
-		die("oops in exp");
+		op = "[ERROR IN EXPRESSION TYPE]";
+		break;
 	}
 
-	len = strlen(op) + strlen(lstr) + strlen(rstr) + 4;
-	str = malloc_or_die(len);
-	snprintf(str, len, "%s %s %s", lstr, op, rstr);
+	asprintf(&str, "%s %s %s", lstr, op, rstr);
 out:
 	free(lstr);
 	free(rstr);
@@ -2239,7 +2235,6 @@ static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
 	char *rstr;
 	char *str = NULL;
 	char *op = NULL;
-	int len;
 
 	lstr = arg_to_str(filter, arg->num.left);
 	rstr = arg_to_str(filter, arg->num.right);
@@ -2270,10 +2265,7 @@ static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
 		if (!op)
 			op = "<=";
 
-		len = strlen(lstr) + strlen(op) + strlen(rstr) + 4;
-		str = malloc_or_die(len);
-		sprintf(str, "%s %s %s", lstr, op, rstr);
-
+		asprintf(&str, "%s %s %s", lstr, op, rstr);
 		break;
 
 	default:
@@ -2291,7 +2283,6 @@ static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
 {
 	char *str = NULL;
 	char *op = NULL;
-	int len;
 
 	switch (arg->str.type) {
 	case FILTER_CMP_MATCH:
@@ -2309,12 +2300,8 @@ static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
 		if (!op)
 			op = "!~";
 
-		len = strlen(arg->str.field->name) + strlen(op) +
-			strlen(arg->str.val) + 6;
-		str = malloc_or_die(len);
-		snprintf(str, len, "%s %s \"%s\"",
-			 arg->str.field->name,
-			 op, arg->str.val);
+		asprintf(&str, "%s %s \"%s\"",
+			 arg->str.field->name, op, arg->str.val);
 		break;
 
 	default:
@@ -2330,7 +2317,9 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
 
 	switch (arg->type) {
 	case FILTER_ARG_BOOLEAN:
-		str = malloc_or_die(6);
+		str = malloc(6);
+		if (str == NULL)
+			return NULL;
 		if (arg->boolean.value)
 			strcpy(str, "TRUE");
 		else
@@ -2369,7 +2358,7 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
  *
  * Returns a string that displays the filter contents.
  *  This string must be freed with free(str).
- *  NULL is returned if no filter is found.
+ *  NULL is returned if no filter is found or allocation failed.
  */
 char *
 pevent_filter_make_string(struct event_filter *filter, int event_id)
-- 
1.7.11.7

