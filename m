Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaK0Jlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:41:31 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33029 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbaK0JlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:41:25 -0500
MIME-Version: 1.0
In-Reply-To: <bde13d5e7931af9aa90ddc09a79be5c30e3eef94.1417029918.git.d-gerlach@ti.com>
References: <cover.1417029918.git.d-gerlach@ti.com>
	<bde13d5e7931af9aa90ddc09a79be5c30e3eef94.1417029918.git.d-gerlach@ti.com>
Date: Thu, 27 Nov 2014 10:41:23 +0100
X-Google-Sender-Auth: RdnCy1lk3AmG8oiIKih7tZB6hv4
Message-ID: <CAMuHMdWn3mgzwX55+OCWwMZwvfXkh7B+n-b0uChAW5gbx9b7Dw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] lib: devres: Add exec versions of
 devm_ioremap_resource and friends
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dave Gerlach <d-gerlach@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russ Dill <russ.dill@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Anson.Huang@freescale.com, Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 10:14 PM, Dave Gerlach <d-gerlach@ti.com> wrote:
> --- a/lib/devres.c
> +++ b/lib/devres.c
> @@ -72,6 +72,64 @@ void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
>  EXPORT_SYMBOL(devm_ioremap_nocache);
>
>  /**
> + * devm_ioremap_exec - Managed ioremap_exec()
> + * @dev: Generic device to remap IO address for
> + * @offset: BUS offset to map
> + * @size: Size of map
> + *
> + * Managed ioremap_exec().  Map is automatically unmapped on driver detach.
> + */
> +void __iomem *devm_ioremap_exec(struct device *dev, resource_size_t offset,
> +                               unsigned long size)
> +{

[...]

> +       addr = ioremap_exec(offset, size);

[...]

> +}
> +EXPORT_SYMBOL(devm_ioremap_exec);
> +
> +/**
> + * devm_ioremap_exec_nocache - Managed ioremap_exec_nocache()
> + * @dev: Generic device to remap IO address for
> + * @offset: BUS offset to map
> + * @size: Size of map
> + *
> + * Managed ioremap_exec_nocache().  Map is automatically unmapped on driver
> + * detach.
> + */
> +void __iomem *devm_ioremap_exec_nocache(struct device *dev,
> +                                       resource_size_t offset,
> +                                       unsigned long size)
> +{

[...]

> +       addr = ioremap_exec_nocache(offset, size);

[...]

> +}
> +EXPORT_SYMBOL(devm_ioremap_exec_nocache);
> +

Both of these are identical to the already-existing devm_ioremap() and
devm_ioremap_nocache(), except for the call to the underlying
ioremap*() variant.

Can't the variant selection be done by passing a flag around, set by
the top-level inline functions, to avoid code duplication?
Some architecture-specific ioremap() implementations already work that
way, cfr. arch/m68k/include/asm/io_mm.h:

static inline void __iomem *ioremap(unsigned long physaddr, unsigned long size)
{
        return __ioremap(physaddr, size, IOMAP_NOCACHE_SER);
}
static inline void __iomem *ioremap_nocache(unsigned long physaddr,
unsigned lonn
g size)
{
        return __ioremap(physaddr, size, IOMAP_NOCACHE_SER);
}
static inline void __iomem *ioremap_writethrough(unsigned long physaddr,
                                         unsigned long size)
{
        return __ioremap(physaddr, size, IOMAP_WRITETHROUGH);
}
static inline void __iomem *ioremap_fullcache(unsigned long physaddr,
                                      unsigned long size)
{
        return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
