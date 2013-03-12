Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab3CLUqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:46:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19009 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab3CLUq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:46:28 -0400
X-IronPort-AV: E=Sophos;i="4.84,833,1355126400"; 
   d="scan'208";a="28887806"
Message-ID: <513F9424.8020902@codeaurora.org>
Date: Tue, 12 Mar 2013 13:46:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 05/11] SSBI: Convert SSBI to device tree
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org> <1363113716-25897-1-git-send-email-davidb@codeaurora.org> <1363113716-25897-6-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1363113716-25897-6-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/13 11:41, David Brown wrote:
> @@ -261,56 +263,13 @@ int msm_ssbi_write(struct device *dev, u16 addr, u8 *buf, int len)
>  }
>  EXPORT_SYMBOL_GPL(msm_ssbi_write);
>  
> -static int msm_ssbi_add_slave(struct msm_ssbi *ssbi,
> -				const struct msm_ssbi_slave_info *slave)
> -{
> -	struct platform_device *slave_pdev;
> -	int ret;
> -
> -	if (ssbi->slave) {
> -		pr_err("slave already attached??\n");
> -		return -EBUSY;
> -	}
> -
> -	slave_pdev = platform_device_alloc(slave->name, -1);
> -	if (!slave_pdev) {
> -		pr_err("cannot allocate pdev for slave '%s'", slave->name);
> -		ret = -ENOMEM;
> -		goto err;
> -	}
> -
> -	slave_pdev->dev.parent = ssbi->dev;
> -	slave_pdev->dev.platform_data = slave->platform_data;
> -
> -	ret = platform_device_add(slave_pdev);
> -	if (ret) {
> -		pr_err("cannot add slave platform device for '%s'\n",
> -				slave->name);
> -		goto err;
> -	}
> -
> -	ssbi->slave = &slave_pdev->dev;
> -	return 0;
> -
> -err:
> -	if (slave_pdev)
> -		platform_device_put(slave_pdev);
> -	return ret;
> -}
> -
>  static int msm_ssbi_probe(struct platform_device *pdev)
>  {
> -	const struct msm_ssbi_platform_data *pdata = pdev->dev.platform_data;

Now that all this code is gone do we have a user of the
msm_ssbi_platform_data struct? Why not remove it from the header file?
If you remove it from the header you can probably move the enum for
controller_type into this file too.

> @@ -334,7 +293,25 @@ static int msm_ssbi_probe(struct platform_device *pdev)
>  	ssbi->dev = &pdev->dev;
>  	platform_set_drvdata(pdev, ssbi);
>  
> -	ssbi->controller_type = pdata->controller_type;
> +	type = of_get_property(np, "qcom,controller-type", NULL);
> +	if (type == NULL) {
> +		pr_err("Missing qcom,controller-type property\n");

This could be dev_err() considering you use dev_info() below.
> +		ret = -EINVAL;
> +		goto err_ssbi_controller;
> +	}
> +	dev_info(&pdev->dev, "SSBI controller type: '%s'\n", type);
> +	if (strcmp(type, "ssbi") == 0)
> +		ssbi->controller_type = MSM_SBI_CTRL_SSBI;
> +	else if (strcmp(type, "ssbi2") == 0)
> +		ssbi->controller_type = MSM_SBI_CTRL_SSBI2;
> +	else if (strcmp(type, "pmic-arbiter") == 0)
> +		ssbi->controller_type = MSM_SBI_CTRL_PMIC_ARBITER;
> +	else {
> +		pr_err("Unknown qcom,controller-type\n");

dev_err()?

> @@ -370,12 +347,18 @@ static int msm_ssbi_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static struct of_device_id ssbi_match_table[] = {

const?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

