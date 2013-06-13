Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab3FMN16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:27:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:39335 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab3FMN1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:27:55 -0400
X-IronPort-AV: E=Sophos;i="4.87,858,1363104000"; 
   d="scan'208";a="7537670"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [Part3 PATCH v2 3/4] mem-hotplug: Skip LOCAL_NODE_DATA pages in memory online procedure.
Date: Thu, 13 Jun 2013 21:03:55 +0800
Message-Id: <1371128636-9027-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371128636-9027-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128636-9027-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:59:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:59:04,
	Serialize complete at 2013/06/13 20:59:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pages marked as LOCAL_NODE_DATA are skipped when we do memory offline.
So we have to skip them again when we do memory online.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 mm/memory_hotplug.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c2017eb..3561048 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -843,6 +843,11 @@ static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
 	if (PageReserved(pfn_to_page(start_pfn)))
 		for (i = 0; i < nr_pages; i++) {
 			page = pfn_to_page(start_pfn + i);
+
+			/* Skip pages storing local node kernel data. */
+			if (is_local_node_data(page))
+				continue;
+
 			(*online_page_callback)(page);
 			onlined_pages++;
 		}
-- 
1.7.1

