Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaGAS5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:57:34 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51749 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaGAS5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:57:33 -0400
MIME-Version: 1.0
In-Reply-To: <1402677403-3542-1-git-send-email-f.fainelli@gmail.com>
References: <1402677403-3542-1-git-send-email-f.fainelli@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 1 Jul 2014 11:56:53 -0700
Message-ID: <CAGVrzca27LfOLmOaVGMuXpch1U_nZf01qPhu3Oj+dWz0Ztxofg@mail.gmail.com>
Subject: Re: [PATCH] genirq: warn on inconstent flags and flow handler
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-13 9:36 GMT-07:00 Florian Fainelli <f.fainelli@gmail.com>:
> It is currently possible for a generic irq chip driver to set IRQ_LEVEL
> and have its irq flow handler be handle_edge_irq. Setting IRQ_LEVEL in
> such a case does not make sense, and will actually prevent e.g: the
> software resend logic from kicking, and potential other problems too.
>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Thomas,
>
> This is the change I mentioned to you on the #mipslinux IRC channel,
> let me know if you feel like this should be somewhere else, AFAICT
> this should not slow things down.

Thomas, Jason, is this something you are willing to accept?
irq_modify_status() should not be called in a hot-path as far as I
audited the code, but let me know if you prefer another solution (like
propagating an error code from irq_modify_status()).

Thanks!

>
> Thanks!
>
>  kernel/irq/chip.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index a2b28a2fd7b1..939ae1283ec9 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -749,8 +749,13 @@ void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
>                 irqd_set(&desc->irq_data, IRQD_PER_CPU);
>         if (irq_settings_can_move_pcntxt(desc))
>                 irqd_set(&desc->irq_data, IRQD_MOVE_PCNTXT);
> -       if (irq_settings_is_level(desc))
> +       if (irq_settings_is_level(desc)) {
> +               /* Setting IRQD_LEVEL does not make sense on non-level
> +                * sensitive interrupts
> +                */
> +               WARN_ON(desc->handle_irq != handle_level_irq);
>                 irqd_set(&desc->irq_data, IRQD_LEVEL);
> +       }
>
>         irqd_set(&desc->irq_data, irq_settings_get_trigger_mask(desc));
>
> --
> 1.9.1
>



-- 
Florian
