Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaFQKuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 06:50:08 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:55178 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbaFQKuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 06:50:05 -0400
Message-ID: <53A01D54.10506@collabora.co.uk>
Date: Tue, 17 Jun 2014 12:49:56 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/10] regulator: Add driver for Maxim 77802 PMIC regulators
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk> <1402941758-11216-8-git-send-email-javier.martinez@collabora.co.uk> <20140616192500.GJ5099@sirena.org.uk>
In-Reply-To: <20140616192500.GJ5099@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

Thanks a lot for your feedback.

On 06/16/2014 09:25 PM, Mark Brown wrote:
> On Mon, Jun 16, 2014 at 08:02:35PM +0200, Javier Martinez Canillas wrote:
> 
>> --- a/drivers/mfd/max77802.c
>> +++ b/drivers/mfd/max77802.c
>> @@ -37,6 +37,7 @@
>>  #include <linux/err.h>
>>  
>>  static const struct mfd_cell max77802_devs[] = {
>> +	{ .name = "max77802-pmic", },
>>  };
>>  
>>  static bool max77802_pmic_is_accessible_reg(struct device *dev,
> 
> Please don't do things like this, it makes it harder to apply your
> series.  Just register all the devices in the MFD when you add the MFD
> driver.
> 

Ok, I'll do that. After all mfd core just omits the devices that don't match.

>> +	default:
>> +		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
>> +			rdev->desc->name, mode);
>> +		return -EINVAL;
> 
> dev_warn().
> 

Ok.

>> +static void max77802_copy_reg(struct device *dev, struct regmap *regmap,
>> +			      int from_reg, int to_reg)
>> +{
>> +	int val;
>> +	int ret;
>> +
>> +	if (from_reg == to_reg)
>> +		return;
>> +
>> +	ret = regmap_read(regmap, from_reg, &val);
>> +	if (!ret)
>> +		ret = regmap_write(regmap, to_reg, val);
>> +
>> +	if (ret)
>> +		dev_warn(dev, "Copy err %d => %d (%d)\n",
>> +			 from_reg, to_reg, ret);
>> +}
> 
> Again, this looks like it should be generic.
> 

Yes, I missed this from your previous feedback, sorry about that.

I'll add a regmap_copy_reg() function to drivers/base/regmap/regmap.c instead.

>> +static int max77802_pmic_probe(struct platform_device *pdev)
>> +{
> 
>> +	dev_dbg(&pdev->dev, "%s\n", __func__);
> 
> This isn't adding anything, just remove it - the core already logs
> probes if you want.
> 

Ok.

>> +	config.dev = &pdev->dev;
> 
> Are you sure this shouldn't be the MFD?
> 

I just looked at regulator_register() and saw that it does rdev->dev.parent =
dev, so yes this has to be the MFD.

>> +	for (i = 0; i < MAX77802_MAX_REGULATORS; i++) {
>> +		struct regulator_dev *rdev;
>> +		int id = pdata->regulators[i].id;
>> +
>> +		config.init_data = pdata->regulators[i].initdata;
>> +		config.of_node = pdata->regulators[i].of_node;
>> +
>> +		max77802->opmode[id] = MAX77802_OPMODE_NORMAL;
> 
> Why isn't this being read from the hardware, this may lead to a
> configuration change the first time we pay attention?
> 

The original Chrome OS driver [0] had a "regulator-op-mode" property similar to
"op_mode" in Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
to specify the operating mode using DT.

But I removed that since I didn't want to have a specific property for what
appears to be a generic need. I wanted to re-post something along the lines of
what was discussed in [1] and add operating mode support to the generic
regulator code.

So, for now I thought it made sense to set the operating mode to normal on
probe() but I'll change it to read from the hardware if that is better.

I guess I should check in the datasheet if a sane default operating mode for
LDOs is expected when the chip is reseted or if this is left undefined and also
if the bootloader already set this.

Best regards,
Javier

[0]:
https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.8/Documentation/devicetree/bindings/mfd/max77xxx.txt
[1]: https://patchwork.kernel.org/patch/1855331/
