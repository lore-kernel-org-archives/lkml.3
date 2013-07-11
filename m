Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab3GKOoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:44:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43010 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807Ab3GKO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 37/98] mm/memory-hotplug: fix lowmem count overflow when offline pages
Date: Thu, 11 Jul 2013 15:24:07 +0100
Message-Id: <1373552708-15235-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wanpeng Li <liwanp@linux.vnet.ibm.com>

commit cea27eb2a202959783f81254c48c250ddd80e129 upstream.

The logic for the memory-remove code fails to correctly account the
Total High Memory when a memory block which contains High Memory is
offlined as shown in the example below.  The following patch fixes it.

Before logic memory remove:

MemTotal:        7603740 kB
MemFree:         6329612 kB
Buffers:           94352 kB
Cached:           872008 kB
SwapCached:            0 kB
Active:           626932 kB
Inactive:         519216 kB
Active(anon):     180776 kB
Inactive(anon):   222944 kB
Active(file):     446156 kB
Inactive(file):   296272 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:       7294672 kB
HighFree:        5704696 kB
LowTotal:         309068 kB
LowFree:          624916 kB

After logic memory remove:

MemTotal:        7079452 kB
MemFree:         5805976 kB
Buffers:           94372 kB
Cached:           872000 kB
SwapCached:            0 kB
Active:           626936 kB
Inactive:         519236 kB
Active(anon):     180780 kB
Inactive(anon):   222944 kB
Active(file):     446156 kB
Inactive(file):   296292 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:       7294672 kB
HighFree:        5181024 kB
LowTotal:       4294752076 kB
LowFree:          624952 kB

[mhocko@suse.cz: fix CONFIG_HIGHMEM=n build]
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/page_alloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0ed96c7..63e6fa4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5911,6 +5911,10 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 		zone->free_area[order].nr_free--;
 		__mod_zone_page_state(zone, NR_FREE_PAGES,
 				      - (1UL << order));
+#ifdef CONFIG_HIGHMEM
+		if (PageHighMem(page))
+			totalhigh_pages -= 1 << order;
+#endif
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);
-- 
1.8.1.2

