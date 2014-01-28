Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaA1Lv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 06:51:26 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18631 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaA1LvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 06:51:25 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-dc-52e799babb3d
Message-id: <52E799A9.8080502@samsung.com>
Date: Tue, 28 Jan 2014 12:51:05 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Manish Badarkhe <badarkhe.manish@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org
Subject: Re: [PATCH V3] max8925_power: Use "IS_ENABLED(CONFIG_OF)" for DT code.
References: <1390847829-8379-1-git-send-email-badarkhe.manish@gmail.com>
In-reply-to: <1390847829-8379-1-git-send-email-badarkhe.manish@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xK7q7Zj4PMlg9iddi3sS37BaTnrxn
	tpi4cjKzxeVdc9gsZpzfx+TA6rFz1l12j80rtDw+b5ILYI7isklJzcksSy3St0vgyli04Dt7
	wVn+in//WRsYn/J0MXJySAiYSPS09TJD2GISF+6tZ+ti5OIQEljKKHHmcCeU85lR4tTqLywg
	VbwCWhJPl+wG62ARUJX4/+McK4jNJqAm8bnhERuILSoQIfF33npGiHpBiR+T74H1iggUSSzb
	8wQsziygKzHv20qwuLCAv8Sua3OAZnIALfOQWPqnFCTMKeAp8WbnHmaIcmuJlZO2QbXKS2xe
	85Z5AqPALCQbZiEpm4WkbAEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkMD9soNx8TGr
	Q4wCHIxKPLwdnc+ChFgTy4orcw8xSnAwK4nwrp72PEiINyWxsiq1KD++qDQntfgQIxMHp1QD
	o0iVrMO3G7N+rvC/s7tV7OqG9SKGxifE8nR0ynZL52tv/t517tXfi9bS06cmRoQf22lt+EZ0
	xju9TuU3H00XPXrBMWGOjSnrymCZXJF7vDbmN41Cndt7X1rfXXqMb0+f0jZtockOa1VOXf7z
	5vhNnheqgixn7+08sH7mbEm1P4defkgMcjjiXq3EUpyRaKjFXFScCABLuCahOgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27.01.2014 19:37, Manish Badarkhe wrote:
> Instead of "#ifdef CONFIG_OF" use "IS_ENABLED(CONFIG_OF)"
> option for DT code to avoid if-deffery in code.
>
> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> ---
> :100644 100644 b4513f2... 3e54476... M	drivers/power/max8925_power.c
>   drivers/power/max8925_power.c |   17 +++++------------
>   1 file changed, 5 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
> index b4513f2..3e54476 100644
> --- a/drivers/power/max8925_power.c
> +++ b/drivers/power/max8925_power.c
> @@ -427,7 +427,6 @@ static int max8925_deinit_charger(struct max8925_power_info *info)
>   	return 0;
>   }
>
> -#ifdef CONFIG_OF
>   static struct max8925_power_pdata *
>   max8925_power_dt_init(struct platform_device *pdev)
>   {
> @@ -440,9 +439,6 @@ max8925_power_dt_init(struct platform_device *pdev)
>   	int no_insert_detect;
>   	struct max8925_power_pdata *pdata;
>
> -	if (!nproot)
> -		return pdev->dev.platform_data;
> -
>   	np = of_find_node_by_name(nproot, "charger");
>   	if (!np) {
>   		dev_err(&pdev->dev, "failed to find charger node\n");
> @@ -468,13 +464,6 @@ max8925_power_dt_init(struct platform_device *pdev)
>
>   	return pdata;
>   }
> -#else
> -static struct max8925_power_pdata *
> -max8925_power_dt_init(struct platform_device *pdev)
> -{
> -	return pdev->dev.platform_data;
> -}
> -#endif
>
>   static int max8925_power_probe(struct platform_device *pdev)
>   {
> @@ -483,7 +472,11 @@ static int max8925_power_probe(struct platform_device *pdev)
>   	struct max8925_power_info *info;
>   	int ret;
>
> -	pdata = max8925_power_dt_init(pdev);
> +	pdata = dev_get_platdata(&pdev->dev);
> +
> +	if (!pdata && chip->dev->of_node)

Shouldn't IS_ENABLED(CONFIG_OF) also be checked here to let the compiler 
throw max8925_power_dt_init() away if the condition always evaluates to 
false?

Best regards,
Tomasz
