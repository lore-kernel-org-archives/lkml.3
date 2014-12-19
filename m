Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaLSVw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 16:52:57 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48463 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaLSVwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 16:52:55 -0500
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
	<7hppbg63zo.fsf@deeprootsystems.com>
	<CAMuHMdWmy82=cnoSVD3gdEu=5Ttr1j-PJv6EXKYwbR3o_FEDiA@mail.gmail.com>
Date: Fri, 19 Dec 2014 13:52:52 -0800
In-Reply-To: <CAMuHMdWmy82=cnoSVD3gdEu=5Ttr1j-PJv6EXKYwbR3o_FEDiA@mail.gmail.com>
	(Geert Uytterhoeven's message of "Fri, 19 Dec 2014 08:59:53 +0100")
Message-ID: <7hsigb1f4b.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

[...]

> On Thu, Dec 18, 2014 at 10:29 PM, Kevin Hilman <khilman@kernel.org> wrote:
>>> However, if PM domains are active, drivers must be runtime PM-aware for the
>>> gpd_dev_ops.start() method to be called in the first place (perhaps this is just
>>> one bug that's easy to fix --- the device is "assumed suspended", but can be
>>> used). They must
>>>   1. call pm_runtime_enable() to enable runtime PM for the device,
>>>   2. call pm_runtime_get_sync() to prevent the device from being put in a
>>>     low-power state at any time. This second call has the
>>> "side-effect" of calling
>>>     gpd_dev_ops.start().
>>>
>>> Hence, if PM domains are enabled, wouldn't it make sense to
>>>   1. enable runtime PM by default, for all devices (bound and unbound),
>>>   2. call pm_runtime_get_sync(), for all devices bound to a driver.
>>> Of course we have to keep track if drivers call any of the pm_runtime_*()
>>> methods theirselves, as that would have to move them from automatic to
>>> manual mode.
>>>
>>> Would this be feasible?
>>
>> We have to be careful about where the PM core's _get_sync() call goes.
>>
>> Because you're talking about "bound" devices, I guess you mean after the
>> driver probes?  Otherwise, it gets tricky if the _get_sync() is before
>> the driver probes, because the device driver may have work it wants to
>> do in its runtime PM callbacks, which are not initialized/available
>> before the driver probes.  Doing this before probe also makes it rather
>> difficult to know for sure the actual physical state of the device, and
>> make sure it matches the runtime PM state of the device.  Rafael
>> mentioned this also, and I'm not sure how we can be sure of the physical
>> state.
>
> Yes, it's complicated by the fact that there are multiple sets of callbacks
> (PM domain, device type, class type, bus type, driver).
> However, the PM domain one has the highest priority, and is always
> (also for devices not bound to a driver) available.

Yes, but if a _get_sync() is called on a device which has not yet setup
its callbacks (e.g. before it has been probed), then the device may not
be properly initialized, and we may not be able to know its physical state.

>> Some thoughts: devices without drivers would be runtime resumed by the
>> core, but will never be suspended, so the PM domain will never shut
>> down.  I guess the core will have to keep track of the devices it
>> automatically runtime resumed and decide to runtime suspend them too?
>> Hmm, where would that go?
>
> No, devices without a driver just need to become runtime PM enabled.
> They will only be resumed when a dependent device (e.g. a child) is resumed,
> and are suspended again after all dependents are suspended. That's how
> simple-pm-bus behaves.

Ah, OK.  I thought you were proposing to _enable() and _get_sync() those
devices.

Thanks for the clarification,

Kevin


