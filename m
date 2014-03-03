Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaCCTAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:00:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56200 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaCCTAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:00:47 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 49/67] staging: comedi: adv_pci1710: fix analog output readback value
Date: Mon,  3 Mar 2014 10:55:37 -0800
Message-Id: <1393872955-28810-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: H Hartley Sweeten <hsweeten@visionengravers.com>

commit 1e85c1ea1ff2a60659e790ef8ec76c7339445841 upstream.

The last value written to a analog output channel is cached in the
private data of this driver for readback.

Currently, the wrong value is cached in the (*insn_write) functions.
The current code stores the data[n] value for readback afer the loop
has written all the values. At this time 'n' points past the end of
the data array.

Fix the functions by using a local variable to hold the data being
written to the analog output channel. This variable is then used
after the loop is complete to store the readback value. The current
value is retrieved before the loop in case no values are actually
written..

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index a6fd8c2..3235f5b 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -491,6 +491,7 @@ static int pci171x_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_insn *insn, unsigned int *data)
 {
 	struct pci1710_private *devpriv = dev->private;
+	unsigned int val;
 	int n, chan, range, ofs;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -506,11 +507,14 @@ static int pci171x_insn_write_ao(struct comedi_device *dev,
 		outw(devpriv->da_ranges, dev->iobase + PCI171x_DAREF);
 		ofs = PCI171x_DA1;
 	}
+	val = devpriv->ao_data[chan];
 
-	for (n = 0; n < insn->n; n++)
-		outw(data[n], dev->iobase + ofs);
+	for (n = 0; n < insn->n; n++) {
+		val = data[n];
+		outw(val, dev->iobase + ofs);
+	}
 
-	devpriv->ao_data[chan] = data[n];
+	devpriv->ao_data[chan] = val;
 
 	return n;
 
@@ -680,6 +684,7 @@ static int pci1720_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_insn *insn, unsigned int *data)
 {
 	struct pci1710_private *devpriv = dev->private;
+	unsigned int val;
 	int n, rangereg, chan;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -689,13 +694,15 @@ static int pci1720_insn_write_ao(struct comedi_device *dev,
 		outb(rangereg, dev->iobase + PCI1720_RANGE);
 		devpriv->da_ranges = rangereg;
 	}
+	val = devpriv->ao_data[chan];
 
 	for (n = 0; n < insn->n; n++) {
-		outw(data[n], dev->iobase + PCI1720_DA0 + (chan << 1));
+		val = data[n];
+		outw(val, dev->iobase + PCI1720_DA0 + (chan << 1));
 		outb(0, dev->iobase + PCI1720_SYNCOUT);	/*  update outputs */
 	}
 
-	devpriv->ao_data[chan] = data[n];
+	devpriv->ao_data[chan] = val;
 
 	return n;
 }
-- 
1.8.3.2

