Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaIALEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:04:25 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39008 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbaIALEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:23 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/28] staging: comedi: amplc_pci230: simplify pci230_ao_mangle_datum()
Date: Mon,  1 Sep 2014 12:03:46 +0100
Message-Id: <1409569440-10979-15-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`pci230_ao_mangle_datum()` converts comedi sample values for the AO
subdevice to hardware register values.  The comedi sample value will be
an unsigned value in the range 0 to 4095 (assuming 12-bit resolution).
The hardware wants the value shifted so the m.s. bit of the sample in in
bit 15.  If set to a bipolar range, it also expects a 2's complement
value, so the top bit of the sample value needs to be inverted in that
case.

Simplify the existing code by doing the 2's complement conversion after
the shift.  That way, it is always bit 15 that is inverted regardless of
the resolution.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 7fa9c70..e4151d7 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -583,17 +583,16 @@ static inline unsigned short pci230_ao_mangle_datum(struct comedi_device *dev,
 	struct pci230_private *devpriv = dev->private;
 
 	/*
-	 * If a bipolar range was specified, mangle it
-	 * (straight binary->twos complement).
-	 */
-	if (devpriv->ao_bipolar)
-		datum ^= 1 << (thisboard->ao_bits - 1);
-
-	/*
 	 * PCI230 is 12 bit - stored in upper bits of 16 bit register (lower
 	 * four bits reserved for expansion).  PCI230+ is also 12 bit AO.
 	 */
 	datum <<= (16 - thisboard->ao_bits);
+	/*
+	 * If a bipolar range was specified, mangle it
+	 * (straight binary->twos complement).
+	 */
+	if (devpriv->ao_bipolar)
+		datum ^= 0x8000;
 	return datum;
 }
 
-- 
2.0.4

