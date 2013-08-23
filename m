Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3HWLOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:14:10 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:62643 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab3HWLOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:14:08 -0400
MIME-Version: 1.0
Date: Fri, 23 Aug 2013 19:14:06 +0800
Message-ID: <CAL1ERfMc-KUEvF-vdWvPgQ+igW29fpRrS4oPwoz_DdGRzsGwtw@mail.gmail.com>
Subject: [PATCH 4/4] zswap: avoid unnecessary page scanning
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Minchan Kim <minchan@kernel.org>, Bob Liu <bob.liu@oracle.com>,
        sjenning@linux.vnet.ibm.com
Cc: weijie.yang@samsung.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add SetPageReclaim before __swap_writepage, so that page can be moved
to the tail of the inactive list,
which will avoid unnecessary page scanning as this page was reclaimed
by swap subsystem before.

---
 mm/zswap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 9d34c3c..67a2e38 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -556,6 +556,9 @@ static int zswap_writeback_entry(struct zbud_pool
*pool, unsigned long handle)
 		SetPageUptodate(page);
 	}

+	/* move it to the tail of the inactive list after end_writeback */
+	SetPageReclaim(page);
+
 	/* start writeback */
 	__swap_writepage(page, &wbc, end_swap_bio_write);
 	page_cache_release(page);
-- 
1.7.0.4
