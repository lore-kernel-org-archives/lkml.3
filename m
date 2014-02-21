Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbaBUMvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:51:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47154 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbaBUMvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 086/121] staging: comedi: adv_pci1710: fix analog output readback value
Date: Fri, 21 Feb 2014 12:48:30 +0000
Message-Id: <1392986945-9693-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index f847bbc..acb66a9 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -489,6 +489,7 @@ static int pci171x_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_insn *insn, unsigned int *data)
 {
 	struct pci1710_private *devpriv = dev->private;
+	unsigned int val;
 	int n, chan, range, ofs;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -504,11 +505,14 @@ static int pci171x_insn_write_ao(struct comedi_device *dev,
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
 
@@ -678,6 +682,7 @@ static int pci1720_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_insn *insn, unsigned int *data)
 {
 	struct pci1710_private *devpriv = dev->private;
+	unsigned int val;
 	int n, rangereg, chan;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -687,13 +692,15 @@ static int pci1720_insn_write_ao(struct comedi_device *dev,
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
1.9.0

