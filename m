Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaLNW0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:26:48 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:41807 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaLNW0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:26:41 -0500
X-Auth-Info: 5q8ePZdQ52bbzt1NGrkvZkEKvIra27g/z1ZW3i1EJO0=
From: Marek Vasut <marex@denx.de>
To: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH RFC] clk: mxs: Fix invalid 32-bit access to frac registers
Date: Sun, 14 Dec 2014 20:19:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, festevam@gmail.com, shawn.guo@linaro.org,
        mturquette@linaro.org, linux-arm-kernel@lists.infradead.org
References: <1418570933-21585-1-git-send-email-stefan.wahren@i2se.com> <201412141712.12589.marex@denx.de> <1638147247.144508.1418577377536.JavaMail.open-xchange@oxbaltgw03.schlund.de>
In-Reply-To: <1638147247.144508.1418577377536.JavaMail.open-xchange@oxbaltgw03.schlund.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201412142019.50047.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 14, 2014 at 06:16:17 PM, Stefan Wahren wrote:
> Hi Marek,
> 
> > Marek Vasut <marex@denx.de> hat am 14. Dezember 2014 um 17:12 geschrieben:
> > > static void __iomem *digctrl;
> > > #define DIGCTRL digctrl
> > > @@ -118,11 +119,12 @@ static void __init clk_misc_init(void)
> > > /*
> > > * 480 MHz seems too high to be ssp clock source directly,
> > > * so set frac0 to get a 288 MHz ref_io0 and ref_io1.
> > > + * According to reference manual we must access frac0 bytewise.
> > > */
> > > - val = readl_relaxed(FRAC0);
> > > - val &= ~((0x3f << BP_FRAC0_IO0FRAC) | (0x3f << BP_FRAC0_IO1FRAC));
> > > - val |= (30 << BP_FRAC0_IO0FRAC) | (30 << BP_FRAC0_IO1FRAC);
> > > - writel_relaxed(val, FRAC0);
> > > + writeb_relaxed(0x3f, FRAC0 + FRAC0_IO0 + CLR);
> > > + writeb_relaxed(30, FRAC0 + FRAC0_IO0 + SET);
> > > + writeb_relaxed(0x3f, FRAC0 + FRAC0_IO1 + CLR);
> > > + writeb_relaxed(30, FRAC0 + FRAC0_IO1 + SET);
> > 
> > This used to be a R-M-W sequence, but now it's changed to multiple
> > writes. This
> > changes the behavior and seeing you use the CLR register, I am worried
> > this might be prone to clock glitches. What do you think please ?
> 
> you are right. I adapt the imx23 init to the imx28 to make code simple. But
> it would be better to avoid glitches.
> I hope it's okay for this bugfix to introduce a R-M-W sequence for the
> imx23 init. So it's consequent.

It should be OK. Make sure to document it in the commit message.

> > [...]
> > 
> > Also, it might be a good idea to zap the 0x3f mask and use HEX and DEC
> > numbers consistently, but this is an idea for another patch.
> 
> Yes.
> 
> Btw i hope this patch also fixes a SPI communication issue with our
> hardware which forces us to bypass ref_io1 for ssp2.
> But i will have access to that hardware tomorrow.

Which issue would that be please ? What are the symptoms ?

Best regards,
Marek Vasut
