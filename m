Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3JMQcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 12:32:13 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:33408 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779Ab3JMQcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 12:32:12 -0400
Message-ID: <525ACB39.5000205@metafoo.de>
Date: Sun, 13 Oct 2013 18:32:57 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dma: pl330: Support per channel irq allocation
References: <08a752258a021feb91eba25eafd28ea2bacf72e4.1380523844.git.michal.simek@xilinx.com> <20131013153111.GN2954@intel.com>
In-Reply-To: <20131013153111.GN2954@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2013 05:31 PM, Vinod Koul wrote:
> On Mon, Sep 30, 2013 at 08:50:48AM +0200, Michal Simek wrote:
>> Some pl330 have per channel irq and it is necessary
>> to allocate all of them. Loop over irq assigned for this
>> device to support these pl330 IPs.
>>
>> For example this IP is available on Xilinx Zynq platform.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>> Hi Vinod,
>>
>> this is the patch I told you about it. I have tested it
>> just on Zynq(8 dma channels) but it shouldn't break
>> any other pl330 clones.
>> One more change has to be done to support all 8 dma channels
>> which is to extend AMBA_NR_IRQS which is still 2.
>> But I will send separate patch for it directly to Russell.
>
> Thanks, this patch looks fine, Lars can you try testing this if you have this HW
> please?
>
> ~Vinod

Michal and I are using the same hardware, I have his patch in my tree and it is 
working fine.

Tested-by: Lars-Peter Clausen <lars@metafoo.de>

>>
>> Thanks,
>> Michal
>>
>> ---
>>   drivers/dma/pl330.c | 17 ++++++++++++-----
>>   1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
>> index 58623dc..96de393 100644
>> --- a/drivers/dma/pl330.c
>> +++ b/drivers/dma/pl330.c
>> @@ -2922,11 +2922,18 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>>
>>   	amba_set_drvdata(adev, pdmac);
>>
>> -	irq = adev->irq[0];
>> -	ret = devm_request_irq(&adev->dev, irq, pl330_irq_handler, 0,
>> -			dev_name(&adev->dev), pi);
>> -	if (ret)
>> -		return ret;
>> +	for (i = 0; i <= AMBA_NR_IRQS; i++) {
>> +		irq = adev->irq[i];
>> +		if (irq) {
>> +			ret = devm_request_irq(&adev->dev, irq,
>> +					       pl330_irq_handler, 0,
>> +					       dev_name(&adev->dev), pi);
>> +			if (ret)
>> +				return ret;
>> +		} else {
>> +			break;
>> +		}
>> +	}
>>
>>   	pi->pcfg.periph_id = adev->periphid;
>>   	ret = pl330_add(pi);
>> --
>> 1.8.2.3
>>
>
>
>

