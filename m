Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaLRV3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:29:52 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:56358 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaLRV3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:29:50 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc\@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Enable runtime PM automatically?
References: <CAMuHMdWY_ne+S3zKrEYqVyU8=S-at=+rGuEkYNauF4s2KaKNdw@mail.gmail.com>
Date: Thu, 18 Dec 2014 13:29:47 -0800
In-Reply-To: <CAMuHMdWY_ne+S3zKrEYqVyU8=S-at=+rGuEkYNauF4s2KaKNdw@mail.gmail.com>
	(Geert Uytterhoeven's message of "Wed, 17 Dec 2014 20:33:13 +0100")
Message-ID: <7hppbg63zo.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Tue, Dec 16, 2014 at 11:10 PM, Kevin Hilman <khilman@kernel.org> wrote:
>> At a deeper level, the problem with this approach is that this is more
>> generically a runtime PM dependency problem, not a genpd problem.  For
>> example, what happens when the same kind of dependency exists on a
>> platform using a custom PM domain instead of genpd (like ACPI.) ?
>>
>> What's needed to solve this problem is a generalized way to have runtime
>> PM dependencies between devices.  Runtime PM already automatically
>> handles parent devices as one type of dependent device (e.g. a parent
>> device needs to be runtime PM resumed before its child.)  So what's
>> needed is a generic way to other PM dependencies with the runtime PM
>> core (not the genpd core.)
>>
>> If runtime PM handles the dependencies corretcly, then genpd (and any
>> other PM domain) will get them "for free".
>
> Having the proper dependencies is not sufficient. Currently drivers have to do
> something to use runtime PM.

Well, yes.  I've been assuming runtime-PM aware drivers.  But I agree
with the goal of not having to assume that.

> By default, runtime PM is disabled for a device
> ("device.power.disable_depth = 1").
>
> However, if PM domains are active, drivers must be runtime PM-aware for the
> gpd_dev_ops.start() method to be called in the first place (perhaps this is just
> one bug that's easy to fix --- the device is "assumed suspended", but can be
> used). They must
>   1. call pm_runtime_enable() to enable runtime PM for the device,
>   2. call pm_runtime_get_sync() to prevent the device from being put in a
>     low-power state at any time. This second call has the
> "side-effect" of calling
>     gpd_dev_ops.start().
>
> Hence, if PM domains are enabled, wouldn't it make sense to
>   1. enable runtime PM by default, for all devices (bound and unbound),
>   2. call pm_runtime_get_sync(), for all devices bound to a driver.
> Of course we have to keep track if drivers call any of the pm_runtime_*()
> methods theirselves, as that would have to move them from automatic to
> manual mode.
>
> Would this be feasible?

We have to be careful about where the PM core's _get_sync() call goes.

Because you're talking about "bound" devices, I guess you mean after the
driver probes?  Otherwise, it gets tricky if the _get_sync() is before
the driver probes, because the device driver may have work it wants to
do in its runtime PM callbacks, which are not initialized/available
before the driver probes.  Doing this before probe also makes it rather
difficult to know for sure the actual physical state of the device, and
make sure it matches the runtime PM state of the device.  Rafael
mentioned this also, and I'm not sure how we can be sure of the physical
state.

Some thoughts: devices without drivers would be runtime resumed by the
core, but will never be suspended, so the PM domain will never shut
down.  I guess the core will have to keep track of the devices it
automatically runtime resumed and decide to runtime suspend them too?
Hmm, where would that go?

Kevin
