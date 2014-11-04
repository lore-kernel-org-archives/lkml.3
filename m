Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaKDQTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:19:17 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:61189 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbaKDQTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:19:14 -0500
MIME-Version: 1.0
In-Reply-To: <5164575.drMJjOBCMX@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1411031036350.1316-100000@iolanthe.rowland.org>
	<1464221.Cac76ZHBQl@vostro.rjw.lan>
	<CAPDyKFozj54qymGyq1QaOp_gLey4GOKtnAJWek+WfieJ-0gPaw@mail.gmail.com>
	<5164575.drMJjOBCMX@vostro.rjw.lan>
Date: Tue, 4 Nov 2014 17:19:13 +0100
Message-ID: <CAPDyKFo3LrQ7agEQFZj6o3JNs5SJEwW137awKQqwKnV7FGij7A@mail.gmail.com>
Subject: Re: [PATCH v8 3/5] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 November 2014 14:59, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, November 04, 2014 10:11:35 AM Ulf Hansson wrote:
>> On 4 November 2014 02:57, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> > On Monday, November 03, 2014 10:41:02 AM Alan Stern wrote:
>> >> On Mon, 3 Nov 2014, Russell King - ARM Linux wrote:
>> >>
>> >> > That makes it pretty horrid from the point of view of having bus
>> >> > management code, because we now have the management of the bus clock
>> >> > split between the bus layer and the device driver.
>> >> >
>> >> > This is /really/ a problem for runtime PM.  Runtime PM permits there
>> >> > to be a bus layer involved - and runtime PM can also be coupled up
>> >> > to PM domains as well.  For all this stuff, the context which the
>> >> > callbacks are called in depends on whether the driver itself has
>> >> > marked the device as having IRQ-safe callbacks.
>> >> >
>> >> > That's fine, but the bus and PM domain level code then /really/ needs
>> >> > to know what context they're being called in, so they know whether
>> >> > they can sleep or not, or they must to be written to always use
>> >> > non-sleeping functions so they work in both contexts.  If we assume
>> >> > the former, then that implies that the irq-safe flag must never change
>> >> > state between a suspend and a resume.
>> >>
>> >> If a bus subsystem or PM domain is going to allow its drivers to choose
>> >> between IRQ-safe and non-IRQ-safe runtime PM, then it is up to the
>> >> subsystem to come up with a way for drivers to indicate their choice.
>> >>
>> >> I tend to agree with Rafael that testing dev->power.irq_safe should be
>> >> good enough, with no real need for a wrapper.  But the subsystem can
>> >> use a different mechanism if it wants.
>> >>
>> >> Bear in mind, however, that once the irq_safe flag has been set, the
>> >> runtime PM core offers no way to turn it off again.
>> >
>> > There is a problem with it, though.  Say, a driver handles a device that
>> > may or may not be in a power domain.  Or in other words, the power domain
>> > the device is in may or may not be always on.  If the domain is always on,
>> > the runtime PM callbacks are IRQ-safe (they depend on the driver only).
>> > If it isn't, they may not be IRQ-safe.  How's the driver going to decide
>> > whether or not to set power.irq_safe?
>>
>> From my point of view; the decision whether the driver will set the
>> IRQ safe flag is in principle a software design choice.
>>
>> Currently genpd isn't able to power off, if one of its devices are IRQ
>> safe configured. That's a limitation in genpd which we need to fix and
>> it's on my TODO list.
>>
>> My point is thus, I don't think the driver should care about PM
>> domains at all regarding using the IRQ safe option. Does that make
>> sense?
>
> Yes, it does, and that's the heart of the problem above.  The driver should
> not care about wherther or not the device is in a power domain, but it needs
> to know that when deciding whether or not to set power.irq_safe.  Catch 22.

Why is it catch22? The problem is supposed to be fixed in the generic
PM domain. How we do that is a different question.

Until genpd get fixed, the driver can still keep using irq_safe if
they want to. It will only lead to limitations if the device is
attached to a genpd.

Kind regards
Uffe
