Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab3KURem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:34:42 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51161 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3KURej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:34:39 -0500
Date: Thu, 21 Nov 2013 09:34:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>, linux-aio@kvack.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] direct IO support for loop driver
Message-ID: <20131121173432.GA11984@infradead.org>
References: <528A648F.1030007@oracle.com>
 <CA+55aFyF-Za7B=1kVDodbn942hETsWixAHCsh_wBA1b6pnUigQ@mail.gmail.com>
 <20131121095837.GB18232@infradead.org>
 <20131121100609.GB17871@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121100609.GB17871@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find the target one below.  I haven't found the ecryptfs work, but it
is a lot more involved as it only wants to use direct I/O, not aio.

--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -31,6 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/module.h>
 #include <linux/falloc.h>
+#include <linux/blk_types.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <asm/unaligned.h>
@@ -120,6 +121,8 @@ static int fd_configure_device(struct se_device *dev)
 	 * of pure timestamp updates.
 	 */
 	flags = O_RDWR | O_CREAT | O_LARGEFILE | O_DSYNC;
+	if (1)
+		flags |= O_DIRECT;
 
 	/*
 	 * Optionally allow fd_buffered_io=1 to be enabled for people
@@ -546,6 +549,61 @@ fd_execute_unmap(struct se_cmd *cmd)
 	return sbc_execute_unmap(cmd, fd_do_unmap, file);
 }
 
+static void fd_rw_aio_complete(u64 data, long res)
+{
+	struct se_cmd *cmd = (struct se_cmd *)(uintptr_t)data;
+
+	kfree(cmd->priv);
+
+	if (res < 0)
+		target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION);
+	else
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
+}
+
+static sense_reason_t
+fd_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
+	      enum dma_data_direction data_direction)
+{
+	struct se_device *se_dev = cmd->se_dev;
+	struct fd_dev *dev = FD_DEV(se_dev);
+	struct file *file = dev->fd_file;
+	struct scatterlist *sg;
+	struct kiocb *iocb;
+	unsigned int op;
+	struct iov_iter iter;
+	struct bio_vec *bvec;
+	loff_t pos = (cmd->t_task_lba * se_dev->dev_attrib.block_size);
+	int i;
+
+	iocb = aio_kernel_alloc(GFP_NOIO);
+	if (!iocb)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	
+	if (data_direction == DMA_TO_DEVICE)
+		op = IOCB_CMD_WRITE_ITER;
+	else
+		op = IOCB_CMD_READ_ITER;
+
+	bvec = cmd->priv = kcalloc(sgl_nents, sizeof(struct bio_vec), GFP_NOIO);
+	if (!bvec) {
+		aio_kernel_free(iocb);
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	for_each_sg(sgl, sg, sgl_nents, i) {
+		bvec[i].bv_page = sg_page(sg);
+		bvec[i].bv_len = sg->length;
+		bvec[i].bv_offset = sg->offset;
+	}
+
+	iov_iter_init_bvec(&iter, bvec, sgl_nents, bvec_length(bvec, sgl_nents), 0);
+	aio_kernel_init_rw(iocb, file, iov_iter_count(&iter), pos);
+	aio_kernel_init_callback(iocb, fd_rw_aio_complete, (u64)(uintptr_t)bvec);
+
+	return aio_kernel_submit(iocb, op, &iter);
+}
+
 static sense_reason_t
 fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	      enum dma_data_direction data_direction)
@@ -553,6 +611,9 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	struct se_device *dev = cmd->se_dev;
 	int ret = 0;
 
+	if (1)
+		return fd_rw_aio(cmd, sgl, sgl_nents, data_direction);
+
 	/*
 	 * Call vectorized fileio functions to map struct scatterlist
 	 * physical memory addresses to struct iovec virtual memory.
