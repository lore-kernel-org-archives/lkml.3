Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbaLHLEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:04:48 -0500
Received: from lucky1.263xmail.com ([211.157.147.130]:36915 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbaLHLEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:04:45 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: kishon@ti.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <56160941769389787db61a3f130bfd3e>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <548585B4.107@rock-chips.com>
Date: Mon, 08 Dec 2014 19:04:20 +0800
From: Yunzhi Li <lyz@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, heiko@sntech.de,
        dianders@chromium.org, romain.perier@gmail.com
CC: olof@lixom.net, huangtao@rock-chips.com, zyw@rock-chips.com,
        cf@rock-chips.com, linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
References: <1418031988-2700-1-git-send-email-lyz@rock-chips.com> <1418031988-2700-2-git-send-email-lyz@rock-chips.com> <548575F0.4090909@ti.com>
In-Reply-To: <548575F0.4090909@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon :

On 2014/12/8 17:57, Kishon Vijay Abraham I wrote:
> Hi,
>
> On Monday 08 December 2014 03:16 PM, Yunzhi Li wrote:
>> This patche to add a generic PHY driver for ROCKCHIP usb PHYs,
> %s/patche/patch
Sorry for this typo.
>> +#include <linux/reset.h>
>> +#include <linux/regmap.h>
>> +#include <linux/mfd/syscon.h>
>> +
>> +#define ROCKCHIP_RK3288_UOC(n)	(0x320 + n * 0x14)
>> +
>> +#define SIDDQ_MSK		BIT(13 + 16)
> This doesn't look correct. Won't this mask bit no:29?
The higher 16-bit of this register is used for write-protect, only if 
BIT(13 + 16)
set to 1 the BIT(13) can be written. I will add some comments here in 
the next
version, to prevent others confused. ok ?

>> [...]
>>
>> +static int rockchip_usb_phy_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct rockchip_usb_phy *rk_phy;
>> +	struct rockchip_usb_phy *phy_array;
>> +	struct phy_provider *phy_provider;
>> +	struct regmap *grf;
>> +	char clk_name[16];
>> +	int i;
>> +
>> +	grf = syscon_regmap_lookup_by_phandle(dev->of_node, "rockchip,grf");
>> +	if (IS_ERR(grf)) {
>> +		dev_err(&pdev->dev, "Missing rockchip,grf property\n");
>> +		return PTR_ERR(grf);
>> +	}
>> +
>> +	phy_array = devm_kzalloc(dev, RK3288_NUM_PHYS * sizeof(*rk_phy),
>> +				 GFP_KERNEL);
>> +	if (!phy_array)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < RK3288_NUM_PHYS; i++) {
> Don't hardcode NUM_PHYS. All this has to come from dt. Model each PHYs as
> subnode of the phy provider node and use it here.
I got it, it should be like this, model each PHYs as sub node and use 
of_get_child_count() to get the number of phys.




