Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaLNRQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 12:16:50 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:65307 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaLNRQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 12:16:47 -0500
Date: Sun, 14 Dec 2014 18:16:17 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
To: Marek Vasut <marex@denx.de>
Cc: linux-kernel@vger.kernel.org, festevam@gmail.com, shawn.guo@linaro.org,
        mturquette@linaro.org, linux-arm-kernel@lists.infradead.org
Message-ID: <1638147247.144508.1418577377536.JavaMail.open-xchange@oxbaltgw03.schlund.de>
In-Reply-To: <201412141712.12589.marex@denx.de>
References: <1418570933-21585-1-git-send-email-stefan.wahren@i2se.com> <201412141712.12589.marex@denx.de>
Subject: Re: [PATCH RFC] clk: mxs: Fix invalid 32-bit access to frac
 registers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.0-Rev33
X-Originating-Client: com.openexchange.ox.gui.dhtml
X-Provags-ID: V03:K0:w/lfozQUZETGol6cAFjrotimQHE9JiFBb5VBsI5m6VCV/GjChYj
 p2gal/Ia3ne9OHN/zXi9LfIA+uc8e08Kdr4b5ANSR7U7B6woQPJGxgGholDCccTj2Vaoauk
 h7ySt4MuGd9JyMRE8YRhe5tk40ORVc5W8nc4zN0EthU1jPI0Q6/uA+UcO6WveTokKewX38Y
 EW5BYMvbY5Qbxyq0eg4Rg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

> Marek Vasut <marex@denx.de> hat am 14. Dezember 2014 um 17:12 geschrieben:
>
> >
> > static void __iomem *digctrl;
> > #define DIGCTRL digctrl
> > @@ -118,11 +119,12 @@ static void __init clk_misc_init(void)
> > /*
> > * 480 MHz seems too high to be ssp clock source directly,
> > * so set frac0 to get a 288 MHz ref_io0 and ref_io1.
> > + * According to reference manual we must access frac0 bytewise.
> > */
> > - val = readl_relaxed(FRAC0);
> > - val &= ~((0x3f << BP_FRAC0_IO0FRAC) | (0x3f << BP_FRAC0_IO1FRAC));
> > - val |= (30 << BP_FRAC0_IO0FRAC) | (30 << BP_FRAC0_IO1FRAC);
> > - writel_relaxed(val, FRAC0);
> > + writeb_relaxed(0x3f, FRAC0 + FRAC0_IO0 + CLR);
> > + writeb_relaxed(30, FRAC0 + FRAC0_IO0 + SET);
> > + writeb_relaxed(0x3f, FRAC0 + FRAC0_IO1 + CLR);
> > + writeb_relaxed(30, FRAC0 + FRAC0_IO1 + SET);
>
> This used to be a R-M-W sequence, but now it's changed to multiple writes.
> This
> changes the behavior and seeing you use the CLR register, I am worried this
> might be prone to clock glitches. What do you think please ?

you are right. I adapt the imx23 init to the imx28 to make code simple. But it
would be better to avoid glitches.
I hope it's okay for this bugfix to introduce a R-M-W sequence for the imx23
init. So it's consequent.

>
> [...]
>
> Also, it might be a good idea to zap the 0x3f mask and use HEX and DEC numbers
> consistently, but this is an idea for another patch.

Yes.

Btw i hope this patch also fixes a SPI communication issue with our hardware
which forces us to bypass ref_io1 for ssp2.
But i will have access to that hardware tomorrow.

Thanks

Stefan

>
> Best regards,
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
