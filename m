Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbbARMBa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:01:30 -0500
Received: from www.osadl.org ([62.245.132.105]:36497 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbbARMB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:01:29 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH RFC] comedi: rtd520: if condition with no effect - if identical to else
Date: Sun, 18 Jan 2015 12:53:24 +0100
Message-Id: <1421582004-2398-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The if and the else branch code are identical - so the condition has no
effect on the effective code - this patch removes the condition and the
duplicated code.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

Patch is against 3.19.0-rc4 -next-20150116

This patch was only compile tested with x86_64_defconfig + CONFIG_STAGING=y
CONFIG_COMEDI=m, CONFIG_COMEDI_PCI_DRIVERS=m, CONFIG_COMEDI_RTD520=m

commit c5930d66 (staging: comedi: rtd520: use the comedi_device 'mmio'
member) introduced the current code, the probably bug was though
present before this commit:

        if (devpriv->xfer_count > 0)    /* transfer every N samples */
                writew(IRQM_ADC_ABOUT_CNT, dev->mmio + LAS0_IT);
        else                            /* 1/2 FIFO transfers */
                writew(IRQM_ADC_ABOUT_CNT, dev->mmio + LAS0_IT);

as the if and else branch are identical but the comments indicate that 
they are serving different purposes this looks like a bug. The code has
though been in use in this form for more than 2 years - so maybe the
condition is simply unnecessary. In any case this needs a review
by someone who knows the details of the driver - the below patch
is only cleaning up the current situation and may thus be wrong.

...and how did this pass multiple modifications and reviews ?...

 drivers/staging/comedi/drivers/rtd520.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 06ae436..3ccdade 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1012,10 +1012,8 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	readw(dev->mmio + LAS0_CLEAR);
 
 	/* TODO: allow multiple interrupt sources */
-	if (devpriv->xfer_count > 0)	/* transfer every N samples */
-		writew(IRQM_ADC_ABOUT_CNT, dev->mmio + LAS0_IT);
-	else				/* 1/2 FIFO transfers */
-		writew(IRQM_ADC_ABOUT_CNT, dev->mmio + LAS0_IT);
+	/* transfer every N samples */
+	writew(IRQM_ADC_ABOUT_CNT, dev->mmio + LAS0_IT);
 
 	/* BUG: start_src is ASSUMED to be TRIG_NOW */
 	/* BUG? it seems like things are running before the "start" */
-- 
1.7.10.4

