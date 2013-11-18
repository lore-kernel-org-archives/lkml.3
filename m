Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3KRS1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:27:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40349 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3KRS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:27:08 -0500
Message-ID: <528A5B95.3040808@ti.com>
Date: Mon, 18 Nov 2013 20:25:25 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: Re: [PATCH 02/12] mtd: nand: davinci: check required ti,davinci-chipselect
 property
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-3-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8CEF@DNCE04.ent.ti.com> <52824E2F.9090302@ti.com>
In-Reply-To: <52824E2F.9090302@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 05:50 PM, Santosh Shilimkar wrote:
> On Monday 11 November 2013 11:53 AM, Khoronzhuk, Ivan wrote:
>> The property "ti,davinci-chipselect" is required. So we have to check
>> if it is set.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> ---
>>   drivers/mtd/nand/davinci_nand.c |   10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
>> index d87213f..8e1c88e 100644
>> --- a/drivers/mtd/nand/davinci_nand.c
>> +++ b/drivers/mtd/nand/davinci_nand.c
>> @@ -541,10 +541,14 @@ static struct davinci_nand_pdata
>>                                  GFP_KERNEL);
>>                  pdev->dev.platform_data = pdata;
>>                  if (!pdata)
>> -                       return NULL;
>> +                       return ERR_PTR(-ENOMEM);
>> +
> This change don't follow commit message.
>

I'll move it to separate patch, that will be first patch

>>                  if (!of_property_read_u32(pdev->dev.of_node,
>>                          "ti,davinci-chipselect", &prop))
>>                          pdev->id = prop;
>> +               else
>> +                       return ERR_PTR(-EINVAL);
>> +
> So the check already exist but the error case wasn't handled.
> This should be reflected in change log.
>

The error will be handled at return by:
	pdata = nand_davinci_get_pdata(pdev);
  	if (IS_ERR(pdata))
		return PTR_ERR(pdata);

or did you mean I should add dev_err().

>>                  if (!of_property_read_u32(pdev->dev.of_node,
>>                          "ti,davinci-mask-ale", &prop))
>>                          pdata->mask_ale = prop;
>> @@ -598,6 +602,10 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
>>          nand_ecc_modes_t                ecc_mode;
>>
>>          pdata = nand_davinci_get_pdata(pdev);
>> +       if (IS_ERR(pdata)) {
>> +               return PTR_ERR(pdata);
>> +       }
>> +
> Again not related to commit log. You might want to split this patch
> then.
>

I'll move it in the same separate patch.

> Regards,
> Santosh
>


-- 
Regards,
Ivan Khoronzhuk
