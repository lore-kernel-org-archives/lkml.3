Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbaHVIW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:22:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11296 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaHVIWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:22:24 -0400
X-AuditID: cbfee61a-f79e46d00000134f-d7-53f6fdb21952
From: Chao Yu <chao2.yu@samsung.com>
To: minchan@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org,
        "'Jerome Marchand'" <jmarchan@redhat.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: [PATCH v3] zram: add num_discards for discarded pages stat
Date: Fri, 22 Aug 2014 16:21:01 +0800
Message-id: <000201cfbde2$2ae08710$80a19530$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+91sMbbhPLxeHVS1Gw3Vk4S34MbQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9jAd1Nf78FG2w+JG8xZ/0aNotTf64z
	WVzeNYfN4t6a/6wWy76+Z7fY0DKL3WLt58fsDuweO2fdZffYtKqTzWPTp0nsHidm/GbxeL/v
	KpvHzk+bWT0+b5ILYI/isklJzcksSy3St0vgypjY2sZe8EmuomFeC0sD42PJLkYODgkBE4kt
	80K7GDmBTDGJC/fWs4HYQgKLGCWmn4/pYuQCsn8wShyefY4JJMEmoCKxvOM/mC0C1PD4yw92
	kCJmgRuMEjd/HmMFSQgLOEs83v2AHcRmEVCVuNLyFyzOK2Ap8aJtKTuELSjxY/I9FhCbWUBL
	Yv3O40wQtrzE5jVvmSEuUpDYcfY1I8QyPYmG2XMYIWrEJTYeucUygVFgFpJRs5CMmoVk1Cwk
	LQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEfEM6kdjCsbLA4xCnAwKvHwRnz5GizE
	mlhWXJl7iFGCg1lJhHfTvG/BQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqem
	FqQWwWSZODilGhhZ9+XOfXsqXyB2Kn+X1jKWd8+rl8y+WhItmK3HLy0gO62xdvqrxUfj9H6x
	v5zBftkpt/iqiOfFEyYz97xj6zCbcefM7unqB154q7+9wP7/1tH3gQVvYp8eCObalXvT8aLH
	kdYDaTP9bNV+Pi3K/W0f4nf0rYdxRc6vwp4LjXO6LJLTHwp/NbioxFKckWioxVxUnAgAeNSP
	vYQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have supported handling discard request in this commit
f4659d8e620d08bd1a84a8aec5d2f5294a242764 (zram: support REQ_DISCARD), zram got
one more chance to free unused memory whenever received discard request. But
without stating for discard request, there is no method for user to know whether
discard request has been handled by zram or how many blocks were discarded by
zram when user wants to know the effect of discard.

In this patch, we add num_discards to stat discarded pages, and export it to
sysfs for users.

* From v1
 * Update zram document to show num_discards in statistics list.

* From v2
 * Update description of this patch with clear goal.

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


