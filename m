Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaEVAlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:41:32 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:50325 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaEVAla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:41:30 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 2/2] staging: comedi: addi_apci_1564: move apci1564_do_insn_bits() to addi_apci_1564.c
Date: Wed, 21 May 2014 19:41:15 -0500
Message-Id: <1400719275-21780-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400719209-21452-1-git-send-email-chase.southwood@gmail.com>
References: <1400719209-21452-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is already compliant with the comedi API and is behaving as
comedi core expects.  This patch moves it out of
addi-data/hwdrv_apci1564.c and into the driver proper since no further
work needs to be done on it.

Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
---
Just a couple patches in this set, but with these out of the way, the
next patchset can focus entirely on getting the change-of-state interrupt
functionality working.  Made sense to just finish up with DI/DO and start
COS interrupts separately.

 .../staging/comedi/drivers/addi-data/hwdrv_apci1564.c   | 17 -----------------
 drivers/staging/comedi/drivers/addi_apci_1564.c         | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 533d156..0ba5385 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -170,23 +170,6 @@ static int apci1564_do_config(struct comedi_device *dev,
 	return insn->n;
 }
 
-static int apci1564_do_insn_bits(struct comedi_device *dev,
-				 struct comedi_subdevice *s,
-				 struct comedi_insn *insn,
-				 unsigned int *data)
-{
-	struct addi_private *devpriv = dev->private;
-
-	s->state = inl(devpriv->i_IobaseAmcc + APCI1564_DO_REG);
-
-	if (comedi_dio_update_state(s, data))
-		outl(s->state, devpriv->i_IobaseAmcc + APCI1564_DO_REG);
-
-	data[1] = s->state;
-
-	return insn->n;
-}
-
 /*
  * Configures The Timer, Counter or Watchdog
  *
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index fe477cc5..13d9962 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -26,6 +26,23 @@ static int apci1564_di_insn_bits(struct comedi_device *dev,
 	return insn->n;
 }
 
+static int apci1564_do_insn_bits(struct comedi_device *dev,
+				 struct comedi_subdevice *s,
+				 struct comedi_insn *insn,
+				 unsigned int *data)
+{
+	struct addi_private *devpriv = dev->private;
+
+	s->state = inl(devpriv->i_IobaseAmcc + APCI1564_DO_REG);
+
+	if (comedi_dio_update_state(s, data))
+		outl(s->state, devpriv->i_IobaseAmcc + APCI1564_DO_REG);
+
+	data[1] = s->state;
+
+	return insn->n;
+}
+
 static int apci1564_reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
-- 
1.9.0

