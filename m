Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaFXPqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:46:36 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48694 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaFXPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:46:35 -0400
Date: Tue, 24 Jun 2014 11:46:32 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v6 2/4] arm: fiq: Allow EOI to be communicated to the
 intc
In-Reply-To: <1403623097-1153-3-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.LFD.2.11.1406241145590.16842@knanqh.ubzr>
References: <1403174303-25456-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-3-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Daniel Thompson wrote:

> Modern ARM systems require an EOI to be sent to the interrupt controller
> on completion of both IRQ and FIQ. The FIQ code currently does not provide
> any API to perform this. This patch provides this API, implemented by
> adding a callback to the fiq_chip structure.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: Nicolas Pitre <nico@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/include/asm/fiq.h | 6 ++++++
>  arch/arm/kernel/fiq.c      | 9 +++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/arch/arm/include/asm/fiq.h b/arch/arm/include/asm/fiq.h
> index a7806ef..e5d9458 100644
> --- a/arch/arm/include/asm/fiq.h
> +++ b/arch/arm/include/asm/fiq.h
> @@ -21,6 +21,11 @@
>  struct fiq_chip {
>  	void (*fiq_enable)(struct irq_data *data);
>  	void (*fiq_disable)(struct irq_data *data);
> +
> +	/* .fiq_eoi() will be called from the FIQ handler. For this
> +	 * reason it must not use spin locks (or any other locks).
> +	 */
> +	void (*fiq_eoi)(struct irq_data *data);
>  };
>  
>  struct fiq_handler {
> @@ -43,6 +48,7 @@ extern void release_fiq(struct fiq_handler *f);
>  extern void set_fiq_handler(void *start, unsigned int length);
>  extern void enable_fiq(int fiq);
>  extern void disable_fiq(int fiq);
> +extern void eoi_fiq(int fiq);
>  extern bool has_fiq(int fiq);
>  extern void fiq_register_mapping(int irq, struct fiq_chip *chip);
>  
> diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
> index 567f8fd..edde332 100644
> --- a/arch/arm/kernel/fiq.c
> +++ b/arch/arm/kernel/fiq.c
> @@ -183,6 +183,15 @@ void disable_fiq(int fiq)
>  	disable_irq(fiq + fiq_start);
>  }
>  
> +void eoi_fiq(int fiq)
> +{
> +	struct fiq_data *data = lookup_fiq_data(fiq);
> +
> +	if (data && data->fiq_chip->fiq_eoi)
> +		data->fiq_chip->fiq_eoi(data->irq_data);
> +}
> +EXPORT_SYMBOL(eoi_fiq);
> +
>  bool has_fiq(int fiq)
>  {
>  	struct fiq_data *data = lookup_fiq_data(fiq);
> -- 
> 1.9.3
> 
