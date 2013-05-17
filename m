Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3EQOGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:06:43 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.198]:45988 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529Ab3EQOGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:06:42 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2013 10:06:42 EDT
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-15.tower-46.messagelabs.com!1368799168!30557667!6
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <5196375A.1070308@digi.com>
Date: Fri, 17 May 2013 15:57:46 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Subject: mxsfb on i.MX28 uses bypassed ref_xtal 24MHz clock for LCD
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was testing the framebuffer on an i.MX28 based platform and found out that the lcdif 
clock is actually bypassed to use the ref_xtal of 24MHz, which makes the 
clk_set_rate() call in the driver useless (as well as the pixclock settings in 
fb_videomode variables in mach-mxs.c):

static void mxsfb_enable_controller(struct fb_info *fb_info)
{
	struct mxsfb_info *host = to_imxfb_host(fb_info);
	u32 reg;

	dev_dbg(&host->pdev->dev, "%s\n", __func__);

	clk_prepare_enable(host->clk);
	clk_set_rate(host->clk, PICOS2KHZ(fb_info->var.pixclock) * 1000U);

This can easily be checked by probing the pixel clock signal.
Is this known or did it go unnoticed because the supported displays work ok with the 
bypassed 24MHz frequency?
If using a pixel clock below 24MHz, the divisor will round to 2 thus generating a 
12MHz signal.

On the MX28EVK board with the Seiko 4.3" LCD, I do not see the penguin or any image in 
v3.8 or v3.9 though the framebuffer device is present and correctly loaded and 
backlight on.
This LCD works in kernel v2.6.35 with the same 24MHz frequency.
@Fabio, does this LCD work out of the box on v3.9? Am I missing something?

Thank you.
-- 
Héctor Palacios
