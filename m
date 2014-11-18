Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaKRTdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:33:00 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:53421 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbaKRTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:32:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Kevin Hilman <khilman@kernel.org>, ssantosh@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
Date: Tue, 18 Nov 2014 20:32:17 +0100
Message-ID: <1709760.E0jX3Myv0h@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <546B95EC.5000705@ti.com>
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <7hsihhzecq.fsf@deeprootsystems.com> <546B95EC.5000705@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BIYKExZFumsqCxXCrGBzZyqNIdUf7Dve4uWr9WtP7bo
 jqYSbYdW3EWcuA7fVV1oyYSkoM0tMyJNlis20LkrH7epBtO948
 31s8mIQYWHs//nQ9kSt3acIJrorOhnn2ahC31N3moI136OvRli
 ULEkdWg0+grYKoaqXS/t/Vb/PM2T0uatqg/I8jcRMbft5mtHS6
 pAOyudHGVK5qvB0I234odu5ANs1XzNl5HNYkqKOtlNib+GLa+M
 uZpKfwklI2iWe+zL4s1zxH03YFufbryHn1MMlGPuMjiWUZse/T
 dKT2gHcoCSqvCoAkdCQO7Tb5QTw7bVvVOVLWcZf8s1m2wl2JBJ
 Dvk9rdwPfCVlrG3fBNWg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2014 20:54:36 Grygorii Strashko wrote:
> Hi All,
> 
> Thank you for your comments.
> 
> On 11/17/2014 11:50 PM, Kevin Hilman wrote:
> > Arnd Bergmann <arnd@arndb.de> writes:
> > 
> >> On Monday 17 November 2014 11:14:16 Kevin Hilman wrote:
> >>>>>
> >>>>> So, The Keystone 2 Generic PM Controller is just a proxy PM layer here between
> >>>>> device and Generic clock manipulation PM callbacks.
> >>>>> It fills per-device clock list when device is attached to GPD and
> >>>>> ensures that all clocks from that list enabled/disabled when device is
> >>>>> started/stopped.
> >>>>
> >>>> The idea of such a generic power domain implementation sounds useful, but
> >>>> it has absolutely no business in platform specific code.
> >>>
> >>> Yes it does.  This isn't a generic power domain implementation, but
> >>> rather just the platform-specific glue that hooks up the clocks to the
> >>> right devices and power-domains so that the generic power-domain and
> >>> generic pm_clocks code does the right thing.
> >>
> >> How would you do this on an arm64 version of keystone then? With
> >> the current approach, you'd need to add a machine specific directory,
> >> and that seems completely pointless since this is not even about
> >> a hardware requirement.
> > 
> > Yeah, you're right.  I misunderstood you're original comment.
> > 
> >>>> I suggest you either remove the power domain proxy from your drivers
> >>>> and use the clocks directly,
> 
> Hm. I've been thinking about this, but the problem is that Keystone 2
> reuses a lot of IPs from Davinci and PM for Davinci is based on Generic clock
> manipulation PM callbacks framework, but for non-DT case. So, I can't simply
> use clocks directly.

I think you could get that to work without too much trouble, but as Kevin
comments, the generic pmdomain code is helpful here, and we should find
a way to make it work better.

> >>> No.  That's a step in the wrong direction.  This change isn't affecting
> >>> drivers directly.  It's the runtime PM and generic power domain layers
> >>> that handle this, and runtime PM adapted drivers don't need any changes.
> >>>   
> >>>> or come up with an implementation that can be used across other
> >>>> platforms and CPU architectures.
> >>>
> >>> We already have those in the generic power domain and the pm_clock
> >>> layers.  This series is just hooking those up for Keystone.
> >>
> >> Then why not add the missing piece to the generic power domain
> >> code to avoid having to add infrastructure to the platform
> >> for it?
> > 
> > Yes, good point.  There is nothing keystone-specific in this glue.
> > 
> > Grygorii, what about adding a feature to the generic domain parsing so
> > that it can get clocks from device nodes that are part of the domain,
> > and so it sets up pm_clk accordingly.
> 
> I'd like to mention few points here:
> 1)  not all platforms may need this
> 
> 2)  not all platforms may allow to add ALL clocks from "clocks" property
>    to pm_clk as some of them can be optional or have to be controlled by drivers only
>    (for example, initially, it was the case for SH-mobile https://lkml.org/lkml/2014/4/24/197
>     also now, last implementation for shmobile add only first clock from "clocks" property
>     to pm_clk https://lkml.org/lkml/2014/11/17/272).
> 
> 3)  such functionality have to be enabled for devices selectively, for example
>    now we are going to enable it for devices which a ready for runtime PM.
> 
> Current implementation cover 1 & 3, but also it allows to cover 2 too, because
> it's platform specific implementation and .attach_dev() can be updated to skip some 
> clocks or devices if needed.

Well, not all drivers and not all platforms have to use it, I think it would
just be good to make the case you are interested in really easy, and definitely
work without platform specific code.

> > I've recently seen other SoCs doing very similar, so this really should
> > be generalized.
> > 
> > I've been looking at this primarily as a right incremental improvement
> > from what is there for Keystone today, but Arnd is right.  This should
> > be moved out of platform code.
> 
> I'm ready to do what ever you want, but I don't fully understand what exactly to do :(
> Should I create some generic_pm_clk_domain.c?
> - or - Do you mean to integrate it in domain.c (see no way to do it:()?
> - or - smth. else
> 
> What about introduced DT bindings? For example, How will devices be
> selected for attachment to Generic pm_clk domain if I'll introduce
> generic_pm_clk_domain.c?

I am not really familiar with the pmdomain code at all, but here is
what I had thought the simplest generic pmdomain code would do:

Have one pmdomain driver in the generic code that knows about clocks,
possibly also regulators and pins and just turns them on when needed.
You can have a "simple-pmdomain" or "generic-pmdomain" compatible
string.

I'm a bit surprised that your pmdomain code looks up the clocks from the
respective device, rather than know about the clocks itself. There is
probably a good reason for this, but I don't see it yet.

Another option would be to have a special case for an empty
"power-domains" property if this is the most common case: if that
property exists but is empty, the pmdomain core could interpret
it as an indication to control all the clocks/regulators/pins
of a device.

	Arnd
