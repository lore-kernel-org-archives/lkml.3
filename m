Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935724Ab3DJA0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:26:13 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:57547 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762821Ab3DJA0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:26:12 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 01/10] staging: zcache: fix account foregin counters against zero-filled pages
Date: Wed, 10 Apr 2013 08:25:51 +0800
Message-Id: <1365553560-32258-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041000-5816-0000-0000-0000077C155F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zero-filled pages won't be compressed and sent to remote system. Monitor
the number ephemeral and persistent pages that Ramster has sent make no
sense. This patch skip account foregin counters against zero-filled pages.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index f3de76d..e23d814 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -415,7 +415,7 @@ create_in_new_page:
 got_pampd:
 	inc_zcache_eph_zbytes(clen);
 	inc_zcache_eph_zpages();
-	if (ramster_enabled && raw)
+	if (ramster_enabled && raw && !zero_filled)
 		ramster_count_foreign_pages(true, 1);
 	if (zero_filled)
 		pampd = (void *)ZERO_FILLED;
@@ -500,7 +500,7 @@ create_in_new_page:
 got_pampd:
 	inc_zcache_pers_zpages();
 	inc_zcache_pers_zbytes(clen);
-	if (ramster_enabled && raw)
+	if (ramster_enabled && raw && !zero_filled)
 		ramster_count_foreign_pages(false, 1);
 	if (zero_filled)
 		pampd = (void *)ZERO_FILLED;
@@ -681,7 +681,7 @@ zero_fill:
 		dec_zcache_pers_zpages(zpages);
 		dec_zcache_pers_zbytes(zsize);
 	}
-	if (!is_local_client(pool->client))
+	if (!is_local_client(pool->client) && !zero_filled)
 		ramster_count_foreign_pages(eph, -1);
 	if (page && !zero_filled)
 		zcache_free_page(page);
@@ -732,7 +732,7 @@ static void zcache_pampd_free(void *pampd, struct tmem_pool *pool,
 		dec_zcache_pers_zpages(zpages);
 		dec_zcache_pers_zbytes(zsize);
 	}
-	if (!is_local_client(pool->client))
+	if (!is_local_client(pool->client) && !zero_filled)
 		ramster_count_foreign_pages(is_ephemeral(pool), -1);
 	if (page && !zero_filled)
 		zcache_free_page(page);
-- 
1.7.10.4

