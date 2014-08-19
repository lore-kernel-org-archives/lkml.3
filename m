Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaHSKfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 06:35:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18827 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaHSKfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 06:35:32 -0400
X-AuditID: cbfee61b-f79f86d00000144c-a8-53f3286ff4ff
From: Chao Yu <chao2.yu@samsung.com>
To: minchan@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org,
        "'Jerome Marchand'" <jmarchan@redhat.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: [PATCH v2] zram: add num_discards for discarded pages stat
Date: Tue, 19 Aug 2014 18:34:30 +0800
Message-id: <003501cfbb99$4abe9c70$e03bd550$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+7mHHrAeXpQAHGSOK7eI6X38WEVQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jQd18jc/BBj9a1S3mrF/DZnHqz3Um
	i8u75rBZ3Fvzn9Vi2df37BYbWmaxW6z9/Jjdgd1j56y77B6bVnWyeWz6NInd48SM3ywe7/dd
	ZfPY+Wkzq8fnTXIB7FFcNimpOZllqUX6dglcGZOOrWAquCZd8eTIE+YGxqniXYycHBICJhIt
	l5ayQdhiEhfurQeyuTiEBKYzSpz5+YAFwvnBKLFx7V0mkCo2ARWJ5R3/wWwRoI7HX36wgxQx
	C9xglLj58xgrSEJYwFniw70OsLEsAqoSyydNA7N5BSwlPj1fxg5hC0r8mHyPBcRmFtCS2Lyt
	iRXClpfYvOYtM8RJChI7zr5mhFimJ/FoWTc7RI24xMYjt1gmMArMQjJqFpJRs5CMmoWkZQEj
	yypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Kh4Jr2DcVWDxSFGAQ5GJR5ehS8fg4VYE8uK
	K3MPMUpwMCuJ8HZIfw4W4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUI
	JsvEwSnVwNhz9Mn1ypz4K7rL3I4c4dz2f0kMC5NJmuDvVMb04tTvhwr+p7w83KJ9gemvVizv
	uRdLWW8L80fZCPAZit5Y97/eg9GG5/7+d4cPZUXd733+MWVxeUPw7h07hFbmmtkyC826m7a1
	e9PV+YLzU/W+XZnFm6SzruDYufR3jjIxp6VTcxkfJ0hbpimxFGckGmoxFxUnAgCnNyShhgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have supported handling discard request which is sended by filesystem,
but no interface could be used to show information of discard.
This patch adds num_discards to stat discarded pages, then export it to sysfs
for displaying.

 v2: update zram document.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 Documentation/ABI/testing/sysfs-block-zram | 10 ++++++++++
 Documentation/blockdev/zram.txt            |  1 +
 drivers/block/zram/zram_drv.c              |  3 +++
 drivers/block/zram/zram_drv.h              |  1 +
 4 files changed, 15 insertions(+)

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
diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
index 0595c3f..e50e18b 100644
--- a/Documentation/blockdev/zram.txt
+++ b/Documentation/blockdev/zram.txt
@@ -89,6 +89,7 @@ size of the disk when not in use so a huge zram is wasteful.
 		num_writes
 		failed_reads
 		failed_writes
+		num_discards
 		invalid_io
 		notify_free
 		zero_pages
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


