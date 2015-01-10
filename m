Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbbAJVkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:40:25 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34679 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbbAJVkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:40:23 -0500
MIME-Version: 1.0
In-Reply-To: <1420857290-8373-8-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
	<1420857290-8373-8-git-send-email-robh@kernel.org>
Date: Sat, 10 Jan 2015 22:40:22 +0100
Message-ID: <CACRpkdbwKN9LenqrWeu4WykhdZOGAdxpC_BYr2cYpc2_cn5GfA@mail.gmail.com>
Subject: Re: [PATCH 07/16] ARM: integrator: convert PCI to use generic config accesses
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robh@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 3:34 AM, Rob Herring <robh@kernel.org> wrote:

> Convert the integrator PCI driver to use the generic config access
> functions.
>
> This changes accesses from __raw_readX/__raw_writeX to readX/writeX
> variants.

Just as good.

> The spinlock is removed because it is unnecessary. The config
> read and write functions are already protected with a spinlock and no
> access can occur during the .pre_init function.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org

I trust that you do the right thing I guess...
Acked-by: Linus Walleij <linus.walleij@linaro.org>

>  static int v3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
>                           int size, u32 *val)
>  {
> -       addr = v3_open_config_window(bus, devfn, where);
> +       int ret = pci_generic_config_read(bus, devfn, where, size, val);
>         v3_close_config_window();
> +       return ret;
>  }
>
>  static int v3_write_config(struct pci_bus *bus, unsigned int devfn, int where,
>                            int size, u32 val)
>  {
> +       int ret = pci_generic_config_write(bus, devfn, where, size, val);
>         v3_close_config_window();
> -       raw_spin_unlock_irqrestore(&v3_lock, flags);
> +       return ret;
>  }
>
>  static struct pci_ops pci_v3_ops = {
> +       .map_bus = v3_open_config_window,
>         .read   = v3_read_config,
>         .write  = v3_write_config,

So .map_bus is called before every .read/.write operation I take it.

Wouldn't it be proper to call the v3_close_config_window() from a
matching .unmap_bus() callback for symmetry?

Yours,
Linus Walleij
