Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3FJMGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 08:06:52 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:41147 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab3FJMGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 08:06:51 -0400
MIME-Version: 1.0
In-Reply-To: <1370864113-17895-13-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
	<1370864113-17895-13-git-send-email-tushar.behera@linaro.org>
Date: Mon, 10 Jun 2013 17:36:50 +0530
Message-ID: <CAK9yfHygMQYpVRqrieyESJw9oZC5OzKoWWSUhYDYEd6KJigegA@mail.gmail.com>
Subject: Re: [PATCH 12/15] ASoC: spear: Convert to use devm_ioremap_resource
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2013 17:05, Tushar Behera <tushar.behera@linaro.org> wrote:
> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().

This patch does a little more than just conversion. May that change
could be mentioned here.

>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: alsa-devel@alsa-project.org
> CC: Liam Girdwood <lgirdwood@gmail.com>
> CC: Mark Brown <broonie@kernel.org>
> ---
>  sound/soc/spear/spdif_out.c |   20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
>
> diff --git a/sound/soc/spear/spdif_out.c b/sound/soc/spear/spdif_out.c
> index 4bde512..896ee7f 100644
> --- a/sound/soc/spear/spdif_out.c
> +++ b/sound/soc/spear/spdif_out.c
> @@ -282,27 +282,17 @@ static int spdif_out_probe(struct platform_device *pdev)
>         struct resource *res;
>         int ret;
>
> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!res)
> -               return -EINVAL;
> -
> -       if (!devm_request_mem_region(&pdev->dev, res->start,
> -                               resource_size(res), pdev->name)) {
> -               dev_warn(&pdev->dev, "Failed to get memory resourse\n");
> -               return -ENOENT;
> -       }
> -
>         host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
>         if (!host) {
>                 dev_warn(&pdev->dev, "kzalloc fail\n");
>                 return -ENOMEM;
>         }
>
> -       host->io_base = devm_request_and_ioremap(&pdev->dev, res->start,
> -                               resource_size(res));
> -       if (!host->io_base) {
> -               dev_warn(&pdev->dev, "ioremap failed\n");
> -               return -ENOMEM;
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       host->io_base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(host->io_base)) {
> +               dev_warn(&pdev->dev, "devm_ioremap_resource failed\n");

This print is not needed as devm_ioremap_resource prints its own messages.


> +               return PTR_ERR(host->io_base);
>         }
>
>         host->clk = devm_clk_get(&pdev->dev, NULL);
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With warm regards,
Sachin
