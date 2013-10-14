Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab3JNU0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:26:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38960 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683Ab3JNUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 081/161] perf lock: Plug some memleaks
Date: Mon, 14 Oct 2013 17:01:10 -0300
Message-Id: <1381780950-25642-82-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

Address some trivial leaks.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1378693159-8747-4-git-send-email-davidlohr@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index d3188629cbaf..77843478a27a 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -321,10 +321,12 @@ static struct lock_stat *lock_stat_findnew(void *addr, const char *name)
 
 	new->addr = addr;
 	new->name = zalloc(sizeof(char) * strlen(name) + 1);
-	if (!new->name)
+	if (!new->name) {
+		free(new);
 		goto alloc_failed;
-	strcpy(new->name, name);
+	}
 
+	strcpy(new->name, name);
 	new->wait_time_min = ULLONG_MAX;
 
 	list_add(&new->hash_entry, entry);
@@ -875,7 +877,7 @@ static int __cmd_record(int argc, const char **argv)
 	const char *record_args[] = {
 		"record", "-R", "-m", "1024", "-c", "1",
 	};
-	unsigned int rec_argc, i, j;
+	unsigned int rec_argc, i, j, ret;
 	const char **rec_argv;
 
 	for (i = 0; i < ARRAY_SIZE(lock_tracepoints); i++) {
@@ -892,7 +894,7 @@ static int __cmd_record(int argc, const char **argv)
 	rec_argc += 2 * ARRAY_SIZE(lock_tracepoints);
 
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
-	if (rec_argv == NULL)
+	if (!rec_argv)
 		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
@@ -908,7 +910,9 @@ static int __cmd_record(int argc, const char **argv)
 
 	BUG_ON(i != rec_argc);
 
-	return cmd_record(i, rec_argv, NULL);
+	ret = cmd_record(i, rec_argv, NULL);
+	free(rec_argv);
+	return ret;
 }
 
 int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
-- 
1.8.1.4

