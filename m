Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaCNN2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:28:43 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36976 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaCNN2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:28:41 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-70-53230407b96f
Message-id: <53230404.6070601@samsung.com>
Date: Fri, 14 Mar 2014 14:28:36 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
In-reply-to: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e/4ZV12FuVggyszWSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7Bb/eg8yWkxZdJjV4vCb
	dlaLk396GS1m3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGcdmkpOZklqUW6dslcGX0HjnNXnCFu+LhjjnsDYyrOLsYOTkkBEwkFp0/ywhh
	i0lcuLeerYuRi0NIYCmjxPkDs6Gcz4wSh7efYwKp4hXQkpjR2MkCYrMIqEosu/sRzGYTUJP4
	3PCIDcTmB6pZ03QdLC4qECExd+JmNoheQYkfk++xgAwVEVjHJHHsyE4wh1ngN5PEs3ePmUGq
	hAUCJF6cbADrFhJwlLg4cSI7iM0p4CTR/HUtmM0sYC2xctI2RghbXmLzmrfMExgFZyFZMgtJ
	2SwkZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihMTd1x2MS49ZHWIU4GBU4uGdcVQx
	WIg1say4MvcQowQHs5II78nHSsFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGDsfM/uevlqg1Hlj
	gq7m8U9T+N+fk0nfPutM5S+JHROn3mqoKA1d/fgvj1h9Zqz3DqYtMy9PO/Y62c7chLHn4wnT
	BJ4wxqlJinkLRS4v/ltc5TJfudjlXPs9sdomFenKKqO/jtels7cUsok9dSnun3bN0+P7loA6
	5XWxPyqWeJ3y716+ISO1WYmlOCPRUIu5qDgRAJGqBzOZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On 14.03.2014 06:05, Cho KyongHo wrote:
> This patch uses managed device helper functions in the probe().
>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>   drivers/iommu/exynos-iommu.c |   64 +++++++++++++++++-------------------------
>   1 file changed, 26 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 36e6b73..33b424d 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -499,51 +499,48 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
>
>   static int exynos_sysmmu_probe(struct platform_device *pdev)
>   {
> -	int ret;
> +	int irq, ret;
>   	struct device *dev = &pdev->dev;
>   	struct sysmmu_drvdata *data;
>   	struct resource *res;
>
> -	data = kzalloc(sizeof(*data), GFP_KERNEL);
> -	if (!data) {
> -		dev_dbg(dev, "Not enough memory\n");
> -		ret = -ENOMEM;
> -		goto err_alloc;
> -	}
> +	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
>
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   	if (!res) {
> -		dev_dbg(dev, "Unable to find IOMEM region\n");
> -		ret = -ENOENT;
> -		goto err_init;
> +		dev_err(dev, "Unable to find IOMEM region\n");
> +		return -ENOENT;
>   	}

No need to check for error and print message, because 
devm_ioremap_resource() already checks the passed resource and handles 
error cases.

Best regards,
Tomasz
