Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbaLORwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:52:50 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:52614 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaLORwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:52:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, arm@kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        HenryC Chen <henryc.chen@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>,
        Olof Johansson <olof@lixom.net>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Subject: Re: [PATCH v3 1/8] soc: mediatek: Add PMIC wrapper for MT8135 and MT6397 SoC
Date: Sun, 14 Dec 2014 21:18:34 +0100
Message-ID: <5375041.4IGZ3lO9Xc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418292255.2315.12.camel@mtksdaap41>
References: <1417752479-4749-1-git-send-email-flora.fu@mediatek.com> <3015972.tvmzP0zTdv@wuerfel> <1418292255.2315.12.camel@mtksdaap41>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:u3zWPyJ7blwuOBp2Z464/LjqIjCZ0Znlpa4E6dkAt3ZgvyuV/Rp
 RI3Vgmy4aLoXL7wQjkfQu8fAqAHqG6Dj3/eFbbH8RlQp39EfOKiaEs9nW4eyUyRGVpHUsYt
 sriXji4gpiSQzrGROBLdiqdbV1Pk1oUSvxnpFKiygB1WWdzo+HAXJllqziDrCF+6byYyNtv
 Ez5jcUN1EhHKZ+BxMhTpA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2014 18:04:15 Flora Fu wrote:
> On Tue, 2014-12-09 at 12:20 +0100, Arnd Bergmann wrote:
> > On Tuesday 09 December 2014 11:30:15 Matthias Brugger wrote:
> > > 2014-12-09 11:13 GMT+01:00 Sascha Hauer <s.hauer@pengutronix.de>:
> > > > On Tue, Dec 09, 2014 at 09:23:18AM +0100, Arnd Bergmann wrote:
> > > >>
> > > >> I think we have had a similar case recently where a controller wasn't
> > > >> actually using I2C, but the sofware protocol was close enough so we decided
> > > >> to make it appear as i2c in Linux.
> > > >>
> > > >> Would that work for you, i.e. register the pmic wrapper as a fake spi
> > > >> master driver in drivers/spi/ and register the rtc/regulator/codec
> > > >> as SPI clients from DT?
> > > >
> > > > I don't think that's appropriate. I mean technically that could even
> > > > work, but in software you really don't see anything from the underlying
> > > > SPI bus. The SoC and the PMIC are really tightly coupled via the PMIC
> > > > wrapper. This goes to the point where pins of the SoCs internal I2C and
> > > > keypad controllers are routed over the SPI bus out of the PMIC. In
> > > > software you do this by setting a bit in the I2C controller. If it's
> > > > set, the signals are routed out of the PMIC instead of the main die.
> > > > As said, technically we probably could create a fake SPI master, but
> > > > that wouldn't really fit to this situation.
> > 
> > Ok, I see.
> > 
> > > I agree with Sascha. Although from the hardware point of view, the
> > > communication between the PMIC and the SOC is done through SPI from
> > > the point of view of the software everything looks like I2C commands
> > > which will be "transalted" into SPI messages by the PMIC wrapper.
> > 
> > If it looks like i2c messages, would it be more appropriate to make
> > it appear as an i2c controller then?
> 
> 
> Although the message looks like I2C command, it is not I2C.
> Form source code, the software does not touch any I2C i/o or protocols.
> It depends SoC and has specific initial flow, read and write transfer
> state. It is not able to an i2c controller.
> That's why we consider its a proprietary hardware with specific
> protocols. How about let it appear in driver/soc?

Ok, I've looked a lot more at other drivers now, and I see that one
of my main objections which was about the way that the drivers look
into dev->parent->drvdata is in fact common practice for pmic drivers,
and using i2c wouldn't change anything here. Based on this, using
drivers/soc is probably best as you say.

I still think the relation between the mt8135 pmic wrapper and the
mt6397 mfd driver could be improved. I don't like the way that
include/linux/soc/mediatek/mtk-pmic-wrap.h exposes an internal
data structure of the pmic-wrap driver to the mfd driver, which
really only needs the regmap pointer from it, and I think it would
be better to pass that pointer using platform_data here in one way
or another. The easiest way to do that is probably using an auxdata
table in of_platform_populate, while another method might be to
restructure the relationship between the wrapper driver and the
mfd driver in some form to take out the extra device node and make
the mfd cells children of the wrapper itself.

	Arnd
