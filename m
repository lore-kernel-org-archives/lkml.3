Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbaICMiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:38:22 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51793 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbaICMiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:38:20 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+bODofj3UkUR2PGDJjL8zQ0H+jEh2azsE=
X-DKIM: OpenDKIM Filter v2.0.1 titan B9E4C5D6C6A
Date: Wed, 3 Sep 2014 08:37:29 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "tony@atomide.com" <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "jonas@southpole.se" <jonas@southpole.se>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        "baohua@kernel.org" <baohua@kernel.org>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "khilman@linaro.org" <khilman@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "larry.bassel@linaro.org" <larry.bassel@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "stefan.kristiansson@saunalahti.fi" 
	<stefan.kristiansson@saunalahti.fi>,
        "vkale@apm.com" <vkale@apm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v2 00/26] genirq: fix use of irq_find_mapping outside
 of legal RCU context
Message-ID: <20140903123729.GM30467@titan.lakedaemon.net>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
 <alpine.DEB.2.10.1408262333420.3323@nanos>
 <87y4uap98n.fsf@approximate.cambridge.arm.com>
 <20140903120406.GK30467@titan.lakedaemon.net>
 <alpine.DEB.2.10.1409031409160.3333@nanos>
 <540707B3.4050305@arm.com>
 <alpine.DEB.2.10.1409031424170.3333@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409031424170.3333@nanos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 02:25:09PM +0200, Thomas Gleixner wrote:
> On Wed, 3 Sep 2014, Marc Zyngier wrote:
> > [Dropping linux@openrisc.net from the CC list]
> > 
> > On 03/09/14 13:09, Thomas Gleixner wrote:
> > > On Wed, 3 Sep 2014, Jason Cooper wrote:
> > > 
> > >> On Wed, Aug 27, 2014 at 10:33:44AM +0100, Marc Zyngier wrote:
> > >>> Hi Thomas,
> > >>>
> > >>> On Tue, Aug 26 2014 at 10:34:51 pm BST, Thomas Gleixner <tglx@linutronix.de> wrote:
> > >>>> On Tue, 26 Aug 2014, Marc Zyngier wrote:
> > >>>>
> > >>>>> A number of irqchip drivers are directly calling irq_find_mapping,
> > >>>>> which may use a rcu_read_lock call when walking the radix tree.
> > >>>>>
> > >>>>> Turns out that if you hit that point with CONFIG_PROVE_RCU enabled,
> > >>>>> the kernel will shout at you, as using RCU in this context may be
> > >>>>> illegal (specially if coming from the idle state, where RCU would be
> > >>>>> in a quiescent state).
> > >>>>>
> > >>>>> A possible fix would be to wrap calls to irq_find_mapping into a
> > >>>>> RCU_NONIDLE macro, but that really looks ugly.
> > >>>>>
> > >>>>> This patch series introduce another generic IRQ entry point
> > >>>>> (handle_domain_irq), which has the exact same behaviour as handle_IRQ
> > >>>>> (as defined on arm, arm64 and openrisc), except that it also takes a
> > >>>>> irq_domain pointer. This allows the logical IRQ lookup to be done
> > >>>>> inside the irq_{enter,exit} section, which contains a
> > >>>>> rcu_irq_{enter,exit}, making it safe.
> > >>>>
> > >>>> Looks good. Should this be routed to the genirq tree?
> > >>>
> > >>> I'm happy for you to take this series, provided the architecture
> > >>> maintainers agree on it (I'm still to hear from the openrisc guys, and
> > >>> their mailing-list seems to positively hate my guts).
> > >>
> > >> I think everyone's had a chance to look over it by now.  Thomas, shall I
> > >> take the series?
> > > 
> > > Yes please.
> > 
> > Do you want a pull request? Or are you picking up the patches from the ML?
> 
> Did you pick up the Acked/Reviewed/Ignored-by tags?

Marc, unless you've already done it, I'll pull from the ml, since I need
to apply the Acked-bys and tweak the subject lines.

thx,

Jason.
