Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaJ1MLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:11:55 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48192 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaJ1MLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:11:52 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-37-544f8805e9aa
Message-id: <1414498308.24949.32.camel@AMDC1943>
Subject: Re: [PATCH 6/8] regulator: max77686: Add external GPIO control
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
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
Date: Tue, 28 Oct 2014 13:11:48 +0100
In-reply-to: <1414486356.24949.19.camel@AMDC1943>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
 <1414422226-10948-7-git-send-email-k.kozlowski@samsung.com>
 <544EA4FA.6040704@collabora.co.uk> <1414486356.24949.19.camel@AMDC1943>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xq7qsHf4hBnPX6VpsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6w6F1wlc3ibNMbdov7X48yWny70sFksenxNVaLy7vmsFnM
	OL+PyeL2ZV6LtUfusluc7mZ1EPBoae5h8/j7/DqLx99VL5g9ds66y+6xaVUnm8eda3vYPOad
	DPTYvKTeo2/LKkaPz5vkAriiuGxSUnMyy1KL9O0SuDKe3FzBVrBAsGL+g7AGxru8XYycHBIC
	JhLLL81hhbDFJC7cW8/WxcjFISSwlFHiatcLJpCEkMBnRok5m6NBbF4BA4kJDU/ZQGxhAXeJ
	+wsPgdWwCRhLbF6+BCwuImAncWP1Q2aQQcwCh1kkFj24DpZgEVCVWHD2JSOIzSlgKDHrySUm
	iG3nGSWmTbsAVsQsoC4xad4ioG4OoJOUJRr73SAWC0r8mHyPBaJEXmLzmrfMExgFZiHpmIWk
	bBaSsgWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQuLs6w7GpcesDjEKcDAq8fBGsPiH
	CLEmlhVX5h5ilOBgVhLhjYgBCvGmJFZWpRblxxeV5qQWH2Jk4uCUamCUtAjfWCOR0SE8W+ho
	yNeiKTnP93vuUdNjvbDtfkTvStVz/hvzQyJ71T/XZHDudjL7uNu0/ONaX63JJ6StV//7vEa3
	aodBhOfnrZv+PP4S3nHB9MPPp6zCaWbHa+6v31i/+j1f1zSH1xLzpbbd+9+4ryOmLyTr+prj
	G3oj5GV/vM9yCrQTK05QYinOSDTUYi4qTgQAlBu8LZECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-10-28 at 09:52 +0100, Krzysztof Kozlowski wrote:
> On pon, 2014-10-27 at 21:03 +0100, Javier Martinez Canillas wrote:
> > Hello Krzysztof,
> > 
> > On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
> > > @@ -85,6 +91,9 @@ struct max77686_data {
> > >  	struct max77686_regulator_data *regulators;
> > >  	int num_regulators;
> > >  
> > > +	/* Array of size num_regulators with GPIOs for external control. */
> > > +	int *ext_control_gpio;
> > > +
> > 
> > The integer-based GPIO API is deprecated in favor of the descriptor-based GPIO
> > interface (Documentation/gpio/consumer.txt). Could you please use the later?
> 
> Sure, I can. Please have in mind that regulator core still accepts old
> GPIO so I will have to use desc_to_gpio(). That should work... and
> should be future-ready.

It seems I was too hasty... I think usage of the new gpiod API implies
completely different bindings.

The gpiod_get() gets GPIO from a device level, not from given sub-node
pointer. This means that you cannot have DTS like this:
ldo21_reg: ldo21 {
	regulator-compatible = "LDO21";
	regulator-name = "VTF_2.8V";
	regulator-min-microvolt = <2800000>;
	regulator-max-microvolt = <2800000>;
	ec-gpio = <&gpy2 0 0>;
};

ldo22_reg: ldo22 {
	regulator-compatible = "LDO22";
	regulator-name = "VMEM_VDD_2.8V";
	regulator-min-microvolt = <2800000>;
	regulator-max-microvolt = <2800000>;
	ec-gpio = <&gpk0 2 0>;
};


I could put GPIOs in device node:

max77686_pmic@09 {
	compatible = "maxim,max77686";
	interrupt-parent = <&gpx0>;
	interrupts = <7 0>;
	reg = <0x09>;
	#clock-cells = <1>;
	ldo21-gpio = <&gpy2 0 0>;
	ldo22-gpio = <&gpk0 2 0>;

	ldo21_reg: ldo21 {
		regulator-compatible = "LDO21";
		regulator-name = "VTF_2.8V";
		regulator-min-microvolt = <2800000>;
		regulator-max-microvolt = <2800000>;
	};

	ldo22_reg: ldo22 {
		regulator-compatible = "LDO22";
		regulator-name = "VMEM_VDD_2.8V";
		regulator-min-microvolt = <2800000>;
		regulator-max-microvolt = <2800000>;
	};

This would work but I don't like it. The properties of a regulator are
above the node configuring that regulator.

Any ideas?

Best regards,
Krzysztof


