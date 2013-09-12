Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3ILUtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:49:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36256 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019Ab3ILUtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:49:31 -0400
Message-ID: <523228B5.5070507@ti.com>
Date: Thu, 12 Sep 2013 16:48:53 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Sricharan R <r.sricharan@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linus.walleij@linaro.org>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <rnayak@ti.com>
Subject: Re: [RFC PATCH 1/4] DRIVERS: IRQCHIP: Add crossbar irqchip driver
References: <1379000351-15672-1-git-send-email-r.sricharan@ti.com> <1379000351-15672-2-git-send-email-r.sricharan@ti.com> <alpine.DEB.2.02.1309122201530.4089@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1309122201530.4089@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Thursday 12 September 2013 04:18 PM, Thomas Gleixner wrote:
> On Thu, 12 Sep 2013, Sricharan R wrote:
>> Signed-off-by: Sricharan R <r.sricharan@ti.com>
>> ---
>> There is lockdep warning during the boot. This is because we try to
>> do one request_irq with in another and that results in kmalloc being
>> called from an atomic context, which generates the warning.
>> Any suggestions to overcome this will help.
> 
> You can't be serious about that. You post a patch series with a
> serious bug in it instead of asking in the first place how to solve
> the problem at hand.
> 
> So why do you actually need to call request_irq() from inside
> request_irq() and how do you actually manage to do that at all?
> 
> I have a hard time to figure out how request_irq() might call itself
> recursive. And I have no intention to look at your patch to figure out
> that you abuse an irq chip callback to do so, simply because that
> would force me to use abusive language which is frowned upon nowadays.
> 
This is an outcome of the discussion on earlier patch set [1] which
tried to add IRQ event router functionality. From beginning I was
against the idea because I also felt that we are abusing the irqchip
infrastructure and force fitting the cross-bar to be behave like an
irqchip. But Linus W and few others strongly felt it to make it
an irqchip implementation.

> Can you please explain what you are trying to solve without referring
> to your existing broken implementation.
> 
I will try to summaries the IP and its need here. On TI SOCs, we have
an IP cross-bar which is essentially an even router(hardware). It can
route the IRQ and DMA in existing implementation.

Specifically for the IRQ case addressed here, the cross-bar IP
sits between the interrupt controller and peripheral interrupts.

CPU <-- GIC  <----- CROSSBAR <----- PERIPHERAL IRQs

Just to expand it better, cross-bar input IRQ lines are more than
what a GIC IRQ controller can support.
e.q Total 250 peripheral IRQ lines out of which GIC support
only 160 IRQ lines.

So the idea here is to dynamically map the IRQ lines at
cross-bar level to pick based on request_irq() so that one
can optimize the use of limited IRQ lines at the GIC level.
Strictly speaking the need is just establish the IRQ
connection from peripheral to GIC and thats achieved
at the request_irq() level.

Earlier approach was to statically build this connections
using the DT information in a separate driver probe but
it had limitations of fixing the IRQ map and taking away
flexibility what this IP provide. 
 
Hope this gives better picture to you behind the patch
series.

Just for others to know, use of IRQCHIP also forced to
have all the irqchip handler redirection which is pure
redirection including the irq-handler. And since it
is *fast path* I asked Sricharan to measure the latency
which is around ~2 uS( 1GHz CPU) overhead for every
interrupt just because of redirections. 

Regards,
Santosh

[1] https://lkml.org/lkml/2013/7/18/362

