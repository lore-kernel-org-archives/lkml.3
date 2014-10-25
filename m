Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaJYThV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:37:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48783 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaJYThT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:37:19 -0400
X-AuditID: cbfee61a-f79c06d000004e71-29-544b6ced7cfd
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Nitin Gupta'" <ngupta@vflare.org>, "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: [PATCH 2/2] zram: avoid NULL pointer access when reading mem_used_total
Date: Sat, 25 Oct 2014 17:26:31 +0800
Message-id: <000101cff035$d9f50480$8ddf0d80$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/wNaMNZ2xp93u/SEKREQj2F1Ypzg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jAd13Od4hBi2z2C3mrF/DZnGhbTeL
	xeVdc9gs7q35z2qx7Ot7dosNINm1nx+zWzw58Z/FgcNj56y77B5PJxxk8ti0qpPNY9OnSewe
	J2b8ZvHY+Wkzq8fnTXIB7FFcNimpOZllqUX6dglcGUvmnGMt2MNZsfDNAcYGxpvsXYycHBIC
	JhI3J99mhbDFJC7cW8/WxcjFISSwiFHi5b/1TBDOH0aJlvOP2UCq2AS0Je72bwTrEBFQk1h3
	8AULSBGzwAYmiecPDzCBJIQFAiS+rJrKAmKzCKhK3P62C8zmFbCT2P77NZQtKPFj8j0gmwOo
	WV1iypRckDCzgLzE5jVvmUHCEkDhR391IVbpSVy9dJsFokRcYuORWywTGAVmIRk0C2HQLCSD
	ZiHpWMDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjODKeSe1gXNlgcYhRgINRiYdXgcU7
	RIg1say4MvcQowQHs5II7/wwoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6Yklqdmp
	qQWpRTBZJg5OqQZG2/a4vnSe0A/L13/y85rFk3+t46p7UtDTZZtfr3tV9baZpfnT67k92xzP
	rBe4cplF7/q2XXVxlz31hL5d6zS70t/zTN7c0WnCvsrSE3rLeH8oTfx5/db30DeKk6Juil3N
	sHZ6pHpp8u1pgv8kZh9grfu09+P/d/vM8raJz9Jf+sDm8ZTaQ0+PXFBiKc5INNRiLipOBAA8
	sKsOiAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a rare NULL pointer bug in mem_used_total_show() in concurrent
situation, like this:
zram is not initialized, process A is a mem_used_total reader which runs
periodicity, while process B try to init zram.

	process A 				process B
access meta, get a NULL value
						init zram, done
init_done() is true
access meta->mem_pool, get a NULL pointer BUG

This patch fixes this issue.
	
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 drivers/block/zram/zram_drv.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 64dd79a..2ffd7d8 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -99,11 +99,12 @@ static ssize_t mem_used_total_show(struct device *dev,
 {
 	u64 val = 0;
 	struct zram *zram = dev_to_zram(dev);
-	struct zram_meta *meta = zram->meta;
 
 	down_read(&zram->init_lock);
-	if (init_done(zram))
+	if (init_done(zram)) {
+		struct zram_meta *meta = zram->meta;
 		val = zs_get_total_pages(meta->mem_pool);
+	}
 	up_read(&zram->init_lock);
 
 	return scnprintf(buf, PAGE_SIZE, "%llu\n", val << PAGE_SHIFT);
-- 
1.7.0.4


