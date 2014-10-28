Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbaJ1JxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:53:24 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:33787 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbaJ1JxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:53:22 -0400
MIME-Version: 1.0
In-Reply-To: <1413883364-681-9-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1413883364-681-9-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Tue, 28 Oct 2014 10:53:21 +0100
Message-ID: <CAPDyKFoXzyFnuEwaa_q-uzhQMioAEs=9HyKTfOwV9KahCJnZhQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 08/12] mmc: sdhci-pxav3: Get optional core clock
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 October 2014 11:22, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> Besides the I/O clock, some PXAv3 SDHCI IP also requires a core clock to
> be enabled. Add an optional core clock to the corresponding driver.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Thanks! Applied for next!

Kind regards
Uffe


> ---
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
> Cc: linux-mmc@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/mmc/host/sdhci-pxav3.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
> index 3dfd97977515..ad0badad0ebc 100644
> --- a/drivers/mmc/host/sdhci-pxav3.c
> +++ b/drivers/mmc/host/sdhci-pxav3.c
> @@ -59,6 +59,7 @@
>  #define SDCE_MISC_INT_EN       (1<<1)
>
>  struct sdhci_pxa {
> +       struct clk *clk_core;
>         struct clk *clk_io;
>         u8      power_mode;
>  };
> @@ -320,6 +321,10 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
>         pltfm_host->clk = pxa->clk_io;
>         clk_prepare_enable(pxa->clk_io);
>
> +       pxa->clk_core = devm_clk_get(dev, "core");
> +       if (!IS_ERR(pxa->clk_core))
> +               clk_prepare_enable(pxa->clk_core);
> +
>         /* enable 1/8V DDR capable */
>         host->mmc->caps |= MMC_CAP_1_8V_DDR;
>
> @@ -392,6 +397,8 @@ err_add_host:
>  err_of_parse:
>  err_cd_req:
>         clk_disable_unprepare(pxa->clk_io);
> +       if (!IS_ERR(pxa->clk_core))
> +               clk_disable_unprepare(pxa->clk_core);
>  err_clk_get:
>  err_mbus_win:
>         sdhci_pltfm_free(pdev);
> @@ -409,6 +416,8 @@ static int sdhci_pxav3_remove(struct platform_device *pdev)
>         pm_runtime_disable(&pdev->dev);
>
>         clk_disable_unprepare(pxa->clk_io);
> +       if (!IS_ERR(pxa->clk_core))
> +               clk_disable_unprepare(pxa->clk_core);
>
>         sdhci_pltfm_free(pdev);
>
> @@ -456,6 +465,8 @@ static int sdhci_pxav3_runtime_suspend(struct device *dev)
>         spin_unlock_irqrestore(&host->lock, flags);
>
>         clk_disable_unprepare(pxa->clk_io);
> +       if (!IS_ERR(pxa->clk_core))
> +               clk_disable_unprepare(pxa->clk_core);
>
>         return 0;
>  }
> @@ -468,6 +479,8 @@ static int sdhci_pxav3_runtime_resume(struct device *dev)
>         unsigned long flags;
>
>         clk_prepare_enable(pxa->clk_io);
> +       if (!IS_ERR(pxa->clk_core))
> +               clk_prepare_enable(pxa->clk_core);
>
>         spin_lock_irqsave(&host->lock, flags);
>         host->runtime_suspended = false;
> --
> 2.1.1
>
