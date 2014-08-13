Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaHMCCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 22:02:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18417 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaHMCCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 22:02:42 -0400
X-AuditID: cbfee61a-f79e46d00000134f-8f-53eac73ee6dc
From: Chao Yu <chao2.yu@samsung.com>
To: minchan@kernel.org
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        "'Jerome Marchand'" <jmarchan@redhat.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: [PATCH v2] zram: fix incorrectly stat with failed_reads
Date: Wed, 13 Aug 2014 10:01:45 +0800
Message-id: <009001cfb69a$a8470840$f8d518c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+2lVbnDu0zflRtTGWlaMj1gTdWhg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t9jAV2746+CDW7/krKYs34Nm8WpP9eZ
	LC7vmsNmsezre3aLDS2z2C3Wfn7M7sDmsXPWXXaPTas62TxOzPjN4vF+31Wg2KfNrB6fN8kF
	sEVx2aSk5mSWpRbp2yVwZXw7wVKwT7ji9MGp7A2MfQJdjJwcEgImEtt/3WGCsMUkLtxbz9bF
	yMUhJLCIUWJ7wwVGCOcHo8T3WVcZQarYBFQklnf8B+sQAep4/OUHO0gRs8ARRomWv4fZQRLC
	Ag4SWw8uACtiEVCV6G6cAmbzClhKPPt1iA3CFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zBAn
	KUjsOPuaEWKZnsTy3kdQNeISG4/cYpnAKDALyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN
	9YoTc4tL89L1kvNzNzGCw/+Z1A7GlQ0WhxgFOBiVeHgreF8FC7EmlhVX5h5ilOBgVhLhddgC
	FOJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cCooivIHHX0
	wVTriRP3fl/fcOgu665XF9+mOTcGeGarnXf+NCMwYyKvgUXTSqP5l71EXuzUP9bplrTWL+LI
	5sv3Z0yYEBPy5cGqFT3rZx5c0nGJm7/6wiv5VRzilYdkp3JoZUxU96zJ/fy7/ZWcUplrU4c9
	s+yq07qyOidXcj5Xy9j/MktmjvxMJZbijERDLeai4kQAbhWoH3sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we allocate a temporary buffer in zram_bvec_read to handle partial page
operations in this commit 924bd88d703e53d30f393fac6117f8f1bc79aab6 (Staging:
zram: allow partial page operations), our ->failed_reads value may be incorrect
as we do not increase its value when failed to allocate the temporary buffer.

Let's fix this issue and correct the annotation of failed_reads.

 v2: clean codes of failed_{reads,writes} stat pointed out by Minchan Kim, and
this cleanup also fix incorrectly stat when fail in zram_decompress_page.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 drivers/block/zram/zram_drv.c | 10 +++++++---
 drivers/block/zram/zram_drv.h |  2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index dfa4024..d00831c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -378,7 +378,6 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret)) {
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
-		atomic64_inc(&zram->stats.failed_reads);
 		return ret;
 	}
 
@@ -547,8 +546,6 @@ out:
 		zcomp_strm_release(zram->comp, zstrm);
 	if (is_partial_io(bvec))
 		kfree(uncmem);
-	if (ret)
-		atomic64_inc(&zram->stats.failed_writes);
 	return ret;
 }
 
@@ -566,6 +563,13 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 		ret = zram_bvec_write(zram, bvec, index, offset);
 	}
 
+	if (unlikely(ret)) {
+		if (rw == READ)
+			atomic64_inc(&zram->stats.failed_reads);
+		else
+			atomic64_inc(&zram->stats.failed_writes);
+	}
+
 	return ret;
 }
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 5b0afde..e0f725c 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -84,7 +84,7 @@ struct zram_stats {
 	atomic64_t compr_data_size;	/* compressed size of pages stored */
 	atomic64_t num_reads;	/* failed + successful */
 	atomic64_t num_writes;	/* --do-- */
-	atomic64_t failed_reads;	/* should NEVER! happen */
+	atomic64_t failed_reads;	/* can happen when memory is too low */
 	atomic64_t failed_writes;	/* can happen when memory is too low */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
-- 
2.0.1.474.g72c7794


