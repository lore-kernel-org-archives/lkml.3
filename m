Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3FGIK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:10:58 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.111]:9454 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230Ab3FGIKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:10:55 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-3.tower-200.messagelabs.com!1370592651!12199681!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <51B1957F.40104@digi.com>
Date: Fri, 7 Jun 2013 10:10:39 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <FlorianSchandinat@gmx.de>, <linux-fbdev@vger.kernel.org>
CC: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        Juergen Beisert <jbe@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "brian@crystalfontz.com" <brian@crystalfontz.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Subject: [PATCH] video: mxsfb: fix color settings for 18bit data bus and 32bpp
References: <519E03B0.1080006@digi.com> <519F4435.5010703@digi.com> <201305241300.25461.jbe@pengutronix.de> <201305241533.19941.jbe@pengutronix.de> <20130607072103.GF14209@lukather> <51B18BA0.50506@digi.com> <20130607074200.GG14209@lukather>
In-Reply-To: <20130607074200.GG14209@lukather>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a combination of 18bit LCD data bus width and a color
mode of 32bpp, the driver was setting the color mapping to
rgb666, which is wrong, as the color in memory realy has an
rgb888 layout.

This patch also removes the setting of flag CTRL_DF24 that
makes the driver dimiss the upper 2 bits when handling 32/24bpp
colors in a diplay with 18bit data bus width. This flag made
true color images display wrong in such configurations.

Finally, the color mapping rgb666 has also been removed as nobody
is using it and high level applications like Qt5 cannot work
with it either.

Reference: https://lkml.org/lkml/2013/5/23/220
Signed-off-by: Hector Palacios <hector.palacios@digi.com>
Acked-by: Juergen Beisert <jbe@pengutronix.de>
---
  drivers/video/mxsfb.c | 26 --------------------------
  1 file changed, 26 deletions(-)

diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index 21223d4..d2c5105 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -239,24 +239,6 @@ static const struct fb_bitfield def_rgb565[] = {
  	}
  };

-static const struct fb_bitfield def_rgb666[] = {
-	[RED] = {
-		.offset = 16,
-		.length = 6,
-	},
-	[GREEN] = {
-		.offset = 8,
-		.length = 6,
-	},
-	[BLUE] = {
-		.offset = 0,
-		.length = 6,
-	},
-	[TRANSP] = {	/* no support for transparency */
-		.length = 0,
-	}
-};
-
  static const struct fb_bitfield def_rgb888[] = {
  	[RED] = {
  		.offset = 16,
@@ -309,9 +291,6 @@ static int mxsfb_check_var(struct fb_var_screeninfo *var,
  			break;
  		case STMLCDIF_16BIT:
  		case STMLCDIF_18BIT:
-			/* 24 bit to 18 bit mapping */
-			rgb = def_rgb666;
-			break;
  		case STMLCDIF_24BIT:
  			/* real 24 bit */
  			rgb = def_rgb888;
@@ -453,11 +432,6 @@ static int mxsfb_set_par(struct fb_info *fb_info)
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
1.8.3


