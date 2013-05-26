Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab3EZUqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 16:46:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63202 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3EZUqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 16:46:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCHv4 1/6] arm: TI-Nspire platform code
Date: Sun, 26 May 2013 22:46:12 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <1369480087-24786-2-git-send-email-dt.tangr@gmail.com>
In-Reply-To: <1369480087-24786-2-git-send-email-dt.tangr@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305262246.12803.arnd@arndb.de>
X-Provags-ID: V02:K0:hSGEJYox3q0f78ZNyKPb6+XxTMsQeGuMM/mOAKkW2Bz
 7NKb2QGu+cNSrEJWbyD+Zd1QyV8TSash8wu7jnSSf+ATBJeuCT
 gt36CGrlRA9966Kpd1M6HJ3sLPBeOzozXofBW9jA9PK3RO9lCM
 N0ZC0LSKfBjvrNQClWKzI/pq6tdvuw6m70e0AHk/LCDJbUw9Z5
 v2cnpGWaHm5sCf1QfpYk6eX3tZZSCB+gClV5Af9qKOexP+FmAR
 fN7sYf7157GjbPQYXLIN5gpAjNGXboc2Du4ztSzQFoWIrARcfu
 XOrABq5eTxUcK2BU3X8S2AUKZRKjq+/ufL1Z5P15Eq4ITEVv/V
 678nNyCpEGJND4ZIzwNU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 May 2013, Daniel Tang wrote:

> +static struct map_desc nspire_io_desc[] __initdata = {
> +	{
> +		.virtual	=  NSPIRE_EARLY_UART_VIRT_BASE,
> +		.pfn		= __phys_to_pfn(NSPIRE_EARLY_UART_PHYS_BASE),
> +		.length		= SZ_4K,
> +		.type		= MT_DEVICE
> +	},

You  can remove this now and call debug_ll_io_init() instead, so you can
remove the duplicate definitions of the base addresses.

> +	{
> +		.virtual	=  NSPIRE_PWR_VIRT_BASE,
> +		.pfn		= __phys_to_pfn(NSPIRE_PWR_PHYS_BASE),
> +		.length		= SZ_4K,
> +		.type		= MT_DEVICE
> +	}
> +};

And I think this one can be replaced with a call to of_iomap:

> +static void __init nspire_early_init(void)
> +{
> +	void __iomem *pwr = IOMEM(NSPIRE_PWR_VIRT_BASE);
> +
> +	/* Re-enable bus access to all peripherals */
> +	writel(0, pwr + NSPIRE_PWR_BUS_DISABLE1);
> +	writel(0, pwr + NSPIRE_PWR_BUS_DISABLE2);
> +
> +	pr_info("Re-enabled bus access to all peripherals\n");
> +}

Since it seems to be used only in this one function.

> +DT_MACHINE_START(NSPIRE, "TI-NSPIRE")
> +	.map_io		= nspire_map_io,
> +	.init_irq	= irqchip_init,
> +	.init_time	= nspire_init_time,
> +	.init_machine	= nspire_init,
> +	.init_early	= nspire_early_init,
> +	.dt_compat	= nspire_dt_match,
> +	.restart	= nspire_restart,
> +MACHINE_END

The reference to irqchip_init is now the default, so you can drop that too.
nspire_init_time is still needed right now, but I'd like to initialize the
clocks automatically soon, so that will go away in the future.

Please reorder the other callbacks in call order, same as the structure
definition.

	Arnd
