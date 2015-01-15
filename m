Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbbAOJtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:49:16 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:44905 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbAOJtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:49:13 -0500
MIME-Version: 1.0
In-Reply-To: <1418031490-17716-2-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1418031490-17716-1-git-send-email-rebecca.swee.fun.chang@intel.com>
	<1418031490-17716-2-git-send-email-rebecca.swee.fun.chang@intel.com>
Date: Thu, 15 Jan 2015 10:49:12 +0100
Message-ID: <CACRpkdbOz0VAH1RzaXdDyfDxzTtAuBNA_yGQoS8G_y8JxCFJiw@mail.gmail.com>
Subject: Re: [PATCHv5 1/2] gpio: sch: Consolidate similar algorithms
From: Linus Walleij <linus.walleij@linaro.org>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Mika Westerberg <mika.westerberg@intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis.turischev@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 10:38 AM, Chang Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com> wrote:

> Consolidating similar algorithms into common functions to make
> GPIO SCH simpler and manageable.
>
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

I have removed this patch from the tree. It breaks completely
in build and looks strange:

> +static void sch_gpio_reg_set(struct gpio_chip *gc, unsigned gpio, unsigned reg,
> +                            int val)

Takes struct gpio_chip * as argument...

> +static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
> +{
> +       struct sch_gpio *sch = to_sch_gpio(gc);
>
> +       spin_lock(&sch->lock);
> +       sch_gpio_reg_set(sch, gpio_num, GIO, 1);

Passes something else as argument.

>  static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int val)
>  {
>         struct sch_gpio *sch = to_sch_gpio(gc);
> -       u8 curr_vals;
> -       unsigned short offset, bit;
>
>         spin_lock(&sch->lock);
> -
> -       offset = sch_gpio_offset(sch, gpio_num, GLV);
> -       bit = sch_gpio_bit(sch, gpio_num);
> -
> -       curr_vals = inb(sch->iobase + offset);
> -
> -       if (val)
> -               outb(curr_vals | (1 << bit), sch->iobase + offset);
> -       else
> -               outb((curr_vals & ~(1 << bit)), sch->iobase + offset);
> -
> +       sch_gpio_reg_set(gc, gpio_num, GLV, val);

Here it is correct.

> @@ -139,18 +123,9 @@ static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
>                                   int val)
>  {
>         struct sch_gpio *sch = to_sch_gpio(gc);
> -       u8 curr_dirs;
> -       unsigned short offset, bit;
>
>         spin_lock(&sch->lock);
> -
> -       offset = sch_gpio_offset(sch, gpio_num, GIO);
> -       bit = sch_gpio_bit(sch, gpio_num);
> -
> -       curr_dirs = inb(sch->iobase + offset);
> -       if (curr_dirs & (1 << bit))
> -               outb(curr_dirs & ~(1 << bit), sch->iobase + offset);
> -
> +       sch_gpio_reg_set(sch, gpio_num, GIO, 0);

Wrong again. Etc.

Makes me suspect that this patch is not tested at all, so dropped.

Yours,
Linus Walleij
