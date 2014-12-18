Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaLRIcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:32:23 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:61103 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaLRIcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:32:21 -0500
MIME-Version: 1.0
In-Reply-To: <2631000.5asdLXAEtK@vostro.rjw.lan>
References: <CAMuHMdWY_ne+S3zKrEYqVyU8=S-at=+rGuEkYNauF4s2KaKNdw@mail.gmail.com>
	<2631000.5asdLXAEtK@vostro.rjw.lan>
Date: Thu, 18 Dec 2014 09:32:19 +0100
X-Google-Sender-Auth: GMOijIfchJpbgR6QntkXiBOwFYY
Message-ID: <CAMuHMdWFHfTSoVR4-JJXZiyHe0XeetzGKqoQnyU5ahZurYNZDw@mail.gmail.com>
Subject: Re: Enable runtime PM automatically?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Kevin Hilman <khilman@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Thanks for your comments!

On Thu, Dec 18, 2014 at 1:57 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, December 17, 2014 08:33:13 PM Geert Uytterhoeven wrote:
>> On Tue, Dec 16, 2014 at 11:10 PM, Kevin Hilman <khilman@kernel.org> wrote:
>> > At a deeper level, the problem with this approach is that this is more
>> > generically a runtime PM dependency problem, not a genpd problem.  For
>> > example, what happens when the same kind of dependency exists on a
>> > platform using a custom PM domain instead of genpd (like ACPI.) ?
>> >
>> > What's needed to solve this problem is a generalized way to have runtime
>> > PM dependencies between devices.  Runtime PM already automatically
>> > handles parent devices as one type of dependent device (e.g. a parent
>> > device needs to be runtime PM resumed before its child.)  So what's
>> > needed is a generic way to other PM dependencies with the runtime PM
>> > core (not the genpd core.)
>> >
>> > If runtime PM handles the dependencies corretcly, then genpd (and any
>> > other PM domain) will get them "for free".
>>
>> Having the proper dependencies is not sufficient. Currently drivers have to do
>> something to use runtime PM.
>>
>> By default, runtime PM is disabled for a device
>> ("device.power.disable_depth = 1").
>
> Which isn't the case for PCI devices.

I didn't know that.

The above code excerpt comes from pm_runtime_init(), which is called from
device_pm_init() / device_initialize() / device_register(), so I
assume it applies
to PCI, too? Can you please tell me where it's overridden by PCI?

>> However, if PM domains are active, drivers must be runtime PM-aware for the
>> gpd_dev_ops.start() method to be called in the first place (perhaps this is just
>> one bug that's easy to fix --- the device is "assumed suspended", but can be
>> used). They must
>>   1. call pm_runtime_enable() to enable runtime PM for the device,
>>   2. call pm_runtime_get_sync() to prevent the device from being put in a
>>     low-power state at any time. This second call has the
>> "side-effect" of calling
>>     gpd_dev_ops.start().
>>
>> Hence, if PM domains are enabled, wouldn't it make sense to
>>   1. enable runtime PM by default, for all devices (bound and unbound),
>
> I guess you mean for devices with and without drivers here?

Yes, indeed.

>>   2. call pm_runtime_get_sync(), for all devices bound to a driver.
>> Of course we have to keep track if drivers call any of the pm_runtime_*()
>> methods theirselves, as that would have to move them from automatic to
>> manual mode.
>>
>> Would this be feasible?
>
> PCI does something similar and IMO it would make sense to do that for all
> devices, at least where we have a known way to power them up/down without a
> driver.

OK.

> There's a couple of questions, though
>  First, how many drivers would break  if we enabled runtime PM by default?

If the default also calls pm_runtime_get_sync() automatically, I don't see
a big issue there, as the device won't be runtime-suspended automatically,
just like before?

> Second, if we do that, how do we figure out the initial value of runtime
> PM status in general?

Do you mean in the context of the following paragraph from
Documentation/power/runtime_pm.txt?

"In addition to that, the initial runtime PM status of all devices is
 'suspended', but it need not reflect the actual physical state of the device."

> Finally, what about drivers that need to work with and without PM domains
> (for example, some systems they run on have PM domains, while some other don't)?

We already have the last issue now, but currently it breaks in subtle ways
on the systems where there are PM domains.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
