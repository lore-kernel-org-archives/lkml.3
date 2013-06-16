Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab3FPWNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:13:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46307 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755546Ab3FPWJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>,
        "Vincent Pelletier" <plr.vincent@gmail.com>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.653588311@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [03/83] libata: make ata_exec_internal_sg honor DMADIR
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Pelletier <plr.vincent@gmail.com>

commit e771451c0a831d96a7c14b0ca8a8ec671d98567b upstream.

libata honors DMADIR for regular commands, but not for internal commands
used (among other) during device initialisation.

This makes SATA-host-to-PATA-device bridges based on Silicon Image SiL3611
(such as "Abit Serillel 2") end up disabled when used with an ATAPI device
after a few tries.

Log output of the bridge being hot-plugged with an ATAPI drive:

  [ 9631.212901] ata1: exception Emask 0x10 SAct 0x0 SErr 0x40c0000 action 0xe frozen
  [ 9631.212913] ata1: irq_stat 0x00000040, connection status changed
  [ 9631.212923] ata1: SError: { CommWake 10B8B DevExch }
  [ 9631.212939] ata1: hard resetting link
  [ 9632.104962] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
  [ 9632.106393] ata1.00: ATAPI: PIONEER DVD-RW  DVR-115, 1.06, max UDMA/33
  [ 9632.106407] ata1.00: applying bridge limits
  [ 9632.108151] ata1.00: configured for UDMA/33
  [ 9637.105303] ata1.00: qc timeout (cmd 0xa0)
  [ 9637.105324] ata1.00: failed to clear UNIT ATTENTION (err_mask=0x5)
  [ 9637.105335] ata1: hard resetting link
  [ 9638.044599] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
  [ 9638.047878] ata1.00: configured for UDMA/33
  [ 9643.044933] ata1.00: qc timeout (cmd 0xa0)
  [ 9643.044953] ata1.00: failed to clear UNIT ATTENTION (err_mask=0x5)
  [ 9643.044963] ata1: limiting SATA link speed to 1.5 Gbps
  [ 9643.044971] ata1.00: limiting speed to UDMA/33:PIO3
  [ 9643.044979] ata1: hard resetting link
  [ 9643.984225] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
  [ 9643.987471] ata1.00: configured for UDMA/33
  [ 9648.984591] ata1.00: qc timeout (cmd 0xa0)
  [ 9648.984612] ata1.00: failed to clear UNIT ATTENTION (err_mask=0x5)
  [ 9648.984619] ata1.00: disabled
  [ 9649.000593] ata1: hard resetting link
  [ 9649.939902] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
  [ 9649.955864] ata1: EH complete

With this patch, the drive enumerates correctly when libata is loaded with
atapi_dmadir=1:

  [ 9891.810863] ata1: exception Emask 0x10 SAct 0x0 SErr 0x40c0000 action 0xe frozen
  [ 9891.810874] ata1: irq_stat 0x00000040, connection status changed
  [ 9891.810884] ata1: SError: { CommWake 10B8B DevExch }
  [ 9891.810900] ata1: hard resetting link
  [ 9892.762105] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
  [ 9892.763544] ata1.00: ATAPI: PIONEER DVD-RW  DVR-115, 1.06, max UDMA/33, DMADIR
  [ 9892.763558] ata1.00: applying bridge limits
  [ 9892.765393] ata1.00: configured for UDMA/33
  [ 9892.786063] ata1: EH complete
  [ 9892.792062] scsi 0:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-115  1.06 PQ: 0 ANSI: 5
  [ 9892.798455] sr2: scsi3-mmc drive: 12x/12x writer dvd-ram cd/rw xa/form2 cdda tray
  [ 9892.798837] sr 0:0:0:0: Attached scsi CD-ROM sr2
  [ 9892.799109] sr 0:0:0:0: Attached scsi generic sg6 type 5

Based on a patch by Csaba Halász <csaba.halasz@gmail.com> on linux-ide:
http://marc.info/?l=linux-ide&m=136121147832295&w=2

tj: minor formatting changes.

Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/libata-core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1598,6 +1598,12 @@ unsigned ata_exec_internal_sg(struct ata
 	qc->tf = *tf;
 	if (cdb)
 		memcpy(qc->cdb, cdb, ATAPI_CDB_LEN);
+
+	/* some SATA bridges need us to indicate data xfer direction */
+	if (tf->protocol == ATAPI_PROT_DMA && (dev->flags & ATA_DFLAG_DMADIR) &&
+	    dma_dir == DMA_FROM_DEVICE)
+		qc->tf.feature |= ATAPI_DMADIR;
+
 	qc->flags |= ATA_QCFLAG_RESULT_TF;
 	qc->dma_dir = dma_dir;
 	if (dma_dir != DMA_NONE) {

