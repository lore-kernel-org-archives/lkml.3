Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbaJ2UOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:14:14 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:49780 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651AbaJ2UOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <20141028215137.GG9255@lukather>
References: <cover.1414444953.git.rbyshko@gmail.com> <210cc2a03d43e3d65b08f302b3b32663044ad94f.1414444953.git.rbyshko@gmail.com>
 <20141028215137.GG9255@lukather>
From: Roman Byshko <rbyshko@gmail.com>
Date: Wed, 29 Oct 2014 21:13:50 +0100
Message-ID: <CAMXmWBmU0j_tf_fseDP5p527SaO=iLB-=fKp1PCvE9J6FQk6dw@mail.gmail.com>
Subject: Re: [PATCH 2/5] ARM: dtsi: sunxi: add common VBUS regulator
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

thank you for the review!

On Tue, Oct 28, 2014 at 10:51 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Mon, Oct 27, 2014 at 10:43:02PM +0100, Roman Byshko wrote:
>> Until now the regulator nodes for powering USB VBUS
>> existed only for the two host controllers. Now the regulator
>> is added for USB OTG too.
>> ---
>>  arch/arm/boot/dts/sunxi-common-regulators.dtsi | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/sunxi-common-regulators.dtsi b/arch/arm/boot/dts/sunxi-common-regulators.dtsi
>> index c9c5b10..f521672 100644
>> --- a/arch/arm/boot/dts/sunxi-common-regulators.dtsi
>> +++ b/arch/arm/boot/dts/sunxi-common-regulators.dtsi
>> @@ -21,6 +21,13 @@
>>                               allwinner,pull = <0>;
>>                       };
>>
>> +                     usb0_vbus_pin_a: usb0_vbus_pin@0 {
>> +                             allwinner,pins = "PB9";
>> +                             allwinner,function = "gpio_out";
>> +                             allwinner,drive = <0>;
>> +                             allwinner,pull = <0>;
>> +                     };
>> +
>>                       usb1_vbus_pin_a: usb1_vbus_pin@0 {
>>                               allwinner,pins = "PH6";
>>                               allwinner,function = "gpio_out";
>> @@ -49,6 +56,18 @@
>>               status = "disabled";
>>       };
>>
>> +     reg_usb0_vbus: usb0-vbus {
>> +             compatible = "regulator-fixed";
>> +             pinctrl-names = "default";
>> +             pinctrl-0 = <&usb0_vbus_pin_a>;
>> +             regulator-name = "usb0-vbus";
>> +             regulator-min-microvolt = <5000000>;
>> +             regulator-max-microvolt = <5000000>;
>> +             enable-active-high;
>> +             gpio = <&pio 1 9 0>;
>> +             status = "disabled";
>> +     };
>
> We're using these regulators because a huuuge majority of the boards
> out there, regardless of their SoC, are using the same GPIO to drive
> the same regulator. Is this the case here? What board have you looked
> at?

Currently I'm developing and testing for Cubietruck. I also have a few
other boards (with different SoC), I will add corresponding DT nodes
for them later.

As for GPIO which is used to drive the USB0 VBUS pin.

$ git remote show origin
* remote origin
  Fetch URL: https://github.com/linux-sunxi/sunxi-boards.git
  Push  URL: https://github.com/linux-sunxi/sunxi-boards.git
...
$ grep -A7 usbc0 -r . | grep usb_drv_vbus_gpio | grep port | sort |
cut -d: -f2 | cut -d "<" -f1 | sort | uniq -c
      1 PA16
      1 PA17
     67 PB09
      4 PB10
      1 PB9
      1 PC17
      1 PD25
      4 PG11
     21 PG12
      1 PG13
      1 PH17
      4 power4

So PB09 is most often used. PG12 is used on (alsmost always) A13. So
propose to make PB09 default, then override it in sun5i-a13.dtsi and
later in board dts file if needed.

Cubietruck uses PH17. That is why I override PB09 in its dts file.

Sounds good?

Best,
Roman


> Thanks,
> Maxime
>
> --
> Maxime Ripard, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
