Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaIALHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:07:31 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38999 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbaIALE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:29 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/28] staging: comedi: amplc_pci230: simplify pci230_ai_read()
Date: Mon,  1 Sep 2014 12:03:47 +0100
Message-Id: <1409569440-10979-16-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`pci230_ai_read()` reads a sample from the ADC data register and
converts it to a comedi sample value.  The AI sample may have 12 or 16
bits of resolution, depending on the board type, but 12-bit sample
values are in bits 15 to 4 of the register.  The hardware value is
signed, 2's complement if set to a bipolar mode, or unsigned, straight
binary if set to a unipolar mode.  To convert to a Comedi sample value
it may need shifting right by 4 bits, and the top bit of the sample
value may need to be toggled.

Simplify the existing code by doing the 2's complement to straight
binary conversion before the shift.  That way, it is always bit 15 that
is inverted regardless of the resolution.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index e4151d7..70b210b 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -563,16 +563,13 @@ static unsigned short pci230_ai_read(struct comedi_device *dev)
 	/*
 	 * PCI230 is 12 bit - stored in upper bits of 16 bit register
 	 * (lower four bits reserved for expansion).  PCI230+ is 16 bit AI.
-	 */
-	data = data >> (16 - thisboard->ai_bits);
-
-	/*
+	 *
 	 * If a bipolar range was specified, mangle it
 	 * (twos complement->straight binary).
 	 */
 	if (devpriv->ai_bipolar)
-		data ^= 1 << (thisboard->ai_bits - 1);
-
+		data ^= 0x8000;
+	data >>= (16 - thisboard->ai_bits);
 	return data;
 }
 
-- 
2.0.4

