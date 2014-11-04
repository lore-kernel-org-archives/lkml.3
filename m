Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaKDIBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:01:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32698 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaKDIBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:01:37 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-0e-545887de808d
Message-id: <1415088092.2389.12.camel@AMDC1943>
Subject: Re: [PATCH v8 3/5] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
Date: Tue, 04 Nov 2014 09:01:32 +0100
In-reply-to: <1464221.Cac76ZHBQl@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1411031036350.1316-100000@iolanthe.rowland.org>
 <1464221.Cac76ZHBQl@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4Zd177REhBnNuSFhsnLGe1eLJgXZG
	i+lTLzBarJ76l9XibNMbdoslk+ezWsyaspfJYmHbEhaLy7vmsFl87j3CaHH7Mq/F2iN32S3e
	vYywuHvqKJvFmdOXWC0m/L7AZnF8bbjFy779LA5CHi3NPWwei/e8ZPK4c20PkNU3mdVjyZtD
	rB5brrazeMy++4PRo2/LKkaPFau/s3t83iTnsffzb5YA7igum5TUnMyy1CJ9uwSujF2tvgVL
	hCu2/nzO3sD4ga+LkZNDQsBE4ujMwywQtpjEhXvr2boYuTiEBJYySrRM+MsM4XxmlOiZ28YK
	UsUroC+xt/8CO4gtLJAp0fnnJ1icTcBYYvPyJWwgtoiAtsTcnlNgzcwCvawS//duYupi5OBg
	EVCVOHZDB6SGU8BA4v+fRWD1QgJFErMWLAa7gllAXWLSvEXMIOUSAsoSjf1uEGsFJX5MvgdV
	Ii+xec1b5gmMArOQdMxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFx+HUH
	49JjVocYBTgYlXh4V8RHhAixJpYVV+YeYpTgYFYS4V1dBRTiTUmsrEotyo8vKs1JLT7EyMTB
	KdXA6GLFpnIjxHL/iTfis15ed/WZ6yuWNr3N/3KYzqYM2ayTsevMIlSn3Vu3Vvq44Pvck+tE
	vvzJfb3NL7xw8YtbApMlNgX/sJrIsvNpR/Z6/UkzshIN9q0P2N/w8ufVuY52frMvakcfm7qz
	6frNPBaTJSy16SLhpztWxsoKN7m0nDj8d9lb5aO3pyuxFGckGmoxFxUnAgD6U4KPoQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-11-04 at 02:57 +0100, Rafael J. Wysocki wrote:
> On Monday, November 03, 2014 10:41:02 AM Alan Stern wrote:
> > On Mon, 3 Nov 2014, Russell King - ARM Linux wrote:
> > 
> > > That makes it pretty horrid from the point of view of having bus
> > > management code, because we now have the management of the bus clock
> > > split between the bus layer and the device driver.
> > > 
> > > This is /really/ a problem for runtime PM.  Runtime PM permits there
> > > to be a bus layer involved - and runtime PM can also be coupled up
> > > to PM domains as well.  For all this stuff, the context which the
> > > callbacks are called in depends on whether the driver itself has
> > > marked the device as having IRQ-safe callbacks.
> > > 
> > > That's fine, but the bus and PM domain level code then /really/ needs
> > > to know what context they're being called in, so they know whether
> > > they can sleep or not, or they must to be written to always use
> > > non-sleeping functions so they work in both contexts.  If we assume
> > > the former, then that implies that the irq-safe flag must never change
> > > state between a suspend and a resume.
> > 
> > If a bus subsystem or PM domain is going to allow its drivers to choose
> > between IRQ-safe and non-IRQ-safe runtime PM, then it is up to the
> > subsystem to come up with a way for drivers to indicate their choice.
> > 
> > I tend to agree with Rafael that testing dev->power.irq_safe should be 
> > good enough, with no real need for a wrapper.  But the subsystem can 
> > use a different mechanism if it wants.
> > 
> > Bear in mind, however, that once the irq_safe flag has been set, the 
> > runtime PM core offers no way to turn it off again.
> 
> There is a problem with it, though.  Say, a driver handles a device that
> may or may not be in a power domain.  Or in other words, the power domain
> the device is in may or may not be always on.  If the domain is always on,
> the runtime PM callbacks are IRQ-safe (they depend on the driver only).
> If it isn't, they may not be IRQ-safe.  How's the driver going to decide
> whether or not to set power.irq_safe?

The pl330 driver (being a part of amba bus) always wants IRQ safe
callbacks. However other amba drivers may not. So actually the driver
always sets one or another. The dualism is present only in the
amba/bus.c driver which encapsulates the child drivers.

Best regards,
Krzysztof


