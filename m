Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaFKIHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:07:00 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52664 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaFKIG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:06:57 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 1/2] tracing: Fix memory leak on failure path in ftrace_allocate_pages()
Date: Wed, 11 Jun 2014 17:06:53 +0900
Message-Id: <1402474014-28655-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As struct ftrace_page is managed in a single linked list, it should
free from the start page.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b372e3ed675..ddfda763ded7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2398,7 +2398,8 @@ ftrace_allocate_pages(unsigned long num_to_init)
 	return start_pg;
 
  free_pages:
-	while (start_pg) {
+	pg = start_pg;
+	while (pg) {
 		order = get_count_order(pg->size / ENTRIES_PER_PAGE);
 		free_pages((unsigned long)pg->records, order);
 		start_pg = pg->next;
-- 
2.0.0

