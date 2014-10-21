Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaJUIpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:45:39 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43437 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaJUIpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:45:36 -0400
MIME-Version: 1.0
In-Reply-To: <1412260889.4875.11.camel@pengutronix.de>
References: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com>
	<1411443545-24951-4-git-send-email-srv_hongzhou.yang@mediatek.com>
	<CACRpkdbiKSvX2dipnq3oyc6YSGWFgCk69onzF=-B9UWLjAYNWQ@mail.gmail.com>
	<1412260889.4875.11.camel@pengutronix.de>
Date: Tue, 21 Oct 2014 10:45:35 +0200
Message-ID: <CACRpkdZiafTKeOr66AJi9sVSaHV5HOmWS-iWxQ6YvnQiTF5+UQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] dt-bindings: Add pinctrl bindings for mt65xx/mt81xx.
From: Linus Walleij <linus.walleij@linaro.org>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: "Hongzhou.Yang" <srv_hongzhou.yang@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>, srv_heupstream@mediatek.com,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>, dandan.he@mediatek.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 4:41 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
> Am Donnerstag, den 02.10.2014, 16:00 +0200 schrieb Linus Walleij:

>> > +The mediatek,pinfunc can use defines directly,
>> > +which are already defind in boot/dts/mt8135-pinfunc.h.
>> > +
>> > +Optional subnode-properties:
>> > +- generic pin configuration option to use, bias-disable, bias-pull-down,
>> > +  bias-pull,up, output-low and output-high are valid.
>> > +  Example :
>> > +       i2c0_pins_a {
>> > +               mediatek,pinfunc = <MT8135_PIN_195_SDA1__FUNC_SDA1>;
>> > +               bias-disable;
>> > +       };
>>
>> I don't like this approach at all.
>>
>> I prefer that pins are put into groups named by strings, like "i2c0-pos0"
>> inside the driver and then connected to function with a certain
>> device-related name, such as "i2c0".
>>
>
> So we should create artificial software groups where there are none in
> hardware? This sounds really backward to me. Almost every new SoC out
> there has the ability to mux every pin on it's own.

This discussion has been had again and again and again in the past,
please consult the mail archives before repeating history.

Usually the number of function to group mappings look like
they are arbitrary but in electronic practice they are not.

In practice there is one or two places where e.g. the MMC
card will be connected, you will not use every second pin
of the MMC connector for half an SPI port, even if it is possible
in theory.

> By defining artificial software groups in the driver we are pushing
> constraints in the binding that don't really exist in hardware.

The binding is supposed to be helpful when configuring the
system, so for a person setting up a new device tree that may
be helpful.

It gives them some info on what is electronically reasonable.

> So if
> someone comes up with a pin usage that isn't covered by the existing
> groups we need to change the binding.

In my experience people don't change bindings very much, because
the life cycle of an SoC is so short. They get it right the first time or
not at all.

> If the hardware allows this much freedom we should also allow it in the
> pinctrl binding.

I have to push back on this, because the pin control bindings are
exploding, and it is irresponsible of me as subsystem maintainer to
just allow anything.

Can you think of something that is both generic and helpful when
working with other systems than this?

What we need to do is get away from all "necessarily different"
bindings.

>> Then put the pin configuration (bias etc) in a separate node in the same
>> state definition like that:
>>
>> i2c0_pins_a {
>>          function = "i2c0";
>>          groups = "i2c0-pos0";
>> };
>> i2c0_pins_b {
>>          bias-disable;
>> };
>
> The problem with that is that different pins might need different
> configuration for the same muxed function. To properly reflect this we
> would need to duplicate the pin definitions. One popular example is the
> MMC interface where part of the pins need to have a pull-up, while
> others don't. How would you reflect this with the DT description above?

That's no problem. Muxing is group+function and configuration is
per-pin.

See this example:

                        uart2 {
                                uart2_default_mode: uart2_default {
                                        default_mux {
                                                function = "u2";
                                                groups = "u2rxtx_c_1";
                                        };
                                        default_cfg1 {
                                                pins = "GPIO29_W2"; /* RXD */
                                                bias-pull-up;
                                                low-power-disable;
                                        };

                                        default_cfg2 {
                                                pins = "GPIO30_W3"; /* TXD */
                                                output-high;
                                                low-power-disable;
                                        };
                                };

                                uart2_sleep_mode: uart2_sleep {
                                        sleep_cfg1 {
                                                pins = "GPIO29_W2"; /* RXD */
                                                low-power-enable;
                                        };

                                        sleep_cfg2 {
                                                pins = "GPIO30_W3"; /* TXD */
                                                low-power-enable;
                                        };
                                };
                        };


Yours,
Linus Walleij
