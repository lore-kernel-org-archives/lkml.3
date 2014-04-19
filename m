Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbaDSO3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 10:29:47 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42347 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaDSO3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 10:29:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAGTfZH0Qwpup_wiyLjFg0EjeiK7UjMDMR3TUhB+uT86+sZboSg@mail.gmail.com>
References: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
	<1397781160-744-2-git-send-email-sangjung.woo@samsung.com>
	<CAGTfZH3L-FZ4+cNHYMpuRqWSbcvEZoOYQdJzxOK8yLofFc5dVw@mail.gmail.com>
	<535246ED.4090701@samsung.com>
	<CAGTfZH0Qwpup_wiyLjFg0EjeiK7UjMDMR3TUhB+uT86+sZboSg@mail.gmail.com>
Date: Sat, 19 Apr 2014 23:29:43 +0900
Message-ID: <CAGTfZH1vuooC5QoQqyBuQPx7hL_Brn9C+J6bMLtFh8HbJ2+sUw@mail.gmail.com>
Subject: Re: [PATCHv3 1/8] extcon: Add resource-managed extcon register function
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Sangjung <sangjung.woo@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, again4you@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Apr 19, 2014 at 10:36 PM, Chanwoo Choi <cwchoi00@gmail.com> wrote:
> Hi,
>
> On Sat, Apr 19, 2014 at 6:50 PM, Sangjung <sangjung.woo@samsung.com> wrote:
>> Hi Chanwoo.
>>
>> Thanks for your comments. I also add my opinion too.
>>
>>
>>
>> On 04/19/2014 04:13 PM, Chanwoo Choi wrote:
>>>
>>> Hi Sangjung,
>>>
>>> On Fri, Apr 18, 2014 at 9:32 AM, Sangjung Woo <sangjung.woo@samsung.com>
>>> wrote:
>>>>
>>>> Add resource-managed extcon device register function for convenience.
>>>> For example, if a extcon device is attached with new
>>>> devm_extcon_dev_register(), that extcon device is automatically
>>>> unregistered on driver detach.
>>>>
>>>> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
>>>> ---
>>>>   drivers/extcon/extcon-class.c |   72
>>>> +++++++++++++++++++++++++++++++++++++++++
>>>>   include/linux/extcon.h        |   17 ++++++++++
>>>>   2 files changed, 89 insertions(+)
>>>>
>>>> diff --git a/drivers/extcon/extcon-class.c
>>>> b/drivers/extcon/extcon-class.c
>>>> index 7ab21aa..e177edb6 100644
>>>> --- a/drivers/extcon/extcon-class.c
>>>> +++ b/drivers/extcon/extcon-class.c
>>>> @@ -819,6 +819,78 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(extcon_dev_unregister);
>>>>
>>>> +
>>>> +/*
>>>> + * Device resource management
>>>> + */
>>>
>>> This comment is un-necessary because this patchset(v3) remove 'struct
>>> extcon_devres'.
>>>
>>>> +static void devm_extcon_dev_release(struct device *dev, void *res)
>>>> +{
>>>> +       struct extcon_dev *devres = res;
>>>> +
>>>> +       extcon_dev_unregister(devres);
>>>
>>> I prefer following function call withou defining separate 'devres'
>>> variable.
>>> But, this casting on the first argument is only for readability.
>>>    extcon_dev_unregister((strcut extcon_dev *)res);
>>>
>> OK. I'll fix it.
>>
>>
>>>> +}
>>>> +
>>>> +static int devm_extcon_dev_match(struct device *dev, void *res, void
>>>> *data)
>>>> +{
>>>> +       struct extcon_dev *devres = res;
>>>> +       struct extcon_dev *match = data;
>>>> +       return devres == match;
>>>
>>> To simplify code, I think you could change checking code as following:
>>>              return res == data;
>>
>> Right. Simple is better than others.
>>
>>
>>>> +}
>>>> +
>>>> +/**
>>>> + * devm_extcon_dev_register() - Resource-managed extcon_dev_register()
>>>> + * @dev:       device to allocate extcon device
>>>> + * @edev:      the new extcon device to register
>>>> + *
>>>> + * Managed extcon_dev_register() function. If extcon device is attached
>>>> with
>>>> + * this function, that extcon device is automatically unregistered on
>>>> driver
>>>> + * detach. Internally this function calls extcon_dev_register()
>>>> function.
>>>> + * To get more information, refer that function.
>>>> + *
>>>> + * If extcon device is registered with this function and the device
>>>> needs to be
>>>> + * unregistered separately, devm_extcon_dev_unregister() should be used.
>>>> + *
>>>> + * RETURNS:
>>>> + * 0 on success, negative error number on failure.
>>>> + */
>>>> +int devm_extcon_dev_register(struct device *dev, struct extcon_dev
>>>> *edev)
>>>> +{
>>>> +       struct extcon_dev *devres;
>>>
>>> The 'devres' in this function don't mean 'device resource structure'.
>>> So I think it is not proper name.
>>> I think you should use other general name (e.g.,  'ptr' or 'res'
>>> instead of 'devres')
>>>
>>>> +       int ret;
>>>> +
>>>> +       devres = devres_alloc(devm_extcon_dev_release, sizeof(*devres)
>>>
>>> Other subsytem used double pointer to get device resource from
>>> devres_alloc() instead of
>>> single pointer.(devres is single pointer)  I can't find subsystem
>>> using single pointer of devm function.
>>> First of all, We have to analyze the correct reason using only double
>>> pointer instead of single pointer whether single pointer use is good
>>> or not.
>>
>>
>> IMO, other subsystem should return the memory pointer that is allocated by
>> devres_alloc().
>> However, in our case, we need not do that since the pointer is used only in
>> extcon core.
>> You can refer the way that I did to gpio subsystem (devm_gpio_request() in
>> /drivers/gpio/devres.c).
>
> As you comment, I checked 'devm_gpio_request' in drivers/gpio/devres.c
> . There are a little difference between devm_extcon_dev_register and
> devm_gpio_request.
>
> The second argument (unsigned gpio) is not pointer type in
> devm_gpio_request() But, devm_extcon_dev_register() needs the pointer
> type for second argument(struct extcon_dev *edev).

This patch have to use double pointer for extcon device from devres_alloc().

Because in this following case:
struct extcon_dev *ptr;

ptr = devres_alloc(...)
...
ptr = edev;
-> edev would override the 'ptr' which is allocated memory from devres_alloc()
In result, this patch cannot access original allocated memory for 'ptr'.

Thanks,
Chanwoo Choi
