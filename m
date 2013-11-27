Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab3K0JZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 04:25:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:32512 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab3K0JY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 04:24:57 -0500
X-IronPort-AV: E=Sophos;i="4.93,780,1378828800"; 
   d="scan'208";a="9137335"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: dsahern@gmail.com, adrian.hunter@intel.com, jolsa@redhat.com,
        namhyung@kernel.org, acme@ghostprotocols.net, mingo@redhat.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] perf util: Join four conditions in two in perf_evlist__create_maps().
Date: Wed, 27 Nov 2013 17:23:04 -0500
Message-Id: <1385590984-30244-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/27 17:24:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/27 17:24:59,
	Serialize complete at 2013/11/27 17:24:59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are four condition branchs in perf_evlist__create_maps, but they
only do two kinds of thing. 1st and 4th call cpu_map__new(), and the others
call cpu_map__dummy_new(). This patch joins them in two branchs, decreasing
the number of branch and removing some duplicated code.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/evlist.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index bbc746a..2258eb4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -819,11 +819,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (target->force_per_cpu)
-		evlist->cpus = cpu_map__new(target->cpu_list);
-	else if (target__has_task(target))
-		evlist->cpus = cpu_map__dummy_new();
-	else if (!target__has_cpu(target) && !target->uses_mmap)
+	if (!target->force_per_cpu &&
+	    (target__has_task(target) || 
+	     (!target__has_cpu(target) && !target->uses_mmap)))
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(target->cpu_list);
-- 
1.8.2.1

