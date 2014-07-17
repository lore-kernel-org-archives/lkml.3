Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbaGQJVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:21:04 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57974 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaGQJU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:20:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Richard Weinberger <richard@nod.at>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Thierry Reding <thierry.reding@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, msalter@redhat.com,
        linux-pwm@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for 'devm_ioremap_resource'
Date: Thu, 17 Jul 2014 11:20:36 +0200
Message-ID: <6823014.2plXDE9VA9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53C7269E.4010702@gmail.com>
References: <201407130545.23004.marex@denx.de> <53C53CE1.4090803@gmail.com> <53C7269E.4010702@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+I0K/LYzfxNYkX5fe3vQAWJGKtR9xDmv/IURg1Uwk4+
 RqCN82F8KMaBUyRKXeGn8cJ24x3GDy6UgjC1e7AFGvrjbhpP1R
 xlWlUE5vlFVMgiYz5rn8a9Uo+9njiwUGfjV1HUNyC8n7d8k0EQ
 gr4Q+SUPVOETqzIQNUtWIA4/GS2AZrzr/n5ntfQ9kR4zCQEYD1
 +wozDh1ycOmrPlwD0cNmlsEvcgKqVliX3z7rXVC2ZI1cRCXoOR
 ulsVWSCdRoXlmwbRJDnNly+T6XyTwGFNRDveEqs4FIpPQVcIZE
 76Zf4ZYiWBQYYonH5kLE0WjVwG1xAmRdUNd2zGmbZxzf1d75lA
 VN2y4n8MrmQP8zS9wDjk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2014 09:27:58 Chen Gang wrote:
>                                          gfp_t gfp_mask, unsigned int order);
>  extern void devm_free_pages(struct device *dev, unsigned long addr);
>  
> +#ifdef CONFIG_HAS_IOMEM
>  void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
> +#elif defined(CONFIG_COMPILE_TEST)
> +static inline void __iomem *devm_ioremap_resource(struct device *dev,
> +                                               struct resource *res)
> +{
> +       pr_warn("no hardware io memory, only for COMPILE_TEST\n");
> +       return (__force void __iomem *)ERR_PTR(-ENXIO);
> +}
> +#endif /* CONFIG_HAS_IOMEM || CONFIG_COMPILE_TEST */
>  
>  /* allows to add/remove a custom action to devres stack */

To be honest, I think it's a bad idea to introduce wrappers functions
that are only available when CONFIG_COMPILE_TEST is set.

COMPILE_TEST is a great tool in general, but it has its limits.
In particular, the case for !CONFIG_IOMEM is completely obscure
and we won't find any bugs by allowing more drivers to be built
in those configurations, but attempting to do it would cause
endless churn by changing each instance of 'depends on HAS_IOMEM'
to 'depends on HAS_IOMEM || COMPILE_TEST'.

Note that s390 no has gained support for IOMEM, tile has it most
of the time (when PCI is enabled, so you get it in half the
test builds already), score should set HAS_IOMEM and doesn't
even have public compilers, and uml doesn't even compile in
latest mainline. Nothing else ever sets NO_IOMEM.

	Arnd
