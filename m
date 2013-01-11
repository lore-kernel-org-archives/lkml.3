Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab3AKNOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:14:06 -0500
Received: from masquerade.micron.com ([137.201.242.130]:13005 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab3AKNOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:14:03 -0500
Message-ID: <50F01010.4090306@micron.com>
Date: Fri, 11 Jan 2013 18:43:52 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw" <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: [PATCH 1/3] mtip32xx: add trim support
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19546.007
X-TM-AS-Result: No--18.988000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TRIM support added through vendor unique command.

Signed-off-by: Sam Bradshaw < sbradshaw@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   96 +++++++++++++++++++++++++++++++++++++
 drivers/block/mtip32xx/mtip32xx.h |   18 +++++++
 2 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index f946d31..b7e6631 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1487,6 +1487,12 @@ static int mtip_get_identify(struct mtip_port *port, void __user *user_buffer)
 	}
 #endif
 
+	/* Demux ID.DRAT & ID.RZAT to determine trim support */
+	if (port->identify[69] & (1 << 14) && port->identify[69] & (1 << 5))
+		port->dd->trim_supp = true;
+	else
+		port->dd->trim_supp = false;
+
 	/* Set the identify buffer as valid. */
 	port->identify_valid = 1;
 
@@ -1674,6 +1680,81 @@ static int mtip_get_smart_attr(struct mtip_port *port, unsigned int id,
 }
 
 /*
+ * Trim unused sectors
+ *
+ * @dd		pointer to driver_data structure
+ * @lba		starting lba
+ * @len		# of 512b sectors to trim
+ *
+ * return value
+ *      -ENOMEM		Out of dma memory
+ *      -EINVAL		Invalid parameters passed in, trim not supported
+ *      -EIO		Error submitting trim request to hw
+ */
+int mtip_send_trim(struct driver_data *dd, unsigned int lba, unsigned int len)
+{
+	int i, rv = 0;
+	u64 tlba, tlen, sect_left;
+	struct mtip_trim_entry *buf;
+	dma_addr_t dma_addr;
+	struct host_to_dev_fis fis;
+
+	if (!len || dd->trim_supp == false)
+		return -EINVAL;
+
+	/* Trim request too big */
+	WARN_ON(len > (MTIP_MAX_TRIM_ENTRY_LEN * MTIP_MAX_TRIM_ENTRIES));
+
+	/* Trim request not aligned on 4k boundary */
+	WARN_ON(len % 8 != 0);
+
+	/* Warn if vu_trim structure is too big */
+	WARN_ON(sizeof(struct mtip_trim) > ATA_SECT_SIZE);
+
+	/* Allocate a DMA buffer for the trim structure */
+	buf = dmam_alloc_coherent(&dd->pdev->dev, ATA_SECT_SIZE, &dma_addr,
+								GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	memset(buf, 0, ATA_SECT_SIZE);
+
+	for (i = 0, sect_left = len, tlba = lba;
+			i < MTIP_MAX_TRIM_ENTRIES && sect_left;
+			i++) {
+		tlen = (sect_left >= MTIP_MAX_TRIM_ENTRY_LEN ?
+					MTIP_MAX_TRIM_ENTRY_LEN :
+					sect_left);
+		buf[i].lba = __force_bit2int cpu_to_le32(tlba);
+		buf[i].range = __force_bit2int cpu_to_le16(tlen);
+		tlba += tlen;
+		sect_left -= tlen;
+	}
+	WARN_ON(sect_left != 0);
+
+	/* Build the fis */
+	memset(&fis, 0, sizeof(struct host_to_dev_fis));
+	fis.type       = 0x27;
+	fis.opts       = 1 << 7;
+	fis.command    = 0xfb;
+	fis.features   = 0x60;
+	fis.sect_count = 1;
+	fis.device     = ATA_DEVICE_OBS;
+
+	if (mtip_exec_internal_command(dd->port,
+					&fis,
+					5,
+					dma_addr,
+					ATA_SECT_SIZE,
+					0,
+					GFP_KERNEL,
+					MTIP_TRIM_TIMEOUT_MS) < 0)
+		rv = -EIO;
+
+	dmam_free_coherent(&dd->pdev->dev, ATA_SECT_SIZE, buf, dma_addr);
+	return rv;
+}
+
+/*
  * Get the drive capacity.
  *
  * @dd      Pointer to the device data structure.
@@ -3623,6 +3704,12 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 		}
 	}
 
+	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
+		bio_endio(bio, mtip_send_trim(dd, bio->bi_sector,
+						bio_sectors(bio)));
+		return;
+	}
+
 	if (unlikely(!bio_has_data(bio))) {
 		blk_queue_flush(queue, 0);
 		bio_endio(bio, 0);
@@ -3765,6 +3852,15 @@ skip_create_disk:
 	 */
 	blk_queue_flush(dd->queue, 0);
 
+	/* Signal trim support */
+	if (dd->trim_supp == true) {
+		set_bit(QUEUE_FLAG_DISCARD, &dd->queue->queue_flags);
+		dd->queue->limits.discard_granularity = 4096;
+		blk_queue_max_discard_sectors(dd->queue,
+			MTIP_MAX_TRIM_ENTRY_LEN * MTIP_MAX_TRIM_ENTRIES);
+		dd->queue->limits.discard_zeroes_data = 0;
+	}
+
 	/* Set the capacity of the device in 512 byte sectors. */
 	if (!(mtip_hw_get_capacity(dd, &capacity))) {
 		dev_warn(&dd->pdev->dev,
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 18627a1..6761202 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -161,6 +161,22 @@ __packed struct smart_attr{
 	u8 res[3];
 };
 
+
+#define MTIP_TRIM_TIMEOUT_MS		240000
+#define MTIP_MAX_TRIM_ENTRIES		8
+#define MTIP_MAX_TRIM_ENTRY_LEN 	0xfff8
+
+struct mtip_trim_entry {
+	u32 lba;   /* starting lba of region */
+	u16 rsvd;  /* unused */
+	u16 range; /* # of 512b blocks to trim */
+} __packed;
+
+struct mtip_trim {
+	/* Array of regions to trim */
+	struct mtip_trim_entry entry[MTIP_MAX_TRIM_ENTRIES];
+} __packed;
+
 /* Register Frame Information Structure (FIS), host to device. */
 struct host_to_dev_fis {
 	/*
@@ -458,6 +474,8 @@ struct driver_data {
 	struct task_struct *mtip_svc_handler; /* task_struct of svc thd */
 
 	struct dentry *dfs_node;
+
+	bool trim_supp; /* flag indicating trim support */
 };
 
 #endif
-- 
1.7.1

