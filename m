Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaBYJNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:13:06 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33356 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaBYJNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:13:00 -0500
MIME-Version: 1.0
In-Reply-To: <1393318071-13524-1-git-send-email-philippe.retornaz@epfl.ch>
References: <CAK9yfHyAK+LtQLr_b-OLHa63dSNT5KN7MBHxqVoTbiHVb4-7DA@mail.gmail.com>
	<1393318071-13524-1-git-send-email-philippe.retornaz@epfl.ch>
Date: Tue, 25 Feb 2014 14:42:59 +0530
Message-ID: <CAK9yfHx9FnQxQOmHcMzc8dQa+mSryPRo=63FL=8tg1JGqe4jNQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] regulator: mc13xxx: check if DT is enabled
From: Sachin Kamat <sachin.kamat@linaro.org>
To: =?ISO-8859-1?Q?Philippe_R=E9tornaz?= <philippe.retornaz@epfl.ch>
Cc: Mark Brown <broonie@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 February 2014 14:17, Philippe Rétornaz <philippe.retornaz@epfl.ch> wrote:
> This fix a regression on non-DT board booted with a DT enabled kernel
>
> Signed-off-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>
> ---
>  drivers/regulator/mc13xxx-regulator-core.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
> index 4498a3f..a10c999 100644
> --- a/drivers/regulator/mc13xxx-regulator-core.c
> +++ b/drivers/regulator/mc13xxx-regulator-core.c
> @@ -167,6 +167,9 @@ int mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
>         struct device_node *parent;
>         int num;
>
> +       if(!pdev->dev.parent->of_node)
> +               return -ENODEV;
> +
>         of_node_get(pdev->dev.parent->of_node);
>         parent = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
>         if (!parent)
> @@ -187,6 +190,9 @@ struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
>         struct device_node *parent, *child;
>         int i, parsed = 0;
>
> +       if(!pdev->dev.parent->of_node)
> +               return NULL;
> +
>         of_node_get(pdev->dev.parent->of_node);
>         parent = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
>         if (!parent)
> --
> 1.7.9.5
>

Thanks for the patch. I was about to send a similar patch which also
does a little more cleanup.
If you could test it in DT and non-DT modes that would be great. I
attach the diff below. You can
even fold it into your patch if you wish.

------------------
diff --git a/drivers/regulator/mc13xxx-regulator-core.c
b/drivers/regulator/mc13xxx-regulator-core.c
index 4498a3f0733d..bf75fcabfa3c 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -167,8 +167,10 @@ int mc13xxx_get_num_regulators_dt(struct
platform_device *pdev)
        struct device_node *parent;
        int num;

-       of_node_get(pdev->dev.parent->of_node);
-       parent = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
+       if (!pdev->dev.of_node)
+               return -ENODEV;
+
+       parent = of_get_child_by_name(pdev->dev.of_node, "regulators");
        if (!parent)
                return -ENODEV;

@@ -187,8 +189,10 @@ struct mc13xxx_regulator_init_data
*mc13xxx_parse_regulators_dt(
        struct device_node *parent, *child;
        int i, parsed = 0;

-       of_node_get(pdev->dev.parent->of_node);
-       parent = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
+       if (!pdev->dev.of_node)
+               return NULL;
+
+       parent = of_get_child_by_name(pdev->dev.of_node, "regulators");
        if (!parent)
                return NULL;


-- 
With warm regards,
Sachin
