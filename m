Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3HBKTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:19:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab3HBKTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:19:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zhouping Liu <zliu@redhat.com>
Subject: [ 39/39] mm/memory-hotplug: fix lowmem count overflow when offline pages
Date: Fri,  2 Aug 2013 18:18:49 +0800
Message-Id: <20130802101502.310137211@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802101456.800497005@linuxfoundation.org>
References: <20130802101456.800497005@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: <stable@vger.kernel.org>	[2.6.24+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Zhouping Liu <zliu@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5592,6 +5592,10 @@ __offline_isolated_pages(unsigned long s
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


