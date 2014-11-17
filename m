Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaKQWKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:10:43 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:64004 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaKQWKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:10:41 -0500
MIME-Version: 1.0
In-Reply-To: <1416249574-22940-1-git-send-email-sviau@codeaurora.org>
References: <1416249574-22940-1-git-send-email-sviau@codeaurora.org>
Date: Mon, 17 Nov 2014 17:10:40 -0500
Message-ID: <CAF6AEGsvY_pTV_gyAc3-qq_M-EM5EgLG1J5KWRGmDqAmJ8618w@mail.gmail.com>
Subject: Re: [PATCH] drm/msm/mdp5: get the core clock rate from MDP5 config
From: Rob Clark <robdclark@gmail.com>
To: Stephane Viau <sviau@codeaurora.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 1:39 PM, Stephane Viau <sviau@codeaurora.org> wrote:
> The core clock rate depends on the hw configuration. Once we have
> read the hardware revision, we can set the core clock to its
> maximum value.
> Before then, the clock is set at a rate supported by all MDP5
> revisions.
>
> Signed-off-by: Stephane Viau <sviau@codeaurora.org>

Thanks, I have this queued up

BR,
-R

> ---
>  drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c | 9 +++++----
>  drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h | 3 ++-
>  2 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
> index 1bb3a28..f2c15bd 100644
> --- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
> +++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
> @@ -62,6 +62,7 @@ static const struct mdp5_config msm8x74_config = {
>                 .count = 4,
>                 .base = { 0x12500, 0x12700, 0x12900, 0x12b00 },
>         },
> +       .max_clk = 200000000,
>  };
>
>  static const struct mdp5_config apq8084_config = {
> @@ -99,6 +100,7 @@ static const struct mdp5_config apq8084_config = {
>                 .count = 5,
>                 .base = { 0x12500, 0x12700, 0x12900, 0x12b00, 0x12d00 },
>         },
> +       .max_clk = 320000000,
>  };
>
>  struct mdp5_config_entry {
> @@ -420,12 +422,13 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
>         if (ret)
>                 goto fail;
>
> -       ret = clk_set_rate(mdp5_kms->src_clk, config->max_clk);
> -
>         ret = mdp5_select_hw_cfg(kms);
>         if (ret)
>                 goto fail;
>
> +       /* TODO: compute core clock rate at runtime */
> +       clk_set_rate(mdp5_kms->src_clk, mdp5_kms->hw_cfg->max_clk);
> +
>         /* make sure things are off before attaching iommu (bootloader could
>          * have left things on, in which case we'll start getting faults if
>          * we don't disable):
> @@ -486,8 +489,6 @@ static struct mdp5_platform_config *mdp5_get_config(struct platform_device *dev)
>         /* TODO */
>  #endif
>         config.iommu = iommu_domain_alloc(&platform_bus_type);
> -       /* TODO hard-coded in downstream mdss, but should it be? */
> -       config.max_clk = 200000000;
>         /* TODO get from DT: */
>         config.smp_blk_cnt = 22;
>
> diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
> index c91101d..bdbdcda 100644
> --- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
> +++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
> @@ -37,6 +37,8 @@ struct mdp5_config {
>         struct mdp5_sub_block dspp;
>         struct mdp5_sub_block ad;
>         struct mdp5_sub_block intf;
> +
> +       uint32_t max_clk;
>  };
>  extern const struct mdp5_config *mdp5_cfg;
>  #include "mdp5.xml.h"
> @@ -78,7 +80,6 @@ struct mdp5_kms {
>  /* platform config data (ie. from DT, or pdata) */
>  struct mdp5_platform_config {
>         struct iommu_domain *iommu;
> -       uint32_t max_clk;
>         int smp_blk_cnt;
>  };
>
> --
> Qualcomm Innovation Center, Inc.
>
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
>
