Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab3K1J65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:58:57 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:37613 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3K1J6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:58:51 -0500
MIME-Version: 1.0
In-Reply-To: <1619468.NHTb5ylADI@vostro.rjw.lan>
References: <1385566500-7666-1-git-send-email-ulf.hansson@linaro.org>
	<1619468.NHTb5ylADI@vostro.rjw.lan>
Date: Thu, 28 Nov 2013 10:58:48 +0100
Message-ID: <CAPDyKFq0OW+uhBF1pMvY01peC1dRERtSdSNY15O=vvdY_XvQUA@mail.gmail.com>
Subject: Re: [PATCH 0/5] PM: Enable option of re-use runtime PM callbacks at
 system suspend
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2013 21:42, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, November 27, 2013 04:34:55 PM Ulf Hansson wrote:
>> To put devices into low power state during system suspend, it may be convenient
>> for runtime PM supported subsystems, power domains and drivers to have the
>> option of re-using the runtime PM callbacks.
>>
>> At the moment, quite complex solutions exist for power domains that tries to
>> handle the above, like for OMAP2. The idea here, is to make it possible for
>> drivers, who should know best, how to easiest put their devices into low power
>> state. The intent is thus not only to simplify drivers but also power domains.
>
> So this is not entirely correct and stems from the fact that you are only
> considering one platform.

Bad wording from my side, sorry.

I guess you realize, that am mostly working on ARM SoCs, but that
involve many platforms and drivers. In these cases it is quite common
that drivers are the best "decision makers" for PM. It is also very
common to have power domain regulators.

This combination is almost impossible to support without "hacks" as of
today, especially if you have a more complex situation were the driver
is attached to both a bus and a power domain, and were those also are
handling runtime PM resources.

>
> On some other platforms, like x86 PC for one example, device drivers have no
> idea how to put their devices into low power states at all, because that
> depends on what's there in the ACPI tables.
>
> This becomes clearly visible when you try to use the same driver on two
> different platforms that have different board layouts and power configurations.
> And if one of them uses ACPI by chance, the driver shouldn't really fiddle with
> its little knobs for clocks and power rails directly.

Again, this patch set will only provide the option of being able to
re-use runtime PM callbacks during system suspend; could also be
considered as fundamental "building blocks" for those SoCs who needs
this.

Additionally and important, it wont break nor interfere with any other
platforms like x86, which of course is very important. On the other
hand, if it makes sense for other platforms to use these new building
blocks they have the opportunity to do so.

>
>> Additionally, some drivers seems to have messed up things when combining
>> runtime PM with system PM. While we enable the option of re-using the runtime
>> PM callbacks during system PM, we also intend to clarify the way forward for
>> how these scenarios could be resolved.
>>
>> Some new helper macros for defining PM callbacks and two new pm_generic*
>> functions has been implemented in this patch set. These are provided to make it
>> easier for those who wants to enable the option of re-using the runtime PM
>> callbacks during system suspend.
>
> I'm generally opposed to re-using callbacks like this, because it adds confusion
> to the picture.  It may seem to be clever, but in fact it leads to bad design
> choices in the drivers in my opinion.

In my world of the kernel, it will clearly resolve confusions and
simplify a significant amount of code in power domains, buses and
drivers. So I guess it depends on from what point you look at this.

And, as you stated previously during these discussions, we have the
opportunity to update the documentation around this topic, I will
happily do it, if needed.

>
> Let's talk about specific examples, though.
>
> Why exactly do you need what patch [5/5] does in the exynos_drm_fimc driver?

This was a simple example, I wanted to visualize how the new building
blocks were going to be used. Anyway, this we achieve with the patch:

1.
The PM part in the driver becomes simplified, we don't need the
wrapper functions for the runtime PM callbacks any more.

2.
Previously the driver did not make sure runtime PM was disabled,
before it put the device into low power state at .suspend. From a
runtime PM point of view, this is not a "nice" behaviour and opens up
for confusions, even if it likely would work in most cases.

3.
The power domain runtime PM callbacks were by-passed during system
suspend, my patch fixes this. Why do I want this? Because the power
domain can have runtime PM resources it need to handle at this phase.
Potentially, it could handle that from it's .suspend_late callback
instead, but then it gets unnecessary complicated, which is what
clearly happened to the power domain for OMAP2, for example.


If you want additional proof of concepts, we can have a look at more
complex example.

Typically I am thinking of cases were a cross SoC driver is attached
to a bus and for some SoCs a power domain as well. Then, the bus, the
power domain and the driver - all have runtime PM resources to handle.

In these cases using the new building blocks will not only
significantly simplify code, but also fix immediate bugs. One example
are drivers attached to the AMBA bus, at drivers/amba/bus.c.

Kind regards
Ulf Hansson

>
> Rafael
>
