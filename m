Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3FEI5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:57:21 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:50030 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3FEI5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:57:17 -0400
Message-ID: <51AEFD65.6030306@gmail.com>
Date: Wed, 05 Jun 2013 10:57:09 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Orion: Hoist bridge interrupt handling out of the
 timer
References: <20121207225507.GB29262@obsidianresearch.com> <20121208112624.GD25315@lunn.ch> <20121209025748.GA10405@obsidianresearch.com> <20121209083046.GA25466@lunn.ch> <50C48CE8.9070400@gmail.com> <20130604172638.GB13745@obsidianresearch.com>
In-Reply-To: <20130604172638.GB13745@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/13 19:26, Jason Gunthorpe wrote:
> On Sun, Dec 09, 2012 at 02:06:48PM +0100, Sebastian Hesselbarth wrote:
>> The main irq controller will be required for sure, but for the secondary
>> irq controller we had a discussion long ago. IIRC Gregory proposed to have
>> shared irqs handled by timer and watchdog, I was proposing chained irqs.
>
> +1 on decoded IRQs for bridge. I've been running that configuration
> now since this patch set was first posted.
>
> There is too much HW variance, the timer, watchdog, etc drivers should
> not have to poke into SOC specific registers just to get an interrupt.
>
> The bridge decode can either be via a chained handler, or by incorporating
> the bridge decode into the main kirkwood handler - the latter having
> lower overhead for timer ticks.

Jason,

I have irqchip and clocksource drivers done for Orion, just need to
find some time to rebase them.

>> For mvebu archs, IIRC, we have wrt to timer-related irqs:
>> - Armada 370/XP with different irq handler and timer irq handling within
>>    timer registers.
>> - Orion SoCs with Bridge irq registers for timer related stuff (timer0/1)
>> - Kirkwood and Dove with watchdog timers (both with wdt irq in bridge irqs)
>> - RTC in bridge irqs, but Dove with RTC connected to PMU irqs
>
>> I think we should have patches for irqchip-orion first and then rethink
>> if we want a standalone timer-orion or merge it with timer-mvebu. Having
>> watchdog using irqs is kind of independent from this.

I suggest not to merge clocksource for Orion and Armada 370/XP. They
are different enough to justify separate drivers. IIRC Armada 370/XP
acks timer interrupts by clearing timer register bits that are not
implemented in Orion SoCs.

> I would think the logical progression is:
> - irq-chip orion combined with work to keep the existing timer working
> - Patch to add the bridge irq-chip
> - Patches to support orion/kirkwood/dove/etc in the existing timer drivers
> - Patch to update the DT to switch to the bridge and updated timer
> - Patch to remove the old timer

I'd rather have irqchip and clocksource mainlined and enable both
drivers when they have surfaced. I try to sent patches by end of this week.

> When I last looked briefly, it seems like merging with timer-mvebu was
> fairly straightforward..
>
>> Back in the days when Gregory, Thomas, and I were looking into merged timer
>> we agreed not to have an extra check on 25MHz support. If you put the
>> property in the node, it will try to set the timer to fixed 25MHz. If you
>> use the property on Orion timer, it will just break timer handling.
>
> As for the mveth case we should have a compatible tag for each SOC,
> the driver can ignore it, but it should be in the DT for future use..

We could have a single clocksource driver but as said above,
clocksource is a tiny driver compared to others. Separate drivers will
save us from checking SoC on every timer event or have a callback for 
Armada 370/XP clearing timer irqs.

Sebastian
