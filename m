Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab3HODYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 23:24:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:11457 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab3HODYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 23:24:44 -0400
X-IronPort-AV: E=Sophos;i="4.89,881,1367942400"; 
   d="scan'208";a="8206384"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        liwanp@linux.vnet.ibm.com, tj@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] memblock cleanup: Remove unnecessary check in memblock_find_in_range_node()
Date: Thu, 15 Aug 2013 11:23:19 +0800
Message-Id: <1376536999-4562-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/15 11:23:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/15 11:23:07,
	Serialize complete at 2013/08/15 11:23:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In memblock_find_in_range_node(), it has the following check at line 117 and 118:

 113         for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
 114                 this_start = clamp(this_start, start, end);
 115                 this_end = clamp(this_end, start, end);
 116
 117                 if (this_end < size)
 118                         continue;
 119
 120                 cand = round_down(this_end - size, align);
 121                 if (cand >= this_start)
 122                         return cand;
 123         }

Since it finds memory from higher memory downwards, if this_end < size,
we can break because the rest memory will all under size. It won't satisfy
us ang more.

Furthermore, we don't need to check "if (this_end < size)" actually. Without
this confusing check, we only waste some loops. So this patch removes the
check.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 mm/memblock.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index a847bfe..e0c626e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -114,9 +114,6 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
 
-		if (this_end < size)
-			continue;
-
 		cand = round_down(this_end - size, align);
 		if (cand >= this_start)
 			return cand;
-- 
1.7.1

