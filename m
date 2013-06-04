Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3FDR0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:26:49 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:56693 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab3FDR0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:26:47 -0400
Date: Tue, 4 Jun 2013 11:26:38 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Orion: Hoist bridge interrupt handling out of the
 timer
Message-ID: <20130604172638.GB13745@obsidianresearch.com>
References: <20121207225507.GB29262@obsidianresearch.com>
 <20121208112624.GD25315@lunn.ch>
 <20121209025748.GA10405@obsidianresearch.com>
 <20121209083046.GA25466@lunn.ch>
 <50C48CE8.9070400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C48CE8.9070400@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2012 at 02:06:48PM +0100, Sebastian Hesselbarth wrote:

> The main irq controller will be required for sure, but for the secondary
> irq controller we had a discussion long ago. IIRC Gregory proposed to have
> shared irqs handled by timer and watchdog, I was proposing chained irqs.

+1 on decoded IRQs for bridge. I've been running that configuration
now since this patch set was first posted.

There is too much HW variance, the timer, watchdog, etc drivers should
not have to poke into SOC specific registers just to get an interrupt.

The bridge decode can either be via a chained handler, or by incorporating
the bridge decode into the main kirkwood handler - the latter having
lower overhead for timer ticks.

> For mvebu archs, IIRC, we have wrt to timer-related irqs:
> - Armada 370/XP with different irq handler and timer irq handling within
>   timer registers.
> - Orion SoCs with Bridge irq registers for timer related stuff (timer0/1)
> - Kirkwood and Dove with watchdog timers (both with wdt irq in bridge irqs)
> - RTC in bridge irqs, but Dove with RTC connected to PMU irqs

> I think we should have patches for irqchip-orion first and then rethink
> if we want a standalone timer-orion or merge it with timer-mvebu. Having
> watchdog using irqs is kind of independent from this.

I would think the logical progression is:
- irq-chip orion combined with work to keep the existing timer working
- Patch to add the bridge irq-chip
- Patches to support orion/kirkwood/dove/etc in the existing timer drivers
- Patch to update the DT to switch to the bridge and updated timer
- Patch to remove the old timer

When I last looked briefly, it seems like merging with timer-mvebu was
fairly straightforward..

> Back in the days when Gregory, Thomas, and I were looking into merged timer
> we agreed not to have an extra check on 25MHz support. If you put the
> property in the node, it will try to set the timer to fixed 25MHz. If you
> use the property on Orion timer, it will just break timer handling.

As for the mveth case we should have a compatible tag for each SOC,
the driver can ignore it, but it should be in the DT for future use..

Jason
