Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934639AbaFTHFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:05:04 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:62164 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934353AbaFTHFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:05:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140619212713.570396433@linutronix.de>
References: <20140619212606.431750473@linutronix.de>
	<20140619212713.570396433@linutronix.de>
Date: Fri, 20 Jun 2014 12:35:00 +0530
X-Google-Sender-Auth: nZUOigIVTFYl_2vQtq21tA428Co
Message-ID: <CAOh2x==nhq6OHkd9U17L3r-_7qnnjYLyiqiKYpGdMuSVEj07=g@mail.gmail.com>
Subject: Re: [patch 09/13] irqchip: spear_shirq: Kill the clear_reg nonsense
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 3:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> None of the chips has a ACK register.

I need to recheck on this after looking at datasheets. Arranging for
them, will revert by tomorrow.

> The code brainlessly fiddles
> with the enable register, so it might even reenable a disabled
> interrupt at least on spear300.

Ack/Clear register is only configured for SPEAr320, how will it
make a difference to SPEAr300 ?

And for SPEAr320 as well, the offset mentioned in code for clear
register is different then ENABLE register.

> Index: linux/drivers/irqchip/spear-shirq.c
> ===================================================================
> --- linux.orig/drivers/irqchip/spear-shirq.c
> +++ linux/drivers/irqchip/spear-shirq.c
> @@ -33,15 +33,11 @@
>   * reset_to_enb: val 1 indicates, we need to clear bit for enabling interrupt
>   * status_reg: status register offset
>   * status_reg_mask: status register valid mask
> - * clear_reg: clear register offset
> - * reset_to_clear: val 1 indicates, we need to clear bit for clearing interrupt
>   */
>  struct shirq_regs {
>         u32 enb_reg;
>         u32 reset_to_enb;
>         u32 status_reg;
> -       u32 clear_reg;

> -       u32 reset_to_clear;

AFAIR, there was a revision for SPEAr320 which was actually using
reset_to_clear and so was present in code. But later revisions got rid
of it and code never got updated.

> @@ -150,13 +141,6 @@ static struct spear_shirq spear320_shirq
>         .nr_irqs        = 7,
>         .mask           = ((0x1 << 7) - 1) << 0,
>         .disabled       = 1,
> -       .regs = {
> -               .enb_reg = SPEAR320_INT_ENB_MASK_REG,
> -               .reset_to_enb = 1,
> -               .status_reg = SPEAR320_INT_STS_MASK_REG,
> -               .clear_reg = SPEAR320_INT_CLR_MASK_REG,
> -               .reset_to_clear = 1,
> -       },

Was removing .regs completely intentional?

I don't see these registers getting added again in later patches.
