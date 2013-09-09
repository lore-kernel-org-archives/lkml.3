Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab3IICTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:19:37 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:25609 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3IICTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:19:34 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 3/7] perf lock: plug some memleaks
Date: Sun,  8 Sep 2013 19:19:15 -0700
Message-Id: <1378693159-8747-4-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378693159-8747-1-git-send-email-davidlohr@hp.com>
References: <1378693159-8747-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Address some trivial leaks.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/builtin-lock.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index d318862..7784347 100644
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
1.7.11.7

