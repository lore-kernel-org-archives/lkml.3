Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3FGGHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:07:54 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54718 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3FGGHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:07:53 -0400
X-AuditID: 9c930197-b7b8cae000003b08-7d-51b178b72e0a
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] tracing: Do not call kmem_cache_free() on allocation failure
Date: Fri,  7 Jun 2013 15:07:48 +0900
Message-Id: <1370585268-29169-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There's no point calling it when _alloc() failed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_events.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 27963e2bf4bf..bb4950b552b5 100644
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
1.7.11.7

