Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaH1QKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 12:10:04 -0400
Received: from gloria.sntech.de ([95.129.55.99]:40003 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaH1QKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 12:10:00 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        rui.zhang@intel.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, dmitry.torokhov@gmail.com,
        zhaoyifeng <zyf@rock-chips.com>, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v3 1/4] thermal: rockchip: add driver for thermal
Date: Thu, 28 Aug 2014 18:11:43 +0200
Message-ID: <3440260.edal29kzlR@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140828143733.GA18084@developer>
References: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com> <2852853.mfRZfFVSev@wuerfel> <20140828143733.GA18084@developer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 28. August 2014, 10:37:35 schrieb Eduardo Valentin:
> Ceasar and Arnd,
> 
> On Thu, Aug 28, 2014 at 10:48:23AM +0200, Arnd Bergmann wrote:
> > On Thursday 28 August 2014 08:59:19 Caesar Wang wrote:
> > > Thermal is TS-ADC Controller module supports user-defined mode and
> > > automatic mode.
> > > 
> > > User-defined mode refers,TSADC all the control signals entirely by
> > > software
> > > writing to register for direct control.
> > > 
> > > Automaic mode refers to the module automatically poll TSADC output,and
> > > the results Were checked.
> > > 
> > > If you find that the temperature High in a period of time, an interrupt
> > > is generated to the processor down-measures taken;if the temperature
> > > over a period of time High, the resulting TSHUT gave CRU module,let it
> > > reset the entire chip, or via GPIO give PMIC.
> > > 
> > > Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> > > Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> > 
> > Hi Caesar,
> > 
> > After looking at the driver (last time I only received the patch for
> > the binding), I have a more general comment:
> > 
> > This looks like a general-purpose ADC device, not an IP block that is
> > specific to thermal management. The binding looks ok for that purpose
> > but should probably be moved into
> > Documentation/devicetree/bindings/iio/adc/ as a minor change.
> 
> I agree with Arnd's point here. It makes sense to me to have this driver
> under the IIO umbrella.

interesting suggestion :-)

I've just taken another look at the registers of the ts-adc on the rk3066 
which is completely different from the rk3288 one. Interestingly the rk3066 one 
is "just" another saradc IP, so for this one it would really make sense.


> > On the driver side, I believe the correct way to deal with this setup
> > is to split your driver into a generic drivers/iio/adc/rockchips-tsadc.c
> > file, and a smaller thermal driver that uses the iio in-kernel interfaces,
> > ideally one that is independent of the underlying hardware and can
> > work on any ADC implementation.
> 
> Agreed. If you can write such interface and make your driver to work in
> such way, that would be great.

But I currently don't see how you would model the temperature handling parts 
from a generic thermal driver to a generic adc driver for the rk3288-tsadc.

I guess the general temperature irq handling would use iio-triggers? But how 
does the target temperature get into the TSADC_COMP1_INT register.

Also when getting the temperature, Caesar's driver compares it to its trip 
points and sets the next trip point depending on the current temperature 
(passive <-> critical) in rockchip_get_temp.

Maybe there is some completely easy way for this, but currently I don't see 
it.


Heiko
