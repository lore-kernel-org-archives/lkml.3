Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab3LWTGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 14:06:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38744 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3LWTGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 14:06:44 -0500
Message-ID: <52B88990.5020807@ti.com>
Date: Mon, 23 Dec 2013 13:05:52 -0600
From: "Anna, Suman" <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Florian Vaussard <florian.vaussard@epfl.ch>,
        Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/7] iommu/omap: Allow enable/disable even without pdata
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-5-git-send-email-florian.vaussard@epfl.ch>
In-Reply-To: <1387284818-28739-5-git-send-email-florian.vaussard@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On 12/17/2013 06:53 AM, Florian Vaussard wrote:
> When booting with a devietree, no platform data is provided. Do not prematurely
> exit iommu_enable() and iommu_disable() in such a case.

Platform data may still be needed if we were to go with the pdata quirks 
approach for handling resets. You may need to revise the patch 
description then, but the change itself may be ok if supporting only DT 
devices.

regards
Suman

>
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>   drivers/iommu/omap-iommu.c | 10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index 51efcc4..0a9854d 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c
> @@ -149,13 +149,10 @@ static int iommu_enable(struct omap_iommu *obj)
>   	struct platform_device *pdev = to_platform_device(obj->dev);
>   	struct iommu_platform_data *pdata = pdev->dev.platform_data;
>
> -	if (!pdata)
> -		return -EINVAL;
> -
>   	if (!arch_iommu)
>   		return -ENODEV;
>
> -	if (pdata->deassert_reset) {
> +	if (pdata && pdata->deassert_reset) {
>   		err = pdata->deassert_reset(pdev, pdata->reset_name);
>   		if (err) {
>   			dev_err(obj->dev, "deassert_reset failed: %d\n", err);
> @@ -175,14 +172,11 @@ static void iommu_disable(struct omap_iommu *obj)
>   	struct platform_device *pdev = to_platform_device(obj->dev);
>   	struct iommu_platform_data *pdata = pdev->dev.platform_data;
>
> -	if (!pdata)
> -		return;
> -
>   	arch_iommu->disable(obj);
>
>   	pm_runtime_put_sync(obj->dev);
>
> -	if (pdata->assert_reset)
> +	if (pdata && pdata->assert_reset)
>   		pdata->assert_reset(pdev, pdata->reset_name);
>   }
>
>

