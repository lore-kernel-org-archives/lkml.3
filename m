Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaDSBdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 21:33:33 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40897 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaDSBdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 21:33:31 -0400
MIME-Version: 1.0
In-Reply-To: <1396597880-2325-2-git-send-email-k.kozlowski@samsung.com>
References: <1396597880-2325-1-git-send-email-k.kozlowski@samsung.com> <1396597880-2325-2-git-send-email-k.kozlowski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 18 Apr 2014 18:33:09 -0700
Message-ID: <CAK5ve-J9hwdHqRumjYxNnaOmgQ=F9yrf1N+VgpAMagTBy-Pytg@mail.gmail.com>
Subject: Re: [PATCH 2/2] leds: 88pm860x: Fix missing refcount decrement for
 parent of_node
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 12:51 AM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> The driver obtained the reference to parent->of_node but immediately it
> was overwritten by reference to child node 'leds'. The of_node_put at
> the end of DT parsing function decremented only the child 'leds' so
> effectively the reference to parent of_node leaked.
>
> Getting reference to parent->of_node is not needed at all so get rid of
> it to fix the reference count.
>

Good catch, thanks. I merged it into my for-next branch as well.
-Bryan

> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/leds/leds-88pm860x.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
> index 2f9ee538f30d..fb7c310e9f20 100644
> --- a/drivers/leds/leds-88pm860x.c
> +++ b/drivers/leds/leds-88pm860x.c
> @@ -131,10 +131,9 @@ static int pm860x_led_dt_init(struct platform_device *pdev,
>         struct device_node *nproot, *np;
>         int iset = 0;
>
> -       nproot = of_node_get(pdev->dev.parent->of_node);
> -       if (!nproot)
> +       if (!pdev->dev.parent->of_node)
>                 return -ENODEV;
> -       nproot = of_get_child_by_name(nproot, "leds");
> +       nproot = of_get_child_by_name(pdev->dev.parent->of_node, "leds");
>         if (!nproot) {
>                 dev_err(&pdev->dev, "failed to find leds node\n");
>                 return -ENODEV;
> --
> 1.7.9.5
>
