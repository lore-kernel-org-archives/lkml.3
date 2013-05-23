Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070Ab3EWNeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:34:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40761 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758749Ab3EWNeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:34:12 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-arm-kernel@lists.infradead.org
Subject: Re: mxsfb: DATA_FORMAT_24_BIT flag outputs invalid colours
Date: Thu, 23 May 2013 15:31:31 +0200
User-Agent: KMail/1.9.10
Cc: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        Hector Palacios <hector.palacios@digi.com>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        brian@crystalfontz.com, s.hauer@pengutronix.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
References: <519E03B0.1080006@digi.com> <20130523130039.GF8595@lukather>
In-Reply-To: <20130523130039.GF8595@lukather>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201305231531.31376.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.76
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

maxime.ripard@free-electrons.com wrote:
> On Thu, May 23, 2013 at 01:55:28PM +0200, Hector Palacios wrote:
> > I'm using an i.MX28 based board with lcd connected with 18bits data bus.
> > My platform uses 32 bits per pixel:
> >
> > 	mxsfb_pdata.default_bpp = 32;
> > 	mxsfb_pdata.ld_intf_width = STMLCDIF_18BIT;
> >
> > With these settings the mxsfb.c driver sets flag DATA_FORMAT_24_BIT
> > at HW_LCDIF_CTRL register in function mxsfb_set_par():
> >
> > 	case 32:
> > 		dev_dbg(&host->pdev->dev, "Setting up RGB888/666 mode\n");
> > 		ctrl |= CTRL_SET_WORD_LENGTH(3);
> > 		switch (host->ld_intf_width) {
> > 		case STMLCDIF_8BIT:
> > 			dev_dbg(&host->pdev->dev,
> > 					"Unsupported LCD bus width mapping\n");
> > 			return -EINVAL;
> > 		case STMLCDIF_16BIT:
> > 		case STMLCDIF_18BIT:
> > 			/* 24 bit to 18 bit mapping */
> > 			ctrl |= CTRL_DF24; /* ignore the upper 2 bits in
> > 					    *  each colour component
> > 					    */
> > 			break;
> > 		case STMLCDIF_24BIT:
> > 			/* real 24 bit */
> > 			break;
> > 		}
> >
> > According to the manual, this flag does:
> > 	0x0: ALL_24_BITS_VALID: Data input to the block is in 24 bpp
> > format, such that all RGB 888 data is contained in 24 bits.
> > 	0x1: DROP_UPPER_2_BITS_PER_BYTE — Data input to the block is
> > actually RGB 18 bpp, but there is 1 colour per byte, hence the upper
> > 2 bits in each byte do not contain any useful data, and should be
> > dropped.
> >
> > The setting of this flag is producing bad colours with true colour
> > images (i.e. the Linux penguin is displayed ok, but QT applications
> > or images displayed with fbv are not).
> > I believe the setting of this flag is not correct (after all, if my
> > bpp is 32, then all 24bit colours are useful and dropping the upper
> > 2 bits is a bad idea).
> > If I don't set it, then true colour images are displayed correctly.
> > The only problem is that the Linux penguin is displayed much darker
> > than usual (correct colours, but darker). Perhaps the 224 colour
> > format of this image justifies it?
> >
> > I noticed the cfa10049 platform also uses the same configuration (18
> > bits data bus and 32bpp) and was wondering if true colour images are
> > correctly displayed in this platform with this flag set (for example
> > with fbv application [1]).
>
> I had the exact same problem, and suggested the exact same solution a
> few weeks back.
>
> https://patchwork.kernel.org/patch/2470441/
>
> The conclusion of that discussion what that the userspace applications
> were not honouring the bitfield correctly set by the mxsfb driver, and
> as such, it was not a bug in the driver.
>
> While this is correct, I wonder, now that since we had that same problem
> in a very short amount of time, if we couldn't set this behaviour
> dependant of some (dt? kernel argument?) property so that one could
> customise it anyway he want.
>
> Maxime

i.MX2[3|8]    LCD1       LCD2       LCD3
              24bit      18bit      18bit
--------------------------------------------
LCD_D0         B0         B0         --
LCD_D1         B1         B1         --
LCD_D2         B2         B2         B0
LCD_D3         B3         B3         B1
LCD_D4         B4         B4         B2
LCD_D5         B5         B5         B3
LCD_D6         B6         G0         B4
LCD_D7         B7         G1         B5

LCD_D8         G0         G2         --
LCD_D9         G1         G3         --
LCD_D10        G2         G4         G0
LCD_D11        G3         G5         G1
LCD_D12        G4         R0         G2
LCD_D13        G5         R1         G3
LCD_D14        G6         R2         G4
LCD_D15        G7         R3         G5

LCD_D16        R0         R4         --
LCD_D17        R1         R5         --
LCD_D18        R2                    R0
LCD_D19        R3                    R1
LCD_D20        R4                    R2
LCD_D21        R5                    R3
LCD_D22        R6                    R4
LCD_D23        R7                    R5

Is your display connected like LCD2 or LCD3? LCD3 must still handled like a 24 
bit display shown in LCD1, while only the LCD2-case is the "24 bit to 18 bit 
mapping" case.

At least my current tests with an i.MX23 and a connection like LCD2 are 
working here with a Qt application. Qt honours the pixel bitfield 
description. And I'm using the "bits-per-pixel = <32>" and "bus-width = <18>" 
entries in the device tree.

Regards,
Juergen

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
