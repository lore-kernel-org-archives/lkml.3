Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaKZUiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:38:15 -0500
Received: from ns.gsystem.sk ([62.176.172.50]:33153 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaKZUiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:38:14 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] wd719x: remove dma_cache_sync call
Date: Wed, 26 Nov 2014 21:37:57 +0100
Message-Id: <1417034277-14412-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_cache_sync() call breaks build on some architectures and
Arnd Bergmann said:
> dma_cache_sync only makes sense with buffers allocated through
> dma_alloc_noncoherent(), which this one is not. I suspect we can just
> remove the call to dma_cache_sync here, in particular since the
> buffer is passed to the device next, and dma_map_single has
> already done all the necessary synchronization.

Remove dma_cache_sync call to fix build on other architectures.
Driver still works fine on x86 without that.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/wd719x.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 23bb5a3..170f228 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -243,8 +243,6 @@ static int wd719x_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	scb->sense_buf_length = SCSI_SENSE_BUFFERSIZE;
 	cmd->SCp.dma_handle = dma_map_single(&wd->pdev->dev, cmd->sense_buffer,
 			SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
-	dma_cache_sync(&wd->pdev->dev, cmd->sense_buffer,
-			SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 	scb->sense_buf = cpu_to_le32(cmd->SCp.dma_handle);
 
 	/* request autosense */
-- 
Ondrej Zary

