Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab3FDQIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:08:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47968 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab3FDQIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:08:47 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/10] zram: avoid double free in function zram_bvec_write()
Date: Wed,  5 Jun 2013 00:06:03 +0800
Message-Id: <1370361968-8764-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing a patial write and the whole page is filled with zero,
zram_bvec_write() will free uncmem twice.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/zram/zram_drv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 88a53f4..6a54bb9 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -272,8 +272,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	if (page_zero_filled(uncmem)) {
 		kunmap_atomic(user_mem);
-		if (is_partial_io(bvec))
-			kfree(uncmem);
 		zram->stats.pages_zero++;
 		zram_set_flag(meta, index, ZRAM_ZERO);
 		ret = 0;
-- 
1.8.1.2

