Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbaGYJFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:05:25 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41152 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759850AbaGYJFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:22 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] staging: comedi: amplc_pc236: set board_name before common attach
Date: Fri, 25 Jul 2014 10:04:58 +0100
Message-Id: <1406279098-8498-13-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For PCI boards, the `auto_attach` handler, `pc236_auto_attach()`,
initializes `dev->board_ptr` to point to a `struct pc236_board`, but
leaves `dev->board_name` unchanged.  The Comedi core will have
initialized `dev->board_name` to the `driver_name` string member of
`amplc_pc236_driver`.  For consistency with ISA boards manually
configured by the `COMEDI_DEVCONFIG` ioctl via the legacy `attach`
handler, `pc236_attach()`, set `dev->board_name` to the `name` member of
the `struct pc236_board` pointed to by `dev->board_ptr`.

Both `pc236_attach()` and `pc236_auto_attach()` call
`pc236_common_attach()`, which also sets `dev->board_name` to the `name`
member of the `struct pc236_board`.  Since this assignment no longer
changes anything, remove it.

A nice side-effect of this change is that the same owner name string is
used for requesting I/O regions (before the call the
`pc236_common_attach()`) as is used for requesting the IRQ handler
(during the call to `pc236_common_attach()`).  It was already the same
for (manually configured) ISA boards, but is now the same for
(automatically configured) PCI boards.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 1a7fa45..b92fc6f 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -284,11 +284,9 @@ static irqreturn_t pc236_interrupt(int irq, void *d)
 static int pc236_common_attach(struct comedi_device *dev, unsigned long iobase,
 			       unsigned int irq, unsigned long req_irq_flags)
 {
-	const struct pc236_board *thisboard = comedi_board(dev);
 	struct comedi_subdevice *s;
 	int ret;
 
-	dev->board_name = thisboard->name;
 	dev->iobase = iobase;
 
 	ret = comedi_alloc_subdevices(dev, 2);
@@ -362,6 +360,7 @@ static int pc236_auto_attach(struct comedi_device *dev,
 		return -ENOMEM;
 
 	dev->board_ptr = &pc236_pci_board;
+	dev->board_name = pc236_pci_board.name;
 	ret = comedi_pci_enable(dev);
 	if (ret)
 		return ret;
-- 
2.0.0

