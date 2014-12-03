Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaLCCff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:35:35 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:61299 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750886AbaLCCfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:35:33 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44389200"
Message-ID: <547E7348.5020204@cn.fujitsu.com>
Date: Wed, 3 Dec 2014 10:19:52 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: <linux-mtd@lists.infradead.org>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <linux-kernel@vger.kernel.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [RESEND PATCH 1/3] mtd:mtdblock: remove the needless mtdblks_lock
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The global lock mtdblks_lock was used to protect the original mtdblks
array to avoid race conditions. As the mtdblks array was already gone,
but the mtdblks_lock is left, and it causes latency when open/release dev.
So we need to remove it here.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/mtd/mtdblock.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index 485ea75..bb4c14f 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -45,8 +45,6 @@ struct mtdblk_dev {
 	enum { STATE_EMPTY, STATE_CLEAN, STATE_DIRTY } cache_state;
 };
 
-static DEFINE_MUTEX(mtdblks_lock);
-
 /*
  * Cache stuff...
  *
@@ -286,10 +284,8 @@ static int mtdblock_open(struct mtd_blktrans_dev *mbd)
 
 	pr_debug("mtdblock_open\n");
 
-	mutex_lock(&mtdblks_lock);
 	if (mtdblk->count) {
 		mtdblk->count++;
-		mutex_unlock(&mtdblks_lock);
 		return 0;
 	}
 
@@ -302,8 +298,6 @@ static int mtdblock_open(struct mtd_blktrans_dev *mbd)
 		mtdblk->cache_data = NULL;
 	}
 
-	mutex_unlock(&mtdblks_lock);
-
 	pr_debug("ok\n");
 
 	return 0;
@@ -315,8 +309,6 @@ static void mtdblock_release(struct mtd_blktrans_dev *mbd)
 
 	pr_debug("mtdblock_release\n");
 
-	mutex_lock(&mtdblks_lock);
-
 	mutex_lock(&mtdblk->cache_mutex);
 	write_cached_data(mtdblk);
 	mutex_unlock(&mtdblk->cache_mutex);
@@ -331,8 +323,6 @@ static void mtdblock_release(struct mtd_blktrans_dev *mbd)
 		vfree(mtdblk->cache_data);
 	}
 
-	mutex_unlock(&mtdblks_lock);
-
 	pr_debug("ok\n");
 }
 
-- 
1.7.7

.

