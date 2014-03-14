Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaCNOBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:01:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbaCNOBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:01:15 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 5/5] perf tools: Share process map groups within process threads
Date: Fri, 14 Mar 2014 15:00:06 +0100
Message-Id: <1394805606-25883-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sharing map groups within all process threads. This way
there's only one copy of mmap info and it's reachale
from any thread within the process.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/util/map.h    |  2 ++
 tools/perf/util/thread.c | 37 ++++++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 99a6488..d4c8df2 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -59,6 +59,8 @@ struct map_groups {
 	struct rb_root	 maps[MAP__NR_TYPES];
 	struct list_head removed_maps[MAP__NR_TYPES];
 	struct machine	 *machine;
+	/* Used for thread sharing */
+	int		  refcnt;
 };
 
 static inline struct kmap *map__kmap(struct map *map)
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 7c1aad0..2599754 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -156,6 +156,16 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 	return 0;
 }
 
+static struct thread* thread__get_leader(struct thread *thread)
+{
+	pid_t pid = thread->pid_;
+
+	if (pid == thread->tid)
+		return thread;
+
+	return machine__findnew_thread(thread->machine, pid, pid);
+}
+
 static struct map_groups* thread__map_groups_alloc(struct thread *thread)
 {
 	struct map_groups* mg = zalloc(sizeof(*mg));
@@ -172,13 +182,34 @@ struct map_groups* thread__map_groups_get(struct thread *thread)
 {
 	struct map_groups* mg = thread->mg;
 
-	if (!mg)
-		mg = thread__map_groups_alloc(thread);
+	if (!mg) {
+		struct thread *leader = thread__get_leader(thread);
+
+		if (!leader)
+			return NULL;
+
+		if (leader->mg)
+			mg = leader->mg;
+		else
+			mg = thread__map_groups_alloc(leader);
+
+		if (leader != thread)
+			thread->mg = mg;
+
+		mg->refcnt++;
+	}
 
 	return mg;
 }
 
 void thread__map_groups_put(struct thread *thread)
 {
-	zfree(&thread->mg);
+	struct map_groups* mg = thread->mg;
+
+	if (mg) {
+		BUG_ON(!mg->refcnt);
+
+		if (!--mg->refcnt)
+			zfree(&thread->mg);
+	}
 }
-- 
1.8.3.1

