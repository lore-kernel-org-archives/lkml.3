Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaG1MJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:09:58 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49010 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbaG1MJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:09:47 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] staging: comedi: amplc_pc236: don't disable h/w interrupt on detach()
Date: Mon, 28 Jul 2014 13:09:30 +0100
Message-Id: <1406549375-1864-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
References: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an asynchronous command was running when the device is being
detached, the comedi core would have called the subdevice `cancel`
handler (`pc236_intr_cancel()`) before calling the `detach` handler
(`pc236_detach()`).  Since the cancel handler disables hardware
interrupts (at least for the PCI236 board) by calling
`pc236_disable_intr()`, there is no need for the detach handler to do so
as well.  Remove the call to `pc236_disable_intr()` from
`pc236_detach()`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index c96519d..32275a5 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -369,8 +369,6 @@ static void pc236_detach(struct comedi_device *dev)
 
 	if (!thisboard)
 		return;
-	if (dev->iobase)
-		pc236_intr_disable(dev);
 	if (is_isa_board(thisboard)) {
 		comedi_legacy_detach(dev);
 	} else if (is_pci_board(thisboard)) {
-- 
2.0.0

