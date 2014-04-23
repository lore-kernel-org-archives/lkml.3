Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbaDWSOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:14:14 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:12018 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756443AbaDWSOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:14:08 -0400
Date: Wed, 23 Apr 2014 11:16:14 -0700
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
Message-ID: <20140423181614.GK17066@sonymobile.com>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
 <1398259168.4724.217.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1398259168.4724.217.camel@iivanov-dev>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 03:19:28PM +0200, Ivan T. Ivanov wrote:
> 
> Hi,
> 
> On Tue, 2014-04-22 at 17:31 -0700, Courtney Cavin wrote:
> > From: Josh Cartwright <joshc@codeaurora.org>
> > 
> > The Qualcomm 8941 and 8841 PMICs are components used with the Snapdragon
> > 800 series SoC family.  This driver exists largely as a glue mfd component,
> > it exists to be an owner of an SPMI regmap for children devices
> > described in device tree.
> > 
> 
> Thanks. This is exactly what I have planed to do :-)
> 

Sorry if I usurped your work!

> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> > ---
> >  drivers/mfd/Kconfig  | 13 +++++++++++
> >  drivers/mfd/Makefile |  1 +
> >  drivers/mfd/pm8x41.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 77 insertions(+)
> >  create mode 100644 drivers/mfd/pm8x41.c
> > 
> 
> <snip>
> 
> > +
> > +static int pm8x41_probe(struct spmi_device *sdev)
> > +{
> > +	struct regmap *regmap;
> > +
> > +	regmap = devm_regmap_init_spmi_ext(sdev, &pm8x41_regmap_config);
> > +	if (IS_ERR(regmap)) {
> > +		dev_dbg(&sdev->dev, "regmap creation failed.\n");
> > +		return PTR_ERR(regmap);
> > +	}
> > +
> > +	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
> 
> I think that this will not going to work. For example in this particular
> case, both controllers have "qcom,qpnp-revid" peripheral which is
> located at offset 0x100.
> 
> And the result is:
> 
> [    0.963944] sysfs: cannot create duplicate filename '/bus/platform/devices/100.revid'
> 
[...]
> 
> Any suggestions?

That's expected behavior actually.  You have two nodes in DT named the
same thing and at the same address.  This error is due to the fact that
all devices are put in '/bus/platform/devices/' with a name made from
the unit address and name specified in DT.  There's no other unique
information used to differentiate the devices.

If you simply change the names in DT, it works.  Example follows:

qcom,pm8941@0 {
	compatible = "qcom,pm8941";
	reg = <0x0 SPMI_USID>;

	#address-cells = <1>;
	#size-cells = <0>;

	qcom,pm8941-revid@100 {
		compatible = "qcom,qpnp-revid";
		reg = <0x100>;
	};
};

qcom,pm8841@4 {
	compatible = "qcom,pm8841";
	reg = <0x4 SPMI_USID>;

	#address-cells = <1>;
	#size-cells = <0>;

	qcom,pm8841-revid@100 {
		compatible = "qcom,qpnp-revid";
		reg = <0x100>;
	};
};


[...] qcom,qpnp-revid 100.qcom,pm8841-revid: PM8841 v2.0 options: 0, 0, 2, 2
[...] qcom,qpnp-revid 100.qcom,pm8941-revid: PM8941 v3.0 options: 2, 0, 0, 0

Whether this should be "fixed" in the device/bus/sysfs core, I don't
know, but it isn't specifically an issue with this driver, and there's
little-to-nothing I can do to fix it here.

-Courtney
