Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbaH0Jdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:33:52 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:27537 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932693AbaH0Jdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:33:50 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux\@openrisc.net" <linux@openrisc.net>,
        "linux\@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "shawn.guo\@freescale.com" <shawn.guo@freescale.com>,
        "kernel\@pengutronix.de" <kernel@pengutronix.de>,
        "tony\@atomide.com" <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "jonas\@southpole.se" <jonas@southpole.se>,
        "jason\@lakedaemon.net" <jason@lakedaemon.net>,
        "shc_work\@mail.ru" <shc_work@mail.ru>,
        "baohua\@kernel.org" <baohua@kernel.org>,
        "maxime.ripard\@free-electrons.com" 
	<maxime.ripard@free-electrons.com>,
        "khilman\@linaro.org" <khilman@linaro.org>,
        "sboyd\@codeaurora.org" <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "larry.bassel\@linaro.org" <larry.bassel@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "stefan.kristiansson\@saunalahti.fi" 
	<stefan.kristiansson@saunalahti.fi>,
        "vkale\@apm.com" <vkale@apm.com>,
        "schwidefsky\@de.ibm.com" <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v2 00/26] genirq: fix use of irq_find_mapping outside of legal RCU context
In-Reply-To: <alpine.DEB.2.10.1408262333420.3323@nanos> (Thomas Gleixner's
	message of "Tue, 26 Aug 2014 22:34:51 +0100")
Organization: ARM Ltd
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
	<alpine.DEB.2.10.1408262333420.3323@nanos>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Wed, 27 Aug 2014 10:33:44 +0100
Message-ID: <87y4uap98n.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Tue, Aug 26 2014 at 10:34:51 pm BST, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 26 Aug 2014, Marc Zyngier wrote:
>
>> A number of irqchip drivers are directly calling irq_find_mapping,
>> which may use a rcu_read_lock call when walking the radix tree.
>> 
>> Turns out that if you hit that point with CONFIG_PROVE_RCU enabled,
>> the kernel will shout at you, as using RCU in this context may be
>> illegal (specially if coming from the idle state, where RCU would be
>> in a quiescent state).
>> 
>> A possible fix would be to wrap calls to irq_find_mapping into a
>> RCU_NONIDLE macro, but that really looks ugly.
>> 
>> This patch series introduce another generic IRQ entry point
>> (handle_domain_irq), which has the exact same behaviour as handle_IRQ
>> (as defined on arm, arm64 and openrisc), except that it also takes a
>> irq_domain pointer. This allows the logical IRQ lookup to be done
>> inside the irq_{enter,exit} section, which contains a
>> rcu_irq_{enter,exit}, making it safe.
>
> Looks good. Should this be routed to the genirq tree?

I'm happy for you to take this series, provided the architecture
maintainers agree on it (I'm still to hear from the openrisc guys, and
their mailing-list seems to positively hate my guts).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
