Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaHOD2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 23:28:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33130 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaHOD2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 23:28:35 -0400
X-AuditID: cbfee61b-f79f86d00000144c-e1-53ed7e5c2f5e
From: Chao Yu <chao2.yu@samsung.com>
To: minchan@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org,
        "'Jerome Marchand'" <jmarchan@redhat.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: [PATCH] zram: add num_discards for discarded pages stat
Date: Fri, 15 Aug 2014 11:27:04 +0800
Message-id: <001201cfb838$fb0ac4a0$f1204de0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+4LI5qxuk9xgY7Qz+wjUI8Ul/WKw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t9jAd2YurfBBnOv61rMWb+GzeLUn+tM
	Fpd3zWGzuLfmP6vFsq/v2S02tMxit1j7+TG7A7vHzll32T02repk89j0aRK7x4kZv1k83u+7
	yuax89NmVo/Pm+QC2KO4bFJSczLLUov07RK4MtqPXWAvaJOoOLp7PXMD42KRLkZODgkBE4ll
	hz8yQthiEhfurWfrYuTiEBJYxCix/u4SKOcHo8TB6xvAqtgEVCSWd/xnArFFgDoef/nBDlLE
	LHCDUeLmz2OsIAlhAQeJjX9msoHYLAKqEm0LPjJ3MXJw8ApYSrw7qgAS5hUQlPgx+R4LiM0s
	oCWxfudxJghbXmLzmrfMEBcpSOw4+5oRYpeexO1779kgasQlNh65xTKBUWAWklGzkIyahWTU
	LCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx8Qz6R2MqxosDjEKcDAq8fA2bH8T
	LMSaWFZcmXuIUYKDWUmEt5z1bbAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZ
	qakFqUUwWSYOTqkGxg19eY7srb3L7xlyGavH17mfPbikO/+Ujt1848y0bQubmny+Xlp5pkiE
	wylvkti0ueplYjrlPzxkprOJS8Y8CFZj3+olfz+49u/V/THnvDZ9Ewla/8H2rHWZ14Xv3XeM
	zIN+7CxfyPBKt2gOb9aZV6ffPfU+NW3Z5leRdyQ3/X0h9ibosGTwbyWW4oxEQy3mouJEABuv
	Iv6FAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have supported handling discard request which is sended by filesystem,
but no interface could be used to show information of discard.
This patch adds num_discards to stat discarded pages, then export it to sysfs
for displaying.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 Documentation/ABI/testing/sysfs-block-zram | 10 ++++++++++
 drivers/block/zram/zram_drv.c              |  3 +++
 drivers/block/zram/zram_drv.h              |  1 +
 3 files changed, 14 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block-zram b/Documentation/ABI/testing/sysfs-block-zram
index 70ec992..fa8936e 100644
--- a/Documentation/ABI/testing/sysfs-block-zram
+++ b/Documentation/ABI/testing/sysfs-block-zram
@@ -57,6 +57,16 @@ Description:
 		The failed_writes file is read-only and specifies the number of
 		failed writes happened on this device.
 
+
+What:		/sys/block/zram<id>/num_discards
+Date:		August 2014
+Contact:	Chao Yu <chao2.yu@samsung.com>
+Description:
+		The num_discards file is read-only and specifies the number of
+		physical blocks which are discarded by this device. These blocks
+		are included in discard request which is sended by filesystem as
+		the blocks are no longer used.
+
 What:		/sys/block/zram<id>/max_comp_streams
 Date:		February 2014
 Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d00831c..904e7a5 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -606,6 +606,7 @@ static void zram_bio_discard(struct zram *zram, u32 index,
 		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 		zram_free_page(zram, index);
 		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+		atomic64_inc(&zram->stats.num_discards);
 		index++;
 		n -= PAGE_SIZE;
 	}
@@ -866,6 +867,7 @@ ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
 ZRAM_ATTR_RO(failed_reads);
 ZRAM_ATTR_RO(failed_writes);
+ZRAM_ATTR_RO(num_discards);
 ZRAM_ATTR_RO(invalid_io);
 ZRAM_ATTR_RO(notify_free);
 ZRAM_ATTR_RO(zero_pages);
@@ -879,6 +881,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_num_writes.attr,
 	&dev_attr_failed_reads.attr,
 	&dev_attr_failed_writes.attr,
+	&dev_attr_num_discards.attr,
 	&dev_attr_invalid_io.attr,
 	&dev_attr_notify_free.attr,
 	&dev_attr_zero_pages.attr,
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index e0f725c..2994aaf 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -86,6 +86,7 @@ struct zram_stats {
 	atomic64_t num_writes;	/* --do-- */
 	atomic64_t failed_reads;	/* can happen when memory is too low */
 	atomic64_t failed_writes;	/* can happen when memory is too low */
+	atomic64_t num_discards;	/* no. of discarded pages */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
 	atomic64_t zero_pages;		/* no. of zero filled pages */
-- 
2.0.1.474.g72c7794


