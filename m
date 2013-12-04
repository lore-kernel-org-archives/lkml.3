Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3LDJ7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:59:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab3LDJ6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:58:31 -0500
X-IronPort-AV: E=Sophos;i="4.93,823,1378828800"; 
   d="scan'208";a="9189161"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: dsahern@gmail.com, jolsa@redhat.com, acme@ghostprotocols.net,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/5] perf tools: Move the checking of which map function to call into function.
Date: Wed, 4 Dec 2013 17:56:40 -0500
Message-Id: <b8c41f1fd2c4f0df71eb7b19aea74fb64d46cdda.1386197481.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1386197481.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1386197481.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 17:58:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 17:58:21,
	Serialize complete at 2013/12/04 17:58:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for cpu_map__dummy_new() or cpu_map__new() to be called in
perf_evlist__create_maps() is more complicated. This patch moves
the checking work into target.h, combining two conditions and making
perf_evlist__create_maps() more readable.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/evlist.c |  8 +-------
 tools/perf/util/target.h | 13 +++++++++++++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 76fa764..7bb6ee1 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -819,13 +819,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (target->default_per_cpu)
-		evlist->cpus = target->per_thread ?
-					cpu_map__dummy_new() :
-					cpu_map__new(target->cpu_list);
-	else if (target__has_task(target))
-		evlist->cpus = cpu_map__dummy_new();
-	else if (!target__has_cpu(target) && !target->uses_mmap)
+	if (target__uses_dummy_map(target))
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(target->cpu_list);
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index 31dd2e9..7381b1c 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -63,4 +63,17 @@ static inline bool target__none(struct target *target)
 	return !target__has_task(target) && !target__has_cpu(target);
 }
 
+static inline bool target__uses_dummy_map(struct target *target)
+{
+	bool use_dummy = false;
+
+	if (target->default_per_cpu)
+		use_dummy = target->per_thread ? true : false;
+	else if (target__has_task(target) ||
+	         (!target__has_cpu(target) && !target->uses_mmap))
+		use_dummy = true;
+
+	return use_dummy;
+}
+
 #endif /* _PERF_TARGET_H */
-- 
1.8.2.1

