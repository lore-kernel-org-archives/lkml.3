Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab3KGPOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:14:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab3KGPOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:14:10 -0500
Date: Thu, 7 Nov 2013 10:13:45 -0500
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ron van der Wees <rvdwees@redhat.com>, Erik Mouw <erik.mouw_2@nxp.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        walken@google.com, Shaohua Li <shli@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC PATCH v2 -mm] provide estimated available memory in
 /proc/meminfo
Message-ID: <20131107101345.14d7be90@annuminas.surriel.com>
In-Reply-To: <20131105144526.49a233ca19298808e54ff900@linux-foundation.org>
References: <ECFC0369-0745-44AB-9858-E689F41CCB4D@nxp.com>
	<5256D4C7.90301@redhat.com>
	<DB649DE8-5595-4370-912B-BDC6BD5FF8C3@nxp.com>
	<20131025120752.GB2415@rh0004426.ams.redhat.com>
	<20131105173852.709a103b@annuminas.surriel.com>
	<20131105144526.49a233ca19298808e54ff900@linux-foundation.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >  fs/proc/meminfo.c | 36 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> 
> Documentation/filesystems/proc.txt told me it's feeling all offended.

You're right, of course.  Here is version 2 :)

---8<---

Subject: provide estimated available memory in /proc/meminfo

Many load balancing and workload placing programs check /proc/meminfo
to estimate how much free memory is available. They generally do this
by adding up "free" and "cached", which was fine ten years ago, but
is pretty much guaranteed to be wrong today.

It is wrong because Cached includes memory that is not freeable as
page cache, for example shared memory segments, tmpfs, and ramfs,
and it does not include reclaimable slab memory, which can take up
a large fraction of system memory on mostly idle systems with lots
of files.

Currently, the amount of memory that is available for a new workload,
without pushing the system into swap, can be estimated from MemFree,
Active(file), Inactive(file), and SReclaimable, as well as the "low"
watermarks from /proc/zoneinfo.

However, this may change in the future, and user space really should
not be expected to know kernel internals to come up with an estimate
for the amount of free memory.

It is more convenient to provide such an estimate in /proc/meminfo.
If things change in the future, we only have to change it in one place.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Erik Mouw <erik.mouw_2@nxp.com>
---
 Documentation/filesystems/proc.txt |  9 +++++++++
 fs/proc/meminfo.c                  | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index fd8d0d5..f57bdd8 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -761,6 +761,7 @@ The "Locked" indicates whether the mapping is locked in memory or not.
 
 MemTotal:     16344972 kB
 MemFree:      13634064 kB
+MemAvailable: 14836172 kB
 Buffers:          3656 kB
 Cached:        1195708 kB
 SwapCached:          0 kB
@@ -793,6 +794,14 @@ AnonHugePages:   49152 kB
     MemTotal: Total usable ram (i.e. physical ram minus a few reserved
               bits and the kernel binary code)
      MemFree: The sum of LowFree+HighFree
+MemAvailable: An estimate of how much memory is available for starting new
+              applications, without swapping. Calculated from MemFree,
+              SReclaimable, the size of the file LRU lists, and the low
+              watermarks in each zone.
+              The estimate takes into account that the system needs some
+              page cache to function well, and that not all reclaimable
+              slab will be reclaimable, due to items being in use. The
+              impact of those factors will vary from system to system.
      Buffers: Relatively temporary storage for raw disk blocks
               shouldn't get tremendously large (20MB or so)
       Cached: in-memory cache for files read from the disk (the
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 5aa847a..1c43db5 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -25,9 +25,12 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	struct sysinfo i;
 	unsigned long committed;
 	unsigned long allowed;
+	long available;
+	unsigned long pagecache, wmark_low = 0;
 	struct vmalloc_info vmi;
 	long cached;
 	unsigned long pages[NR_LRU_LISTS];
+	struct zone *zone;
 	int lru;
 
 /*
@@ -50,12 +53,44 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
 		pages[lru] = global_page_state(NR_LRU_BASE + lru);
 
+	for_each_zone(zone)
+		wmark_low += zone->watermark[WMARK_LOW];
+
+	/*
+	 * Estimate the amount of memory available for userspace allocations,
+	 * without causing swapping.
+	 *
+	 * Free memory cannot be taken below the low watermark, before the
+	 * system starts swapping.
+	 */
+	available = i.freeram - wmark_low;
+
+	/*
+	 * Not all the page cache can be freed, otherwise the system will
+	 * start swapping. Assume at least half of the page cache, or the
+	 * low watermark worth of cache, needs to stay.
+	 */
+	pagecache = pages[LRU_ACTIVE_FILE] + pages[LRU_INACTIVE_FILE];
+	pagecache -= min(pagecache / 2, wmark_low);
+	available += pagecache;
+
+	/*
+	 * Part of the reclaimable swap consists of items that are in use,
+	 * and cannot be freed. Cap this estimate at the low watermark.
+	 */
+	available += global_page_state(NR_SLAB_RECLAIMABLE) -
+		     min(global_page_state(NR_SLAB_RECLAIMABLE) / 2, wmark_low);
+
+	if (available < 0)
+		available = 0;
+
 	/*
 	 * Tagged format, for easy grepping and expansion.
 	 */
 	seq_printf(m,
 		"MemTotal:       %8lu kB\n"
 		"MemFree:        %8lu kB\n"
+		"MemAvailable:   %8lu kB\n"
 		"Buffers:        %8lu kB\n"
 		"Cached:         %8lu kB\n"
 		"SwapCached:     %8lu kB\n"
@@ -108,6 +143,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		,
 		K(i.totalram),
 		K(i.freeram),
+		K(available),
 		K(i.bufferram),
 		K(cached),
 		K(total_swapcache_pages()),

