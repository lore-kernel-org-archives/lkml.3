Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaLCCgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:36:04 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:19894 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750969AbaLCCgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:36:01 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44389228"
Message-ID: <547E7365.8090603@cn.fujitsu.com>
Date: Wed, 3 Dec 2014 10:20:21 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: <linux-mtd@lists.infradead.org>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <linux-kernel@vger.kernel.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [RESEND PATCH 3/3] mtd/mtdblock: introduce helper macro blktrans_dev_to_mtdblk
 to wrap the conversion (mtd_blktrans_dev to mtdblk_dev)
References: <1417052709-22026-1-git-send-email-guz.fnst@cn.fujitsu.com>
In-Reply-To: <1417052709-22026-1-git-send-email-guz.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper macro blktrans_dev_to_mtdblk to wrap the conversion
(mtd_blktrans_dev to mtdblk_dev), just cleanup.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/mtd/mtdblock.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index acc00f1..3af3d1c 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -50,6 +50,8 @@ struct mtdblk_dev {
 	enum CACHE_STATES cache_state;
 };
 
+#define blktrans_dev_to_mtdblk(dev) container_of(dev, struct mtdblk_dev, mbd)
+
 /*
  * Cache stuff...
  *
@@ -263,14 +265,16 @@ static int do_cached_read (struct mtdblk_dev *mtdblk, unsigned long pos,
 static int mtdblock_readsect(struct mtd_blktrans_dev *dev,
 			      unsigned long block, char *buf)
 {
-	struct mtdblk_dev *mtdblk = container_of(dev, struct mtdblk_dev, mbd);
+	struct mtdblk_dev *mtdblk = blktrans_dev_to_mtdblk(dev);
+
 	return do_cached_read(mtdblk, block<<9, 512, buf);
 }
 
 static int mtdblock_writesect(struct mtd_blktrans_dev *dev,
 			      unsigned long block, char *buf)
 {
-	struct mtdblk_dev *mtdblk = container_of(dev, struct mtdblk_dev, mbd);
+	struct mtdblk_dev *mtdblk = blktrans_dev_to_mtdblk(dev);
+
 	if (unlikely(!mtdblk->cache_data && mtdblk->cache_size)) {
 		mtdblk->cache_data = vmalloc(mtdblk->mbd.mtd->erasesize);
 		if (!mtdblk->cache_data)
@@ -285,7 +289,7 @@ static int mtdblock_writesect(struct mtd_blktrans_dev *dev,
 
 static int mtdblock_open(struct mtd_blktrans_dev *mbd)
 {
-	struct mtdblk_dev *mtdblk = container_of(mbd, struct mtdblk_dev, mbd);
+	struct mtdblk_dev *mtdblk = blktrans_dev_to_mtdblk(mbd);
 
 	pr_debug("mtdblock_open\n");
 
@@ -310,7 +314,7 @@ static int mtdblock_open(struct mtd_blktrans_dev *mbd)
 
 static void mtdblock_release(struct mtd_blktrans_dev *mbd)
 {
-	struct mtdblk_dev *mtdblk = container_of(mbd, struct mtdblk_dev, mbd);
+	struct mtdblk_dev *mtdblk = blktrans_dev_to_mtdblk(mbd);
 
 	pr_debug("mtdblock_release\n");
 
@@ -333,7 +337,7 @@ static void mtdblock_release(struct mtd_blktrans_dev *mbd)
 
 static int mtdblock_flush(struct mtd_blktrans_dev *dev)
 {
-	struct mtdblk_dev *mtdblk = container_of(dev, struct mtdblk_dev, mbd);
+	struct mtdblk_dev *mtdblk = blktrans_dev_to_mtdblk(dev);
 
 	mutex_lock(&mtdblk->cache_mutex);
 	write_cached_data(mtdblk);
-- 
1.7.7

.

