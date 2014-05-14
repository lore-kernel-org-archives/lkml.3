Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaENOYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:24:32 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48949 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbaENOY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:24:29 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 2/6] of: consolidate linker section OF match table
 declarations
To: Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: benh@kernel.crashing.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh@kernel.org>
In-Reply-To: <1399587823-17701-3-git-send-email-robherring2@gmail.com>
References: <1399587823-17701-1-git-send-email-robherring2@gmail.com>
	<1399587823-17701-3-git-send-email-robherring2@gmail.com>
Date: Wed, 14 May 2014 15:24:17 +0100
Message-Id: <20140514142417.75C11C4153D@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 May 2014 17:23:39 -0500, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <robh@kernel.org>
> 
> We now have several OF match tables using linker sections that are
> nearly the same definition. The only variation is the callback function
> prototype. Create a common define for creating linker section OF match
> table entries which each table declaration can use.
> 
> Cc: Grant Likely <grant.likely@linaro.org>
> Signed-off-by: Rob Herring <robh@kernel.org>

Nice!

Acked-by: Grant Likely <grant.likely@linaro.org>

g.

> ---
>  drivers/clocksource/clksrc-of.c |  2 +-
>  drivers/irqchip/irqchip.h       |  7 +++----
>  include/linux/clk-provider.h    |  5 +----
>  include/linux/clocksource.h     | 16 +++-------------
>  include/linux/of.h              | 22 ++++++++++++++++++++++
>  include/linux/of_reserved_mem.h | 18 ++----------------
>  6 files changed, 32 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
> index ae2e427..0093a8e 100644
> --- a/drivers/clocksource/clksrc-of.c
> +++ b/drivers/clocksource/clksrc-of.c
> @@ -27,7 +27,7 @@ void __init clocksource_of_init(void)
>  {
>  	struct device_node *np;
>  	const struct of_device_id *match;
> -	clocksource_of_init_fn init_func;
> +	of_init_fn_1 init_func;
>  	unsigned clocksources = 0;
>  
>  	for_each_matching_node_and_match(np, __clksrc_of_table, &match) {
> diff --git a/drivers/irqchip/irqchip.h b/drivers/irqchip/irqchip.h
> index e445ba2..0f6486d 100644
> --- a/drivers/irqchip/irqchip.h
> +++ b/drivers/irqchip/irqchip.h
> @@ -11,6 +11,8 @@
>  #ifndef _IRQCHIP_H
>  #define _IRQCHIP_H
>  
> +#include <linux/of.h>
> +
>  /*
>   * This macro must be used by the different irqchip drivers to declare
>   * the association between their DT compatible string and their
> @@ -21,9 +23,6 @@
>   * @compstr: compatible string of the irqchip driver
>   * @fn: initialization function
>   */
> -#define IRQCHIP_DECLARE(name,compstr,fn)				\
> -	static const struct of_device_id irqchip_of_match_##name	\
> -	__used __section(__irqchip_of_table)				\
> -	= { .compatible = compstr, .data = fn }
> +#define IRQCHIP_DECLARE(name, compat, fn) OF_DECLARE_2(irqchip, name, compat, fn)
>  
>  #endif
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 59e2eb5..3429929 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -501,10 +501,7 @@ struct clk_onecell_data {
>  
>  extern struct of_device_id __clk_of_table;
>  
> -#define CLK_OF_DECLARE(name, compat, fn)			\
> -	static const struct of_device_id __clk_of_table_##name	\
> -		__used __section(__clk_of_table)		\
> -		= { .compatible = compat, .data = fn };
> +#define CLK_OF_DECLARE(name, compat, fn) OF_DECLARE_1(clk, name, compat, fn)
>  
>  #ifdef CONFIG_OF
>  int of_clk_add_provider(struct device_node *np,
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index 67301a4..a16b497 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -339,23 +339,13 @@ extern int clocksource_mmio_init(void __iomem *, const char *,
>  
>  extern int clocksource_i8253_init(void);
>  
> -struct device_node;
> -typedef void(*clocksource_of_init_fn)(struct device_node *);
> +#define CLOCKSOURCE_OF_DECLARE(name, compat, fn) \
> +	OF_DECLARE_1(clksrc, name, compat, fn)
> +
>  #ifdef CONFIG_CLKSRC_OF
>  extern void clocksource_of_init(void);
> -
> -#define CLOCKSOURCE_OF_DECLARE(name, compat, fn)			\
> -	static const struct of_device_id __clksrc_of_table_##name	\
> -		__used __section(__clksrc_of_table)			\
> -		 = { .compatible = compat,				\
> -		     .data = (fn == (clocksource_of_init_fn)NULL) ? fn : fn }
>  #else
>  static inline void clocksource_of_init(void) {}
> -#define CLOCKSOURCE_OF_DECLARE(name, compat, fn)			\
> -	static const struct of_device_id __clksrc_of_table_##name	\
> -		__attribute__((unused))					\
> -		 = { .compatible = compat,				\
> -		     .data = (fn == (clocksource_of_init_fn)NULL) ? fn : fn }
>  #endif
>  
>  #endif /* _LINUX_CLOCKSOURCE_H */
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 3bad8d1..6fb2185 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -757,4 +757,26 @@ static inline int of_get_available_child_count(const struct device_node *np)
>  	return num;
>  }
>  
> +#ifdef CONFIG_OF
> +#define _OF_DECLARE(table, name, compat, fn, fn_type)			\
> +	static const struct of_device_id __of_table_##name		\
> +		__used __section(__##table##_of_table)			\
> +		 = { .compatible = compat,				\
> +		     .data = (fn == (fn_type)NULL) ? fn : fn  }
> +#else
> +#define _OF_DECLARE(name, compat, fn, fn_type)					\
> +	static const struct of_device_id __of_table_##name		\
> +		__attribute__((unused))					\
> +		 = { .compatible = compat,				\
> +		     .data = (fn == (fn_type)NULL) ? fn : fn }
> +#endif
> +
> +typedef int (*of_init_fn_2)(struct device_node *, struct device_node *);
> +typedef void (*of_init_fn_1)(struct device_node *);
> +
> +#define OF_DECLARE_1(table, name, compat, fn) \
> +		_OF_DECLARE(table, name, compat, fn, of_init_fn_1)
> +#define OF_DECLARE_2(table, name, compat, fn) \
> +		_OF_DECLARE(table, name, compat, fn, of_init_fn_2)
> +
>  #endif /* _LINUX_OF_H */
> diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
> index 4c81b84..4669ddf 100644
> --- a/include/linux/of_reserved_mem.h
> +++ b/include/linux/of_reserved_mem.h
> @@ -23,31 +23,17 @@ struct reserved_mem_ops {
>  
>  typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem);
>  
> +#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
> +	_OF_DECLARE(reservedmem, name, compat, init, reservedmem_of_init_fn)
>  
>  #ifdef CONFIG_OF_RESERVED_MEM
>  void fdt_init_reserved_mem(void);
>  void fdt_reserved_mem_save_node(unsigned long node, const char *uname,
>  			       phys_addr_t base, phys_addr_t size);
> -
> -#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
> -	static const struct of_device_id __reservedmem_of_table_##name	\
> -		__used __section(__reservedmem_of_table)		\
> -		 = { .compatible = compat,				\
> -		     .data = (init == (reservedmem_of_init_fn)NULL) ?	\
> -				init : init }
> -
>  #else
>  static inline void fdt_init_reserved_mem(void) { }
>  static inline void fdt_reserved_mem_save_node(unsigned long node,
>  		const char *uname, phys_addr_t base, phys_addr_t size) { }
> -
> -#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
> -	static const struct of_device_id __reservedmem_of_table_##name	\
> -		__attribute__((unused))					\
> -		 = { .compatible = compat,				\
> -		     .data = (init == (reservedmem_of_init_fn)NULL) ?	\
> -				init : init }
> -
>  #endif
>  
>  #endif /* __OF_RESERVED_MEM_H */
> -- 
> 1.9.1
> 

