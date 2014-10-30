Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbaJ3NUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:20:03 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:39090 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278AbaJ3NT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:19:59 -0400
MIME-Version: 1.0
In-Reply-To: <54522CF7.6030302@samsung.com>
References: <1410786785-9838-1-git-send-email-gautam.vivek@samsung.com>
	<1410786785-9838-3-git-send-email-gautam.vivek@samsung.com>
	<54522CF7.6030302@samsung.com>
Date: Thu, 30 Oct 2014 18:49:58 +0530
X-Google-Sender-Auth: uFayvWDqbl-OmraFEkAFkfsWHCM
Message-ID: <CAFp+6iFLo2sRWC6=KhY4XObZjj4D+HOXv1L2fU2GRe1r6gom3A@mail.gmail.com>
Subject: Re: [PATCH 2/3] drm/exynos: dp: Remove support for unused dptx-phy
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Paul <seanpaul@google.com>, kishon <kishon@ti.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, "cpgs ." <cpgs@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Inki,


On Thu, Oct 30, 2014 at 5:50 PM, Inki Dae <inki.dae@samsung.com> wrote:
>
> Sorry for late. I missed this patch a little bit for long time.

Thanks for reviewing.

>
>
> On 2014년 09월 15일 22:13, Vivek Gautam wrote:
>> Now that we have moved to generic phy based bindings,
>> we don't need to have any code related to older dptx-phy.
>> Nobody is using this dptx-phy anymore, so removing the
>> same.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>> ---
>>  drivers/gpu/drm/exynos/exynos_dp_core.c |   58 +++++++------------------------
>>  drivers/gpu/drm/exynos/exynos_dp_core.h |    2 --
>>  2 files changed, 13 insertions(+), 47 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.c b/drivers/gpu/drm/exynos/exynos_dp_core.c
>> index 4f3c7eb..5ffc1b2 100644
>> --- a/drivers/gpu/drm/exynos/exynos_dp_core.c
>> +++ b/drivers/gpu/drm/exynos/exynos_dp_core.c
>> @@ -1050,28 +1050,14 @@ static int exynos_dp_create_connector(struct exynos_drm_display *display,
>>
>>  static void exynos_dp_phy_init(struct exynos_dp_device *dp)
>>  {
>> -     if (dp->phy) {
>> +     if (dp->phy)
>>               phy_power_on(dp->phy);
>> -     } else if (dp->phy_addr) {
>> -             u32 reg;
>> -
>> -             reg = __raw_readl(dp->phy_addr);
>> -             reg |= dp->enable_mask;
>> -             __raw_writel(reg, dp->phy_addr);
>> -     }
>>  }
>>
>>  static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
>>  {
>> -     if (dp->phy) {
>> +     if (dp->phy)
>>               phy_power_off(dp->phy);
>> -     } else if (dp->phy_addr) {
>> -             u32 reg;
>> -
>> -             reg = __raw_readl(dp->phy_addr);
>> -             reg &= ~(dp->enable_mask);
>> -             __raw_writel(reg, dp->phy_addr);
>> -     }
>>  }
>>
>>  static void exynos_dp_poweron(struct exynos_drm_display *display)
>> @@ -1210,39 +1196,21 @@ static struct video_info *exynos_dp_dt_parse_pdata(struct device *dev)
>>
>>  static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
>>  {
>> -     struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
>> -     u32 phy_base;
>>       int ret = 0;
>>
>> -     dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
>> -     if (!dp_phy_node) {
>> -             dp->phy = devm_phy_get(dp->dev, "dp");
>> -             return PTR_ERR_OR_ZERO(dp->phy);
>> -     }
>> -
>> -     if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
>> -             dev_err(dp->dev, "failed to get reg for dptx-phy\n");
>> -             ret = -EINVAL;
>> -             goto err;
>> -     }
>> -
>> -     if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
>> -                             &dp->enable_mask)) {
>> -             dev_err(dp->dev, "failed to get enable-mask for dptx-phy\n");
>> -             ret = -EINVAL;
>> -             goto err;
>> -     }
>> -
>> -     dp->phy_addr = ioremap(phy_base, SZ_4);
>> -     if (!dp->phy_addr) {
>> -             dev_err(dp->dev, "failed to ioremap dp-phy\n");
>> -             ret = -ENOMEM;
>> -             goto err;
>> +     dp->phy = devm_phy_get(dp->dev, "dp");
>> +     if (IS_ERR(dp->phy)) {
>> +             ret = PTR_ERR(dp->phy);
>> +             if (ret == -ENOSYS || ret == -ENODEV) {
>> +                     dp->phy = NULL;
>> +             } else if (ret == -EPROBE_DEFER) {
>> +                     return ret;
>> +             } else {
>
> WARNING: else is not generally useful after a break or return
> #146: FILE: drivers/gpu/drm/exynos/exynos_dp_core.c:1208:
> +                       return ret;
> +               } else {
>
> How about just returning ret like below?
>                 if (IS_ERR(dp->phy)) {
>                         dev_err(dp->dev, "no DP phy configured\n");
>                         return PTR_ERR(ret);
>                 }
>
> And then you can handle the error at probe function properly.

Right, point taken. Will post the reworked patch.

[snip]

-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
