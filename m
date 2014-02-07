Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaBGLYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:24:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40848 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaBGLXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:23:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 11/88] staging: comedi: 8255_pci: fix for newer PCI-DIO48H
Date: Fri,  7 Feb 2014 11:22:08 +0000
Message-Id: <1391772205-22239-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

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

Since  the PCI subvendor and subdevice IDs were both zero on the old
design, but are the same as the vendor and device on the new design, we
can tell the old design and new design apart easily enough.  Split the
existing entry for the PCI-DIO48H in `pci_8255_boards[]` into two new
entries, referenced by different entries in the PCI device ID table
`pci_8255_pci_table[]`.  Use the same board name for both entries.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Ian: Applies to 3.4.y and 3.5.y (Ubuntu Extended Stable).
  Note that other changes make this patch somewhat different to the
  upstream commit, but it fixes the same problem. ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers/cb_pcidio.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 713132c..d4f7fda 100644
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
 
@@ -173,10 +163,15 @@ found:
 	if (comedi_pci_enable(pcidev, thisboard->name))
 		return -EIO;
 
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
-- 
1.8.3.2

