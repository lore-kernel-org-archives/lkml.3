Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaAMWgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 17:36:33 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:60470 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaAMWga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 17:36:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus SH list <linux-sh@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ARM: shmobile: compile drivers/sh for CONFIG_ARCH_SHMOBILE_MULTI
Date: Mon, 13 Jan 2014 23:37:11 +0100
Message-ID: <23961394.c3Uic7DPzS@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.25-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52D38B90.1060002@codethink.co.uk>
References: <1389445589-21502-1-git-send-email-ben.dooks@codethink.co.uk> <4441342.H8MHOLBobb@avalon> <52D38B90.1060002@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Monday 13 January 2014 06:45:36 Ben Dooks wrote:
> On 12/01/14 22:01, Laurent Pinchart wrote:
> > On Sunday 12 January 2014 22:54:15 Laurent Pinchart wrote:
> >> Hi Ben,
> >> 
> >> Thank you for the patch.
> >> 
> >> On Saturday 11 January 2014 13:06:29 Ben Dooks wrote:
> >>> If the kernel is built to support multi-arm configurmation with shmobile
> >>> support built in, then the drivers/sh is not built. This contains
> >>> drivers that are essential to devices support by that configuration,
> >>> including the PM runtime code in drivers/sh/pm_runtime.c (which
> >>> implicitly enables the bus clocks for all devices).
> > 
> > Thinking a bit more about this, I think the approach taken in
> > drivers/sh/pm_runtime.c isn't good. The code enables device clocks when
> > devices are bound to a driver, increasing power consumption when devices
> > are idle. Instead of enabling it for ARCH_SHMOBILE_MULTI I'd like to
> > either add explicit clock support to drivers, or to integrate clocks with
> > runtime PM only.
> 
> If pm-runtime is enabled, then I believe that the device clocks are
> kept in sync with the active state of the device, which means that
> they should be shut down when the device is not needed. There have
> been recent discussions about this with respect to the PCI bridges
> used by the USB host system.
> 
> Given the above, I'm not sure exactly what you mean by the statement
> "I think the approach taken in drivers/sh/pm_runtime.c isn't good."

I might have read the code too fast. I was under the impression that the code 
enabled the device clock as soon as the device was bound to a driver. Upon 
closer inspection this doesn't seem to be the case.

> as if we're going to abstract the clock management we have the following
> issues.
> 
> - If pm-runtime is not enabled then we need something to manage the clocks
>   for the driver. If we put that code in the driver then there is not a lot
>   of point in having the pm-runtime clock code here as the driver really
>   only needs a helper to turn them on and off at the right place.
> 
> - If just standard power management is enabled, then do we really care
>   about the power consumption of leaving peripherals running when their
>   devices are bound? Managing the device clock optimally is hardly a concern
>   if device drivers are not going to be idled when they are not being used.

Many devices are not bound to a power domain handled by runtime PM. Adding a 
runtime PM dependency to clock handling for those devices doesn't make me 
really happy.

Does automatic clock handling even work at all with runtime PM disabled ? The 
clk_enable() call seems to come from pm_clk_resume() only, which is used as 
the runtime_resume handler. with runtime PM disabled that code looks like it 
won't be called at all.

> When discussing this on freenode's #armkernel channel, several people
> including Mark Brown wanted to keep this as it made driver's handling
> of clocks much easier (there was no longer any need to deal with the
> clk code when writing a simple driver). My view is it is a pain as we
> now have a mix of drivers which expect to do their own clock work and
> some that do not. (It is possible there are even some shmobile drivers
> that still do their own clock management).

We could remove manual clock handling from some drivers, but the drivers that 
need to handle several clocks will still need to do so manually. As long as 
the core code allows this (which I think it does, but I'm not too familiar 
with the code) I won't complain (too much at least :-)).

> Personally I do not like hiding the implementation of this, as it ends
> up confusing people when they first come to it.

I like explicit implementations as well, but I have to admit that devices that 
require a single clock and have clock requirements that are in sync with the 
PM runtime requirements would probably benefit from automatic clock handling, 
at least from a driver code complexity point of view, to the expense of a less 
explicit implementation.

-- 
Regards,

Laurent Pinchart

