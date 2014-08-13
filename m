Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaHMA1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 20:27:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50252 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaHMA1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 20:27:19 -0400
Message-ID: <53EAB0E6.2040204@codeaurora.org>
Date: Tue, 12 Aug 2014 17:27:18 -0700
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: grant.likely@linaro.org, Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] of: Deep-copy names of platform devices
References: <1407811356-24222-1-git-send-email-stepanm@codeaurora.org> <C248D37F-739E-477D-AF67-5C0187E5F8BF@codeaurora.org>
In-Reply-To: <C248D37F-739E-477D-AF67-5C0187E5F8BF@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/2014 9:12 AM, Kumar Gala wrote:
>
> On Aug 11, 2014, at 9:42 PM, Stepan Moskovchenko <stepanm@codeaurora.org> wrote:
>
>> When we parse the device tree and allocate platform
>> devices, the 'name' of the newly-created platform_device
>> is set to point to the 'name' field of the 'struct device'
>> embedded within the platform_device. This is dangerous,
>> because the name of the 'struct device' is dynamically
>> allocated. Drivers may call dev_set_name() on the device,
>> which will free and reallocate the name of the device,
>> leaving the 'name' of the platform_device pointing to the
>> now-freed memory.
>>
>> Furthermore, if the dev_set_name() call is made from a
>> driver's probe() function and a subsequent request results
>> in probe deferral, the dangling 'name' reference may lead
>> to the device being re-probed using the wrong driver.
>>
>> To mitigate these scenarios, we use kstrdup to perform a
>> deep copy of the device name when assigning the name of the
>> platform_device, so that the platform_device name is
>> unaffected by any calls to dev_set_name() that might made
>> by drivers to rename the embedded 'struct device'.
>>
>> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
>> ---
>> I suppose creating a 'pdev_set_name' API may seem like
>> another possibility, but I feel that dev.name and pdev.name
>> have two different meanings. One is used for device/driver
>> binding purposes, whereas the other serves a more general
>> identification purpose, and is used for things like sysfs.
>> Drivers might want to change dev.name while leaving the
>> pdev.name alone. I guess yet another possibility would be
>> to prohibit calling dev_set_name() on devices created from
>> device tree, but a driver does not necessarily know how a
>> given platform_device was allocated.
>>
>> drivers/of/device.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/of/device.c b/drivers/of/device.c
>> index f685e55..fe5f025 100644
>> --- a/drivers/of/device.c
>> +++ b/drivers/of/device.c
>> @@ -54,7 +54,7 @@ int of_device_add(struct platform_device *ofdev)
>>
>> 	/* name and id have to be set so that the platform bus doesn't get
>> 	 * confused on matching */
>> -	ofdev->name = dev_name(&ofdev->dev);
>> +	ofdev->name = kstrdup(dev_name(&ofdev->dev), GFP_KERNEL);
>> 	ofdev->id = -1;
>>
>> 	/* device_add will assume that this device is on the same node as
>
> Don’t we need to free this is of_device_unregister() now?
>
> - k
>

Argh. I was confused by the asymmetric naming of the APIs, but after 
digging through the callers outside from drivers/of/, it looks like 
things do eventually filter down to of_device_add() in all the cases I 
could find. So yes, this does need to be fixed. Expect v2 soon.

Thanks
Steve

-- 
  The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
  hosted by The Linux Foundation
