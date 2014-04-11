Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422907AbaDKA3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:29:46 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:35748 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759420AbaDKA3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:29:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140410213808.GA5990@atomide.com>
References: <20140410213808.GA5990@atomide.com>
Date: Thu, 10 Apr 2014 19:29:36 -0500
Message-ID: <CAL_JsqL4-gnMWaR_G_Bpk8Yiyopnx0x6gkJtpNkF3+TTkC-nYg@mail.gmail.com>
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
From: Rob Herring <robherring2@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 4:38 PM, Tony Lindgren <tony@atomide.com> wrote:
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

There is a newer solution here which Grant seemed happier with:

http://lkml.iu.edu/hypermail/linux/kernel/1403.2/03666.html

Does it work for you?

> The addition of of_platform_probe() is based on patches posted earlier by
> Thierry Reding <thierry.reding@gmail.com>.

I fail to see how this patch does EPROBE_DEFER and solves the problem.
Don't you need Thierry's other patches for that? I'm probably missing
something.

Rob
