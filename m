Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3KHJuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:50:16 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42436 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab3KHJuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:50:14 -0500
Message-ID: <1383904203.2715.2.camel@ubuntu>
Subject: [Patch 3.11.7 1/1]mm: remove and free expired data in time in zswap
From: "changkun.li" <xfishcoder@gmail.com>
To: sjenning@linux.vnet.ibm.com, linux-mm@kvack.org
Cc: luyi@360.cn, lichangkun@360.cn, linux-kernel@vger.kernel.org
Date: Fri, 08 Nov 2013 17:50:03 +0800
Organization: 360.cn
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In zswap, store page A to zbud if the compression ratio is high, insert
its entry into rbtree. if there is a entry B which has the same offset
in the rbtree.Remove and free B before insert the entry of A.

case:
if the compression ratio of page A is not high, return without checking
the same offset one in rbtree.

if there is a entry B which has the same offset in the rbtree. Now, we
make sure B is invalid or expired. But the entry and compressed memory
of B are not freed in time.

Because zswap spaces data in memory, it makes the utilization of memory
lower. the other valid data in zbud is writeback to swap device more
possibility, when zswap is full.

So if we make sure a entry is expired, free it in time.

Signed-off-by: changkun.li<xfishcoder@gmail.com>
---
 mm/zswap.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index cbd9578..90a2813 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -596,6 +596,7 @@ fail:
 	return ret;
 }
 
+static void zswap_frontswap_invalidate_page(unsigned type, pgoff_t
offset);
 /*********************************
 * frontswap hooks
 **********************************/
@@ -614,7 +615,7 @@ static int zswap_frontswap_store(unsigned type,
pgoff_t offset,
 
 	if (!tree) {
 		ret = -ENODEV;
-		goto reject;
+		goto nodev;
 	}
 
 	/* reclaim space if needed */
@@ -695,6 +696,8 @@ freepage:
 	put_cpu_var(zswap_dstmem);
 	zswap_entry_cache_free(entry);
 reject:
+	zswap_frontswap_invalidate_page(type, offset);
+nodev:
 	return ret;
 }
 
-- 
1.7.1


