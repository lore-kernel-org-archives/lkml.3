Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaKDBgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:36:49 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63245 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750834AbaKDBgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:36:47 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v8 3/5] amba: Don't unprepare the clocks if device driver wants IRQ safe runtime PM
Date: Tue, 04 Nov 2014 02:57:30 +0100
Message-ID: <1464221.Cac76ZHBQl@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1411031036350.1316-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1411031036350.1316-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 03, 2014 10:41:02 AM Alan Stern wrote:
> On Mon, 3 Nov 2014, Russell King - ARM Linux wrote:
> 
> > That makes it pretty horrid from the point of view of having bus
> > management code, because we now have the management of the bus clock
> > split between the bus layer and the device driver.
> > 
> > This is /really/ a problem for runtime PM.  Runtime PM permits there
> > to be a bus layer involved - and runtime PM can also be coupled up
> > to PM domains as well.  For all this stuff, the context which the
> > callbacks are called in depends on whether the driver itself has
> > marked the device as having IRQ-safe callbacks.
> > 
> > That's fine, but the bus and PM domain level code then /really/ needs
> > to know what context they're being called in, so they know whether
> > they can sleep or not, or they must to be written to always use
> > non-sleeping functions so they work in both contexts.  If we assume
> > the former, then that implies that the irq-safe flag must never change
> > state between a suspend and a resume.
> 
> If a bus subsystem or PM domain is going to allow its drivers to choose
> between IRQ-safe and non-IRQ-safe runtime PM, then it is up to the
> subsystem to come up with a way for drivers to indicate their choice.
> 
> I tend to agree with Rafael that testing dev->power.irq_safe should be 
> good enough, with no real need for a wrapper.  But the subsystem can 
> use a different mechanism if it wants.
> 
> Bear in mind, however, that once the irq_safe flag has been set, the 
> runtime PM core offers no way to turn it off again.

There is a problem with it, though.  Say, a driver handles a device that
may or may not be in a power domain.  Or in other words, the power domain
the device is in may or may not be always on.  If the domain is always on,
the runtime PM callbacks are IRQ-safe (they depend on the driver only).
If it isn't, they may not be IRQ-safe.  How's the driver going to decide
whether or not to set power.irq_safe?

Rafael

