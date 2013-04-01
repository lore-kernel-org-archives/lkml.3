Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab3DAHRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 03:17:52 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:37062 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab3DAHRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 03:17:51 -0400
MIME-Version: 1.0
In-Reply-To: <1364798210-31517-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1364798210-31517-1-git-send-email-prabhakar.csengg@gmail.com>
Date: Mon, 1 Apr 2013 12:47:50 +0530
Message-ID: <CA+Z25wXJt=vZnZ-ba+zkOWMgx0AjfnZT1JyHbaF4nuQ8MLvaKg@mail.gmail.com>
Subject: Re: [PATCH v2] davinci: vpif: add pm_runtime support
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: Prabhakar lad <prabhakar.csengg@gmail.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, Sekhar Nori <nsekhar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 April 2013 12:06, Prabhakar lad <prabhakar.csengg@gmail.com> wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> Add pm_runtime support to the TI Davinci VPIF driver.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Sekhar Nori <nsekhar@ti.com>
> ---
>  Changes for v2:
>  1: Removed use of clk API as pointed by Laurent and Sekhar.
>
>  drivers/media/platform/davinci/vpif.c |   24 +++++++-----------------
>  1 files changed, 7 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
> index 28638a8..599cabb 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
> @@ -23,8 +23,8 @@
>  #include <linux/spinlock.h>
>  #include <linux/kernel.h>
>  #include <linux/io.h>
> -#include <linux/clk.h>
>  #include <linux/err.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/v4l2-dv-timings.h>
>
>  #include <mach/hardware.h>
> @@ -44,7 +44,6 @@ static struct resource        *res;
>  spinlock_t vpif_lock;
>
>  void __iomem *vpif_base;
> -struct clk *vpif_clk;
>
>  /**
>   * ch_params: video standard configuration parameters for vpif
> @@ -439,19 +438,15 @@ static int vpif_probe(struct platform_device *pdev)
>                 goto fail;
>         }
>
> -       vpif_clk = clk_get(&pdev->dev, "vpif");
> -       if (IS_ERR(vpif_clk)) {
> -               status = PTR_ERR(vpif_clk);
> -               goto clk_fail;
> -       }
> -       clk_prepare_enable(vpif_clk);
> +       pm_runtime_enable(&pdev->dev);
> +       pm_runtime_resume(&pdev->dev);
> +
> +       pm_runtime_get(&pdev->dev);

I don't see runtime-pm ops being registered. Can you explain how clock
prepare/unprepare is taken care by runtime-pm?

>
>         spin_lock_init(&vpif_lock);
>         dev_info(&pdev->dev, "vpif probe success\n");
>         return 0;
>
> -clk_fail:
> -       iounmap(vpif_base);
>  fail:
>         release_mem_region(res->start, res_len);
>         return status;
> @@ -459,11 +454,6 @@ fail:
>
>  static int vpif_remove(struct platform_device *pdev)
>  {
> -       if (vpif_clk) {
> -               clk_disable_unprepare(vpif_clk);
> -               clk_put(vpif_clk);
> -       }
> -
>         iounmap(vpif_base);
>         release_mem_region(res->start, res_len);
>         return 0;
> @@ -472,13 +462,13 @@ static int vpif_remove(struct platform_device *pdev)
>  #ifdef CONFIG_PM
>  static int vpif_suspend(struct device *dev)
>  {
> -       clk_disable_unprepare(vpif_clk);
> +       pm_runtime_put(dev);
>         return 0;
>  }
>
>  static int vpif_resume(struct device *dev)
>  {
> -       clk_prepare_enable(vpif_clk);
> +       pm_runtime_get(dev);
>         return 0;
>  }
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Regards,
Rajagopal
