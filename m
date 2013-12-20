Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab3LTLnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:43:41 -0500
Received: from 20.mo1.mail-out.ovh.net ([188.165.45.168]:49792 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755895Ab3LTLnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:43:40 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Dec 2013 06:43:39 EST
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH 1/2] ARM: AT91: PIT: Remove irq handler when clock event is unused
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <1387536341-7452-2-git-send-email-bigeasy@linutronix.de>
Date: Fri, 20 Dec 2013 19:35:22 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "<linux-arm-kernel@lists.infradead.org> mailing list" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas FERRE <nicolas.ferre@atmel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        =?windows-1252?Q?Sami_Pietik=E4inen?= <Sami.Pietikainen@wapice.com>,
        tglx@linutronix.de, Benedikt Spranger <b.spranger@linutronix.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <BB6D8A98-942B-4B2E-A668-5D47DDC0DBF7@jcrosoft.com>
References: <1387536341-7452-1-git-send-email-bigeasy@linutronix.de> <1387536341-7452-2-git-send-email-bigeasy@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
X-Mailer: Apple Mail (2.1827)
X-Ovh-Tracer-Id: 3206844410790980440
X-Ovh-Remote: 124.217.186.116 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK
On Dec 20, 2013, at 6:45 PM, Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> From: Benedikt Spranger <b.spranger@linutronix.de>
> 
> Setup and remove the interrupt handler in clock event mode selection.
> This avoids calling the (shared) interrupt handler when the device is
> not used.
> 
> Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> [bigeasy: redo the patch with NR_IRQS_LEGACY which is probably required since
> commit 8fe82a55 ("ARM: at91: sparse irq support") which is included since v3.6.
> Patch based on what Sami Pietikäinen <Sami.Pietikainen@wapice.com> suggested].
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> arch/arm/mach-at91/at91rm9200_time.c  | 1 +
> arch/arm/mach-at91/at91sam926x_time.c | 5 ++++-
> 2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
> index bc7b363..fd34d55 100644
> --- a/arch/arm/mach-at91/at91rm9200_time.c
> +++ b/arch/arm/mach-at91/at91rm9200_time.c
> @@ -134,6 +134,7 @@ clkevt32k_mode(enum clock_event_mode mode, struct clock_event_device *dev)
> 		break;
> 	case CLOCK_EVT_MODE_SHUTDOWN:
> 	case CLOCK_EVT_MODE_UNUSED:
> +		remove_irq(NR_IRQS_LEGACY + AT91_ID_SYS, &at91rm9200_timer_irq);

I’m a fan of copy and paste NR_IRQS_LEGACY + AT91_ID_SYS but ok

Best Regards,
J.
> 	case CLOCK_EVT_MODE_RESUME:
> 		irqmask = 0;
> 		break;
> diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
> index bb39232..1c4c487 100644
> --- a/arch/arm/mach-at91/at91sam926x_time.c
> +++ b/arch/arm/mach-at91/at91sam926x_time.c
> @@ -77,7 +77,7 @@ static struct clocksource pit_clk = {
> 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
> };
> 
> -
> +static struct irqaction at91sam926x_pit_irq;
> /*
>  * Clockevent device:  interrupts every 1/HZ (== pit_cycles * MCK/16)
>  */
> @@ -86,6 +86,8 @@ pit_clkevt_mode(enum clock_event_mode mode, struct clock_event_device *dev)
> {
> 	switch (mode) {
> 	case CLOCK_EVT_MODE_PERIODIC:
> +		/* Set up irq handler */
> +		setup_irq(at91sam926x_pit_irq.irq, &at91sam926x_pit_irq);
> 		/* update clocksource counter */
> 		pit_cnt += pit_cycle * PIT_PICNT(pit_read(AT91_PIT_PIVR));
> 		pit_write(AT91_PIT_MR, (pit_cycle - 1) | AT91_PIT_PITEN
> @@ -98,6 +100,7 @@ pit_clkevt_mode(enum clock_event_mode mode, struct clock_event_device *dev)
> 	case CLOCK_EVT_MODE_UNUSED:
> 		/* disable irq, leaving the clocksource active */
> 		pit_write(AT91_PIT_MR, (pit_cycle - 1) | AT91_PIT_PITEN);
> +		remove_irq(at91sam926x_pit_irq.irq, &at91sam926x_pit_irq);
> 		break;
> 	case CLOCK_EVT_MODE_RESUME:
> 		break;
> -- 
> 1.8.5.1
> 

