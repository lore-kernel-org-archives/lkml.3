Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3GXNSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:18:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43699 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab3GXNSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:18:43 -0400
Message-ID: <51EFD3D5.2070506@ti.com>
Date: Wed, 24 Jul 2013 16:17:09 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Kevin Hilman <khilman@linaro.org>,
        Graeme Gregory <gg@slimlogic.co.uk>, <linux-omap@vger.kernel.org>,
        Ruslan Bilovol <ruslan.bilovol@ti.com>, <linux-kernel@vger.kernel.org>,
        Naga Venkata Srikanth V <vnv.srikanth@samsung.com>,
        Oleg_Kosheliev <oleg.kosheliev@ti.com>
Subject: Re: [PATCH 1/4] mfd: twl6030-irq: migrate to IRQ threaded handler
References: <1374595624-15054-1-git-send-email-grygorii.strashko@ti.com> <1374595624-15054-2-git-send-email-grygorii.strashko@ti.com> <20130724104945.GH26801@laptop> <51EFC072.9070702@ti.com> <20130724125011.GM26801@laptop>
In-Reply-To: <20130724125011.GM26801@laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 03:50 PM, Lee Jones wrote:
>>>> +	if (ret) {
>>>> +		pr_warn("%s: I2C error %d reading PIH ISR\n", __func__, ret);
>>>
>>> Does the user really care which function we're returning from.
>>>
>>> Would it be better if you replace '__func__' with the device name?
>>
>> This module hasn't been converted to the device yet:(
>> (I mean "interrupt-controller").
>> But I'm thinking about it as the next step :) and then It will be
>> absolutely reasonable change to replace pr_*() with dev_*() and
>> remove __func__.
>
> I don't mean anything as compicated as that for 'this' patch. (NB: See my
> comment in subsequent patches about creating a 'struct twl6030' where
> you could store 'struct dev'.) In this patch I mean litterally
> replacing "%s: ", with "tw16030_irq: ". Simples. :)

Ok. I understand it now - will redo.


>
>> Now, the pointer on "dev" (in our case "twl-core" device) isn't passed
>> in IRQ handler, so It can't be used here.
>>
>> Of course it can be done, but would it make code better?
>> My opinion - no.
>
>>>> +	if (sts.bytes[2] & 0x10)
>>>> +		sts.bytes[2] |= 0x08;
>>>>
>>>> -		for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++) {
>>>> -			local_irq_disable();
>>>> -			if (sts.int_sts & 0x1) {
>>>> -				int module_irq = twl6030_irq_base +
>>>> +	for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++)
>>>> +		if (sts.int_sts & 0x1) {
>>>
>>> I'm a little confused by this. Where does sts.int_sts come from?
>>
>> See my comment above, pls
>
> Okay, that's my fault for not understanding unions properly as I've
> never had to use one, but now I do, thanks.
>
>>>> @@ -437,10 +386,13 @@ int twl6030_exit_irq(void)
>>>>   {
>>>>   	unregister_pm_notifier(&twl6030_irq_pm_notifier_block);
>>>>
>>>> -	if (twl6030_irq_base) {
>>>> +	if (!twl6030_irq_base) {
>>>>   		pr_err("twl6030: can't yet clean up IRQs?\n");
>>>>   		return -ENOSYS;
>>>>   	}
>>>> +
>>>> +	free_irq(twl_irq, NULL);
>>>> +
>>>
>>> If request_threaded_irq() fails, isn't there a chance that
>>> twl6030_irq_base will be allocated, but twl_irq will still be
>>> undefined?
>>
>> Yes. A mess is here (historically:), thanks. Will use twl_irq
>> instead of twl6030_irq_base (I did it, actually, in patch [3]:).
>
> Yes, I saw it. It would be better if you still fixed up this patch to
> be correct though. Even if you break it out and add it as [PATCH 1/x].
>
ok

