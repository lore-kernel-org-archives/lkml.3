Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbaJ3OCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:02:49 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33549 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaJ3OCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:02:47 -0400
Message-ID: <54524501.8030604@collabora.co.uk>
Date: Thu, 30 Oct 2014 15:02:41 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [RFT v3 06/14] regulator: max77802: Remove support for board
 files
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com> <1414668053-31370-7-git-send-email-k.kozlowski@samsung.com> <54522615.7040002@collabora.co.uk> <1414671037.23399.2.camel@AMDC1943> <54522D2C.9050002@collabora.co.uk> <1414672235.23399.7.camel@AMDC1943> <54523224.3010407@collabora.co.uk> <1414673587.23399.13.camel@AMDC1943>
In-Reply-To: <1414673587.23399.13.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/30/2014 01:53 PM, Krzysztof Kozlowski wrote:
> 
> To me a intuitive structure would be:
> MFD device
>   |
>   - clock device
>      |
>      - clock1
>      - clock2
>   - regulator device
>      |
>      - LDO1
>      - LDO2
> etc.
> 
> This also maps to structure in DTS. dev_err* messages and any
> allocations should be done on behalf of regulator device, not parent.
>
> Various drivers do this differently... The wm8* drivers set it mostly to
> parent (MFD)...
>
> I do not insists, especially because using parent's device would make
> this driver simpler.
>

Another reason to set it to the parent is to lookup the regulator input supply
node. The regulator_register() function does:

	if (supply) {
		struct regulator_dev *r;

		r = regulator_dev_lookup(dev, supply, &ret);

where dev = config->dev so that will determine on which device node your
input supplies have to be defined. For example on the Peach Pit DTS has this:

	max77802: max77802-pmic@9 {
		...
		inb1-supply = <&tps65090_dcdc2>;
		...
		inb10-supply = <&tps65090_dcdc1>;

		inl1-supply = <&buck5_reg>;
		...
		inl10-supply = <&buck7_reg>;
		...

		regulators {
		...
		};
	};

which is how most (all?) DTS define the input supplies. If you instead
do config.dev = &pdev->dev, then the input supplies have to be in the
"regulators" node which is not the standard AFAICT.

This is not a problem for max77686 because I see that DTS don't define
the input supplies but I guess that is because the power scheme is not
completely modeled.
 
> Mark, maybe you could shed light on it?
> 
> 
> Best regards,
> Krzysztof
> 
> 

Best regards,
Javier
