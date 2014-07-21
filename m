Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaGUIAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:00:41 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:61191 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaGUIAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:00:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Chanwoo Choi <cwchoi00@gmail.com>, jic23@kernel.org,
        naveen krishna <ch.naveen@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        pawel.moll@arm.com, Mark Rutland <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        rdunlap@infradead.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-iio@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCHv6 3/4] iio: devicetree: Add DT binding documentation for Exynos3250 ADC
Date: Mon, 21 Jul 2014 10:00:24 +0200
Message-ID: <7477106.gq1AqisQx4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53CC725C.9010406@samsung.com>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <5381273.c6GzlyQ7Ea@wuerfel> <53CC725C.9010406@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1vLm2K+8+ewPWKYKuwD56nDghX2LKGrFbrDPlfNaJfC
 HJrGb8owBtTYdsTsdsw9CQl12W6b6w6GeQeQjQU2q1WDykdZb2
 n5I89bt/2XUQhl8vXhh6FO6iIrZmvyJpdPvMV5eoORRbZawdmB
 W3ZjjTCDpSOqUbk6L5X89mA11+XRSl1mrFSgt7xPzAH7zrOkZF
 loTUcURSCZ4VlhcUQsnJn/BLfQc8lO+cKPxCXbpdJf+/hqGAEK
 7cMPhl4r85ogOnOYyqhUaJqkMudzvZNzIosBLiMAyJ7uU4Ss0x
 d2Ky+hC4JtrqYLm91tUcSaeMeAoV0fPimee72Etem6CjsZ1m8m
 5TV3sv2qgZ9eKAsC6ItY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2014 10:52:28 Chanwoo Choi wrote:
> > Yes, your current version is certainly better than this, but another way
> > to address Tomasz' comment would be to change the binding to list the "sclk"
> > as optional for any device and make the code silently ignore missing sclk
> > entries, like:
> > 
> > 
> >       info->sclk = devm_clk_get(&pdev->dev, "sclk");
> >       if (IS_ERR(info->sclk)) {
> >               switch (PTR_ERR(info->sclk)) {
> >               case -EPROBE_DEFER:
> >                       /* silently return error so we can retry */
> >                       return -EPROBE_DEFER:
> >               case -ENOENT:
> >                       /* silently ignore missing optional clk */
> >                       info->sclk = NULL;
> >                       break;
> >               default:
> >                       /* any other error: clk is defined by doesn't work  */
> >                       dev_err(&pdev->dev, "failed getting sclk clock, err = %ld\n",
> >                               PTR_ERR(info->sclk));
> >                       return PTR_ERR(info->sclk));
> >               }
> >       }
> 
> I tested this patch suggested by you.
> But, devm_clk_get returns always '-ENOENT' on follwong two cases:
> 
> Case 1.
> ADC dt node in exynos3250.dtsi don't include 'sclk' clock as following:
> 
>                 adc: adc@126C0000 {
>                         compatible = "samsung,exynos3250-adc";
>                         reg = <0x126C0000 0x100>, <0x10020718 0x4>;
>                         interrupts = <0 137 0>;
>                         clock-names = "adc";
>                         clocks = <&cmu CLK_TSADC>;
>                         #io-channel-cells = <1>;
>                         io-channel-ranges;
>                 };
> 
> Case 2.
> ADC dt node in exynos3250.dtsi don't include 'sclk' clock
> but, exynos3250 clock controller don't support CLK_SCLK_TSADC clock as following:
> 
>                 adc: adc@126C0000 {
>                         compatible = "samsung,exynos3250-adc";
>                         reg = <0x126C0000 0x100>, <0x10020718 0x4>;
>                         interrupts = <0 137 0>;
>                         clock-names = "adc", "sclk";
>                         clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
>                         #io-channel-cells = <1>;
>                         io-channel-ranges;
>                 };

But neither of those cases is actually a correct DT representation for
exynos3250: The first case describes an ADC that doesn't need a second
clock, so if the hardware actually needs it to function, it is clearly
unsufficiently described. The second case is even worse because it refers
to a clock that isn't there. Actually that should probably return a different
error code, but that's a different matter.

> So, I think exynos-adc needs to use 'needs_sclk' field suggested by Tomasz Figa.

I don't mind you adding a field to the data, especially since you already
need to have separate structures to encode the different number of channels.
However, I don't see it as necessary either. What you do here is just
checking the DT representation for correctness and consistency. It's not
harmful but we don't normally do that because passing incorrect DT blobs
can cause an infinite number of other problems that we don't check for.

	Arnd
