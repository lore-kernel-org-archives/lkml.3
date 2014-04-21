Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaDUPia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 11:38:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaDUPiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 11:38:25 -0400
Message-ID: <53553B69.9060706@redhat.com>
Date: Mon, 21 Apr 2014 17:38:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "kefeng.wang" <kefeng.wang@linaro.org>
CC: Kefeng Wang <wangkefeng.wang@huawei.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ahci: add support for Hisilicon sata
References: <1398052903-10322-1-git-send-email-kefeng.wang@linaro.org> <1398052903-10322-3-git-send-email-kefeng.wang@linaro.org> <53549AE7.8040301@linaro.org>
In-Reply-To: <53549AE7.8040301@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kefeng,

On 04/21/2014 06:13 AM, kefeng.wang wrote:
> Hi Hans,
> 
> A hflags argument is useless in ahci_platform_init_host for another driver's caller,
> use the pointer of ata_port_info in ahci_probe, is this OK?

Hmm, this can theoretically break when multiple platform ahci-s are present in a
single system. This likely will never happen, but I still think you should not
be changing a global struct which may be shared between multiple runs of the
probe method, that is just asking for trouble.

I know that other users of ahci_platform_init_host don't need a dynamic hflags
argument, but you can just remove the AHCI_HFLAGS(...) argument from their
ata_port_info - template and pass that in as the new arguments, this makes
ahci_platform_init_host more flexible which will hopefully also benefit us
in the future with other new ahci platform drivers.

Regards,

Hans


> 
> Regards,
> Kefeng
> 
> On 2014-4-21 12:01, Kefeng Wang wrote:
>> The hip04 SoC of hisilicon has an AHCI compliant SATA controller,
>> and it is compliant with the ahci 1.3 and sata 3.0 specification.
>>
>> There is a wrong bit in HOST_CAP of hip04 sata controller, which
>> enable unsupported feature of FBS, use AHCI_HFLAG_NO_FBS hflag to
>> disable it.
>>
>> Cc: Hans de Geode <hdegoede@redhat.com>
>> Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
>> ---
>>  .../devicetree/bindings/ata/ahci-platform.txt      |    3 ++-
>>  drivers/ata/ahci_platform.c                        |   10 ++++++++--
>>  2 files changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
>> index 48b285f..aab1d70 100644
>> --- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
>> +++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
>> @@ -7,7 +7,8 @@ Required properties:
>>  - compatible        : compatible list, one of "snps,spear-ahci",
>>                        "snps,exynos5440-ahci", "ibm,476gtr-ahci",
>>                        "allwinner,sun4i-a10-ahci", "fsl,imx53-ahci"
>> -                      "fsl,imx6q-ahci" or "snps,dwc-ahci"
>> +                      "fsl,imx6q-ahci", "snps,dwc-ahci" or
>> +                      "hisilicon,hisi-ahci"
>>  - interrupts        : <interrupt mapping for SATA IRQ>
>>  - reg               : <registers mapping>
>>  
>> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
>> index ef67e79..48b9feb 100644
>> --- a/drivers/ata/ahci_platform.c
>> +++ b/drivers/ata/ahci_platform.c
>> @@ -17,11 +17,12 @@
>>  #include <linux/pm.h>
>>  #include <linux/device.h>
>>  #include <linux/platform_device.h>
>> +#include <linux/of_device.h>
>>  #include <linux/libata.h>
>>  #include <linux/ahci_platform.h>
>>  #include "ahci.h"
>>  
>> -static const struct ata_port_info ahci_port_info = {
>> +static struct ata_port_info ahci_port_info = {
>>  	.flags		= AHCI_FLAG_COMMON,
>>  	.pio_mask	= ATA_PIO4,
>>  	.udma_mask	= ATA_UDMA6,
>> @@ -32,6 +33,7 @@ static int ahci_probe(struct platform_device *pdev)
>>  {
>>  	struct device *dev = &pdev->dev;
>>  	struct ahci_platform_data *pdata = dev_get_platdata(dev);
>> +	struct ata_port_info *pi = &ahci_port_info;
>>  	struct ahci_host_priv *hpriv;
>>  	int rc;
>>  
>> @@ -55,7 +57,10 @@ static int ahci_probe(struct platform_device *pdev)
>>  			goto disable_resources;
>>  	}
>>  
>> -	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info, 0, 0);
>> +	if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
>> +		pi->private_data = (void *)AHCI_HFLAG_NO_FBS;
>> +
>> +	rc = ahci_platform_init_host(pdev, hpriv, pi, 0, 0);
>>  	if (rc)
>>  		goto pdata_exit;
>>  
>> @@ -76,6 +81,7 @@ static const struct of_device_id ahci_of_match[] = {
>>  	{ .compatible = "snps,exynos5440-ahci", },
>>  	{ .compatible = "ibm,476gtr-ahci", },
>>  	{ .compatible = "snps,dwc-ahci", },
>> +	{ .compatible = "hisilicon,hisi-ahci", },
>>  	{},
>>  };
>>  MODULE_DEVICE_TABLE(of, ahci_of_match);
>>
> 
