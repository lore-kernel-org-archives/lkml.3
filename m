Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaDNPxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:53:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbaDNPwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:52:47 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/5] perf tools: Reference count map_groups objects
Date: Mon, 14 Apr 2014 17:52:01 +0200
Message-Id: <1397490723-1992-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397490723-1992-1-git-send-email-jolsa@redhat.com>
References: <1397490723-1992-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We will share it among threads in the same process.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/map.c    | 7 +++++++
 tools/perf/util/map.h    | 9 +++++++++
 tools/perf/util/thread.c | 2 +-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ae4c5e1..ba5f5c0c 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -323,6 +323,7 @@ void map_groups__init(struct map_groups *mg)
 		INIT_LIST_HEAD(&mg->removed_maps[i]);
 	}
 	mg->machine = NULL;
+	mg->refcnt = 1;
 }
 
 static void maps__delete(struct rb_root *maps)
@@ -374,6 +375,12 @@ void map_groups__delete(struct map_groups *mg)
 	free(mg);
 }
 
+void map_groups__put(struct map_groups *mg)
+{
+	if (--mg->refcnt == 0)
+		map_groups__delete(mg);
+}
+
 void map_groups__flush(struct map_groups *mg)
 {
 	int type;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 1073e2d..d6445b2 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -59,11 +59,20 @@ struct map_groups {
 	struct rb_root	 maps[MAP__NR_TYPES];
 	struct list_head removed_maps[MAP__NR_TYPES];
 	struct machine	 *machine;
+	int		 refcnt;
 };
 
 struct map_groups *map_groups__new(void);
 void map_groups__delete(struct map_groups *mg);
 
+static inline struct map_groups *map_groups__get(struct map_groups *mg)
+{
+	++mg->refcnt;
+	return mg;
+}
+
+void map_groups__put(struct map_groups *mg);
+
 static inline struct kmap *map__kmap(struct map *map)
 {
 	return (struct kmap *)(map + 1);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index dc51d16..b501848 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -50,7 +50,7 @@ void thread__delete(struct thread *thread)
 {
 	struct comm *comm, *tmp;
 
-	map_groups__delete(thread->mg);
+	map_groups__put(thread->mg);
 	thread->mg = NULL;
 	list_for_each_entry_safe(comm, tmp, &thread->comm_list, list) {
 		list_del(&comm->list);
-- 
1.8.3.1

