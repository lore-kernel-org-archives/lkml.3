Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbaDPKj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:39:56 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:64215 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbaDPKju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:39:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140416094428.GK3207@lukather>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
 <1397544101-18135-8-git-send-email-wens@csie.org> <20140415144215.GG3207@lukather>
 <CAGb2v643HyvFdhQ0znreB8ENXHWpcx6tFwdeU7VuU8KYWcT4ZA@mail.gmail.com> <20140416094428.GK3207@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 16 Apr 2014 18:39:28 +0800
X-Google-Sender-Auth: QwDa0vvjbVpZXvkVr45F8Mg4E-g
Message-ID: <CAGb2v67HzB22a3huRRZyufXkdTFE410MhXqAHyC-MmVo0-GCFA@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 7/7] ARM: sun7i: cubietruck: enable
 bluetooth module
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "maxime.ripard" <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 16, 2014 at 5:44 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi,
>
> Please try to keep me in CC, even though the ML doesn't make it easy..

Sorry about that.

> On Wed, Apr 16, 2014 at 12:06:59AM +0800, Chen-Yu Tsai wrote:
>> >> @@ -139,4 +152,16 @@
>> >>       reg_usb2_vbus: usb2-vbus {
>> >>               status = "okay";
>> >>       };
>> >> +
>> >> +     rfkill_bt {
>> >> +             compatible = "rfkill-gpio";
>> >> +             pinctrl-names = "default";
>> >> +             pinctrl-0 = <&bt_pwr_pin_cubietruck>, <&clk_out_a_pins_a>;
>> >> +             clocks = <&clk_out_a>;
>> >> +             clock-frequency = <32768>;
>> >> +             gpios = <&pio 7 18 0>; /* PH18 */
>> >> +             gpio-names = "reset";
>> >> +             rfkill-name = "bt";
>> >> +             rfkill-type = <2>;
>> >> +     };
>> >
>> > Hmmm, I don't think that's actually right.
>> >
>> > If you have such a device, then I'd expect it to be represented as a
>> > full device in the DT, probably with one part for the WiFi, one part
>> > for the Bluetooth, and here the definition of the rfkill device that
>> > controls it.
>>
>> The AP6210 is not one device, but 2 separate chips in one module. Each
>> chip has its own controls and interface. They just so happen to share
>> the same enclosure. Even 2-in-1 chips by Broadcom have separate controls
>> and interfaces. The WiFi side is most likely connected via SDIO, while
>> the Bluetooth side is connected to a UART, and optionally I2S for sound.
>
> It's even easier to represent then.
>
>> > But tying parts of the device to the rfkill that controls it, such as
>> > the clocks, or the frequency it runs at seems just wrong.
>>
>> I understand where you're coming from. For devices on buses that require
>> drivers (such as USB, SDIO) these properties probably should be tied to
>> the device node.
>>
>> For our use case here, which is a bluetooth chip connected on the UART,
>> there is no in kernel representation or driver to tie them to. Same goes
>> for UART based GPS chips. They just so happen to require toggling a GPIO,
>> and maybe enabling a specific clock, to get it running. Afterwards,
>> accessing it is done solely from userspace. For our Broadcom chips, the
>> user has to upload its firmware first, then designate the tty as a Bluetooth
>> HCI using hciattach.
>>
>> We are using the rfkill device as a on-off switch.
>
> I understand your point, but the fact that it's implemented in
> user-space, or that UART is not a bus (which probably should be), is
> only a Linux specific story, and how it's implemented in Linux (even
> if the whole rfkill node is another one, but let's stay on topic).

I gave it some thought last night. You are right. My whole approach
is wrong. But let's try to make it right.

So considering the fact that it's primarily connected to a UART,
maybe I should make it a sub-node to the UART node it's actually
connected to? Something like:

        uart2: serial@01c28800 {
                pinctrl-names = "default";
                pinctrl-0 = <&uart2_pins_a>;
                status = "okay";

                bt: bt_hci {
                        compatible = "brcm,bcm20710";
                        /* maybe add some generic compatible */
                        pinctrl-names = "default";
                        pinctrl-0 = <&clk_out_a_pins_a>,
<&bt_pwr_pin_cubietruck>;
                        clocks = <&clk_out_a>;
                        clock-frequency = <32768>;
                        gpios = <&pio 7 18 0>; /* PH18 */
                };
        };

And let the uart core handle power sequencing for sub-nodes.

The rfkill node would still have the gpios and clocks, but not the
clock-frequency property. It's sole purpose would be to toggle the
controls. But I think the placement is still odd. Perhaps these
virtual devices shouldn't live in the DT at all.

> This is a huge abstraction leak.
>
> Let's say you need the I2S stream you mentionned for some
> reason. Would you tie the audio stream to the rfkill node as well?
> I'm sorry, but from an hardware description perspective, it makes no
> sense.

The above revision should be better, from a hardware perspective. I'm
not sure how to tie in the I2S stream, and there I haven't found any
examples in the DT tree.

> What's the feeling of the DT maintainers?


Cheers

ChenYu
