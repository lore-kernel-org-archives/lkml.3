Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaHKIkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:40:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13516 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaHKIkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:40:01 -0400
X-AuditID: cbfee61a-f79e46d00000134f-81-53e8815f3be3
From: Chao Yu <chao2.yu@samsung.com>
To: minchan@kernel.org, ngupta@vflare.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] zram: fix incorrectly stat with failed_reads
Date: Mon, 11 Aug 2014 16:39:17 +0800
Message-id: <000001cfb53f$d63b6ea0$82b24be0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+1P65V9xl+1nZ8QQ6LinFpjCg40w==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t9jQd2ExhfBBtNuMFtc3jWHzWLZ1/fs
	FhtaZrE7MHtsWtXJ5rHz02ZWj8+b5AKYo7hsUlJzMstSi/TtErgyjh75ylpwkLdi9uMzrA2M
	K7m7GDk5JARMJLbO38kOYYtJXLi3ng3EFhKYziixol+ji5ELyP7BKLFs2w1WkASbgIrE8o7/
	TCC2iICmxJ8DzWDNzAIKEr/ubQKq4eAQFrCVuDpBFyTMIqAqsaXzNwuIzStgKbF2+lpmCFtQ
	4sfkeywQrVoS63ceZ4Kw5SU2r3nLDHGPgsSOs68ZIVbpSaw8vR+qRlxi45FbLBMYBWYhGTUL
	yahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw+D6T2sG4ssHiEKMAB6MS
	D+/BL8+DhVgTy4orcw8xSnAwK4nw/rR4ESzEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQ
	QHpiSWp2ampBahFMlomDU6qBcVn+FAHxE3Lb/85wibOV0L20K6jdX8haPk/ziIWNn4jsc/lF
	1o6relbs+fZcJtBPRsLONCWCqeTWh+Ky0K5srVdTns70mapVxWe+/XHxtAvP7uuuWvS153vW
	wncqs2MSi7gtvXcmh79MO+62+WiT2gVt5/caMaySr3fH6bFz7lmn/mm64KRPSizFGYmGWsxF
	xYkAgTOWGFsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we allocate a temporary buffer in zram_bvec_read to handle partial page
operations in this commit 924bd88d703e53d30f393fac6117f8f1bc79aab6 (Staging:
zram: allow partial page operations), our ->failed_reads value may be incorrect
as we do not increase its value when failed to allocate the temporary buffer.

Let's fix this issue and correct the annotation of failed_reads.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 drivers/block/zram/zram_drv.c | 1 +
 drivers/block/zram/zram_drv.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index dfa4024..bf8ea1b 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -413,6 +413,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 
 	if (!uncmem) {
 		pr_info("Unable to allocate temp memory\n");
+		atomic64_inc(&zram->stats.failed_reads);
 		ret = -ENOMEM;
 		goto out_cleanup;
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


