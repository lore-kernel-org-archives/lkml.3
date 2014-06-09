Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaFIDiF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 23:38:05 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58581 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaFIDh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 23:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuKGyGXQtD9XwqQ=V1M4-tHQLBF5j5i3+-eGCawS0iJNew@mail.gmail.com>
References: <1402189798-7665-1-git-send-email-houcheng@gmail.com>
	<CAAVeFuKGyGXQtD9XwqQ=V1M4-tHQLBF5j5i3+-eGCawS0iJNew@mail.gmail.com>
Date: Mon, 9 Jun 2014 11:37:56 +0800
Message-ID: <CAL8JtxCZ_L9LnL9ZR8jb6CJmbBAv2nyye+rsrodkgAvG3mV5mQ@mail.gmail.com>
Subject: Re: [RFC PATCH] gpio: Add a defer reset object to send board specific reset
From: Houcheng Lin <houcheng@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# RESEND and please ignore previous mail #

On 2014/06/08 20:58, Alexandre Courbot wrote:
> Interesting approach to a long-standing problem. I had my own
> embarrassing attempt at it (power sequences), and more recently Olof
> (CC'd) sent something related for the MMC bus
> (http://www.spinics.net/lists/devicetree/msg18900.html - I'm not sure
> what has become of this patch?). And there are certainly other
> attempts that I don't know of. So, let's say that this time we do it
> for real. There are some points I like in your approach, like the fact
> that it is completely bus-agnostic. But although it will certainly not
> end up being as controversial as the power sequences have been, I am
> not sure everybody will agree to use the DT this way...

Thanks a lot for your reply. I not sure if DT people like this approach to use
DT. As most poeple use DT as a script to describe a hardware board: cpu,
buses, memory, address mappings and devices. But I think the DT file can also
be a interface between hardware and software engineers. From the software
engineer's view to a board, he may not get clear informed that this board's
some chip need a special reset signal when bus is on. From the hardware
engineer's view, every devices may works well on bootloader but not in Linux.
The DT file can serve as note between the two engineers, and a defered reset
object specify in DT file level can a useful note in this situation.

>> Example dts File
>> ----------------
>>     usb-ehci-chip@1211000{
>>         usb-phy = <&usb2_phy>;
>>         defer_reset_vbus {
>>             compatible = "defer-reset";
>>             reset-gpios = <&gpx3 5 1>;
>>             reset-init = <0>;
>>             reset-end = <1>;
>>             delay = <5>;
>>         };
>>     };
>
> Here I am not convinced that everybody will like the fact that this
> appears as a device of its own, with its own compatible property.
> Let's see what the DT people think of it.
Yes, this patch need DT people agree to use DT in this way.
>
> +       /* setup parameters */
> +       of_property_read_u32_array(dnode, "reset-init", reset_init, count);
> +       of_property_read_u32_array(dnode, "reset-end", reset_end, count);
> +       of_property_read_u32(dnode, "delay", &delay);
> +
> +       /* reset init */
> +       for (i = 0; i < count; i++) {
> +               gpio = of_get_named_gpio(dnode, "reset-gpios", i);
>
> Quick note: please make use of the gpiod interface in your code.
> (include/linux/gpio/consumer.h and Documentation/gpio/consumer.txt).
> That will simplify it a great deal and will force you to actually
> request the GPIOs, which you omitted here.
I ommitted this and will add code to use consumer.h in next version.
> +static int gdr_probe(struct platform_device *pdev)
> +{
> +       struct list_head *pos;
> +
> +       pr_debug("gpio defer reset probe\n");
> +       list_for_each(pos, &deferred_reset_list) {
> +               struct platform_device *pd;
> +               struct defer_reset_private *prv = list_entry(
> +                       pos, struct defer_reset_private, next);
> +               if (prv->issued)
> +                       continue;
> +               pd = of_find_device_by_node(
> +                       prv->node->parent);
> +               if (pd->dev.driver != 0) {
> +                       gdr_issue_reset(pdev, prv->node);
> +                       prv->issued = 1;
>
> Is there anything that prevents you from removing (and freeing) the
> items from the list once the reset is issued?

Nothing prevents the removing and freeing. The resources claimed by this
driver are no depend to others and should be release immediately after usage.
The free of resources will be added in next version.

>
>
>> +               }
>> +       }
>> +       list_for_each(pos, &deferred_reset_list) {
>> +               struct defer_reset_private *prv = list_entry(pos,
>> +                       struct defer_reset_private, next);
>> +               if (!prv->issued)
>> +                       return -EPROBE_DEFER;
>> +       }
>> +       return 0;
>
> If you can remove your defer_reset_private instances as they are
> processed you can simple return 0 if the list is empty, or
> -EPROBE_DEFER otherwise. And probably get rid of your "issued" member
> too.
>
> Also, once everything is processed, it would be nice to de-register your device.

Yes, the driver only need a list to keep all pending deferred reset. Once
a reset is issued, the corresponding deferred-reset object in list can be
removed and that the member "issued" can no longer needed. When list empty,
de-register this device from kernel.

>
> Before doing a more thorough review, I'd like to discuss the basic
> idea. All the previous attempts at implementing an out-of-bus reset
> mechanism are strong evidence that something like this is needed.
> Having a generic mechanism would be a great plus. I am not convinced
> that using a dummy device instance is the right thing to do though.
> Also depending on the bus or device you might desire a different
> timing for issuing the reset: e.g. I know of a modem on a discoverable
> bus (MMC) that will only let itself be probed after the reset is
> applied.

On some hardware board's resetting signal's timing sequence depends on
initialization of a device. Pull the reseting logic onto the device level fits
the original hardware and no need to modify the chip driver's source code.

However, this mechanism is encasulated as a dummy, pseudo device in kerne. By
nature, it should be a system type/errata, bus feature or kernel feature. I am
not sure if it is okay that a kernel feature code can registers a driver, run
probe code and de-register driver. Is there any suggestion ?

>
> Maybe something ought to be implemented at a deeper level, like the
> bus (as in, all of them) of even the device layer?
>
> Alex.

Thanks a lot for spending time and giving comments.
Best regards,
Houcheng Lin
