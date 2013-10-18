Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3JRHbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 03:31:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56618 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3JRHbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 03:31:10 -0400
Message-ID: <5260E3B5.2010900@ti.com>
Date: Fri, 18 Oct 2013 10:31:01 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: <tj@kernel.org>, <sergei.shtylyov@cogentembedded.com>, <kishon@ti.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Balaji T K <balajitk@ti.com>
Subject: Re: [PATCH v2 1/2] ata: ahci_platform: Manage SATA PHY
References: <1381923773-10596-1-git-send-email-rogerq@ti.com> <1381923773-10596-2-git-send-email-rogerq@ti.com> <1896416.QtZRH9T0D7@amdc1032>
In-Reply-To: <1896416.QtZRH9T0D7@amdc1032>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 04:57 PM, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Wednesday, October 16, 2013 02:42:52 PM Roger Quadros wrote:
>> From: Balaji T K <balajitk@ti.com>
>>
>> Some platforms have a PHY hooked up to the
>> SATA controller. The PHY needs to be initialized
>> and powered up for SATA to work. We do that
>> using the PHY framework.
>>
>> [Roger Q] Cleaned up.
>>
>> CC: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Balaji T K <balajitk@ti.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  .../devicetree/bindings/ata/ahci-platform.txt      |    3 +-
>>  drivers/ata/ahci.h                                 |    2 ++
>>  drivers/ata/ahci_platform.c                        |   29 +++++++++++++++++++-
>>  3 files changed, 32 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
>> index 89de156..c8a6cea 100644
>> --- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
>> +++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
>> @@ -4,7 +4,8 @@ SATA nodes are defined to describe on-chip Serial ATA controllers.
>>  Each SATA controller should have its own node.
>>  
>>  Required properties:
>> -- compatible        : compatible list, contains "snps,spear-ahci"
>> +- compatible        : compatible list, contains "snps,spear-ahci",
>> +			snps,exynos5440-ahci or "snps,dwc-ahci"
> 
> minor nit:
> s/snps,exynos5440-ahci/"snps,exynos5440-ahci"/

OK.
> 
>>  - interrupts        : <interrupt mapping for SATA IRQ>
>>  - reg               : <registers mapping>
>>  
>> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
>> index 1145637..94484cb 100644
>> --- a/drivers/ata/ahci.h
>> +++ b/drivers/ata/ahci.h
>> @@ -37,6 +37,7 @@
>>  
>>  #include <linux/clk.h>
>>  #include <linux/libata.h>
>> +#include <linux/phy/phy.h>
>>  
>>  /* Enclosure Management Control */
>>  #define EM_CTRL_MSG_TYPE              0x000f0000
>> @@ -322,6 +323,7 @@ struct ahci_host_priv {
>>  	u32			em_buf_sz;	/* EM buffer size in byte */
>>  	u32			em_msg_type;	/* EM message type */
>>  	struct clk		*clk;		/* Only for platforms supporting clk */
>> +	struct phy		*phy;		/* If platforms use phy */
> 
> minor nit:
> s/If platforms use phy/If platform uses PHY/

Right.

> 
>>  	void			*plat_data;	/* Other platform data */
>>  };
>>  
>> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
>> index 2daaee0..5a0f1418 100644
>> --- a/drivers/ata/ahci_platform.c
>> +++ b/drivers/ata/ahci_platform.c
>> @@ -141,6 +141,21 @@ static int ahci_probe(struct platform_device *pdev)
>>  		}
>>  	}
>>  
>> +	hpriv->phy = devm_phy_get(dev, "sata-phy");
>> +	if (IS_ERR(hpriv->phy)) {
>> +		dev_dbg(dev, "can't get sata-phy\n");
>> +		/* return only if -EPROBE_DEFER */
>> +		if (PTR_ERR(hpriv->phy) == -EPROBE_DEFER) {
>> +			rc = -EPROBE_DEFER;
>> +			goto disable_unprepare_clk;
>> +		}
>> +	}
>> +
>> +	if (!IS_ERR(hpriv->phy)) {
>> +		phy_init(hpriv->phy);
>> +		phy_power_on(hpriv->phy);
>> +	}
>> +
>>  	/*
>>  	 * Some platforms might need to prepare for mmio region access,
>>  	 * which could be done in the following init call. So, the mmio
>> @@ -150,7 +165,7 @@ static int ahci_probe(struct platform_device *pdev)
>>  	if (pdata && pdata->init) {
>>  		rc = pdata->init(dev, hpriv->mmio);
>>  		if (rc)
>> -			goto disable_unprepare_clk;
>> +			goto disable_phy;
>>  	}
>>  
>>  	ahci_save_initial_config(dev, hpriv,
>> @@ -220,6 +235,12 @@ static int ahci_probe(struct platform_device *pdev)
>>  pdata_exit:
>>  	if (pdata && pdata->exit)
>>  		pdata->exit(dev);
>> +disable_phy:
>> +	if (!IS_ERR(hpriv->phy)) {
>> +		phy_power_off(hpriv->phy);
>> +		phy_exit(hpriv->phy);
>> +	}
>> +
>>  disable_unprepare_clk:
>>  	if (!IS_ERR(hpriv->clk))
>>  		clk_disable_unprepare(hpriv->clk);
>> @@ -238,6 +259,11 @@ static void ahci_host_stop(struct ata_host *host)
>>  	if (pdata && pdata->exit)
>>  		pdata->exit(dev);
>>  
>> +	if (!IS_ERR(hpriv->phy)) {
>> +		phy_power_off(hpriv->phy);
>> +		phy_exit(hpriv->phy);
>> +	}
>> +
>>  	if (!IS_ERR(hpriv->clk)) {
>>  		clk_disable_unprepare(hpriv->clk);
>>  		clk_put(hpriv->clk);
>> @@ -328,6 +354,7 @@ static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, ahci_resume);
> 
> Shouldn't phy_power_off/on also be used in ahci_suspend() and ahci_resume()?

I think so. Maybe even phy_exit and phy_init?

> 
>>  static const struct of_device_id ahci_of_match[] = {
>>  	{ .compatible = "snps,spear-ahci", },
>>  	{ .compatible = "snps,exynos5440-ahci", },
>> +	{ .compatible = "snps,dwc-ahci", },
> 
> This change together with ahci-platform.txt one should be in a separate patch.

Agreed.

> 
>>  	{},
>>  };
>>  MODULE_DEVICE_TABLE(of, ahci_of_match);

cheers,
-roger
