Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbaJaOcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:32:50 -0400
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:38810 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932578AbaJaOct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:32:49 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: icp_multi: correct insn_bits returned data for DO
Date: Fri, 31 Oct 2014 14:32:27 +0000
Message-Id: <1414765947-15464-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some unfathomable reason, the Comedi `insn_bits` handler for the
digital output subdevice (`icp_multi_insn_bits_do()`) writes the digital
output register and reads back the unrelated digital input register.
Read back the current state of the outputs (held in `s->state`) instead.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/icp_multi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index f4e1c1c..db744c8 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -53,7 +53,7 @@ Configuration options: not applicable, uses PCI auto config
 #define ICP_MULTI_AI		2	/* R:   Analogue input data */
 #define ICP_MULTI_DAC_CSR	4	/* R/W: DAC command/status register */
 #define ICP_MULTI_AO		6	/* R/W: Analogue output data */
-#define ICP_MULTI_DI		8	/* R/W: Digital inouts */
+#define ICP_MULTI_DI		8	/* R/W: Digital inputs */
 #define ICP_MULTI_DO		0x0A	/* R/W: Digital outputs */
 #define ICP_MULTI_INT_EN	0x0C	/* R/W: Interrupt enable register */
 #define ICP_MULTI_INT_STAT	0x0E	/* R/W: Interrupt status register */
@@ -319,7 +319,7 @@ static int icp_multi_insn_bits_do(struct comedi_device *dev,
 	if (comedi_dio_update_state(s, data))
 		writew(s->state, dev->mmio + ICP_MULTI_DO);
 
-	data[1] = readw(dev->mmio + ICP_MULTI_DI);
+	data[1] = s->state;
 
 	return insn->n;
 }
-- 
2.1.1

