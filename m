Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaHQE0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 00:26:32 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:55957 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaHQE0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 00:26:31 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 3/3] staging: comedi: dt3000: remove unneeded variable
Date: Sat, 16 Aug 2014 23:26:11 -0500
Message-Id: <1408249571-1478-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coccinelle (using scripts/coccinelle/tests/doublebitand.cocci) found this
assignment because 0 is or'd twice.  Upon inspection, I found that the
variable "mode" is only assigned once and used once, and thus can be
cleanly removed.  This patch plugs its value straight into writew() and
then removes the variable.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
It occurred to me while doing this that zero might be or'd twice to
indicate "no information" in order to maintain some three-part structure
used elsewhere.  If this is the case, I think that the variable could
still be removed and the "| 0 | 0" could be added to the writew().

 drivers/staging/comedi/drivers/dt3000.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 56e21cc..176a7ee 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -488,7 +488,6 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	unsigned int chan, range, aref;
 	unsigned int divider;
 	unsigned int tscandiv;
-	unsigned int mode;
 
 	for (i = 0; i < cmd->chanlist_len; i++) {
 		chan = CR_CHAN(cmd->chanlist[i]);
@@ -513,8 +512,7 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		writew((tscandiv & 0xffff), dev->mmio + DPR_Params(4));
 	}
 
-	mode = DT3000_AD_RETRIG_INTERNAL | 0 | 0;
-	writew(mode, dev->mmio + DPR_Params(5));
+	writew(DT3000_AD_RETRIG_INTERNAL, dev->mmio + DPR_Params(5));
 	writew(aref == AREF_DIFF, dev->mmio + DPR_Params(6));
 
 	writew(AI_FIFO_DEPTH / 2, dev->mmio + DPR_Params(7));
-- 
2.0.4

