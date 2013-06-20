Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187Ab3FTDjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:39:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935701Ab3FTDgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:40 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jFrl7hLK7gcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fU4MqtBxlbIA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=jMg_Gfg-Gvda8nM5g_EA:9 a=lqfzikGvtTgA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=RdTXm-Io4kZL_5OU:21 a=kenop1vB8jGrfAZk:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033639.582765054@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 07/12] tracing: Do not call kmem_cache_free() on allocation failure
References: <20130620033516.003166252@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Do-not-call-kmem_cache_free-on-allocation-fa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There's no point calling it when _alloc() failed.

Link: http://lkml.kernel.org/r/1370585268-29169-1-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index db086f1..f57b015 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -97,7 +97,7 @@ static int __trace_define_field(struct list_head *head, const char *type,
 
 	field = kmem_cache_alloc(field_cachep, GFP_TRACE);
 	if (!field)
-		goto err;
+		return -ENOMEM;
 
 	field->name = name;
 	field->type = type;
@@ -114,11 +114,6 @@ static int __trace_define_field(struct list_head *head, const char *type,
 	list_add(&field->link, head);
 
 	return 0;
-
-err:
-	kmem_cache_free(field_cachep, field);
-
-	return -ENOMEM;
 }
 
 int trace_define_field(struct ftrace_event_call *call, const char *type,
-- 
1.7.10.4


