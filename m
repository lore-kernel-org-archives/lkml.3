Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934812AbaFTIGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:06:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:57353 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933893AbaFTIGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:06:11 -0400
Date: Fri, 20 Jun 2014 10:06:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [patch 08/13] irqchip: spear_shirq: Precalculate status mask
In-Reply-To: <CAOh2x==trCJcQnzekEdcFoBb2i1Mc7hMsJq94iu2dzrZ=Xkeow@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406201005400.5170@nanos>
References: <20140619212606.431750473@linutronix.de> <20140619212713.496614337@linutronix.de> <CAOh2x==trCJcQnzekEdcFoBb2i1Mc7hMsJq94iu2dzrZ=Xkeow@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Viresh Kumar wrote:
> On Fri, Jun 20, 2014 at 3:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > @@ -176,6 +186,7 @@ static struct spear_shirq spear320_shirq
> >  static struct spear_shirq spear320_shirq_intrcomm_ras = {
> >         .offset         = 11,
> >         .nr_irqs        = 11,
> > +       .mask           = ((0x1 << 11) - 1) << 11,
> >         .regs = {
> >                 .enb_reg = -1,
> >                 .status_reg = SPEAR320_INT_STS_MASK_REG,
> 
> If you like, maybe this instead of above diff:

What's wrong with letting the compiler fill it in?
 
> diff --git a/drivers/irqchip/spear-shirq.c b/drivers/irqchip/spear-shirq.c
> index 3fdda3a..40c5c1b 100644
> --- a/drivers/irqchip/spear-shirq.c
> +++ b/drivers/irqchip/spear-shirq.c
> @@ -281,6 +281,8 @@ static int __init shirq_init(struct spear_shirq
> **shirq_blocks, int block_nr,
>                 shirq_blocks[i]->base = base;
>                 shirq_blocks[i]->irq_base = irq_find_mapping(shirq_domain,
>                                 hwirq);
> +               shirq_blocks[i]->mask = ((0x1 << shirq_blocks[i]->nr_irqs) - 1)
> +                                       << shirq_blocks[i]->offset;
>                 shirq_blocks[i]->irq = irq_of_parse_and_map(np, i);
> 
>                 spear_shirq_register(shirq_blocks[i]);
> 
> 
> > @@ -239,7 +250,7 @@ static void shirq_handler(unsigned irq,
> >
> >         chip->irq_ack(idata);
> >
> > -       mask = ((0x1 << shirq->nr_irqs) - 1) << shirq->offset;
> > +       mask = shirq->mask;
> >         while ((val = readl(shirq->base + shirq->regs.status_reg) &
> >                                 mask)) {
> >
> >
> >
> 
