Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934988Ab3BTLBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:01:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27708 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933396Ab3BTLBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:01:41 -0500
X-IronPort-AV: E=Sophos;i="4.84,701,1355068800"; 
   d="scan'208";a="6736029"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [Bug fix PATCH 1/2] acpi, movablemem_map: Exclude memblock.reserved ranges when parsing SRAT.
Date: Wed, 20 Feb 2013 19:00:55 +0800
Message-Id: <1361358056-1793-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1361358056-1793-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1361358056-1793-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 19:00:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 19:00:59,
	Serialize complete at 2013/02/20 19:00:59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned by HPA before, when we are using movablemem_map=acpi, if all the
memory ranges in SRAT is hotpluggable, then no memory can be used by kernel.

Before parsing SRAT, memblock has already reserve some memory ranges for other
purposes, such as for kernel image, and so on. We cannot prevent kernel from
using these memory. So we need to exclude these ranges even if these memory is
hotpluggable.

This patch changes the movablemem_map=acpi option's behavior. The memory ranges
reserved by memblock will not be added into movablemem_map.map[]. So even if
all the memory is hotpluggable, there will always be memory that could be used
by the kernel.

Reported-by: H Peter Anvin <hpa@zytor.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/srat.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 62ba97b..b8028b2 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -145,7 +145,7 @@ static inline int save_add_info(void) {return 0;}
 static void __init
 handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
 {
-	int overlap;
+	int overlap, i;
 	unsigned long start_pfn, end_pfn;
 
 	start_pfn = PFN_DOWN(start);
@@ -161,8 +161,24 @@ handle_movablemem(int node, u64 start, u64 end, u32 hotpluggable)
 	 *
 	 * Using movablemem_map, we can prevent memblock from allocating memory
 	 * on ZONE_MOVABLE at boot time.
+	 *
+	 * Before parsing SRAT, memblock has already reserve some memory ranges
+	 * for other purposes, such as for kernel image. We cannot prevent
+	 * kernel from using these memory, so we need to exclude these memory
+	 * even if it is hotpluggable.
 	 */
 	if (hotpluggable && movablemem_map.acpi) {
+		/* Exclude ranges reserved by memblock. */
+		struct memblock_type *rgn = &memblock.reserved;
+
+		for (i = 0; i < rgn->cnt; i++) {
+			if (end <= rgn->regions[i].base ||
+			    start >= rgn->regions[i].base +
+			    rgn->regions[i].size)
+				continue;
+			goto out;
+		}
+
 		insert_movablemem_map(start_pfn, end_pfn);
 
 		/*
-- 
1.7.1

