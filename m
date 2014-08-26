Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbaHZVfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:35:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:57066 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbaHZVe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:34:59 -0400
Date: Tue, 26 Aug 2014 23:34:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux@openrisc.net, linux@arm.linux.org.uk,
        shawn.guo@freescale.com, kernel@pengutronix.de, tony@atomide.com,
        catalin.marinas@arm.com, will.deacon@arm.com, jonas@southpole.se,
        jason@lakedaemon.net, shc_work@mail.ru, baohua@kernel.org,
        maxime.ripard@free-electrons.com, khilman@linaro.org,
        sboyd@codeaurora.org, lorenzo.pieralisi@arm.com,
        larry.bassel@linaro.org, mark.rutland@arm.com, sudeep.holla@arm.com,
        stefan.kristiansson@saunalahti.fi, vkale@apm.com,
        schwidefsky@de.ibm.com
Subject: Re: [PATCH v2 00/26] genirq: fix use of irq_find_mapping outside of
 legal RCU context
In-Reply-To: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
Message-ID: <alpine.DEB.2.10.1408262333420.3323@nanos>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Marc Zyngier wrote:

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

Looks good. Should this be routed to the genirq tree?

Thanks,

	tglx
