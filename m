Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaAMQkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:40:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53291 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbaAMQDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 101/208] staging: comedi: 8255_pci: fix for newer PCI-DIO48H
Date: Mon, 13 Jan 2014 15:59:02 +0000
Message-Id: <1389628849-1614-102-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers/8255_pci.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255_pci.c b/drivers/staging/comedi/drivers/8255_pci.c
index 3d3547c..3d40a26 100644
--- a/drivers/staging/comedi/drivers/8255_pci.c
+++ b/drivers/staging/comedi/drivers/8255_pci.c
@@ -62,7 +62,8 @@ enum pci_8255_boardid {
 	BOARD_ADLINK_PCI7296,
 	BOARD_CB_PCIDIO24,
 	BOARD_CB_PCIDIO24H,
-	BOARD_CB_PCIDIO48H,
+	BOARD_CB_PCIDIO48H_OLD,
+	BOARD_CB_PCIDIO48H_NEW,
 	BOARD_CB_PCIDIO96H,
 	BOARD_NI_PCIDIO96,
 	BOARD_NI_PCIDIO96B,
@@ -105,11 +106,16 @@ static const struct pci_8255_boardinfo pci_8255_boards[] = {
 		.dio_badr	= 2,
 		.n_8255		= 1,
 	},
-	[BOARD_CB_PCIDIO48H] = {
+	[BOARD_CB_PCIDIO48H_OLD] = {
 		.name		= "cb_pci-dio48h",
 		.dio_badr	= 1,
 		.n_8255		= 2,
 	},
+	[BOARD_CB_PCIDIO48H_NEW] = {
+		.name		= "cb_pci-dio48h",
+		.dio_badr	= 2,
+		.n_8255		= 2,
+	},
 	[BOARD_CB_PCIDIO96H] = {
 		.name		= "cb_pci-dio96h",
 		.dio_badr	= 2,
@@ -263,7 +269,10 @@ static DEFINE_PCI_DEVICE_TABLE(pci_8255_pci_table) = {
 	{ PCI_VDEVICE(ADLINK, 0x7296), BOARD_ADLINK_PCI7296 },
 	{ PCI_VDEVICE(CB, 0x0028), BOARD_CB_PCIDIO24 },
 	{ PCI_VDEVICE(CB, 0x0014), BOARD_CB_PCIDIO24H },
-	{ PCI_VDEVICE(CB, 0x000b), BOARD_CB_PCIDIO48H },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CB, 0x000b, 0x0000, 0x0000),
+	  .driver_data = BOARD_CB_PCIDIO48H_OLD },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CB, 0x000b, PCI_VENDOR_ID_CB, 0x000b),
+	  .driver_data = BOARD_CB_PCIDIO48H_NEW },
 	{ PCI_VDEVICE(CB, 0x0017), BOARD_CB_PCIDIO96H },
 	{ PCI_VDEVICE(NI, 0x0160), BOARD_NI_PCIDIO96 },
 	{ PCI_VDEVICE(NI, 0x1630), BOARD_NI_PCIDIO96B },
-- 
1.8.3.2

