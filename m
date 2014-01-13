Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbaAMGpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 01:45:44 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:34779 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaAMGpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 01:45:42 -0500
Message-ID: <52D38B90.1060002@codethink.co.uk>
Date: Mon, 13 Jan 2014 06:45:36 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-kernel@lists.codethink.co.uk,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus SH list <linux-sh@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ARM: shmobile: compile drivers/sh for CONFIG_ARCH_SHMOBILE_MULTI
References: <1389445589-21502-1-git-send-email-ben.dooks@codethink.co.uk> <2820428.J065BbN1jW@avalon> <4441342.H8MHOLBobb@avalon>
In-Reply-To: <4441342.H8MHOLBobb@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/14 22:01, Laurent Pinchart wrote:
> Hi Ben,
>
> On Sunday 12 January 2014 22:54:15 Laurent Pinchart wrote:
>> Hi Ben,
>>
>> Thank you for the patch.
>>
>> On Saturday 11 January 2014 13:06:29 Ben Dooks wrote:
>>> If the kernel is built to support multi-arm configurmation with shmobile
>>> support built in, then the drivers/sh is not built. This contains drivers
>>> that are essential to devices support by that configuration, including the
>>> PM runtime code in drivers/sh/pm_runtime.c (which implicitly enables the
>>> bus clocks for all devices).
>
> Thinking a bit more about this, I think the approach taken in
> drivers/sh/pm_runtime.c isn't good. The code enables device clocks when
> devices are bound to a driver, increasing power consumption when devices are
> idle. Instead of enabling it for ARCH_SHMOBILE_MULTI I'd like to either add
> explicit clock support to drivers, or to integrate clocks with runtime PM
> only.

If pm-runtime is enabled, then I believe that the device clocks are
kept in sync with the active state of the device, which means that
they should be shut down when the device is not needed. There have
been recent discussions about this with respect to the PCI bridges
used by the USB host system.

Given the above, I'm not sure exactly what you mean by the statement
"I think the approach taken in drivers/sh/pm_runtime.c isn't good."
as if we're going to abstract the clock management we have the following
issues.

- If pm-runtime is not enabled then we need something to manage the
   clocks for the driver. If we put that code in the driver then there
   is not a lot of point in having the pm-runtime clock code here as
   the driver really only needs a helper to turn them on and off at
   the right place.

- If just standard power management is enabled, then do we really care
   about the power consumption of leaving peripherals running when their
   devices are bound? Managing the device clock optimally is hardly
   a concern if device drivers are not going to be idled when they are
   not being used.

When discussing this on freenode's #armkernel channel, several people
including Mark Brown wanted to keep this as it made driver's handling
of clocks much easier (there was no longer any need to deal with the
clk code when writing a simple driver). My view is it is a pain as we
now have a mix of drivers which expect to do their own clock work and
some that do not. (It is possible there are even some shmobile drivers
that still do their own clock management).

Personally I do not like hiding the implementation of this, as it ends
up confusing people when they first come to it.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
