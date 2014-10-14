Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbaJNVGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:06:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:44868 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaJNVGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:06:09 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/24] perf thread_map: Create dummy constructor out of open coded equivalent
Date: Tue, 14 Oct 2014 18:04:24 -0300
Message-Id: <1413320673-5784-16-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Create a dummy thread_map, one that has just one entry and it is -1,
meaning 'all threads', as this ends up going down to perf_event_open().

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8av26cz8uxmbnihl5mmrygp9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread_map.c | 21 +++++++++++++--------
 tools/perf/util/thread_map.h |  1 +
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 5d3215912105..f93b9734735b 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -214,6 +214,17 @@ out_free_threads:
 	goto out;
 }
 
+struct thread_map *thread_map__new_dummy(void)
+{
+	struct thread_map *threads = malloc(sizeof(*threads) + sizeof(pid_t));
+
+	if (threads != NULL) {
+		threads->map[0]	= -1;
+		threads->nr	= 1;
+	}
+	return threads;
+}
+
 static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 {
 	struct thread_map *threads = NULL, *nt;
@@ -224,14 +235,8 @@ static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 	struct strlist *slist;
 
 	/* perf-stat expects threads to be generated even if tid not given */
-	if (!tid_str) {
-		threads = malloc(sizeof(*threads) + sizeof(pid_t));
-		if (threads != NULL) {
-			threads->map[0] = -1;
-			threads->nr	= 1;
-		}
-		return threads;
-	}
+	if (!tid_str)
+		return thread_map__new_dummy();
 
 	slist = strlist__new(false, tid_str);
 	if (!slist)
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index 0cd8b3108084..95313f43cc0f 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -9,6 +9,7 @@ struct thread_map {
 	pid_t map[];
 };
 
+struct thread_map *thread_map__new_dummy(void);
 struct thread_map *thread_map__new_by_pid(pid_t pid);
 struct thread_map *thread_map__new_by_tid(pid_t tid);
 struct thread_map *thread_map__new_by_uid(uid_t uid);
-- 
1.9.3

