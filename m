Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbaJ3N45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:56:57 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:61217 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759871AbaJ3N4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:56:54 -0400
MIME-Version: 1.0
In-Reply-To: <5450C63B.3000602@collabora.co.uk>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
 <1414422226-10948-7-git-send-email-k.kozlowski@samsung.com>
 <544EA4FA.6040704@collabora.co.uk> <1414486356.24949.19.camel@AMDC1943>
 <1414498308.24949.32.camel@AMDC1943> <1414579362.18868.11.camel@AMDC1943> <5450C63B.3000602@collabora.co.uk>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 30 Oct 2014 22:56:33 +0900
Message-ID: <CAAVeFuLncbkNLGxEAj90yMmugRDNjtjeGoV_QYTMDZ7NVMJCmg@mail.gmail.com>
Subject: Re: [PATCH 6/8] regulator: max77686: Add external GPIO control
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, and thanks for bringing this issue to us!

On Wed, Oct 29, 2014 at 7:49 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> [adding Linus and Alexandre to the cc list]
>
> Hello Krzysztof,
>
> On 10/29/2014 11:42 AM, Krzysztof Kozlowski wrote:
>> On wto, 2014-10-28 at 13:11 +0100, Krzysztof Kozlowski wrote:
>>> On wto, 2014-10-28 at 09:52 +0100, Krzysztof Kozlowski wrote:
>>> > On pon, 2014-10-27 at 21:03 +0100, Javier Martinez Canillas wrote:
>>> > > Hello Krzysztof,
>>> > >
>>> > > On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
>>> > > > @@ -85,6 +91,9 @@ struct max77686_data {
>>> > > >        struct max77686_regulator_data *regulators;
>>> > > >        int num_regulators;
>>> > > >
>>> > > > +      /* Array of size num_regulators with GPIOs for external control. */
>>> > > > +      int *ext_control_gpio;
>>> > > > +
>>> > >
>>> > > The integer-based GPIO API is deprecated in favor of the descriptor-based GPIO
>>> > > interface (Documentation/gpio/consumer.txt). Could you please use the later?
>>> >
>>> > Sure, I can. Please have in mind that regulator core still accepts old
>>> > GPIO so I will have to use desc_to_gpio(). That should work... and
>>> > should be future-ready.
>>>
>>> It seems I was too hasty... I think usage of the new gpiod API implies
>>> completely different bindings.
>>>
>>> The gpiod_get() gets GPIO from a device level, not from given sub-node
>>> pointer. This means that you cannot have DTS like this:
>>> ldo21_reg: ldo21 {
>>>      regulator-compatible = "LDO21";
>>>      regulator-name = "VTF_2.8V";
>>>      regulator-min-microvolt = <2800000>;
>>>      regulator-max-microvolt = <2800000>;
>>>      ec-gpio = <&gpy2 0 0>;
>>> };
>>>
>>> ldo22_reg: ldo22 {
>>>      regulator-compatible = "LDO22";
>>>      regulator-name = "VMEM_VDD_2.8V";
>>>      regulator-min-microvolt = <2800000>;
>>>      regulator-max-microvolt = <2800000>;
>>>      ec-gpio = <&gpk0 2 0>;
>>> };
>>>
>>>
>>> I could put GPIOs in device node:
>>>
>>> max77686_pmic@09 {
>>>      compatible = "maxim,max77686";
>>>      interrupt-parent = <&gpx0>;
>>>      interrupts = <7 0>;
>>>      reg = <0x09>;
>>>      #clock-cells = <1>;
>>>      ldo21-gpio = <&gpy2 0 0>;
>>>      ldo22-gpio = <&gpk0 2 0>;
>>>
>>>      ldo21_reg: ldo21 {
>>>              regulator-compatible = "LDO21";
>>>              regulator-name = "VTF_2.8V";
>>>              regulator-min-microvolt = <2800000>;
>>>              regulator-max-microvolt = <2800000>;
>>>      };
>>>
>>>      ldo22_reg: ldo22 {
>>>              regulator-compatible = "LDO22";
>>>              regulator-name = "VMEM_VDD_2.8V";
>>>              regulator-min-microvolt = <2800000>;
>>>              regulator-max-microvolt = <2800000>;
>>>      };
>>>
>>> This would work but I don't like it. The properties of a regulator are
>>> above the node configuring that regulator.
>>>
>>> Any ideas?
>>>
>>
>> Continuing talking to myself... I found another problem - GPIO cannot be
>> requested more than once (-EBUSY). In case of this driver (and board:
>> Trats2) one GPIO is connected to regulators. The legacy GPIO API and
>> regulator core handle this.
>>
>> With new GPIO API I would have to implement some additional steps in
>> such case...
>>
>> So there are 2 issues:
>> 1. Cannot put GPIO property in regulator node.

For this problem you will probably want to use the
dev(m)_get_named_gpiod_from_child() function from the following patch:

https://lkml.org/lkml/2014/10/6/529

It should reach -next soon now.

>> 2. Cannot request some GPIO more than once.

We have been confronted to this problem with the regulator core as well:

http://marc.info/?l=linux-arm-kernel&m=140417649119733&w=1

I have a draft patch that allows GPIOs to be requested by several
clients. What prevented me from submitting it was that I wanted to
make sure the different requested configurations were compatible, but
maybe I am overthinking this. There are also a couple of other patches
that this depends on (like removal of the big descs array), so I don't
think it will be available too soon, sadly.

So maybe your best shot for now is to keep using the integer API, as
much as I hate it. Once we become able to request the same GPIO
several times, you should be good to switch to descriptors. Sorry this
has not been done faster.
