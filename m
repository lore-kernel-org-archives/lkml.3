Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab3DVIL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:11:56 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:43997 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab3DVILz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:11:55 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Brian Lilly <brian@crystalfontz.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] video: mxsfb: Fix colors display on lower color depth
Date: Mon, 22 Apr 2013 10:11:50 +0200
Message-Id: <1366618310-7068-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code always registers as a 32 bits display, and uses the
hardware to drop the MSB of each color to abjust to the interface width
used by the panel.

This results on 18 bits (and probably 16 bits display as well) in colors
being displayed poorly, because the MSB are obviously the most important
bits for each color definition.

The default controller behaviour when using an interface width smaller
than the color depth is to drop the LSBs of each color, which makes more
sense because you lose the least important part of the color definition.

So, to fix the colors display, just get back to the default controller
behaviour.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
  - Copied Sascha

 drivers/video/mxsfb.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index 755556c..2cfaf8b 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -424,11 +424,6 @@ static int mxsfb_set_par(struct fb_info *fb_info)
 			return -EINVAL;
 		case STMLCDIF_16BIT:
 		case STMLCDIF_18BIT:
-			/* 24 bit to 18 bit mapping */
-			ctrl |= CTRL_DF24; /* ignore the upper 2 bits in
-					    *  each colour component
-					    */
-			break;
 		case STMLCDIF_24BIT:
 			/* real 24 bit */
 			break;
-- 
1.7.10.4

