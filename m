Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3H1Rt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:49:27 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17744 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3H1RtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:49:25 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f0a6d000007b1b-44-521e38229718
Message-id: <521E381F.802@samsung.com>
Date: Wed, 28 Aug 2013 20:49:19 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: gregkh@linuxfoundation.org, dmitry.kasatkin@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] dev-core: fix build break when DEBUG is enabled
References: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
 <20130828174328.GG26483@xanatos>
In-reply-to: <20130828174328.GG26483@xanatos>
Content-transfer-encoding: 8bit
X-Originating-IP: [106.210.244.194]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xa7pKFnJBBs1nTSy+LK2zaF68ns3i
	8q45bBbNJ04xO7B47Jx1l91j3slAj/1z17B7fN4kF8ASxWWTkpqTWZZapG+XwJWxresec8F5
	xYpV2woaGFdKdzFyckgImEhc+f2GEcIWk7hwbz1bFyMXh5DAUkaJ6y/Ws4IkeAUEJX5MvscC
	YjMLqEtMmreIGaKokUli1tUXUM58RokN984zQXSoSbR9nA00loODRUBV4sceOZAwm4CexIbm
	H+wgtqhAhMTKJQ/AFogI6EtMnNrDBrEgUmLJxf9gcWEBL4nT66ZDXdTIKHF220uwIk4BXYl1
	Te8YIRrkJQ5eeQ52nRDQru61a9kg3lGWuPxyO8sERuFZSJ6YheSJWUjaFzAyr2IUTS1NLihO
	Ss811CtOzC0uzUvXS87P3cQIiYEvOxgXH7M6xCjAwajEwxvxWzZIiDWxrLgy9xCjBAezkgjv
	bxG5ICHelMTKqtSi/Pii0pzU4kOMTBycUg2MYc0H9yrubnHQ3e7DqszX3v1qoZzr1tqSln3T
	gs9Un5N3kP7dHry2Id90sXN5zcxDGf4XH/8VDYzZcuMjw5eD3ptnMYXoSU6cuE72lGOFrhy7
	nkj4xxfzgzccX7o79HGp4ffGy6f47l5OWXt2VjqPHqtSRIXmW6P7hzWjv+Xdafp3ce3mmVyL
	lViKMxINtZiLihMBzQfVpl8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/13 20:43, Sarah Sharp wrote:
> Applying: dev-core: fix build break when DEBUG is enabled
> WARNING: Avoid unnecessary line continuations
> #18: FILE: include/linux/device.h:1110:
> +	   "callbacks suppressed" */					\
>
> WARNING: Prefer dev_dbg(... to dev_printk(KERN_DEBUG, ...
> #33: FILE: include/linux/device.h:1123:
> +		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
>
> total: 0 errors, 2 warnings, 31 lines checked
>
> I'm just going to fix the first warning myself by moving your comment
> above the macro.  Please don't add comments inside macros, and please
> run your patches through checkpatch.pl.

I run checkpatch always.
The first warning is in my understanding is not related to comments
inside macro,
but just that avoid using "\".
I would not remove comment, because it is for explaining the macro line...

Second warning is natural in this case because macro itself defines
dev_dbg() functionality.
Internally it must use something else than itself...

- Dmitry

> Sarah Sharp
>
> On Tue, Aug 27, 2013 at 05:47:34PM +0300, Dmitry Kasatkin wrote:
>> When DEBUG is defined, dev_dbg_ratelimited uses dynamic debug data
>> structures even when CONFIG_DYNAMIC_DEBUG is not defined.
>> It leads to build break.
>> For example, when I try to use dev_dbg_ratelimited in USB code and
>> CONFIG_USB_DEBUG is enabled, but CONFIG_DYNAMIC_DEBUG is not, I get:
>>
>>   CC [M]  drivers/usb/host/xhci-ring.o
>>   drivers/usb/host/xhci-ring.c: In function ‘xhci_queue_intr_tx’:
>>   drivers/usb/host/xhci-ring.c:3059:3: error: implicit declaration of function ‘DEFINE_DYNAMIC_DEBUG_METADATA’ [-Werror=implicit-function-declaration]
>>   drivers/usb/host/xhci-ring.c:3059:3: error: ‘descriptor’ undeclared (first use in this function)
>>   drivers/usb/host/xhci-ring.c:3059:3: note: each undeclared identifier is reported only once for each function it appears in
>>   drivers/usb/host/xhci-ring.c:3059:3: error: implicit declaration of function ‘__dynamic_pr_debug’ [-Werror=implicit-function-declaration]
>>   drivers/usb/host/xhci-ring.c: In function ‘xhci_queue_isoc_tx_prepare’:
>>   drivers/usb/host/xhci-ring.c:3847:3: error: ‘descriptor’ undeclared (first use in this function)
>>   cc1: some warnings being treated as errors
>>   make[2]: *** [drivers/usb/host/xhci-ring.o] Error 1
>>   make[1]: *** [drivers/usb/host] Error 2
>>   make: *** [drivers/usb/] Error 2
>>
>> This patch separates definition for CONFIG_DYNAMIC_DEBUG and DEBUG cases.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> ---
>>  include/linux/device.h | 17 ++++++++++++++---
>>  1 file changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/device.h b/include/linux/device.h
>> index 22b546a..d336beb 100644
>> --- a/include/linux/device.h
>> +++ b/include/linux/device.h
>> @@ -1099,17 +1099,28 @@ do {									\
>>  	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
>>  #define dev_info_ratelimited(dev, fmt, ...)				\
>>  	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
>> -#if defined(CONFIG_DYNAMIC_DEBUG) || defined(DEBUG)
>> +#if defined(CONFIG_DYNAMIC_DEBUG)
>>  #define dev_dbg_ratelimited(dev, fmt, ...)				\
>>  do {									\
>>  	static DEFINE_RATELIMIT_STATE(_rs,				\
>>  				      DEFAULT_RATELIMIT_INTERVAL,	\
>>  				      DEFAULT_RATELIMIT_BURST);		\
>>  	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
>> +	/* descriptor check is first to prevent flooding with		\
>> +	   "callbacks suppressed" */					\
>>  	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT) &&	\
>>  	    __ratelimit(&_rs))						\
>> -		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),		\
>> -				   ##__VA_ARGS__);			\
>> +		__dynamic_dev_dbg(&descriptor, dev, fmt,		\
>> +				  ##__VA_ARGS__);			\
>> +} while (0)
>> +#elif defined(DEBUG)
>> +#define dev_dbg_ratelimited(dev, fmt, ...)				\
>> +do {									\
>> +	static DEFINE_RATELIMIT_STATE(_rs,				\
>> +				      DEFAULT_RATELIMIT_INTERVAL,	\
>> +				      DEFAULT_RATELIMIT_BURST);		\
>> +	if (__ratelimit(&_rs))						\
>> +		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
>>  } while (0)
>>  #else
>>  #define dev_dbg_ratelimited(dev, fmt, ...)			\
>> -- 
>> 1.8.1.2
>>

