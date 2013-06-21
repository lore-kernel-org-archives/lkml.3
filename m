Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965525Ab3FUKY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:24:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42592 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3FUKY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:24:57 -0400
Message-ID: <51C429F4.60709@arm.com>
Date: Fri, 21 Jun 2013 11:24:52 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v6 4/8] ARM: Add .init_platform() callback to machine
 descriptor
References: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com> <1371774924-9224-5-git-send-email-tomasz.figa@gmail.com>
In-Reply-To: <1371774924-9224-5-git-send-email-tomasz.figa@gmail.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 21 Jun 2013 10:24:53.0479 (UTC) FILETIME=[91AA1F70:01CE6E69]
X-MC-Unique: 113062111245404101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/13 01:35, Tomasz Figa wrote:

Hi Tomasz,

> Most ARM platforms have parts that should be initialized as early as
> possible, which usually means as soon as memory management (kmalloc,
> ioremap) starts to work,
> 
> However, currently there is no appropriate callback in machine_desc
> struct to use for such initialization and platforms tend to stuff things
> up .init_irq() and .init_time() callbacks.
> 
> Since all the DT-based platforms are going towards generic IRQ and time
> initialization (using irqchip_init and clocksource_of_init) and current
> code assumes that if custom callbacks are not provided in machine_desc
> then generic ones should be used, this problem has become a bit more
> inconvenient.
> 
> This patch tries to solve this issue by introducing new callback called
> .init_platform(), where any custom low level initialization of platform
> can be done safely.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  arch/arm/include/asm/mach/arch.h | 1 +
>  arch/arm/kernel/irq.c            | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
> index 308ad7d..b2f4d11 100644
> --- a/arch/arm/include/asm/mach/arch.h
> +++ b/arch/arm/include/asm/mach/arch.h
> @@ -46,6 +46,7 @@ struct machine_desc {
>  	void			(*reserve)(void);/* reserve mem blocks	*/
>  	void			(*map_io)(void);/* IO mapping function	*/
>  	void			(*init_early)(void);
> +	void			(*init_platform)(void);
>  	void			(*init_irq)(void);
>  	void			(*init_time)(void);
>  	void			(*init_machine)(void);
> diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
> index 9723d17..61e2000 100644
> --- a/arch/arm/kernel/irq.c
> +++ b/arch/arm/kernel/irq.c
> @@ -115,6 +115,9 @@ EXPORT_SYMBOL_GPL(set_irq_flags);
>  
>  void __init init_IRQ(void)
>  {
> +	if (machine_desc->init_platform)
> +		machine_desc->init_platform();
> +
>  	if (IS_ENABLED(CONFIG_OF) && !machine_desc->init_irq)
>  		irqchip_init();
>  	else

To me, this new hook is strictly equivalent to init_irq. What do we gain
exactly? I didn't think init_irq was going away...

I know init_irq is not pretty, and we tend to overload it with other
stuff, but I don't really see the point of adding a new callback that
has the exact same properties.

	M.
-- 
Jazz is not dead. It just smells funny...

