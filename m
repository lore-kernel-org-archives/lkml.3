Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaBMJ3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:29:20 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:35843 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaBMJ3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:29:15 -0500
MIME-Version: 1.0
In-Reply-To: <52FC8CB3.4090305@gmail.com>
References: <1392059868-8782-1-git-send-email-arend@broadcom.com> <52FC8CB3.4090305@gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 13 Feb 2014 17:28:53 +0800
X-Google-Sender-Auth: muXG6hdV86dFLHbusD6gDBQt4CQ
Message-ID: <CAGb2v67za+5yW3RE0pwBWk-NdTUSm-JkKE+j9NLjbBkE_Fc1hQ@mail.gmail.com>
Subject: Re: [RFC] dt: bindings: add bindings for Broadcom bcm43xx sdio devices
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 13, 2014 at 5:13 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Arend,
>
>
> On 10.02.2014 20:17, Arend van Spriel wrote:
>>
>> The Broadcom bcm43xx sdio devices are fullmac devices that may be
>> integrated in ARM platforms. Currently, the brcmfmac driver for
>> these devices support use of platform data. This patch specifies
>> the bindings that allow this platform data to be expressed in the
>> devicetree.
>>
>> Cc: Chen-Yu Tsai <wens@csie.org>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>> This devicetree binding proposal is intended for platforms with
>> Broadcom wireless device in MMC sdio slot. These devices may
>> have their own interrupt and power line. Also the SDIO drive
>> strength is often hardware dependent and expressed in this
>> binding.
>>
>> Not sure if this should go in staging or not. Feel free to
>> comment on this proposal.
>>
>> Regards,
>> Arend
>> ---
>>   .../staging/net/wireless/brcm,bcm43xx-fmac.txt     |   37
>> ++++++++++++++++++++
>>   1 file changed, 37 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/staging/net/wireless/brcm,bcm43xx-fmac.txt
>>
>> diff --git
>> a/Documentation/devicetree/bindings/staging/net/wireless/brcm,bcm43xx-fmac.txt
>> b/Documentation/devicetree/bindings/staging/net/wireless/brcm,bcm43xx-fmac.txt
>> new file mode 100644
>> index 0000000..535f343
>> --- /dev/null
>> +++
>> b/Documentation/devicetree/bindings/staging/net/wireless/brcm,bcm43xx-fmac.txt
>> @@ -0,0 +1,37 @@
>> +Broadcom BCM43xx Fullmac wireless SDIO devices
>> +
>> +This node provides properties for controlling the Broadcom wireless
>> device. The
>> +node is expected to be specified as a child node to the MMC controller
>> that
>> +connects the device to the system.
>> +
>> +Required properties:
>> +
>> + - compatible : Should be "brcm,bcm43xx-fmac".
>> + - wlan-supply : phandle for fixed regulator used to control power for
>> +       the device/module.
>
>
> The BCM43xx WLAN chips I used to work always have been controlled by a
> simple power enable GPIO of the chip itself. Has this changed in newer
> chips?

Actually some (I only have one kind) of the chips have 2 GPIO lines,
but they are almost always tied together in the module or on the
board.

> If you need to simply toggle a GPIO to control the power, you don't need to
> use the regulator API at all, controlling the GPIO directly.
>
>
>> +
>> +Optional properties:
>> + - drive-strength : drive strength used for SDIO pins on device (default
>> = 6mA).
>
>
> This should be a part of the MMC binding, I think. Probably also moved under
> MMC controller's node, since it's a board-specific property altering the
> parameters of the MMC controller, not the WLAN chip.

AFAIK, this controls the drive strength for MMC on the WLAN chip's MMC
controller.

>> + - interrupt-parent : the phandle for the interrupt controller to which
>> the
>> +       device interrupt (HOST_WAKE) is connected.
>> + - interrupts : interrupt specifier encoded according the interrupt
>> controller
>> +       specified by interrupt-parent property.
>
>
> I would also add a clock here, since the BCM43xx chips usually need a 32k
> clock to operate (or at least the ones I used to work with did). It can be
> optional, as not all systems can control this clock.

2, the main oscillator (MHz range) and the low power clock (32.768 KHz).
In the other thread, someone mentioned they had to enable the main
oscillator separately.

>> +
>> +Example:
>> +
>> +mmc3: mmc@01c20000 {
>> +       pinctrl-0 = <&mmc3_pins>;
>> +       pinctrl-1 = <&wifi_host_wake>;
>
>
> WLAN_HOST_WAKE pin (aka the OOB interrupt) is specific to the WLAN chip, so
> this should be rather configured in a pinctrl state of the WLAN chip itself.

AFAIK, the pinctrl in tied to the device node, and is selected when the device
is registered. The MMC subsystem currently does not register child nodes, so
this would be useless.

brcmfmac actually has to walk the whole DT to find the node with the right
compatible.

>> +       vmmc-supply = <&mmc3_supply>;
>> +       bus-width = <4>;
>> +
>> +       bcm4335: bcm4335@0 {
>
>
> nit: Why @0, if there is no reg property under this node?

Off chance that you have 2 or more nodes with the same name?
The node name should be more generic, too.

This brings about a different problem, how should driver in its current
state, differentiate between the two? And brcmfmac only supports one set
of platform data ATM.


Cheers
ChenYu


> Best regards,
> Tomasz
>
>
>> +               compatible = "brcm,bcm43xx-fmac";
>> +               wlan-supply = <&wlan-reg>;
>> +               drive-strength = <4>;
>> +               interrupt-parent = <&gpx2>;
>> +               interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
>> +               interrupt-names = "HOST_WAKE";
>> +       };
>> +};
>> +
>>
>
