Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaBLSCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:02:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50438 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753663AbaBLSCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:02:33 -0500
Date: Wed, 12 Feb 2014 18:02:23 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sbkim73@samsung.com" <sbkim73@samsung.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v2 2/3] regulator: Add support for S2MPA01 regulator
Message-ID: <20140212180223.GA23630@e106331-lin.cambridge.arm.com>
References: <1389266554-23463-1-git-send-email-sachin.kamat@linaro.org>
 <1389266554-23463-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389266554-23463-2-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 11:22:33AM +0000, Sachin Kamat wrote:
> Add support for S2MPA01 voltage and current regulator.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> * Addressed comments from Mark Brown
>  - Used module_platform_driver instead of subsys init call
> ---
>  drivers/regulator/Kconfig   |    7 +
>  drivers/regulator/Makefile  |    1 +
>  drivers/regulator/s2mpa01.c |  482 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 490 insertions(+)
>  create mode 100644 drivers/regulator/s2mpa01.c

[...]

> +static int s2mpa01_pmic_probe(struct platform_device *pdev)
> +{
> +       struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> +       struct sec_platform_data *pdata = dev_get_platdata(iodev->dev);
> +       struct of_regulator_match rdata[S2MPA01_REGULATOR_MAX];
> +       struct device_node *reg_np = NULL;
> +       struct regulator_config config = { };
> +       struct s2mpa01_info *s2mpa01;
> +       int i, ret;
> +
> +       s2mpa01 = devm_kzalloc(&pdev->dev, sizeof(*s2mpa01), GFP_KERNEL);
> +       if (!s2mpa01)
> +               return -ENOMEM;
> +
> +       for (i = 0; i < S2MPA01_REGULATOR_CNT; i++)
> +               rdata[i].name = regulators[i].name;
> +
> +       if (iodev->dev->of_node) {
> +               reg_np = of_find_node_by_name(iodev->dev->of_node,
> +                                                       "regulators");

This walks the allnodes list, and can thus walk outside of the parent
node.

Use of_get_child_by_name instead.

> +                       if (!reg_np) {
> +                               dev_err(&pdev->dev,
> +                                       "could not find regulators sub-node\n");
> +                               return -EINVAL;
> +                       }
> +
> +               of_regulator_match(&pdev->dev, reg_np, rdata,
> +                                               S2MPA01_REGULATOR_MAX);

Is a reference to reg_np held beyond this? Do you need an
of_node_put(reg_np)?

Thanks,
Mark.
