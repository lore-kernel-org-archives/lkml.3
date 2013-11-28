Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab3K1Gev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:34:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:37213 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab3K1Ger (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:34:47 -0500
X-IronPort-AV: E=Sophos;i="4.93,789,1378828800"; 
   d="scan'208";a="9144300"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: dsahern@gmail.com, adrian.hunter@intel.com, jolsa@redhat.com,
        namhyung@kernel.org, acme@ghostprotocols.net, mingo@redhat.com,
        a.p.zijlstra@chello.nl, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] perf target: Move what map fucntion to call check into function.
Date: Thu, 28 Nov 2013 14:32:54 -0500
Message-Id: <1385667174-16181-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/28 14:34:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/28 14:34:40,
	Serialize complete at 2013/11/28 14:34:40
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

