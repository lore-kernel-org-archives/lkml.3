Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaJTX5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:57:19 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:35272 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaJTX5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:57:18 -0400
MIME-Version: 1.0
In-Reply-To: <1413847670-12245-4-git-send-email-dianders@chromium.org>
References: <1413847670-12245-1-git-send-email-dianders@chromium.org>
	<1413847670-12245-4-git-send-email-dianders@chromium.org>
Date: Mon, 20 Oct 2014 16:57:17 -0700
X-Google-Sender-Auth: CXPQtKVSY2h8qjIXLtr_S6XnbyA
Message-ID: <CAD=FV=XJ1VWy0JvD5-kJ611mgxKGZ8hK-7uu9GyAWbmER_UZhQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] pinctrl: rockchip: Protect read-modify-write with the spinlock
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 20, 2014 at 4:27 PM, Doug Anderson <dianders@chromium.org> wrote:
> @@ -1464,15 +1474,20 @@ static int rockchip_irq_set_type(struct irq_data *d, unsigned int type)
>         if (ret < 0)
>                 return ret;
>
> +       spin_lock_irqsave(&bank->slock, flags);
> +
>         data = readl_relaxed(bank->reg_base + GPIO_SWPORT_DDR);
>         data &= ~mask;
>         writel_relaxed(data, bank->reg_base + GPIO_SWPORT_DDR);
>
> +       spin_unlock_irqrestore(&bank->slock, flags);
> +
>         if (type & IRQ_TYPE_EDGE_BOTH)
>                 __irq_set_handler_locked(d->irq, handle_edge_irq);
>         else
>                 __irq_set_handler_locked(d->irq, handle_level_irq);
>
> +       spin_lock_irqsave(&bank->slock, flags);
>         irq_gc_lock(gc);
>
>         level = readl_relaxed(gc->reg_base + GPIO_INTTYPE_LEVEL);
> @@ -1522,6 +1537,7 @@ static int rockchip_irq_set_type(struct irq_data *d, unsigned int type)
>         writel_relaxed(polarity, gc->reg_base + GPIO_INT_POLARITY);
>
>         irq_gc_unlock(gc);
> +       spin_unlock_irqrestore(&bank->slock, flags);

I just reviewed this again myself and I realized that there was an
error path case that I missed.  I'll plan to spin tomorrow and include
any extra feedback people have.

I'll also note that I'd love any extra scrutiny people have on this
patch.  I'm submitting it totally based on code inspection and am
nowhere near an expert on this driver.  I mostly just looked for all
of the read/modify/wites using writel and added the lock...

-Doug
