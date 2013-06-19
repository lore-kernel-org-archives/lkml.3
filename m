Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120Ab3FSSs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:48:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47647 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964916Ab3FSSqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:46:45 -0400
Message-ID: <51C1FB91.1000006@ti.com>
Date: Wed, 19 Jun 2013 21:42:25 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 2/5] i2c: omap: add runtime check in isr to be sure that
 i2c is enabled
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com> <1370630768-4077-3-git-send-email-grygorii.strashko@ti.com> <20130607190206.GC15295@arwen.pp.htv.fi>
In-Reply-To: <20130607190206.GC15295@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,
On 06/07/2013 10:02 PM, Felipe Balbi wrote:
> Hi,
>
> On Fri, Jun 07, 2013 at 09:46:05PM +0300, Grygorii Strashko wrote:
>> Add runtime check at the beginning of omap_i2c_isr/omap_i2c_isr_thread
>> to be sure that i2c is enabled, before performing IRQ handling and accessing
>> I2C IP registers:
>> 	if (pm_runtime_suspended(dev->dev)) {
>> 		WARN_ONCE(true, "We should never be here!\n");
>> 		return IRQ_NONE;
>> 	}
>>
>> Produce warning in case if ISR called when i2c is disabled
>>
>> CC: Kevin Hilman <khilman@linaro.org>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   drivers/i2c/busses/i2c-omap.c |   10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
>> index 97844ff..2dac598 100644
>> --- a/drivers/i2c/busses/i2c-omap.c
>> +++ b/drivers/i2c/busses/i2c-omap.c
>> @@ -885,6 +885,11 @@ omap_i2c_isr(int irq, void *dev_id)
>>   	u16 stat;
>>   
>>   	spin_lock(&dev->lock);
>> +	if (pm_runtime_suspended(dev->dev)) {
>> +		WARN_ONCE(true, "We should never be here!\n");
>> +		return IRQ_NONE;
>> +	}
> returning IRQ_NONE is not what you want to do in this case. You want to
> setup a flag so that your runtime_resume() knows that there are pending
> events to be handled and you handle those in runtime_resume time.
I don't want to handle this IRQ - we should never be here.
Will be changed to  IRQ_HANDLED.
>
> But to be frank, I don't see how this can trigger since we're calling
> pm_runtime_get_sync() from omap_i2c_xfer() which means by the time
> pm_runtime_get_sync() returns, assuming no errors, i2c module should be
> fully resumed and ready to go. Perhaps you have found a bug somewhere
> else ?
May be it's better to revert this patch:
e3a36b207f76364c281aeecaf14c1b22a7247278
i2c: omap: remove unnecessary pm_runtime_suspended check

which doesn't cover case when transfer is *finished*.
Please, see https://patchwork.kernel.org/patch/2689211/ and
cover-latter.
>
> Also, your 'We should never be here' message isn't helpfull at all.
>
>> @@ -905,6 +910,11 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
>>   	u16 stat;
>>   	int err = 0, count = 0;
>>   
>> +	if (pm_runtime_suspended(dev->dev)) {
>> +		WARN_ONCE(true, "We should never be here!\n");
>> +		return IRQ_NONE;
>> +	}
> because of IRQF_ONESHOT I can't see how this would *ever* be a valid
> check.
>
Please, see https://patchwork.kernel.org/patch/2689211/ and
cover-latter.

Sorry, for delayed reply - I've had problems with my e-mail.

- grygorii
