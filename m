Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3GSHnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:43:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35076 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3GSHnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:43:03 -0400
Date: Fri, 19 Jul 2013 00:42:39 -0700
From: tip-bot for Sukadev Bhattiprolu <tipbot@zytor.com>
Message-ID: <tip-ec1e7e437ac47ecf7b4e07241036b1e1c3366012@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, sukadev@linux.vnet.ibm.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, sukadev@linux.vnet.ibm.com,
        jolsa@redhat.com
In-Reply-To: <20130523012620.GA27733@us.ibm.com>
References: <20130523012620.GA27733@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Rename cpu_map__all()
  to cpu_map__empty()
Git-Commit-ID: ec1e7e437ac47ecf7b4e07241036b1e1c3366012
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:42:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec1e7e437ac47ecf7b4e07241036b1e1c3366012
Gitweb:     http://git.kernel.org/tip/ec1e7e437ac47ecf7b4e07241036b1e1c3366012
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Wed, 22 May 2013 17:42:38 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:45:44 -0300

perf tools: Rename cpu_map__all() to cpu_map__empty()

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
