Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3EWB1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 21:27:00 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38422 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746Ab3EWB06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 21:26:58 -0400
Date: Wed, 22 May 2013 18:26:20 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Rename cpu_map__all() to cpu_map__empty()
Message-ID: <20130523012620.GA27733@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052301-7182-0000-0000-000006D74B45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 22 May 2013 17:42:38 -0700
Subject: [PATCH] Rename cpu_map__all() to cpu_map__empty().

The CPU map is in an "empty" (or not-applicable) state when monitoring
specific threads.

cpu_map__all() returns true if the CPU map is in this empty state (i.e
for the 'empty_cpu_map' or if we created the map via cpu_map__dummy_new().

The name, cpu_map__all(), is misleading, because even when monitoring all
CPUs, (eg: perf record -a), cpu_map__all() returns false.

Rename cpu_map__all() to cpu_map__empty().

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/util/cpumap.h |    2 +-
 tools/perf/util/evlist.c |    4 ++--
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
index f7c7278..8b9b8f7 100644
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
1.7.1

