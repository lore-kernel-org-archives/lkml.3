Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbbAHLr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 06:47:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48994 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbbAHLr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:47:57 -0500
Message-ID: <1420717669.3190.37.camel@pengutronix.de>
Subject: Re: [PATCH] mfd: syscon: fix syscon probing from dt
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, kernel@pengutronix.de,
        Lee Jones <lee.jones@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Heiko Stuebner <heiko@sntech.de>
Date: Thu, 08 Jan 2015 12:47:49 +0100
In-Reply-To: <54AE6501.8020905@samsung.com>
References: <1420558236-14063-1-git-send-email-p.zabel@pengutronix.de>
	 <35536202.10QfWIDQqq@wuerfel> <1420628264.3191.27.camel@pengutronix.de>
	 <54AD15E5.5070803@samsung.com> <1420631728.3191.52.camel@pengutronix.de>
	 <54AE6501.8020905@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

Am Donnerstag, den 08.01.2015, 16:37 +0530 schrieb Pankaj Dubey:
[...]
> > The ldb device is controlled purely through the gpr regmap, so in my
> > opinion it should be a child to the iomuxc-gpr node:
> >
> > 	gpr: iomuxc-gpr@20e00000 {
> > 		compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
> > 		reg = <0x020e0000 0x38>;
> >
> > 		ldb: ldb@020e0008 {
> > 			compatible = "fsl,imx6q-ldb";
> > 			gpr = <&gpr>;
> > 		};
> > 	};
> >
> > 	iomuxc: iomuxc@020e0000 {
> > 		compatible = "fsl,imx6q-iomuxc";
> > 		reg = <0x020e0000 0x4000>;
> > 	};
> >
> > In that case, if there is no device associated with iomuxc-gpr, which
> > device should be the parent to ldb?If the syscon is created from the
> > iomuxc device, the ldb device could be made a child to iomuxc.
> 
> If you need ldb as child device of gpr, then there is no need of syscon 
> or SYSCON APIs here in ldb. In my opinion this is an extra feature which 
> are trying to feed into syscon. As in case of sibling devices it makes 
> sense to access registers across them using syscon APIs, but in case of 
> parent-child devices we already have MFD drivers, and MFD client devices 
> which can serve this purpose.

ldb is not the only device controlled purely through the GPR region, and
the multiplexers are in a shared register, for example, so these
registers should be accessed through a shared regmap.

syscon is a mechanism to share a regmap between multiple devices.
Whether they are siblings or parent/child or in completely different
places in the device tree is somewhat besides the point.

MFD is for devices with multiple functional blocks, but this is not what
the GPR region is. This register space just bundles various signals from
different parts of the SoC. A few of these signals happen to be the only
way to talk to the ldb.

> > In fact, since the gpr registers are part of the iomuxc register space,
> > one could even think about merging the iomuxg-gpr syscon into the iomuxc
> > node:
> >
> > 	gpr: iomuxc: iomuxc@020e0000 {
> > 		compatible = "fsl,imx6q-iomuxc", "fsl,imx6q-iomuxc-gpr";
> > 		reg = <0x020e0000 0x4000>;
> >
> > 		ldb: ldb@020e0008 {
> > 			compatible = "fsl,imx6q-ldb";
> > 		};
> > 	};
> >
> >> I guess for i.MX iomuxc it could be argued
> >>> that the iomuxc-gpr syscon should be merged into the iomuxc pinctrl
> >>> device instead of probing iomuxc-gpr as a platform device by itself.
> 
> Yes, also in the probe of this driver you can register itself as MFD 
> driver and all the child devices and MFD client devices so that child 
> devices can be probed. For example a similar approach has been attempted 
> for exynos-pmu here [1].

I disagree. MFD is the wrong abstraction as there are no cells in which
to partition the GPR, and the children are not allowed to do MMIO access
themselves. All the useful parts of MFD would serve no purpose here.

> 1: http://www.spinics.net/lists/linux-samsung-soc/msg38446.html
> 
> While doing this you can still keep "syscon" compatible to the gpr node 
> if it's some of it's register will be accessed from some other devices.
> But definitely ldb does not need to have a phandle to this syscon 
> device, as after being a MFD client device it can access MFD parent 
> device address space.

[...]
> >> In past a similar approach [2] for letting device driver to register
> >> themselves as syscon provided, has been rejected giving reason that
> >> syscon should not need it's own platform device.
> >
> > In that mail Arnd mentions registering a syscon with both an optional
> > device and an explicit device_node pointer, which is what this patch
> > would do. There is no need for a platform device.
> >
> 
> I don't think so, as per I recall he was against of any such extra API 
> to register syscon [2].
> 
> 2: https://lkml.org/lkml/2014/9/1/227

This comment is about removing the dependency on a platform driver.
My patch doesn't touch that. It just adds an optional device pointer,
which is completely different.

regards
Philipp

