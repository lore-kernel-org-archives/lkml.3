Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbaICNS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:18:56 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23161 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbaICNSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:18:52 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/EcODnGaJeej/JT994ABpff+SGocfRjA4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 378965D6DF0
Date: Wed, 3 Sep 2014 09:18:01 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux@openrisc.net, linux@arm.linux.org.uk,
        shawn.guo@freescale.com, kernel@pengutronix.de, tony@atomide.com,
        catalin.marinas@arm.com, will.deacon@arm.com, jonas@southpole.se,
        tglx@linutronix.de, shc_work@mail.ru, baohua@kernel.org,
        maxime.ripard@free-electrons.com, khilman@linaro.org,
        sboyd@codeaurora.org, lorenzo.pieralisi@arm.com,
        larry.bassel@linaro.org, mark.rutland@arm.com, sudeep.holla@arm.com,
        stefan.kristiansson@saunalahti.fi, vkale@apm.com,
        schwidefsky@de.ibm.com
Subject: Re: [PATCH v2 00/26] genirq: fix use of irq_find_mapping outside
 of legal RCU context
Message-ID: <20140903131801.GN30467@titan.lakedaemon.net>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 11:03:15AM +0100, Marc Zyngier wrote:
> A number of irqchip drivers are directly calling irq_find_mapping,
> which may use a rcu_read_lock call when walking the radix tree.
> 
> Turns out that if you hit that point with CONFIG_PROVE_RCU enabled,
> the kernel will shout at you, as using RCU in this context may be
> illegal (specially if coming from the idle state, where RCU would be
> in a quiescent state).
> 
> A possible fix would be to wrap calls to irq_find_mapping into a
> RCU_NONIDLE macro, but that really looks ugly.
> 
> This patch series introduce another generic IRQ entry point
> (handle_domain_irq), which has the exact same behaviour as handle_IRQ
> (as defined on arm, arm64 and openrisc), except that it also takes a
> irq_domain pointer. This allows the logical IRQ lookup to be done
> inside the irq_{enter,exit} section, which contains a
> rcu_irq_{enter,exit}, making it safe.
> 
> A number of irqchips are then converted to this new entry point. I've
> converted all the direct users of irq_find_mapping, except for the
> cases where it was used as a chained handler (chained_irq_{enter,exit}
> makes it safe). Users of irq_linear_revmap are safe as well. I've
> given it some light testing on arm64.
> 
> The series is also available in my tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git handle_domain_irq
> 
> From v1 [1]:
> - Made handle_domain_irq a generic function
> - Added OpenRISC to the list of affected architectures
> - Converted more interrupt controllers
> - Rebased on v3.17-rc1
> 
> [1]: https://lkml.org/lkml/2014/7/8/381
> 
> Marc Zyngier (26):
>   genirq: add irq_domain-aware core IRQ handler
>   arm64: convert handle_IRQ to use __handle_domain_irq
>   ARM: convert handle_IRQ to use __handle_domain_irq
>   openrisc: convert handle_IRQ to use __handle_domain_irq
>   irqchip: GIC: convert to handle_domain_irq
>   irqchip: armada-370-xp: convert to handle_domain_irq
>   irqchip: clps711x: convert to handle_domain_irq
>   irqchip: mmp: convert to handle_domain_irq
>   irqchip: mxs: convert to handle_domain_irq
>   irqchip: orion: convert to handle_domain_irq
>   irqchip: s3c24xx: convert to handle_domain_irq
>   irqchip: sirfsoc: convert to handle_domain_irq
>   irqchip: sun4i: convert to handle_domain_irq
>   irqchip: versatile-fpga: convert to handle_domain_irq
>   irqchip: vic: convert to handle_domain_irq
>   irqchip: vt8500: convert to handle_domain_irq
>   irqchip: zevio: convert to handle_domain_irq
>   irqchip: GICv3: convert to handle_domain_irq
>   irqchip: atmel-aic: convert to handle_domain_irq
>   irqchip: atmel-aic5: convert to handle_domain_irq
>   irqchip: or1k-pic: convert to handle_domain_irq
>   ARM: imx: avic: convert to handle_domain_irq
>   ARM: imx: tzic: convert to handle_domain_irq
>   ARM: omap2: irq: convert to handle_domain_irq
>   arm64: get rid of handle_IRQ
>   openrisc: get rid of handle_IRQ
> 
>  arch/arm/Kconfig                     |  1 +
>  arch/arm/kernel/irq.c                | 19 +---------------
>  arch/arm/mach-imx/avic.c             |  2 +-
>  arch/arm/mach-imx/tzic.c             |  3 +--
>  arch/arm/mach-omap2/irq.c            |  3 +--
>  arch/arm64/Kconfig                   |  1 +
>  arch/arm64/include/asm/hardirq.h     |  2 --
>  arch/arm64/kernel/irq.c              | 27 -----------------------
>  arch/openrisc/Kconfig                |  1 +
>  arch/openrisc/include/asm/irq.h      |  1 -
>  arch/openrisc/kernel/irq.c           | 12 -----------
>  drivers/irqchip/irq-armada-370-xp.c  | 19 ++++++++--------
>  drivers/irqchip/irq-atmel-aic.c      |  4 +---
>  drivers/irqchip/irq-atmel-aic5.c     |  4 +---
>  drivers/irqchip/irq-clps711x.c       | 18 ++++++----------
>  drivers/irqchip/irq-gic-v3.c         | 13 ++++++-----
>  drivers/irqchip/irq-gic.c            |  3 +--
>  drivers/irqchip/irq-mmp.c            | 10 ++++-----
>  drivers/irqchip/irq-mxs.c            |  3 +--
>  drivers/irqchip/irq-or1k-pic.c       |  4 ++--
>  drivers/irqchip/irq-orion.c          |  5 ++---
>  drivers/irqchip/irq-s3c24xx.c        |  4 +---
>  drivers/irqchip/irq-sirfsoc.c        |  6 ++----
>  drivers/irqchip/irq-sun4i.c          |  5 ++---
>  drivers/irqchip/irq-versatile-fpga.c |  2 +-
>  drivers/irqchip/irq-vic.c            |  2 +-
>  drivers/irqchip/irq-vt8500.c         |  5 ++---
>  drivers/irqchip/irq-zevio.c          |  3 +--
>  include/linux/irqdesc.h              | 19 ++++++++++++++++
>  kernel/irq/Kconfig                   |  3 +++
>  kernel/irq/irqdesc.c                 | 42 ++++++++++++++++++++++++++++++++++++
>  31 files changed, 116 insertions(+), 130 deletions(-)

Whole series applied to irqchip/handle_domain with Acks applied and
subject line tweaked for capitalization.  Turns out we have the openrisc
Ack from:

  https://lkml.kernel.org/r/20140827170905.GA5838@chokladfabriken.org

I'll let this sit in -next for a few days and then merge it into
irqchip/core.

thx,

Jason.
