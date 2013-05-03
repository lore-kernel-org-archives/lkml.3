Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763656Ab3ECVus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:50:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:47042 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3ECVur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:50:47 -0400
Message-Id: <20130503212258.385818955@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 03 May 2013 21:50:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <alpine.LFD.2.02.1305031514230.2886@ionos>
Subject: [RFC patch 0/8] genirq: Support for irq domains in generic irq chip
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ongoing device tree support for ARM is creating new irq chip
drivers in drivers/irqchip/ in a frenzy. Quite some of them are
ripping out the generic irq chip implementation from arch/arm/* and
just creating the same mess of duplicated code again, which was
cleaned up with the generic irq chip implementation with a lot of
effort. Sigh!

I already prodded a few people in reviews to tackle that issue with no
outcome. Even more sigh!

Poor Sebastian triggered me into rant mode, but he ad hoc
volunteered to give it a try. YAY!

Though he asked for a bit of kickstart help. So I squeezed out a few
spare cycles and implemented the basics as far as I think that they
should work.

The following series contains the missing bits and pieces including a
somehow forgotten and now slightly modified series from Gerlando
adding support for irq chips which need separate mask caches for
different chip (control flow) types.

At the moment this supports only linear irq domains, but it could be
extended to other types as well if the need arises. Though the ARM
chips are pretty much all about linear domains AFAICT.

It also lacks support for removing an irq domain at the moment, but
that should be rather trivial to fix.

The last patch in the series is a blind conversion of the irq-sun4i
irq chip driver, completely untested and not even compiled. I just
added it for demonstration purposes. As Russell expected, there is a
lot of consolidation potential. The changelog of that patch is:

 1 file changed, 29 insertions(+), 71 deletions(-)

The preparing series has

 4 files changed, 294 insertions(+), 50 deletions(-)

So for removing 42 lines in a single driver the core grows 244 lines
including header changes and comments. Convert 6 drivers and we are
more than even because we get the benefit of sharing and therefor
exposing the same code to broader testing and utilization.

We have already 11 of those candidates in drivers/irqchips and new
ones are knocking on the door.

There might be even more consolidation potential, but I leave that to the
DT/irq domain experts.


WARNING: It's compile tested only. So if you find bugs you can keep
them and fix them yourself :)


Thanks,

	tglx
---
 drivers/irqchip/irq-sun4i.c |  100 ++++-----------
 include/linux/irq.h         |   45 ++++++-
 include/linux/irqdomain.h   |   12 +
 kernel/irq/generic-chip.c   |  281 +++++++++++++++++++++++++++++++++++++-------
 kernel/irq/irqdomain.c      |    6 
 5 files changed, 323 insertions(+), 121 deletions(-)

