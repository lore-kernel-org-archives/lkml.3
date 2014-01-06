Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbaAGAIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:08:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806AbaAFWi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [PATCH 3.12 010/144] staging: comedi: 8255_pci: fix for newer PCI-DIO48H
Date: Mon,  6 Jan 2014 14:36:11 -0800
Message-Id: <20140106223745.624215919@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/comedi/drivers/8255_pci.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/staging/comedi/drivers/8255_pci.c
+++ b/drivers/staging/comedi/drivers/8255_pci.c
@@ -63,7 +63,8 @@ enum pci_8255_boardid {
 	BOARD_ADLINK_PCI7296,
 	BOARD_CB_PCIDIO24,
 	BOARD_CB_PCIDIO24H,
-	BOARD_CB_PCIDIO48H,
+	BOARD_CB_PCIDIO48H_OLD,
+	BOARD_CB_PCIDIO48H_NEW,
 	BOARD_CB_PCIDIO96H,
 	BOARD_NI_PCIDIO96,
 	BOARD_NI_PCIDIO96B,
@@ -106,11 +107,16 @@ static const struct pci_8255_boardinfo p
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
@@ -263,7 +269,10 @@ static DEFINE_PCI_DEVICE_TABLE(pci_8255_
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


