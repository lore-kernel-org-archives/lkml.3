Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaF3NHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:07:14 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:48624 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952AbaF3NHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:07:12 -0400
Message-ID: <53B160CD.9090201@st.com>
Date: Mon, 30 Jun 2014 15:06:21 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>
Cc: <kernel@stlinux.com>
Subject: Re: [STLinux Kernel] [PATCH 4/5] phy: miphy365x: Represent each PHY
 channel as a subnode
References: <1404133317-25953-1-git-send-email-lee.jones@linaro.org> <1404133317-25953-5-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1404133317-25953-5-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-30_03:2014-06-30,2014-06-29,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

	No description, no sign-off?

On 06/30/2014 03:01 PM, Lee Jones wrote:
> ---
>   drivers/phy/phy-miphy365x.c | 104 ++++++++++++++++++++++++++++++++------------
>   1 file changed, 75 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/phy/phy-miphy365x.c b/drivers/phy/phy-miphy365x.c
> index 1109f42..2c4ea6e 100644
> --- a/drivers/phy/phy-miphy365x.c
> +++ b/drivers/phy/phy-miphy365x.c
> @@ -17,6 +17,7 @@
>   #include <linux/module.h>
>   #include <linux/of.h>
>   #include <linux/of_platform.h>
> +#include <linux/of_address.h>
>   #include <linux/clk.h>
>   #include <linux/phy/phy.h>
>   #include <linux/delay.h>
> @@ -144,6 +145,7 @@ struct miphy365x {
>   	void __iomem *pcie;
>   	u8 type;
>   	u8 port;
> +	bool enabled;
>   };
>
>   struct miphy365x_dev {
> @@ -468,7 +470,7 @@ static struct phy *miphy365x_xlate(struct device *dev,
>   	struct miphy365x_dev *state = dev_get_drvdata(dev);
>   	u8 port, type;
>
> -	if (args->count != 2) {
> +	if (args->args_count != 2) {
>   		dev_err(dev, "Invalid number of cells in 'phy' property\n");
>   		return ERR_PTR(-EINVAL);
>   	}
> @@ -484,6 +486,11 @@ static struct phy *miphy365x_xlate(struct device *dev,
>   	if (WARN_ON(port >= ARRAY_SIZE(ports)))
>   		return ERR_PTR(-EINVAL);
>
> +	if (!state->phys[port].enabled) {
> +		dev_warn(dev, "PHY port %d is disabled\n", port);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>   	if (type == MIPHY_TYPE_SATA)
>   		state->phys[port].base = state->phys[port].sata;
>   	else if (type == MIPHY_TYPE_PCIE)
> @@ -503,38 +510,75 @@ static struct phy_ops miphy365x_ops = {
>   	.owner		= THIS_MODULE,
>   };
>
> -static int miphy365x_get_base_addr(struct platform_device *pdev,
> -				    struct miphy365x_phy *phy, u8 port)
> +static int miphy365x_get_base_addr_one(struct platform_device *pdev,
> +				       struct miphy365x *phy,
> +				       struct device_node *child,
> +				       int index)
>   {
> -	struct resource *res;
> -	char type[6];
> +	void __iomem *base;
> +	const char *name;
> +	int ret;
>
> -	sprintf(type, "sata%d", port);
> +	base = of_iomap(child, index);
> +	if (!base) {
> +		dev_err(&pdev->dev, "Failed to map %s\n", child->full_name);
> +		return -EINVAL;
> +	}
>
> -	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, type);
> -	if (!res)
> -		return -ENODEV;
> +	ret = of_property_read_string_index(child, "reg-names", index, &name);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +			"%s: no reg-names property not found\n", child->name);
> +		return ret;
> +	}
>
> -	phy->sata = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> -	if (!phy->sata)
> -		return -ENOMEM;
> +	if (!strncmp(name, "sata", 4))
> +		phy->sata = base;
> +	else if (!strncmp(name, "pcie", 4))
> +		phy->pcie = base;
> +	else {
> +		dev_err(&pdev->dev, "reg-names in %s not sata or pcie: %s",
> +			child->name, name);
> +		return -EINVAL;
> +	}
>
> -	sprintf(type, "pcie%d", port);
> +	return 0;
> +}
>
> -	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, type);
> -	if (!res)
> -		return -ENODEV;
> +static int miphy365x_get_base_addr(struct platform_device *pdev,
> +				   struct miphy365x *phy,
> +				   struct device_node *child)
> +{
> +	int index;
> +	int ret;
>
> -	phy->pcie = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> -	if (!phy->pcie)
> -		return -ENOMEM;
> +	/* Each port handles SATA or PCIE. */
> +	for (index = 0; index < 2; index++) {
> +		ret = miphy365x_get_base_addr_one(pdev, phy,
> +						  child, index);
> +		if (ret)
> +			return ret;
> +	}
>
>   	return 0;
>   }
>
> -static int miphy365x_of_probe(struct device_node *np,
> +static int miphy365x_of_probe(struct platform_device *pdev,
>   			      struct miphy365x_dev *phy_dev)
>   {
> +	struct device_node *np = pdev->dev.of_node;
> +	struct device_node *child;
> +	int child_count = 0;
> +
> +	for_each_child_of_node(np, child)
> +		child_count++;
> +
> +	if (child_count != ARRAY_SIZE(ports)) {
> +		dev_err(&pdev->dev, "%d ports supported, %d supplied\n",
> +			ARRAY_SIZE(ports), child_count);
> +		return -EINVAL;
> +	}
> +
>   	phy_dev->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
>   	if (IS_ERR(phy_dev->regmap)) {
>   		dev_err(phy_dev->dev, "No syscfg phandle specified\n");
> @@ -556,11 +600,10 @@ static int miphy365x_of_probe(struct device_node *np,
>
>   static int miphy365x_probe(struct platform_device *pdev)
>   {
> -	struct device_node *np = pdev->dev.of_node;
> +	struct device_node *child, *np = pdev->dev.of_node;
>   	struct miphy365x_dev *phy_dev;
>   	struct device *dev = &pdev->dev;
>   	struct phy_provider *provider;
> -	u8 port;
>   	int ret;
>
>   	if (!np) {
> @@ -572,7 +615,7 @@ static int miphy365x_probe(struct platform_device *pdev)
>   	if (!phy_dev)
>   		return -ENOMEM;
>
> -	ret = miphy365x_of_probe(np, phy_dev);
> +	ret = miphy365x_of_probe(pdev, phy_dev);
>   	if (ret)
>   		return ret;
>
> @@ -582,8 +625,9 @@ static int miphy365x_probe(struct platform_device *pdev)
>
>   	mutex_init(&phy_dev->miphy_mutex);
>
> -	for (port = 0; port < ARRAY_SIZE(ports); port++) {
> +	for_each_child_of_node(np, child) {
>   		struct phy *phy;
> +		static int port = 0;
>
>   		phy = devm_phy_create(dev, &miphy365x_ops, NULL);
>   		if (IS_ERR(phy)) {
> @@ -591,15 +635,17 @@ static int miphy365x_probe(struct platform_device *pdev)
>   			return PTR_ERR(phy);
>   		}
>
> -		phy_dev->phys[port].phy  = phy;
> -		phy_dev->phys[port].port = port;
> -
> -		ret = miphy365x_get_base_addr(pdev,
> -					&phy_dev->phys[port], port);
> +		ret = miphy365x_get_base_addr(pdev, &phy_dev->phys[port],
> +					      child);
>   		if (ret)
>   			return ret;
>
> +		phy_dev->phys[port].phy  = phy;
> +		phy_dev->phys[port].port = port;
> +		phy_dev->phys[port].enabled = !!of_device_is_available(child);
> +
>   		phy_set_drvdata(phy, &phy_dev->phys[port]);
> +		port++;
>   	}
>
>   	provider = devm_of_phy_provider_register(dev, miphy365x_xlate);
>
