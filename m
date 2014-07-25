Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbaGYJF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:05:29 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41165 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760097AbaGYJFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:22 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] staging: comedi: amplc_pc236: Simplify PCI board look-up
Date: Fri, 25 Jul 2014 10:04:56 +0100
Message-Id: <1406279098-8498-11-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since only a single PCI board is supported by the driver, there is no
need to call `pc236_find_pci_board()` to find the a board entry with
matching PCI device ID in `pc236_pci_boards[]`.  Just point to the entry
directly and remove the look-up function.  In fact, there is no reason
for `pc236_pci_boards[]` to be an array, so change it to a non-array
variable and rename it to `pc236_pci_board`.  Also, the `devid` member
of `struct pc236_board` is no longer needed as it was only used by the
look-up function, so remove it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 29 ++++------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 51c22f9..1aae066 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -85,7 +85,6 @@ enum pc236_bustype { isa_bustype, pci_bustype };
 
 struct pc236_board {
 	const char *name;
-	unsigned short devid;
 	enum pc236_bustype bustype;
 };
 
@@ -96,12 +95,9 @@ static const struct pc236_board pc236_isa_boards[] = {
 	},
 };
 
-static const struct pc236_board pc236_pci_boards[] = {
-	{
-		.name = "pci236",
-		.devid = PCI_DEVICE_ID_AMPLICON_PCI236,
-		.bustype = pci_bustype,
-	},
+static const struct pc236_board pc236_pci_board = {
+	.name = "pci236",
+	.bustype = pci_bustype,
 };
 
 struct pc236_private {
@@ -122,19 +118,6 @@ static inline bool is_pci_board(const struct pc236_board *board)
 }
 
 /*
- * This function looks for a board matching the supplied PCI device.
- */
-static const struct pc236_board *pc236_find_pci_board(struct pci_dev *pci_dev)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(pc236_pci_boards); i++)
-		if (pci_dev->device == pc236_pci_boards[i].devid)
-			return &pc236_pci_boards[i];
-	return NULL;
-}
-
-/*
  * This function is called to mark the interrupt as disabled (no command
  * configured on subdevice 1) and to physically disable the interrupt
  * (not possible on the PC36AT, except by removing the IRQ jumper!).
@@ -382,11 +365,7 @@ static int pc236_auto_attach(struct comedi_device *dev,
 	if (!devpriv)
 		return -ENOMEM;
 
-	dev->board_ptr = pc236_find_pci_board(pci_dev);
-	if (dev->board_ptr == NULL) {
-		dev_err(dev->class_dev, "BUG! cannot determine board type!\n");
-		return -EINVAL;
-	}
+	dev->board_ptr = &pc236_pci_board;
 	ret = comedi_pci_enable(dev);
 	if (ret)
 		return ret;
-- 
2.0.0

