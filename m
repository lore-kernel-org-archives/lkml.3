Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3IJDoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:44:05 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16960 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3IJDoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:44:03 -0400
Message-ID: <522E9569.9060104@huawei.com>
Date: Tue, 10 Sep 2013 11:43:37 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] slub: Fix calculation of cpu slabs
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  /sys/kernel/slab/:t-0000048 # cat cpu_slabs
  231 N0=16 N1=215
  /sys/kernel/slab/:t-0000048 # cat slabs
  145 N0=36 N1=109

See, the number of slabs is smaller than that of cpu slabs.

The bug was introduced by commit 49e2258586b423684f03c278149ab46d8f8b6700
("slub: per cpu cache for partial pages").

We should use page->pages instead of page->pobjects when calculating
the number of cpu partial slabs. This also fixes the mapping of slabs
and nodes.

As there's no variable storing the number of total/active objects in
cpu partial slabs, and we don't have user interfaces requiring those
statistics, I just add WARN_ON for those cases.

Cc: <stable@vger.kernel.org> # 3.2+
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 mm/slub.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index e3ba1f2..6ea461d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4300,7 +4300,13 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 
 			page = ACCESS_ONCE(c->partial);
 			if (page) {
-				x = page->pobjects;
+				node = page_to_nid(page);
+				if (flags & SO_TOTAL)
+					WARN_ON_ONCE(1);
+				else if (flags & SO_OBJECTS)
+					WARN_ON_ONCE(1);
+				else
+					x = page->pages;
 				total += x;
 				nodes[node] += x;
 			}
-- 
1.8.0.2
