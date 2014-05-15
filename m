Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaEOJpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:45:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38978 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbaEOJpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:45:14 -0400
Message-ID: <53748C6F.4090801@ti.com>
Date: Thu, 15 May 2014 15:14:15 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, <stern@rowland.harvard.edu>,
        <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Boris Brezillon <boris@free-electrons.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <kevin.z.m.zh@gmail.com>, <sunny@allwinnertech.com>,
        <shuge@allwinnertech.com>, <zhuzhenhua@allwinnertech.com>,
        <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH RESEND v4 3/8] phy: sunxi: Rework phy initialization
References: <1399995862-17788-1-git-send-email-maxime.ripard@free-electrons.com> <1399995862-17788-4-git-send-email-maxime.ripard@free-electrons.com> <537303C3.8040503@ti.com>
In-Reply-To: <537303C3.8040503@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday 14 May 2014 11:18 AM, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Tuesday 13 May 2014 09:14 PM, Maxime Ripard wrote:
>> Move the phy initialization and variables declaration to the loop itself, since
>> it is where it really belongs. Also remove all the temporary variables, we can
>> use the structure members directly.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> 
> let me know if I have to queue this and the next patch in my PHY tree.

queued this and the next patch in my tree.

Cheers
Kishon

> 
> Cheers
> Kishon
> 
>> ---
>>  drivers/phy/phy-sun4i-usb.c | 42 ++++++++++++++++++------------------------
>>  1 file changed, 18 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
>> index e6e6c4ba7145..66a87d50512b 100644
>> --- a/drivers/phy/phy-sun4i-usb.c
>> +++ b/drivers/phy/phy-sun4i-usb.c
>> @@ -224,13 +224,8 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
>>  	struct sun4i_usb_phy_data *data;
>>  	struct device *dev = &pdev->dev;
>>  	struct device_node *np = dev->of_node;
>> -	void __iomem *pmu = NULL;
>>  	struct phy_provider *phy_provider;
>> -	struct reset_control *reset;
>> -	struct regulator *vbus;
>>  	struct resource *res;
>> -	struct phy *phy;
>> -	char name[16];
>>  	int i;
>>  
>>  	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
>> @@ -262,42 +257,41 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
>>  
>>  	/* Skip 0, 0 is the phy for otg which is not yet supported. */
>>  	for (i = 1; i < data->num_phys; i++) {
>> +		struct sun4i_usb_phy *phy = data->phys + i;
>> +		char name[16];
>> +
>>  		snprintf(name, sizeof(name), "usb%d_vbus", i);
>> -		vbus = devm_regulator_get_optional(dev, name);
>> -		if (IS_ERR(vbus)) {
>> -			if (PTR_ERR(vbus) == -EPROBE_DEFER)
>> +		phy->vbus = devm_regulator_get_optional(dev, name);
>> +		if (IS_ERR(phy->vbus)) {
>> +			if (PTR_ERR(phy->vbus) == -EPROBE_DEFER)
>>  				return -EPROBE_DEFER;
>> -			vbus = NULL;
>> +			phy->vbus = NULL;
>>  		}
>>  
>>  		snprintf(name, sizeof(name), "usb%d_reset", i);
>> -		reset = devm_reset_control_get(dev, name);
>> -		if (IS_ERR(reset)) {
>> +		phy->reset = devm_reset_control_get(dev, name);
>> +		if (IS_ERR(phy->reset)) {
>>  			dev_err(dev, "failed to get reset %s\n", name);
>> -			return PTR_ERR(reset);
>> +			return PTR_ERR(phy->reset);
>>  		}
>>  
>>  		if (i) { /* No pmu for usbc0 */
>>  			snprintf(name, sizeof(name), "pmu%d", i);
>>  			res = platform_get_resource_byname(pdev,
>>  							IORESOURCE_MEM, name);
>> -			pmu = devm_ioremap_resource(dev, res);
>> -			if (IS_ERR(pmu))
>> -				return PTR_ERR(pmu);
>> +			phy->pmu = devm_ioremap_resource(dev, res);
>> +			if (IS_ERR(phy->pmu))
>> +				return PTR_ERR(phy->pmu);
>>  		}
>>  
>> -		phy = devm_phy_create(dev, &sun4i_usb_phy_ops, NULL);
>> -		if (IS_ERR(phy)) {
>> +		phy->phy = devm_phy_create(dev, &sun4i_usb_phy_ops, NULL);
>> +		if (IS_ERR(phy->phy)) {
>>  			dev_err(dev, "failed to create PHY %d\n", i);
>> -			return PTR_ERR(phy);
>> +			return PTR_ERR(phy->phy);
>>  		}
>>  
>> -		data->phys[i].phy = phy;
>> -		data->phys[i].pmu = pmu;
>> -		data->phys[i].vbus = vbus;
>> -		data->phys[i].reset = reset;
>> -		data->phys[i].index = i;
>> -		phy_set_drvdata(phy, &data->phys[i]);
>> +		phy->index = i;
>> +		phy_set_drvdata(phy->phy, &data->phys[i]);
>>  	}
>>  
>>  	dev_set_drvdata(dev, data);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
