Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaIALGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:06:08 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39059 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbaIALEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:33 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 27/28] staging: comedi: amplc_pci230: change pci230_handle_ao_fifo() return type
Date: Mon,  1 Sep 2014 12:03:59 +0100
Message-Id: <1409569440-10979-28-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the return type of `pci230_handle_ao_fifo()` from `int` to
`bool`.  A return value of `true` indicates the AO command is still
running.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 27ff5be..7748e17 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -1109,10 +1109,12 @@ static void pci230_handle_ao_nofifo(struct comedi_device *dev,
 	}
 }
 
-/* Loads DAC FIFO (if using it) from buffer. */
-/* Returns 0 if AO finished due to completion or error, 1 if still going. */
-static int pci230_handle_ao_fifo(struct comedi_device *dev,
-				 struct comedi_subdevice *s)
+/*
+ * Loads DAC FIFO (if using it) from buffer.
+ * Returns false if AO finished due to completion or error, true if still going.
+ */
+static bool pci230_handle_ao_fifo(struct comedi_device *dev,
+				  struct comedi_subdevice *s)
 {
 	struct pci230_private *devpriv = dev->private;
 	struct comedi_async *async = s->async;
@@ -1122,7 +1124,7 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 	unsigned short dacstat;
 	unsigned int i, n;
 	unsigned int events = 0;
-	int running;
+	bool running;
 
 	/* Get DAC FIFO status. */
 	dacstat = inw(devpriv->daqio + PCI230_DACCON);
@@ -1207,9 +1209,9 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 	if (events & (COMEDI_CB_EOA | COMEDI_CB_ERROR | COMEDI_CB_OVERFLOW)) {
 		/* Stopping AO due to completion or error. */
 		pci230_ao_stop(dev, s);
-		running = 0;
+		running = false;
 	} else {
-		running = 1;
+		running = true;
 	}
 	async->events |= events;
 	return running;
@@ -1267,7 +1269,7 @@ static void pci230_ao_start(struct comedi_device *dev,
 	if (devpriv->hwver >= 2) {
 		/* Using DAC FIFO. */
 		unsigned short scantrig;
-		int run;
+		bool run;
 
 		/* Preload FIFO data. */
 		run = pci230_handle_ao_fifo(dev, s);
-- 
2.0.4

