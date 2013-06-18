Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3FRFjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 01:39:42 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:37438 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3FRFjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 01:39:40 -0400
MIME-Version: 1.0
In-Reply-To: <1597172.lxipa1bjlr@avalon>
References: <20130617064052.3573.68839.sendpatchset@w520>
	<1597172.lxipa1bjlr@avalon>
Date: Tue, 18 Jun 2013 14:39:38 +0900
Message-ID: <CANqRtoSnBfr5sfSiYayKCmyw0EpY4+kq7pnQ1BJQt6wagTe8eQ@mail.gmail.com>
Subject: Re: [PATCH] clocksource: sh_cmt: 32-bit control register support
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tue, Jun 18, 2013 at 3:37 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> Thanks for the patch.
>
> On Monday 17 June 2013 15:40:52 Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> Add support for CMT hardware with 32-bit control and counter
>> registers, as found on r8a73a4 and r8a7790. To use the CMT
>> with 32-bit hardware a second I/O memory resource needs to
>> point out the CMSTR register and it needs to be 32 bit wide.
>
> Is a memory second resource required ? Can't we use a single resource that
> will contain all the registers ?

The CMT hardware block comes with a shared timer start stop register
that historically has been left out of the resource. The location of
this register has so far been pointed out by the "channel offset"
platform data member, together with information about which bit that
happens to be assigned to the timer channel. This start stop register
has happened to be kept in the same page of I/O memory as the main
timer channel resource, so at this point we're sort of "lucky" that a
single ioremap() has covered all cases.

With this patch it becomes optional to instead of platform data use a
second resource to point out the timer start/stop register. While we
do that we can also use the size of that resource to determine the I/O
access width, which happens to be something that is needed to enable
the driver on certain SoCs.

> Time to switch to devm_* managed functions ? :-)

Yes, indeed. That among other things, like converting the driver to in
a more optimal way support clock source only or clock event only
configurations. Also, some more modern CMT hardware versions have
extended registers with 48-bit counters, and we can also often use
more high frequency clocks to improve timer resolution.

As you can tell, in general there are many things that can be improved
with this driver. I thought a first shot could be to make it actually
work on more recent CMT hardware with 32-bit only registers. So that's
what this patch does!

Cheers,

/ magnus
