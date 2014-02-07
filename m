Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbaBGNEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:04:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41747 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaBGLt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, Pekka Enberg <penberg@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 073/233] slub: Fix calculation of cpu slabs
Date: Fri,  7 Feb 2014 11:44:52 +0000
Message-Id: <1391773652-25214-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 8afb1474db4701d1ab80cd8251137a3260e6913e upstream.

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

Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/slub.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 71ad7c9..fef48ae 100644
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
1.8.3.2

