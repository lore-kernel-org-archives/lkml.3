Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaFPLW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:22:56 -0400
Received: from 19.mo3.mail-out.ovh.net ([178.32.98.231]:56523 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751092AbaFPLWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:22:55 -0400
X-Greylist: delayed 12600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 07:22:54 EDT
MIME-Version: 1.0
In-Reply-To: <539DB25A.4000201@free-electrons.com>
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com>
	<1402329860-27520-2-git-send-email-boris.brezillon@free-electrons.com>
	<539D5F24.1020304@traphandler.com>
	<539DB25A.4000201@free-electrons.com>
Date: Mon, 16 Jun 2014 09:46:52 +0200
Message-ID: <CACh+v5MJ92=jNVkpx=FS3bNYcr+Xw2MUpLDfqwpYsj1zNZOu9w@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] mfd: add atmel-hlcdc driver
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pwm <linux-pwm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
X-Ovh-Tracer-Id: 11596206091350726797
X-Ovh-Remote: 209.85.213.172 (mail-ig0-f172.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrkeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrkeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-15 16:48 GMT+02:00 Boris BREZILLON <boris.brezillon@free-electrons.com>:
>
>
> Hello JJ,
>
> On 15/06/2014 10:53, Jean-Jacques Hiblot wrote:
> > On 06/09/2014 06:04 PM, Boris BREZILLON wrote:
> >> The HLCDC IP available on some Atmel SoCs (i.e. at91sam9n12, at91sam9x5
> >> family or sama5d3 family) exposes 2 subdevices:
> >> - a display controller (controlled by a DRM driver)
> >> - a PWM chip
> >>
> >> Add support for the MFD device which will just retrieve HLCDC clocks and
> >> create a regmap so that subdevices can access the HLCDC register range
> >> concurrently.
> >>
> >> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> >> ---
> >>  .../devicetree/bindings/mfd/atmel-hlcdc.txt        |  41 ++++++++
> >>  drivers/mfd/Kconfig                                |  11 ++
> >>  drivers/mfd/Makefile                               |   1 +
> [...]
> >> +    memset(&config, 0, sizeof(config));
> >> +    config.reg_bits = 32;
> >> +    config.val_bits = 32;
> >> +    config.reg_stride = 4;
> >> +    config.max_register = (resource_size(res) / 4) - 1;
> >> +    hlcdc->regmap = devm_regmap_init_mmio_clk(dev, "periph_clk", regs,
> >> +                                              &config);
> > I don't think it's necessary to use "periph_clk" here. This clock will
> > always be running because the HLCDC needs it to work (it's not just an
> > interface clock). In the end it's just some extra work for each register
> > access.
>
> Yes, I thought about removing this clk from regmap registration too (for
> the exact same reason: avoiding extra enable/disable work when accessing
> registers), but ATM I do not prepare/enable periph_clk in the hlcdc-pwm
> driver, this means the regmap won't work until the hlcdc-dc driver has
> probed the display controller device.
>
> How about preparing/enabling the periph_clk in the MFD device, so that
> PWM and Display Controller subdevices won't have to bother about this
> clk, and the regmap will work as expected ?
> Or, should we just prepare/enable the periph clock in each subdevices ?

I think the latest is the best approach. This way the PWM and the DRM
driver can handle their clock gating independently. BTW it's quite
probable that the PWM don't really needs this clock except for
register access.

>
>
>
> Best Regards,
>
> Boris
>
> --
> Boris Brezillon, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com
>
