Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbaKSRyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:54:17 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:44208 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318AbaKSRyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:54:14 -0500
MIME-Version: 1.0
In-Reply-To: <1416354596-15013-3-git-send-email-dianders@chromium.org>
References: <1416354596-15013-1-git-send-email-dianders@chromium.org>
	<1416354596-15013-3-git-send-email-dianders@chromium.org>
Date: Wed, 19 Nov 2014 09:54:13 -0800
X-Google-Sender-Auth: E2Tdl1eBYI7m_jgPmfCLBmOIORs
Message-ID: <CAD=FV=W3oQjEJLo4vYoTOwv38iKNT0MHQ9qPSWBm=qFMTnHKag@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: rockchip: Fix enable/disable/mask/unmask
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Linus Walleij <linus.walleij@linaro.org>
Cc: Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Zhong <zyw@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 18, 2014 at 3:49 PM, Doug Anderson <dianders@chromium.org> wrote:
> +static void rockchip_irq_disable(struct irq_data *d)
> +{
> +       struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +       u32 val;
> +
> +       irq_gc_lock(gc);
> +       val = irq_reg_readl(gc, GPIO_INTEN);
> +       irq_reg_writel(gc, val & ~d->mask, GPIO_INTEN);
> +       irq_gc_unlock(gc);
> +}

Off list, Dmitry asked me why I didn't use irq_gc_mask_disable_reg()
and irq_gc_unmask_enable_reg() (AKA why I coded up my own function
here).  Originally I tried to use irq_gc_mask_disable_reg() and
irq_gc_unmask_enable_reg().  ..but they're really not designed to work
in tandem with the irq_gc_mask_set_bit() and irq_gc_mask_clr_bit().

Specifically if you try to use one set of functions for your
mask/unmask and the other for your disable/enable you'll find that
they stomp on each other.  Both functions upkeep the exact same
"mask_cache" variable.

Personally I'm totally baffled by how irq_gc_mask_disable_reg() and
irq_gc_unmask_enable_reg() could actually be sane, but that's maybe a
topic for another discussion.  I say that they don't seem sane because
(it seems to me) that if we have a separate "enable" and "disable"
register in hardware that you'd want to write "1"s to both of them and
also possibly not even have a cache.  The current
irq_gc_mask_disable_reg() doesn't do this.  I'm imagining something
like I think I've seen on STM32 where you're got a 3 registers for
everything: the real register, a "write 1 to set", and a "write 1 to
clear".

-Doug
