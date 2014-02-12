Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaBLIOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:14:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50337 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240AbaBLIOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:12 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, kernel-team@lists.ubuntu.com,
        "Ian Abbott" <abbotti@mev.co.uk>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.906388703@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 21/79] staging: comedi: cb_pcidio: fix for newer 
 PCI-DIO48H
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 0283f7a100882684ad32b768f9f1ad81658a0b92 upstream.

At some point, Measurement Computing / ComputerBoards redesigned the
PCI-DIO48H to use a PLX PCI interface chip instead of an AMCC chip.
This meant they had to put their hardware registers in the PCI BAR 2
region instead of PCI BAR 1.  Unfortunately, they kept the same PCI
device ID for the new design.  This means the driver recognizes the
newer cards, but doesn't work (and is likely to screw up the local
configuration registers of the PLX chip) because it's using the wrong
region.

Since all the supported boards have the DIO registers in the PCI BAR 2
region except for older PCI-DIO48H boards which have an empty PCI BAR 2
region and the DIO registers in PCI BAR 1, determine which PCI BAR
region to use based on whether the PCI BAR 2 region is empty or not.

This change makes the `dioregs_badrindex` member of `struct
pcidio_board` redundant.  The `pcicontroler_badrindex` member is also
unused, so remove both members.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Cc: kernel-team@lists.ubuntu.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/cb_pcidio.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 79477a5..b3c9c8f 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -56,10 +56,6 @@ struct pcidio_board {
 	const char *name;	/*  name of the board */
 	int dev_id;
 	int n_8255;		/*  number of 8255 chips on board */
-
-	/*  indices of base address regions */
-	int pcicontroler_badrindex;
-	int dioregs_badrindex;
 };
 
 static const struct pcidio_board pcidio_boards[] = {
@@ -67,22 +63,16 @@ static const struct pcidio_board pcidio_boards[] = {
 	 .name = "pci-dio24",
 	 .dev_id = 0x0028,
 	 .n_8255 = 1,
-	 .pcicontroler_badrindex = 1,
-	 .dioregs_badrindex = 2,
 	 },
 	{
 	 .name = "pci-dio24h",
 	 .dev_id = 0x0014,
 	 .n_8255 = 1,
-	 .pcicontroler_badrindex = 1,
-	 .dioregs_badrindex = 2,
 	 },
 	{
 	 .name = "pci-dio48h",
 	 .dev_id = 0x000b,
 	 .n_8255 = 2,
-	 .pcicontroler_badrindex = 0,
-	 .dioregs_badrindex = 1,
 	 },
 };
 
@@ -244,10 +234,15 @@ found:
 		    ("cb_pcidio: failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
-	devpriv->dio_reg_base
-	    =
+	/*
+	 * Use PCI BAR 2 region if non-zero length, else use PCI BAR 1 region.
+	 * PCI BAR 1 is only used for older PCI-DIO48H boards.  At some point
+	 * the PCI-DIO48H was redesigned to use the same PCI interface chip
+	 * (and same PCI BAR region) as the other boards.
+	 */
+	devpriv->dio_reg_base =
 	    pci_resource_start(devpriv->pci_dev,
-			       pcidio_boards[index].dioregs_badrindex);
+			       (pci_resource_len(pcidev, 2) ? 2 : 1));
 
 /*
  * Allocate the subdevice structures.  alloc_subdevice() is a

