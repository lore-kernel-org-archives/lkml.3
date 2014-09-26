Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbaIZWE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 18:04:59 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:36183 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbaIZWE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 18:04:57 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-ide@vger.kernel.org
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] libata-sff: Fix controllers with no ctl port
Date: Sat, 27 Sep 2014 00:04:46 +0200
Message-Id: <1411769086-12408-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, ata_sff_softreset is skipped for controllers with no ctl port.
But that also skips ata_sff_dev_classify required for device detection.
This means that libata is currently broken on controllers with no ctl port.

No device connected:
[    1.872480] pata_isapnp 01:01.02: activated
[    1.889823] scsi2 : pata_isapnp
[    1.890109] ata3: PATA max PIO0 cmd 0x1e8 ctl 0x0 irq 11
[    6.888110] ata3.01: qc timeout (cmd 0xec)
[    6.888179] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
[   16.888085] ata3.01: qc timeout (cmd 0xec)
[   16.888147] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
[   46.888086] ata3.01: qc timeout (cmd 0xec)
[   46.888148] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
[   51.888100] ata3.00: qc timeout (cmd 0xec)
[   51.888160] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[   61.888079] ata3.00: qc timeout (cmd 0xec)
[   61.888141] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[   91.888089] ata3.00: qc timeout (cmd 0xec)
[   91.888152] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x5)

ATAPI device connected:
[    1.882061] pata_isapnp 01:01.02: activated
[    1.893430] scsi2 : pata_isapnp
[    1.893719] ata3: PATA max PIO0 cmd 0x1e8 ctl 0x0 irq 11
[    6.892107] ata3.01: qc timeout (cmd 0xec)
[    6.892171] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
[   16.892079] ata3.01: qc timeout (cmd 0xec)
[   16.892138] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
[   46.892079] ata3.01: qc timeout (cmd 0xec)
[   46.892138] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
[   46.908586] ata3.00: ATAPI: ACER CD-767E/O, V1.5X, max PIO2, CDB intr
[   46.924570] ata3.00: configured for PIO0 (device error ignored)
[   46.926295] scsi 2:0:0:0: CD-ROM            ACER     CD-767E/O        1.5X PQ: 0 ANSI: 5
[   46.984519] sr0: scsi3-mmc drive: 6x/6x xa/form2 tray
[   46.984592] cdrom: Uniform CD-ROM driver Revision: 3.20

So don't skip ata_sff_softreset, just skip the reset part of ata_bus_softreset
if the ctl port is not available.

This makes IDE port on ES968 behave correctly:

No device connected:
[    4.670888] pata_isapnp 01:01.02: activated
[    4.673207] scsi host2: pata_isapnp
[    4.673675] ata3: PATA max PIO0 cmd 0x1e8 ctl 0x0 irq 11
[    7.081840] Adding 2541652k swap on /dev/sda2.  Priority:-1 extents:1 across:2541652k

ATAPI device connected:
[    4.704362] pata_isapnp 01:01.02: activated
[    4.706620] scsi host2: pata_isapnp
[    4.706877] ata3: PATA max PIO0 cmd 0x1e8 ctl 0x0 irq 11
[    4.872782] ata3.00: ATAPI: ACER CD-767E/O, V1.5X, max PIO2, CDB intr
[    4.888673] ata3.00: configured for PIO0 (device error ignored)
[    4.893984] scsi 2:0:0:0: CD-ROM            ACER     CD-767E/O        1.5X PQ: 0 ANSI: 5
[    7.015578] Adding 2541652k swap on /dev/sda2.  Priority:-1 extents:1 across:2541652k

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/ata/libata-sff.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 1121153..db90aa3 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2008,13 +2008,15 @@ static int ata_bus_softreset(struct ata_port *ap, unsigned int devmask,
 
 	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
 
-	/* software reset.  causes dev0 to be selected */
-	iowrite8(ap->ctl, ioaddr->ctl_addr);
-	udelay(20);	/* FIXME: flush */
-	iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
-	udelay(20);	/* FIXME: flush */
-	iowrite8(ap->ctl, ioaddr->ctl_addr);
-	ap->last_ctl = ap->ctl;
+	if (ap->ioaddr.ctl_addr) {
+		/* software reset.  causes dev0 to be selected */
+		iowrite8(ap->ctl, ioaddr->ctl_addr);
+		udelay(20);	/* FIXME: flush */
+		iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
+		udelay(20);	/* FIXME: flush */
+		iowrite8(ap->ctl, ioaddr->ctl_addr);
+		ap->last_ctl = ap->ctl;
+	}
 
 	/* wait the port to become ready */
 	return ata_sff_wait_after_reset(&ap->link, devmask, deadline);
@@ -2215,10 +2217,6 @@ void ata_sff_error_handler(struct ata_port *ap)
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	/* ignore ata_sff_softreset if ctl isn't accessible */
-	if (softreset == ata_sff_softreset && !ap->ioaddr.ctl_addr)
-		softreset = NULL;
-
 	/* ignore built-in hardresets if SCR access is not available */
 	if ((hardreset == sata_std_hardreset ||
 	     hardreset == sata_sff_hardreset) && !sata_scr_valid(&ap->link))
-- 
Ondrej Zary

