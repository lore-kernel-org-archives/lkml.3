Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbaGYJFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:05:31 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41163 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760096AbaGYJFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:21 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] staging: comedi: amplc_pc236: don't check bus type in attach
Date: Fri, 25 Jul 2014 10:04:55 +0100
Message-Id: <1406279098-8498-10-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the legacy attach routine `pc236_attach()` is only called for
board names matching an entry in our array of ISA boards
`pc236_isa_boards[]`, and it is reasonable to expect all elements of
`pc236_isa_boards[]` to have their `bustype` member initialized
correctly to `isa_bustype`, don't bother checking the bus type in
`pc236_attach()`.  Add `if (!DO_ISA) return -EINVAL` to optimize out the
remainder of the function if `CONFIG_COMEDI_AMPLC_PC236_ISA` is not
defined.

Similarly, don't bother checking the bus type in
`pc236_find_pci_board()` as it is reasonable to expect all elements of
`pc236_pci_boards[]` to have their `bustype` member initialized
correctly to `pci_bustype`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 0a5ba10..51c22f9 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -129,8 +129,7 @@ static const struct pc236_board *pc236_find_pci_board(struct pci_dev *pci_dev)
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(pc236_pci_boards); i++)
-		if (is_pci_board(&pc236_pci_boards[i]) &&
-		    pci_dev->device == pc236_pci_boards[i].devid)
+		if (pci_dev->device == pc236_pci_boards[i].devid)
 			return &pc236_pci_boards[i];
 	return NULL;
 }
@@ -349,30 +348,21 @@ static int pc236_common_attach(struct comedi_device *dev, unsigned long iobase,
 
 static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	const struct pc236_board *thisboard = comedi_board(dev);
 	struct pc236_private *devpriv;
 	int ret;
 
+	if (!DO_ISA)
+		return -EINVAL;
+
 	devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
 	if (!devpriv)
 		return -ENOMEM;
 
-	/* Process options according to bus type. */
-	if (is_isa_board(thisboard)) {
-		ret = comedi_request_region(dev, it->options[0], 0x4);
-		if (ret)
-			return ret;
-
-		return pc236_common_attach(dev, dev->iobase, it->options[1], 0);
-	} else if (is_pci_board(thisboard)) {
-		dev_err(dev->class_dev,
-			"Manual configuration of PCI board '%s' is not supported\n",
-			thisboard->name);
-		return -EIO;
-	}
+	ret = comedi_request_region(dev, it->options[0], 0x4);
+	if (ret)
+		return ret;
 
-	dev_err(dev->class_dev, "BUG! cannot determine board type!\n");
-	return -EINVAL;
+	return pc236_common_attach(dev, dev->iobase, it->options[1], 0);
 }
 
 static int pc236_auto_attach(struct comedi_device *dev,
-- 
2.0.0

