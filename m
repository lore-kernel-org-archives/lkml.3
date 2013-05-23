Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab3EWL4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:56:13 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.1]:51160 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758526Ab3EWL4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:56:11 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-9.tower-28.messagelabs.com!1369310168!25826832!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <519E03B0.1080006@digi.com>
Date: Thu, 23 May 2013 13:55:28 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        <s.hauer@pengutronix.de>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        <brian@crystalfontz.com>
Subject: mxsfb: DATA_FORMAT_24_BIT flag outputs invalid colours
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm using an i.MX28 based board with lcd connected with 18bits data bus.
My platform uses 32 bits per pixel:

	mxsfb_pdata.default_bpp = 32;
	mxsfb_pdata.ld_intf_width = STMLCDIF_18BIT;

With these settings the mxsfb.c driver sets flag DATA_FORMAT_24_BIT at HW_LCDIF_CTRL 
register in function mxsfb_set_par():

	case 32:
		dev_dbg(&host->pdev->dev, "Setting up RGB888/666 mode\n");
		ctrl |= CTRL_SET_WORD_LENGTH(3);
		switch (host->ld_intf_width) {
		case STMLCDIF_8BIT:
			dev_dbg(&host->pdev->dev,
					"Unsupported LCD bus width mapping\n");
			return -EINVAL;
		case STMLCDIF_16BIT:
		case STMLCDIF_18BIT:
			/* 24 bit to 18 bit mapping */
			ctrl |= CTRL_DF24; /* ignore the upper 2 bits in
					    *  each colour component
					    */
			break;
		case STMLCDIF_24BIT:
			/* real 24 bit */
			break;
		}

According to the manual, this flag does:
	0x0: ALL_24_BITS_VALID: Data input to the block is in 24 bpp format, such that all 
RGB 888 data is contained in 24 bits.
	0x1: DROP_UPPER_2_BITS_PER_BYTE — Data input to the block is actually RGB 18 bpp, but 
there is 1 colour per byte, hence the upper 2 bits in each byte do not contain any 
useful data, and should be dropped.

The setting of this flag is producing bad colours with true colour images (i.e. the 
Linux penguin is displayed ok, but QT applications or images displayed with fbv are not).
I believe the setting of this flag is not correct (after all, if my bpp is 32, then 
all 24bit colours are useful and dropping the upper 2 bits is a bad idea).
If I don't set it, then true colour images are displayed correctly. The only problem 
is that the Linux penguin is displayed much darker than usual (correct colours, but 
darker). Perhaps the 224 colour format of this image justifies it?

I noticed the cfa10049 platform also uses the same configuration (18 bits data bus and 
32bpp) and was wondering if true colour images are correctly displayed in this 
platform with this flag set (for example with fbv application [1]).

Regards,
-- 
Héctor Palacios

[1] http://freecode.com/projects/fbv
