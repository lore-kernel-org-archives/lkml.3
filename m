Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbaBUAgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:36:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbaBTXwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 3.12 38/82] staging: comedi: adv_pci1710: fix analog output readback value
Date: Thu, 20 Feb 2014 15:52:21 -0800
Message-Id: <20140220235020.616550739@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/comedi/drivers/adv_pci1710.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -490,6 +490,7 @@ static int pci171x_insn_write_ao(struct
 				 struct comedi_insn *insn, unsigned int *data)
 {
 	struct pci1710_private *devpriv = dev->private;
+	unsigned int val;
 	int n, chan, range, ofs;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -505,11 +506,14 @@ static int pci171x_insn_write_ao(struct
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
 
@@ -679,6 +683,7 @@ static int pci1720_insn_write_ao(struct
 				 struct comedi_insn *insn, unsigned int *data)
 {
 	struct pci1710_private *devpriv = dev->private;
+	unsigned int val;
 	int n, rangereg, chan;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -688,13 +693,15 @@ static int pci1720_insn_write_ao(struct
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


