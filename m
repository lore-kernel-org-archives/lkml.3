Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaD0VhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 17:37:10 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:36748 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaD0VhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 17:37:07 -0400
MIME-Version: 1.0
In-Reply-To: <E1We4rQ-0001mv-Ps@rmk-PC.arm.linux.org.uk>
References: <E1We4rQ-0001mv-Ps@rmk-PC.arm.linux.org.uk>
Date: Sun, 27 Apr 2014 16:37:06 -0500
Message-ID: <CAL_JsqLLUQn9ESBwyJ4T3TL3CzZm7H6hTdYKbO8tdLpPDxrKYg@mail.gmail.com>
Subject: Re: [PATCH] clkdev: only fall through to clk_get_sys() if DT
 indicates no entry
From: Rob Herring <robherring2@gmail.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 10:49 AM, Russell King
<rmk+kernel@arm.linux.org.uk> wrote:
> There are two failures which DT can return when looking up a phandle:
> -ENOENT - when DT finds that the desired property/index is not present
> -EINVAL - when DT finds that the desired property/index is present, but
>  there is a problem parsing it.
>
> We should only fall through to clk_get_sys() (the table driven clock
> lookup) when DT indicates that there was no entry in the OF tables
> for the clock.  Doing otherwise causes the clk API to always indicate
> that there is no entry for this clock, which is not correct behaviour.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
> Grant, Rob,
>
> Please let me know ASAP if this gives you any cause for concern.  This
> looks to me like a long standing bug which really needs fixing.  Part
> of the motivation here is similar to Jean-Francois' patch to clkdev
> which allows a DT specified clock which isn't get present to have
> clk_get() and friends return -EPROBE_DEFER - again, something that I
> think really should happen.  Jean-Francois hasn't been able to get
> much traction for his patch, so let's start with fixing this bug first.

I have no issues. A platform would have to be pretty broken to be
relying on the current behavior.

Rob

>
>  drivers/clk/clkdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index 48f67218247c..4e65d0e10b05 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -165,7 +165,7 @@ struct clk *clk_get(struct device *dev, const char *con_id)
>
>         if (dev) {
>                 clk = of_clk_get_by_name(dev->of_node, con_id);
> -               if (!IS_ERR(clk))
> +               if (!IS_ERR(clk) || PTR_ERR(clk) != -ENOENT)
>                         return clk;
>         }
>
> --
> 1.8.3.1
>
