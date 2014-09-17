Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaIQL6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:58:13 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59956 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754510AbaIQL6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:58:12 -0400
Date: Wed, 17 Sep 2014 12:57:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chanho Min <chanho.min@lge.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Michael Opdenacker <michael@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jongsung Kim <neidhard.kim@lge.com>
Subject: Re: [PATCH v2] ARM: timer-sp: ensure interrupt is cleared at
	sp804_of_init
Message-ID: <20140917115758.GQ12361@n2100.arm.linux.org.uk>
References: <1410953686-15072-1-git-send-email-chanho.min@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410953686-15072-1-git-send-email-chanho.min@lge.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 08:34:46PM +0900, Chanho Min wrote:
> sp804 may not be added to the tick device if the higher device is
> already registered. In this case, If pending interrupt is existed
> (usually It will be passed from the boot loader), inetrrupt is occured
> without event_handler then it cause kernel panic. So Interrupts
> should be cleared before clockevent is registered.
> 
> Changes since v1:
>  - Move to sp804_of_init
>  - Clear TIMER2 interrupt
>  - Update commit log
> 
> Signed-off-by: Chanho Min <chanho.min@lge.com>
> ---
>  arch/arm/common/timer-sp.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
> index fd6bff0..e3cc08e 100644
> --- a/arch/arm/common/timer-sp.c
> +++ b/arch/arm/common/timer-sp.c
> @@ -226,6 +226,10 @@ static void __init sp804_of_init(struct device_node *np)
>  	writel(0, base + TIMER_CTRL);
>  	writel(0, base + TIMER_2_BASE + TIMER_CTRL);
>  
> +	/* Ensure interrupt is cleared */
> +	writel(1, base + TIMER_INTCLR);
> +	writel(1, base + TIMER_2_BASE + TIMER_INTCLR);

NAK.

This is really not necessary for two reasons, and incorrect for a third
reason:

1. If the control register is cleared, interrupts are disabled.  When
   interrupts are disabled, the IRQ line from the timer module is
   deasserted irrespective of the internal interrupt state of the timer.

2. We only enable the interrupt when we set the timer up to run in either
   periodic or one-shot modes.  If the timer is not used, the interrupt
   remains masked.

3. Even if this was necessary (which it isn't), only doing this in the
   sp804_of_init() path is wrong - there are other initialisation paths
   in this code, and there's no reason why one should have a different
   behaviour to the others.

If you've found this by running the kernel with QEMU, then it's probably
a QEMU bug if it raises an interrupt during the above code.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
