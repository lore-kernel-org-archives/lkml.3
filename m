Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaDZAio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 20:38:44 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:4265 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbaDZAim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 20:38:42 -0400
Date: Fri, 25 Apr 2014 17:40:48 -0700
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Frank Rowand <frowand.list@gmail.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
Message-ID: <20140426004048.GQ17066@sonymobile.com>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
 <1398259168.4724.217.camel@iivanov-dev>
 <535AFD96.90505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <535AFD96.90505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 02:28:06AM +0200, Frank Rowand wrote:
> On 4/23/2014 6:19 AM, Ivan T. Ivanov wrote:
[...]
> >> +static int pm8x41_probe(struct spmi_device *sdev)
> >> +{
> >> +	struct regmap *regmap;
> >> +
> >> +	regmap = devm_regmap_init_spmi_ext(sdev, &pm8x41_regmap_config);
> >> +	if (IS_ERR(regmap)) {
> >> +		dev_dbg(&sdev->dev, "regmap creation failed.\n");
> >> +		return PTR_ERR(regmap);
> >> +	}
> >> +
> >> +	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
> > 
> > I think that this will not going to work. For example in this particular
> > case, both controllers have "qcom,qpnp-revid" peripheral which is
> > located at offset 0x100.
> > 
> > And the result is:
> > 
> > [    0.963944] sysfs: cannot create duplicate filename '/bus/platform/devices/100.revid'
> 
> The duplicate filename error is because pm8x41_probe() is calling of_platform_populate()
> directly.
> 
> If that call is removed then there is no attempt to create a revid file in
> /sys/bus/platform/devices.  If I add your pm8841@4 node to my dts file, then
> the 100.revid file is properly created at
> 
>   /sys/firmware/devicetree/base/soc/qcom,spmi@fc4cf000/pm8841@4/qcom,revid@100
> 
> and no attempt is made to create /sys/bus/platform/devices/100.revid
> 
> This appears to be correct to me, because I do not think revid should be created as
> a platform device.
> 

Wait, what?  That's the entire point of this driver.

[...] 
> > Any suggestions?
> 
> Remove of_platform_populate() from pm8x41_probe().  Do you know of any
> other reason it can not be removed?

I do!  If you remove it, the entire driver becomes a useless pile of
nothing!

The PMICs targeted by this driver are mostly made up of independent
blocks which should be able to be written as standalone device drivers.
The design of this driver is to create a simple bus-like layer between
SPMI and these independent blocks.  of_platform_populate() is what makes
it work.

-Courtney
