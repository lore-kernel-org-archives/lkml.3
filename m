Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbaGYJHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:07:34 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41156 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759796AbaGYJFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:21 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] staging: comedi: amplc_pc236: split pc236_boards[] into ISA & PCI
Date: Fri, 25 Jul 2014 10:04:54 +0100
Message-Id: <1406279098-8498-9-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split `pc236_boards[]` into `pc236_isa_boards[]` for ISA cards and
`pc236_pci_boards[]` for PCI cards (there is only one of each).  Only
initialize the board name look-up members of `struct comedi_driver
amplc_pc236_driver` if the ISA part of the driver is enabled in the
kernel config (`CONFIG_COMEDI_AMPLC_PC236_ISA`) using the array of ISA
boards (`pc236_isa_boards[]`).  The driver doesn't allow manual
configuration of PCI devices, so there is no point having the comedi
core match the names of the PCI boards before it calls our driver's
legacy attach routine (`pc236_attach()`).

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 129578f..0a5ba10 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -88,20 +88,20 @@ struct pc236_board {
 	unsigned short devid;
 	enum pc236_bustype bustype;
 };
-static const struct pc236_board pc236_boards[] = {
-#if DO_ISA
+
+static const struct pc236_board pc236_isa_boards[] = {
 	{
 		.name = "pc36at",
 		.bustype = isa_bustype,
 	},
-#endif
-#if DO_PCI
+};
+
+static const struct pc236_board pc236_pci_boards[] = {
 	{
 		.name = "pci236",
 		.devid = PCI_DEVICE_ID_AMPLICON_PCI236,
 		.bustype = pci_bustype,
 	},
-#endif
 };
 
 struct pc236_private {
@@ -128,10 +128,10 @@ static const struct pc236_board *pc236_find_pci_board(struct pci_dev *pci_dev)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(pc236_boards); i++)
-		if (is_pci_board(&pc236_boards[i]) &&
-		    pci_dev->device == pc236_boards[i].devid)
-			return &pc236_boards[i];
+	for (i = 0; i < ARRAY_SIZE(pc236_pci_boards); i++)
+		if (is_pci_board(&pc236_pci_boards[i]) &&
+		    pci_dev->device == pc236_pci_boards[i].devid)
+			return &pc236_pci_boards[i];
 	return NULL;
 }
 
@@ -429,9 +429,11 @@ static struct comedi_driver amplc_pc236_driver = {
 	.attach = pc236_attach,
 	.auto_attach = pc236_auto_attach,
 	.detach = pc236_detach,
-	.board_name = &pc236_boards[0].name,
+#if DO_ISA
+	.board_name = &pc236_isa_boards[0].name,
 	.offset = sizeof(struct pc236_board),
-	.num_names = ARRAY_SIZE(pc236_boards),
+	.num_names = ARRAY_SIZE(pc236_isa_boards),
+#endif
 };
 
 #if DO_PCI
-- 
2.0.0

