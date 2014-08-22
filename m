Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaHVBBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 21:01:45 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:34378 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaHVBBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 21:01:43 -0400
Date: Fri, 22 Aug 2014 00:58:41 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] tpm_tis: Verify ACPI-specified interrupt
Message-ID: <alpine.LNX.2.11.1408220043560.1360@localhost.localdomain>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some machines, such as the Acer C720 and Toshiba CB35, have TPMs
that do not use interrupts while also having an ACPI TPM entry
indicating a specific interrupt to be used. Since this interrupt
is invalid, these machines freeze on resume until the interrupt
times out.

Generate the ACPI-specified interrupt. If none is received, then
fall back to polling mode.

Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
Tested-by: James Duley <jagduley@gmail.com>
Tested-by: Michael Mullin <masmullin@gmail.com>
---
  drivers/char/tpm/tpm_tis.c | 14 ++++++++------
  1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2c46734..736ed4a 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -633,12 +633,14 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
  	iowrite32(intmask,
  		  chip->vendor.iobase +
  		  TPM_INT_ENABLE(chip->vendor.locality));
-	if (interrupts)
-		chip->vendor.irq = irq;
-	if (interrupts && !chip->vendor.irq) {
-		irq_s =
-		    ioread8(chip->vendor.iobase +
-			    TPM_INT_VECTOR(chip->vendor.locality));
+	chip->vendor.irq = 0;
+	if (interrupts) {
+		if (irq)
+			irq_s = irq;
+		else
+			irq_s =
+			    ioread8(chip->vendor.iobase +
+				    TPM_INT_VECTOR(chip->vendor.locality));
  		if (irq_s) {
  			irq_e = irq_s;
  		} else {
-- 
2.0.4
