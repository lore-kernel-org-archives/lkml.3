Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934658AbaGYRHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:07:30 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:43474 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbaGYRH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:07:27 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging: comedi: amplc_dio200_pci: no need to test board pointer in dio200_pci_detach()
Date: Fri, 25 Jul 2014 18:07:09 +0100
Message-Id: <1406308029-15712-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406308029-15712-1-git-send-email-abbotti@mev.co.uk>
References: <1406308029-15712-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`dio200_pci_detach()` doesn't need to check if the pointer to constant
board data (`thisboard`) and the pointer to private per-device data
(`devpriv`) are valid before calling `amplc_dio200_common_detach()`.  It
has no further need to check `thisboard` so remove the variable
altogether.  Move the test of `devpriv` to the first point it is needs
to be valid.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_dio200_pci.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_dio200_pci.c b/drivers/staging/comedi/drivers/amplc_dio200_pci.c
index 3cec0e0..1954c1b 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200_pci.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200_pci.c
@@ -414,13 +414,10 @@ static int dio200_pci_auto_attach(struct comedi_device *dev,
 
 static void dio200_pci_detach(struct comedi_device *dev)
 {
-	const struct dio200_board *thisboard = comedi_board(dev);
 	struct dio200_private *devpriv = dev->private;
 
-	if (!thisboard || !devpriv)
-		return;
 	amplc_dio200_common_detach(dev);
-	if (devpriv->io.regtype == mmio_regtype)
+	if (devpriv && devpriv->io.regtype == mmio_regtype)
 		iounmap(devpriv->io.u.membase);
 	comedi_pci_disable(dev);
 }
-- 
2.0.0

