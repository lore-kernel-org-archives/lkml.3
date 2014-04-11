Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaDKJ0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:26:52 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:57911 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756480AbaDKJVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:21:09 -0400
Date: Fri, 11 Apr 2014 10:20:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Rob Herring <robherring2@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
	populating interrupts
Message-ID: <20140411092028.GI16119@n2100.arm.linux.org.uk>
References: <20140410213808.GA5990@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410213808.GA5990@atomide.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 02:38:09PM -0700, Tony Lindgren wrote:
> Currently we get the following kind of errors if we try to use interrupt
> phandles to irqchips that have not yet initialized:
> 
> irq: no irq domain found for /ocp/pinmux@48002030 !
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_alloc+0x144/0x184()
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00038-g42a9708 #1012
> (show_stack+0x14/0x1c)
> (dump_stack+0x6c/0xa0)
> (warn_slowpath_common+0x64/0x84)
> (warn_slowpath_null+0x1c/0x24)
> (of_device_alloc+0x144/0x184)
> (of_platform_device_create_pdata+0x44/0x9c)
> (of_platform_bus_create+0xd0/0x170)
> (of_platform_bus_create+0x12c/0x170)
> (of_platform_populate+0x60/0x98)
> 
> This is because we're wrongly trying to populate resources that are not yet
> available. It's perfectly valid to create irqchips dynamically, so let's
> fix up the issue by populating the interrupt resources at the driver probe
> time instead.
> 
> Note that at least currently we cannot dynamically allocate the resources as bus
> specific code may add legacy resources with platform_device_add_resources()
> before the driver probe. At least omap_device_alloc() currently relies on
> num_resources to determine if legacy resources should be added. Some of these
> will clear automatically when mach-omap2 boots with DT only, but there are
> probably other places too where platform_device_add_resources() modifies
> things before driver probe.
> 
> This patch was discussed quite a bit earlier, but so far it seems we don't
> have any better options to fix the problem. For the earlier discussion,
> please see:
> 
> https://lkml.org/lkml/2013/11/22/520
> 
> The addition of of_platform_probe() is based on patches posted earlier by
> Thierry Reding <thierry.reding@gmail.com>.
> 
> Signed-off-by: Tony Lindgren <tony@atomide.com>

So what happens if a device driver probe function:

- creates a new platform device
- copies the resources from the original to the new device
- copies the of_node from the original to the new device
- registers the new device

Yes, it's broken (because it can result in the same driver being re-probed
by the new device) but we *do* have stuff in the kernel tree which does
this.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
