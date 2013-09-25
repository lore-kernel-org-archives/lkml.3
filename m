Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3IYXXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:23:21 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:43031 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3IYXXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:23:19 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 23/40] mm: Fix vmstat to also account for freepages in
 the region allocator
To: akpm@linux-foundation.org, mgorman@suse.de, dave@sr71.net,
        hannes@cmpxchg.org, tony.luck@intel.com, matthew.garrett@nebula.com,
        riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 04:49:05 +0530
Message-ID: <20130925231903.26184.23956.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-5564-0000-0000-000009E2611F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently vmstat considers only the freepages present in the buddy freelists
of the page allocator. But with the newly introduced region allocator in
place, freepages could be present in the region allocator as well. So teach
vmstat to take them into consideration when reporting free memory.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/vmstat.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index bb44d30..4dc103e 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -868,6 +868,8 @@ static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
 {
 	int i, order, t;
 	struct free_area *area;
+	struct free_area_region *reg_area;
+	struct region_allocator *reg_alloc;
 
 	seq_printf(m, "Node %d, zone %8s \n", pgdat->node_id, zone->name);
 
@@ -884,6 +886,12 @@ static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
 				nr_free +=
 					area->free_list[t].mr_list[i].nr_free;
 			}
+
+			/* Add up freepages in the region allocator as well */
+			reg_alloc = &zone->region_allocator;
+			reg_area = &reg_alloc->region[i].region_area[order];
+			nr_free += reg_area->nr_free;
+
 			seq_printf(m, "%6lu ", nr_free);
 		}
 		seq_putc(m, '\n');

