Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbaKAFrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 01:47:53 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:54821 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaKAFrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 01:47:51 -0400
MIME-Version: 1.0
In-Reply-To: <1414741898.20071.8.camel@AMDC1943>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
 <1414422226-10948-7-git-send-email-k.kozlowski@samsung.com>
 <544EA4FA.6040704@collabora.co.uk> <1414486356.24949.19.camel@AMDC1943>
 <1414498308.24949.32.camel@AMDC1943> <1414579362.18868.11.camel@AMDC1943>
 <5450C63B.3000602@collabora.co.uk> <CAAVeFuLncbkNLGxEAj90yMmugRDNjtjeGoV_QYTMDZ7NVMJCmg@mail.gmail.com>
 <1414681386.26703.6.camel@AMDC1943> <CAAVeFuJo1wTyxOo4FEZM3=GTejuSHi+mnr=QV6HUeV5mAOCmqg@mail.gmail.com>
 <1414741898.20071.8.camel@AMDC1943>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 1 Nov 2014 14:47:29 +0900
Message-ID: <CAAVeFuL7XiP3e4+pQt_asL+0f-UpffTvj0Mt=D0TPevW4hT=zA@mail.gmail.com>
Subject: Re: [PATCH 6/8] regulator: max77686: Add external GPIO control
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 4:51 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> On pią, 2014-10-31 at 12:31 +0900, Alexandre Courbot wrote:
>> On Fri, Oct 31, 2014 at 12:03 AM, Krzysztof Kozlowski
>> <k.kozlowski@samsung.com> wrote:
>> > On czw, 2014-10-30 at 22:56 +0900, Alexandre Courbot wrote:
>> >> Hi, and thanks for bringing this issue to us!
>> >>
>> >> On Wed, Oct 29, 2014 at 7:49 PM, Javier Martinez Canillas
>> >> <javier.martinez@collabora.co.uk> wrote:
>> >> > [adding Linus and Alexandre to the cc list]
>> >> >
>> >> > Hello Krzysztof,
>> >> >
>> >> > On 10/29/2014 11:42 AM, Krzysztof Kozlowski wrote:
>> >> >> On wto, 2014-10-28 at 13:11 +0100, Krzysztof Kozlowski wrote:
>> >> >>> On wto, 2014-10-28 at 09:52 +0100, Krzysztof Kozlowski wrote:
>> >> >>> > On pon, 2014-10-27 at 21:03 +0100, Javier Martinez Canillas wrote:
>> >> >>> > > Hello Krzysztof,
>> >> >>> > >
>> >> >>> > > On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
>> >> >>> > > > @@ -85,6 +91,9 @@ struct max77686_data {
>> >> >>> > > >        struct max77686_regulator_data *regulators;
>> >> >>> > > >        int num_regulators;
>> >> >>> > > >
>> >> >>> > > > +      /* Array of size num_regulators with GPIOs for external control. */
>> >> >>> > > > +      int *ext_control_gpio;
>> >> >>> > > > +
>> >> >>> > >
>> >> >>> > > The integer-based GPIO API is deprecated in favor of the descriptor-based GPIO
>> >> >>> > > interface (Documentation/gpio/consumer.txt). Could you please use the later?
>> >> >>> >
>> >> >>> > Sure, I can. Please have in mind that regulator core still accepts old
>> >> >>> > GPIO so I will have to use desc_to_gpio(). That should work... and
>> >> >>> > should be future-ready.
>> >> >>>
>> >> >>> It seems I was too hasty... I think usage of the new gpiod API implies
>> >> >>> completely different bindings.
>> >> >>>
>> >> >>> The gpiod_get() gets GPIO from a device level, not from given sub-node
>> >> >>> pointer. This means that you cannot have DTS like this:
>> >> >>> ldo21_reg: ldo21 {
>> >> >>>      regulator-compatible = "LDO21";
>> >> >>>      regulator-name = "VTF_2.8V";
>> >> >>>      regulator-min-microvolt = <2800000>;
>> >> >>>      regulator-max-microvolt = <2800000>;
>> >> >>>      ec-gpio = <&gpy2 0 0>;
>> >> >>> };
>> >> >>>
>> >> >>> ldo22_reg: ldo22 {
>> >> >>>      regulator-compatible = "LDO22";
>> >> >>>      regulator-name = "VMEM_VDD_2.8V";
>> >> >>>      regulator-min-microvolt = <2800000>;
>> >> >>>      regulator-max-microvolt = <2800000>;
>> >> >>>      ec-gpio = <&gpk0 2 0>;
>> >> >>> };
>> >> >>>
>> >> >>>
>> >> >>> I could put GPIOs in device node:
>> >> >>>
>> >> >>> max77686_pmic@09 {
>> >> >>>      compatible = "maxim,max77686";
>> >> >>>      interrupt-parent = <&gpx0>;
>> >> >>>      interrupts = <7 0>;
>> >> >>>      reg = <0x09>;
>> >> >>>      #clock-cells = <1>;
>> >> >>>      ldo21-gpio = <&gpy2 0 0>;
>> >> >>>      ldo22-gpio = <&gpk0 2 0>;
>> >> >>>
>> >> >>>      ldo21_reg: ldo21 {
>> >> >>>              regulator-compatible = "LDO21";
>> >> >>>              regulator-name = "VTF_2.8V";
>> >> >>>              regulator-min-microvolt = <2800000>;
>> >> >>>              regulator-max-microvolt = <2800000>;
>> >> >>>      };
>> >> >>>
>> >> >>>      ldo22_reg: ldo22 {
>> >> >>>              regulator-compatible = "LDO22";
>> >> >>>              regulator-name = "VMEM_VDD_2.8V";
>> >> >>>              regulator-min-microvolt = <2800000>;
>> >> >>>              regulator-max-microvolt = <2800000>;
>> >> >>>      };
>> >> >>>
>> >> >>> This would work but I don't like it. The properties of a regulator are
>> >> >>> above the node configuring that regulator.
>> >> >>>
>> >> >>> Any ideas?
>> >> >>>
>> >> >>
>> >> >> Continuing talking to myself... I found another problem - GPIO cannot be
>> >> >> requested more than once (-EBUSY). In case of this driver (and board:
>> >> >> Trats2) one GPIO is connected to regulators. The legacy GPIO API and
>> >> >> regulator core handle this.
>> >> >>
>> >> >> With new GPIO API I would have to implement some additional steps in
>> >> >> such case...
>> >> >>
>> >> >> So there are 2 issues:
>> >> >> 1. Cannot put GPIO property in regulator node.
>> >>
>> >> For this problem you will probably want to use the
>> >> dev(m)_get_named_gpiod_from_child() function from the following patch:
>> >>
>> >> https://lkml.org/lkml/2014/10/6/529
>> >>
>> >> It should reach -next soon now.
>> >
>> > Thanks! Probably I would switch to "top" level gpios property anyway
>> > (other reasons) but it would be valuable in some cases to specify them
>> > per child node.
>>
>> Mmm, but doesn't it make more sense to have them in the child nodes?
>
> Yes, it makes more sense. Using old way of parsing regulators from DT it
> was straightforward.
>
> However new DT style parsing (regulator_of_get_init_data()) does the
> basic parsing stuff and this removes a lot of code from driver. The
> driver no longer parses all regulaotrs but the regulator core does it.
> Unfortunately regulator core does not parse custom bindings (like such
> GPIOs) so I would have to iterate once again through all regulators just
> to find "gpios" property.
>
> It is simpler just to do something like (5 regulators can be controlled
> by GPIO):
>
> max77686_pmic_dt_parse_gpio_control(struct platform_device *pdev, *gpio)
> {
>   gpio[MAX77686_LDO20] = of_get_named_gpio(np, "ldo20-gpios", 0);
>   gpio[MAX77686_LDO21] = of_get_named_gpio(np, "ldo21-gpios", 0);
>   gpio[MAX77686_LDO22] = of_get_named_gpio(np, "ldo22-gpios", 0);
>   gpio[MAX77686_BUCK8] = of_get_named_gpio(np, "buck8-gpios", 0);
>   gpio[MAX77686_BUCK9] = of_get_named_gpio(np, "buck9-gpios", 0);
> }

It is simpler from the driver's perspective, but if I understand
correctly DT bindings are not supposed to be adapted to make life
easier for a particular implementation. If the driver needs to make an
additional pass into the child nodes, then so be it, as long as the
nodes describe the hardware accurately and in a way that is easy to
understand. You can always adapt the driver core to handle your
use-case better, but once DT bindings are published, they are set in
stone.
