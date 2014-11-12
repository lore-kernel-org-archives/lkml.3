Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaKLU1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:27:07 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:62345 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbaKLU1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:27:05 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat+g9Pnyo0=
X-RZG-CLASS-ID: mo00
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] mfd: twl4030-power: Fix poweroff with PM configuration enabled
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <CANOLnOP8JmROaCruC8NEwh+Nzq_-fFit-+5d_W9vU9KtNTphoA@mail.gmail.com>
Date: Wed, 12 Nov 2014 21:26:54 +0100
Cc: Igor Grinberg <grinberg@compulab.co.il>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <515E660B-B65D-41EF-97F5-74E4DE8FDD13@goldelico.com>
References: <20141102180756.GH31454@atomide.com> <5458D29E.50908@compulab.co.il> <20141104154231.GP31454@atomide.com> <CANOLnOP8JmROaCruC8NEwh+Nzq_-fFit-+5d_W9vU9KtNTphoA@mail.gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>, Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 12.11.2014 um 16:45 schrieb Grazvydas Ignotas <notasas@gmail.com>:

> On Tue, Nov 4, 2014 at 5:42 PM, Tony Lindgren <tony@atomide.com> wrote:
>> * Igor Grinberg <grinberg@compulab.co.il> [141104 05:22]:
>>> Hi Tony,
>>> 
>>> On 11/02/14 20:07, Tony Lindgren wrote:
>>>> Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
>>>> configuration") enabled configuring the PM features for twl4030.
>>>> 
>>>> This caused poweroff command to fail on devices that have the
>>>> BCI charger on twl4030 wired, or have power wired for VBUS.
>>>> Instead of powering off, the device reboots. This is because
>>>> voltage is detected on charger or VBUS with the default bits
>>>> enabled for the power transition registers.
>>>> 
>>>> To fix the issue, let's just clear VBUS and CHG bits as we want
>>>> poweroff command to keep the system powered off.
>>> 
>>> What about devices that really need to start once VBUS or CHG is connected?
>> 
>> More handling can be added for some cases. With this patch the
>> poweron bits will clear to defaults if power is completely removed.
>> So start-up with VBUS and CHG works in that case.
>> 
>> However, if you have a battery connected, and you poweroff, with
>> this patch the device won't power up with VBUS or CHG connected.
>> 
>> Note that most battery operated devices are not using the charger
>> on twl4030 because it has issues charging a completely empty
>> battery AFAIK. So most battery powered devices have been using an
>> external USB charger chip that's not affected by this patch.
> 
> Pandora does, as well as GTA04 AFAIK,

Yes. The trick is that the power level that turns on the device is a little higher
and the battery provides enough energy for approx. 30 seconds until it drained
to a level where it turns off. Depending on general setup (WIFI must remain
powered off after boot) this is enough to boot into Linux and start full charging.
Another trick is to modify MLO and U-Boot to raise the charging current.

> but that's not "most devices“ I

Indeed.

> guess.. At least pandora was booting up on charger connect up until
> now.

Same for GTA04.

> I don't know why shutdown used to work for Russell in legacy boot
> and it changed for DT, the device would always start up when there was
> AC power here.
> 
> 
> Grazvydas
> 
>> 
>> We could consider exporting a function for the charger driver to
>> configure the poweron mask. And we could also consider passing a
>> mask in ti,use_poweroff = 0xff.

Yes, exporting these masks would be fine - if a board needs a non-default
setup.

>> 
>>> It seems to me that forcing these bits on power off can break that kind of
>>> devices and these settings should really be board specific.
>>> What do you think?
>> 
>> There's a patch series for "[RFC,01/16] kernel: Add support for
>> poweroff handler call chain" that should help with that. For sure
>> the poweroff handling needs to be board specific as some systems
>> may need to use a GPIO to shut off a regulator powering something
>> before powering off the SoC.
>> 
>> Regards,
>> 
>> Tony
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

BR,
Nikolaus

