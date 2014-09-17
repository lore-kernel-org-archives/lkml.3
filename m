Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbaIQTBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:01:52 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39414 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730AbaIQTBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:01:50 -0400
Message-ID: <5419DA91.8090409@gmail.com>
Date: Wed, 17 Sep 2014 12:01:37 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, jason@lakedaemon.net
Subject: Re: [PATCH v3] genirq: warn on inconstent flags and flow handler
References: <1409164725-25901-1-git-send-email-f.fainelli@gmail.com>
In-Reply-To: <1409164725-25901-1-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 11:38 AM, Florian Fainelli wrote:
> It is currently possible for a generic irq chip driver to set IRQ_LEVEL
> and have its irq flow handler be handle_edge_irq. Setting IRQ_LEVEL in
> such a case does not make sense, and will actually prevent e.g: the
> software resend logic from kicking, and potential other problems too.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Thomas, do you need me to resubmit this patch? It still applies cleanly
on top of irq/core db985cbd67c45f875ef43cb5febfaa8cbd203c27 ("Merge tag
'irqchip-core-3.18' of git://git.infradead.org/users/jcooper/linux into
irq/core").

Thanks!

> ---
> Changes in v3:
> - replaced BUG_ON() with WARN_ON(), essentially making it similar to v1
> 
> Changes in v2:
> - replaced WARN_ON() with BUG_ON()
> 
>  kernel/irq/chip.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index a2b28a2fd7b1..939ae1283ec9 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -749,8 +749,13 @@ void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
>  		irqd_set(&desc->irq_data, IRQD_PER_CPU);
>  	if (irq_settings_can_move_pcntxt(desc))
>  		irqd_set(&desc->irq_data, IRQD_MOVE_PCNTXT);
> -	if (irq_settings_is_level(desc))
> +	if (irq_settings_is_level(desc)) {
> +		/* Setting IRQD_LEVEL does not make sense on non-level
> +		 * sensitive interrupts
> +		 */
> +		WARN_ON(desc->handle_irq != handle_level_irq);
>  		irqd_set(&desc->irq_data, IRQD_LEVEL);
> +	}
>  
>  	irqd_set(&desc->irq_data, irq_settings_get_trigger_mask(desc));
>  
> 

