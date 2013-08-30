Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3H3Mie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:38:34 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58819 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab3H3Mic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:38:32 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 03/35] mm: Introduce memory regions data-structure to
 capture region boundaries within nodes
To: akpm@linux-foundation.org, mgorman@suse.de, hannes@cmpxchg.org,
        tony.luck@intel.com, matthew.garrett@nebula.com, dave@sr71.net,
        riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, paulmck@linux.vnet.ibm.com, amit.kachhap@linaro.org,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 18:04:25 +0530
Message-ID: <20130830123423.24352.64753.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130830123303.24352.18732.stgit@srivatsabhat.in.ibm.com>
References: <20130830123303.24352.18732.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083012-5806-0000-0000-000022963194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory within a node can be divided into regions of memory that can be
independently power-managed. That is, chunks of memory can be transitioned
(manually or automatically) to low-power states based on the frequency of
references to that region. For example, if a memory chunk is not referenced
for a given threshold amount of time, the hardware (memory controller) can
decide to put that piece of memory into a content-preserving low-power state.
And of course, on the next reference to that chunk of memory, it will be
transitioned back to full-power for read/write operations.

So, the Linux MM can take advantage of this feature by managing the available
memory with an eye towards power-savings - ie., by keeping the memory
allocations/references consolidated to a minimum no. of such power-manageable
memory regions. In order to do so, the first step is to teach the MM about
the boundaries of these regions - and to capture that info, we introduce a new
data-structure called "Memory Regions".

[Also, the concept of memory regions could potentially be extended to work
with different classes of memory like PCM (Phase Change Memory) etc and
hence, it is not limited to just power management alone].

We already sub-divide a node's memory into zones, based on some well-known
constraints. So the question is, where do we fit in memory regions in this
hierarchy. Instead of artificially trying to fit it into the hierarchy one
way or the other, we choose to simply capture the region boundaries in a
parallel data-structure, since most likely the region boundaries won't
naturally fit inside the zone boundaries or vice-versa.

But of course, memory regions are sub-divisions *within* a node, so it makes
sense to keep the data-structures in the node's struct pglist_data. (Thus
this placement makes memory regions parallel to zones in that node).

Once we capture the region boundaries in the memory regions data-structure,
we can influence MM decisions at various places, such as page allocation,
reclamation etc, in order to perform power-aware memory management.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mmzone.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index af4a3b7..4246620 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -35,6 +35,8 @@
  */
 #define PAGE_ALLOC_COSTLY_ORDER 3
 
+#define MAX_NR_NODE_REGIONS	256
+
 enum {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_RECLAIMABLE,
@@ -708,6 +710,14 @@ struct node_active_region {
 extern struct page *mem_map;
 #endif
 
+struct node_mem_region {
+	unsigned long start_pfn;
+	unsigned long end_pfn;
+	unsigned long present_pages;
+	unsigned long spanned_pages;
+	struct pglist_data *pgdat;
+};
+
 /*
  * The pg_data_t structure is used in machines with CONFIG_DISCONTIGMEM
  * (mostly NUMA machines?) to denote a higher-level memory zone than the
@@ -724,6 +734,8 @@ typedef struct pglist_data {
 	struct zone node_zones[MAX_NR_ZONES];
 	struct zonelist node_zonelists[MAX_ZONELISTS];
 	int nr_zones;
+	struct node_mem_region node_regions[MAX_NR_NODE_REGIONS];
+	int nr_node_regions;
 #ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
 	struct page *node_mem_map;
 #ifdef CONFIG_MEMCG

