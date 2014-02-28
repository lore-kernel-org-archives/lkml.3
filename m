Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaB1Fxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 00:53:49 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51414 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaB1Fxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 00:53:47 -0500
Message-ID: <53102465.4030600@ti.com>
Date: Fri, 28 Feb 2014 11:23:41 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "msmucr@gmail.com" <msmucr@gmail.com>
Subject: Re: [PATCH 1/2] dma: cppi41: start tear down only if channel is busy
References: <1393478081-14226-1-git-send-email-george.cherian@ti.com>	 <1393478081-14226-2-git-send-email-george.cherian@ti.com> <1393490862.28803.40.camel@smile.fi.intel.com>
In-Reply-To: <1393490862.28803.40.camel@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/2014 2:17 PM, Shevchenko, Andriy wrote:
> On Thu, 2014-02-27 at 10:44 +0530, George Cherian wrote:
>> Start the channel tear down only if the channel is busy, else just
>> bail out. In some cases its seen that by the time the tear down is
>> initiated the cppi completes the DMA, especially in ISOCH transfers.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   drivers/dma/cppi41.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
>> index c18aebf..d028f36 100644
>> --- a/drivers/dma/cppi41.c
>> +++ b/drivers/dma/cppi41.c
>> @@ -620,12 +620,15 @@ static int cppi41_stop_chan(struct dma_chan *chan)
>>   	u32 desc_phys;
>>   	int ret;
>>   
>> +	desc_phys = lower_32_bits(c->desc_phys);
>> +	desc_num = (desc_phys - cdd->descs_phys) / sizeof(struct cppi41_desc);
>> +	if (!cdd->chan_busy[desc_num])
>> +		return 0;
>> +
>>   	ret = cppi41_tear_down_chan(c);
>>   	if (ret)
>>   		return ret;
>>   
>> -	desc_phys = lower_32_bits(c->desc_phys);
>> -	desc_num = (desc_phys - cdd->descs_phys) / sizeof(struct cppi41_desc);
>>   	WARN_ON(!cdd->chan_busy[desc_num]);
> Do you still need this WARN_ON?

Yes in some cases wherein the channel is busy and tear down didn't 
happen successfully.
>
>>   	cdd->chan_busy[desc_num] = NULL;
>>   
>


-- 
-George

