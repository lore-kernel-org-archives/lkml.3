Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965395Ab3GRULa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:11:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41467 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397Ab3GRTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/76] perf tools: Rename cpu_map__all() to cpu_map__empty()
Date: Thu, 18 Jul 2013 16:48:48 -0300
Message-Id: <1374177003-3706-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

The CPU map is in an "empty" (or not-applicable) state when monitoring
specific threads.

cpu_map__all() returns true if the CPU map is in this empty state (i.e
for the 'empty_cpu_map' or if we created the map via
cpu_map__dummy_new().

The name, cpu_map__all(), is misleading, because even when monitoring
all CPUs, (eg: perf record -a), cpu_map__all() returns false.

Rename cpu_map__all() to cpu_map__empty().

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/20130523012620.GA27733@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/cpumap.h | 2 +-
 tools/perf/util/evlist.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index 9bed02e..b123bb9 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -41,7 +41,7 @@ static inline int cpu_map__nr(const struct cpu_map *map)
 	return map ? map->nr : 1;
 }
 
-static inline bool cpu_map__all(const struct cpu_map *map)
+static inline bool cpu_map__empty(const struct cpu_map *map)
 {
 	return map ? map->map[0] == -1 : true;
 }
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 8065ce8..4a901be 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -421,7 +421,7 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
 static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 {
 	evlist->nr_mmaps = cpu_map__nr(evlist->cpus);
-	if (cpu_map__all(evlist->cpus))
+	if (cpu_map__empty(evlist->cpus))
 		evlist->nr_mmaps = thread_map__nr(evlist->threads);
 	evlist->mmap = zalloc(evlist->nr_mmaps * sizeof(struct perf_mmap));
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
@@ -573,7 +573,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 			return -ENOMEM;
 	}
 
-	if (cpu_map__all(cpus))
+	if (cpu_map__empty(cpus))
 		return perf_evlist__mmap_per_thread(evlist, prot, mask);
 
 	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
-- 
1.8.1.4

