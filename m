Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbaLIKOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:14:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36082 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbaLIKOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:14:18 -0500
Date: Tue, 9 Dec 2014 11:13:41 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Flora Fu <flora.fu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        arm@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        srv_heupstream@mediatek.com, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, HenryC Chen <henryc.chen@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>,
        Olof Johansson <olof@lixom.net>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Subject: Re: [PATCH v3 1/8] soc: mediatek: Add PMIC wrapper for MT8135 and
 MT6397 SoC
Message-ID: <20141209101341.GV30369@pengutronix.de>
References: <1417752479-4749-1-git-send-email-flora.fu@mediatek.com>
 <2751641.o51TuZRl88@wuerfel>
 <1418091337.5663.9.camel@mtksdaap41>
 <2248330.M654Toyebg@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2248330.M654Toyebg@wuerfel>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:15:27 up 54 days, 20:29, 77 users,  load average: 0.12, 0.12,
 0.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 09:23:18AM +0100, Arnd Bergmann wrote:
> On Tuesday 09 December 2014 10:15:37 Flora Fu wrote:
> > Hi, Arnd,
> > 
> > On Fri, 2014-12-05 at 11:13 +0100, Arnd Bergmann wrote:
> > > On Friday 05 December 2014 12:07:52 Flora Fu wrote:
> > > > Add PMIC wrapper of MT8135 to access MT6397 MFD.
> > > > 
> > > > Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> > > > 
> > > 
> > > Please explain what a PMIC wrapper is and why you need one for MT8135.
> > > I don't understand the purpose of this code at all. Is this just another
> > > way of accessing the MT6397 when not using i2c or spi like other
> > > PMIC drivers do?
> > > 
> > 
> > Yes, MT8135 uses a proprietary hardware to communicate with MT6397. 
> > The hardware is called PMIC Wrapper or PWRAP.
> > Since it is not standard i2c or spi protocols, a soc related software
> > driver is implemented to handle access protocols in AP side.
> > 
> > +-----------------+           +---------------+
> > |                 |           |               |
> > | Mediatek AP SoC |           |               |
> > | (ex. MT8135)    |           |    MT6397     |
> > |                 |           |               |
> > |      +--------+ | (SPI bus) | +--------+    |
> > |      |        | |-----------| |        |    |
> > |      |  PMIC  | |-----------| |  PMIC  |    |
> > |      | Wrapper| |-----------| | Wrapper|    |
> > |      |        | |-----------| |        |    |
> > |      +--------+ |           | +--------+    |
> > |                 |           |               |
> > +-----------------+           +---------------+
> > 
> 
> I think we have had a similar case recently where a controller wasn't
> actually using I2C, but the sofware protocol was close enough so we decided
> to make it appear as i2c in Linux.
> 
> Would that work for you, i.e. register the pmic wrapper as a fake spi
> master driver in drivers/spi/ and register the rtc/regulator/codec
> as SPI clients from DT?

I don't think that's appropriate. I mean technically that could even
work, but in software you really don't see anything from the underlying
SPI bus. The SoC and the PMIC are really tightly coupled via the PMIC
wrapper. This goes to the point where pins of the SoCs internal I2C and
keypad controllers are routed over the SPI bus out of the PMIC. In
software you do this by setting a bit in the I2C controller. If it's
set, the signals are routed out of the PMIC instead of the main die.
As said, technically we probably could create a fake SPI master, but
that wouldn't really fit to this situation.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
