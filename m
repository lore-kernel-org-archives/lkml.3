Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaGCCRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:17:41 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:39282 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaGCCRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:17:39 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH v2 2/3] staging: comedi: addi_apci_1564: fix use of apci1564_reset() to disable DI interrupts
Date: Wed,  2 Jul 2014 21:17:04 -0500
Message-Id: <1404353824-28984-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404353739-28607-1-git-send-email-chase.southwood@gmail.com>
References: <1404353739-28607-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apci1564_cos_insn_config() is currently using apci1564_reset() to disable
digital input interrupts when the configuration operation is
COMEDI_DIGITAL_TRIG_DISABLE.  However, this is incorrect as the device reset
function also resets the registers for the digital outputs, timer, watchdog, and
counters as well.  Replace the reset function call with a direct disabling of
just the digital input interrupts.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 59786e7..0141ed9 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -285,7 +285,10 @@ static int apci1564_cos_insn_config(struct comedi_device *dev,
 			devpriv->ctrl = 0;
 			devpriv->mode1 = 0;
 			devpriv->mode2 = 0;
-			apci1564_reset(dev);
+			outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+			inl(devpriv->amcc_iobase + APCI1564_DI_INT_STATUS_REG);
+			outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE1_REG);
+			outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE2_REG);
 			break;
 		case COMEDI_DIGITAL_TRIG_ENABLE_EDGES:
 			if (devpriv->ctrl != (APCI1564_DI_INT_ENABLE |
-- 
2.0.1

