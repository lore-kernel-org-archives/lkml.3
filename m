Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab3JOFZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:25:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33014 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3JOFY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:24:58 -0400
Date: Mon, 14 Oct 2013 22:24:20 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-0a98c7febf55325ebac4f28289a9433f4b66ed0e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, mitake@dcl.info.waseda.ac.jp,
        fweisbec@gmail.com, tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, mitake@dcl.info.waseda.ac.jp,
        fweisbec@gmail.com, tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
In-Reply-To: <1378693159-8747-4-git-send-email-davidlohr@hp.com>
References: <1378693159-8747-4-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock: Plug some memleaks
Git-Commit-ID: 0a98c7febf55325ebac4f28289a9433f4b66ed0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:24:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a98c7febf55325ebac4f28289a9433f4b66ed0e
Gitweb:     http://git.kernel.org/tip/0a98c7febf55325ebac4f28289a9433f4b66ed0e
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Sun, 8 Sep 2013 19:19:15 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:23:39 -0300

perf lock: Plug some memleaks

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
