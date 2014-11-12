Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaKLPpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:45:16 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:63866 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaKLPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:45:13 -0500
MIME-Version: 1.0
In-Reply-To: <20141104154231.GP31454@atomide.com>
References: <20141102180756.GH31454@atomide.com>
	<5458D29E.50908@compulab.co.il>
	<20141104154231.GP31454@atomide.com>
Date: Wed, 12 Nov 2014 17:45:12 +0200
Message-ID: <CANOLnOP8JmROaCruC8NEwh+Nzq_-fFit-+5d_W9vU9KtNTphoA@mail.gmail.com>
Subject: Re: [PATCH] mfd: twl4030-power: Fix poweroff with PM configuration enabled
From: Grazvydas Ignotas <notasas@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 5:42 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Igor Grinberg <grinberg@compulab.co.il> [141104 05:22]:
>> Hi Tony,
>>
>> On 11/02/14 20:07, Tony Lindgren wrote:
>> > Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
>> > configuration") enabled configuring the PM features for twl4030.
>> >
>> > This caused poweroff command to fail on devices that have the
>> > BCI charger on twl4030 wired, or have power wired for VBUS.
>> > Instead of powering off, the device reboots. This is because
>> > voltage is detected on charger or VBUS with the default bits
>> > enabled for the power transition registers.
>> >
>> > To fix the issue, let's just clear VBUS and CHG bits as we want
>> > poweroff command to keep the system powered off.
>>
>> What about devices that really need to start once VBUS or CHG is connected?
>
> More handling can be added for some cases. With this patch the
> poweron bits will clear to defaults if power is completely removed.
> So start-up with VBUS and CHG works in that case.
>
> However, if you have a battery connected, and you poweroff, with
> this patch the device won't power up with VBUS or CHG connected.
>
> Note that most battery operated devices are not using the charger
> on twl4030 because it has issues charging a completely empty
> battery AFAIK. So most battery powered devices have been using an
> external USB charger chip that's not affected by this patch.

Pandora does, as well as GTA04 AFAIK, but that's not "most devices" I
guess.. At least pandora was booting up on charger connect up until
now. I don't know why shutdown used to work for Russell in legacy boot
and it changed for DT, the device would always start up when there was
AC power here.


Grazvydas

>
> We could consider exporting a function for the charger driver to
> configure the poweron mask. And we could also consider passing a
> mask in ti,use_poweroff = 0xff.
>
>> It seems to me that forcing these bits on power off can break that kind of
>> devices and these settings should really be board specific.
>> What do you think?
>
> There's a patch series for "[RFC,01/16] kernel: Add support for
> poweroff handler call chain" that should help with that. For sure
> the poweroff handling needs to be board specific as some systems
> may need to use a GPIO to shut off a regulator powering something
> before powering off the SoC.
>
> Regards,
>
> Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
