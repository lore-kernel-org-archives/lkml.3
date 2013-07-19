Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965496Ab3GSFXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:23:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965472Ab3GSFWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:22:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 37/38] mm/memory-hotplug: fix lowmem count overflow when offline pages
Date: Thu, 18 Jul 2013 22:21:53 -0700
Message-Id: <20130719052050.409700339@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052047.858393825@linuxfoundation.org>
References: <20130719052047.858393825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6078,6 +6078,10 @@ __offline_isolated_pages(unsigned long s
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
+#ifdef CONFIG_HIGHMEM
+		if (PageHighMem(page))
+			totalhigh_pages -= 1 << order;
+#endif
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);


