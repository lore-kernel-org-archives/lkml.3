Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaJ0CEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:04:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25238 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaJ0CEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:04:23 -0400
X-AuditID: cbfee61a-f79c06d000004e71-c6-544da8250ef3
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Minchan Kim'" <minchan@kernel.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: [PATCH] zram: avoid NULL pointer access in concurrent situation
Date: Mon, 27 Oct 2014 10:03:19 +0800
Message-id: <000001cff18a$52d70d80$f8852880$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/xiVaxwYm37LuyRVuTX1E8eYk4tw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t9jQV3VFb4hBt8+KVnMWb+GzeJC224W
	i8u75rBZ3Fvzn9Vi2df37BYbWmaxW6z9/Jjd4smJ/ywOHB47Z91l93g64SCTx6ZVnWwemz5N
	Yvc4MeM3i8fOT5tZPT5vkgtgj+KySUnNySxLLdK3S+DKePSkja3gKV/F5oY+tgbGVp4uRg4O
	CQETiRtbnboYOYFMMYkL99azgdhCAtMZJZ6sL+5i5AKy/zBKrHz1iRkkwSagLXG3fyMrSK+I
	gL5EW4sGSA2zwFImibZ311hBaoQFPCS6eucxgtgsAqoSm07MBOvlFbCTuPVvCyuELSjxY/I9
	FpA5zALqElOm5IKEmQXkJTavecsMcZq6xKO/uiBhEQE9ibcHNzBBlIhLbDxyi2UCo8AsJINm
	IQyahWTQLCQdCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx8QzqR2MKxssDjEKcDAq
	8fBaFPqGCLEmlhVX5h5ilOBgVhLhFc0HCvGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQ
	nliSmp2aWpBaBJNl4uCUamDUrKicUFJzI+TTp9K6pCm7HxV99N4SdP1qTGSO9rOrz5YEtFg7
	76iqDfOsuvev1Kmp9ff3M5x2CSuvTriuumvfVsv7t47u5nywLjVkQqyz2sdP3QcN/pdLcaye
	eiPXZMOp/50sO/Ykxp37emfzZ7MVne2PzbsNZv37+fhyE6u/wdnbK49pVKaIKrEUZyQaajEX
	FScCANrKEXuFAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a rare NULL pointer bug in mem_used_total_show() and
mem_used_max_store() in concurrent situation, like this:

zram is not initialized, process A is a mem_used_total reader which runs
periodically, while process B try to init zram.

	process A 				process B
access meta, get a NULL value
						init zram, done
init_done() is true
access meta->mem_pool, get a NULL pointer BUG

This patch fixes this issue.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 0e63e8a..2ad0b5b 100644
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
@@ -173,16 +174,17 @@ static ssize_t mem_used_max_store(struct device *dev,
 	int err;
 	unsigned long val;
 	struct zram *zram = dev_to_zram(dev);
-	struct zram_meta *meta = zram->meta;
 
 	err = kstrtoul(buf, 10, &val);
 	if (err || val != 0)
 		return -EINVAL;
 
 	down_read(&zram->init_lock);
-	if (init_done(zram))
+	if (init_done(zram)) {
+		struct zram_meta *meta = zram->meta;
 		atomic_long_set(&zram->stats.max_used_pages,
 				zs_get_total_pages(meta->mem_pool));
+	}
 	up_read(&zram->init_lock);
 
 	return len;
-- 
1.7.0.4


