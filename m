Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3JWSGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 14:06:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:5071 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab3JWSGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 14:06:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,555,1378882800"; 
   d="scan'208";a="421519023"
Message-ID: <52681128.2010404@linux.intel.com>
Date: Wed, 23 Oct 2013 11:10:48 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, ning.li@intel.com,
        ivan.gorinov@intel.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/2] mrst_max3110: fix SPI UART interrupt parameters
References: <1382470930-13807-1-git-send-email-david.a.cohen@linux.intel.com> <5266E070.2060408@linux.intel.com> <5267041F.2090905@linux.intel.com> <1382509666.28248007@f107.i.mail.ru>
In-Reply-To: <1382509666.28248007@f107.i.mail.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 11:27 PM, Alexander Shiyan wrote:
>> On 10/22/2013 01:30 PM, David Cohen wrote:
>>> On 10/22/2013 12:46 PM, Alexander Shiyan wrote:
>>>>> The change in the max3110 driver makes the IRQ handling threaded, now
>>>>> the handler is called only once per received character. Without that
>>>>> change, we had many (more than 100) interrupts per one received
>>>>> character.
>>>>>
>>>>> Unfortunately, SFI interface does not support IRQ polarity and
>>>>> triggering modes, so we have to keep the hacks as hard-coded device
>>>>> names and IRQ numbers until we switch to ACPI.
>>>>>
>>>>> Edge-triggered IRQ still supported to keep old platforms working.
>>>>> Use platform data to pass the irq mode argument.
>>>>>
>>>>> Signed-off-by: Ivan Gorinov <ivan.gorinov@intel.com>
>>>>> Signed-off-by: Li Ning <ning.li@intel.com>
>>>>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>>>> ...
>>>>> +++ b/include/linux/serial_max3110.h
>>>>> @@ -0,0 +1,16 @@
>>>>> +#ifndef _LINUX_SERIAL_MAX3110_H
>>>>> +#define _LINUX_SERIAL_MAX3110_H
>>>>> +
>>>>> +/**
>>>>> + * struct plat_max3110 - MAX3110 SPI UART platform data
>>>>> + * @irq_edge_trigger: if IRQ is edge triggered
>>>>> + *
>>>>> + * You should use this structure in your machine description to specify
>>>>> + * how the MAX3110 is connected.
>>>>> + *
>>>>> + */
>>>>> +struct plat_max3110 {
>>>>> +    int irq_edge_triggered;
>>>>> +};
>>>>> +
>>>>> +#endif
>>>>> --
>>>>
>>>> Is just resource->flags for IRQ can be reused for handle such case?
>>>
>>> I believe your suggestion makes perfect sense. I'll rework it.
>>
>> Looks like isp_device has no place for 'resource'. In this case pdata
>> seems to be the way to go here.
>> Or maybe there's a better way to recommend?
>
> What do you mean by the isp_device?

Allow me to correct my typo: I meant spi_device (this is a spi
device/driver).

>
> My idea is always use threaded irq and passing flags into request.
> Like as:
> unsigned long flags = res->flags & IORESOURCE_BITS;
> ...
> request_threaded_irq(max->irq, serial_m3110_irq, IRQF_ONESHOT | flags, "max3110", max);


Oh, maybe we were talking about different things afterall :)
The reason this struct plat_max3110 was created is to allow platform
code (located under arch/x86/platform/intel-mid/device_libs/) to define
the irq edge type.
When I saw your comment I though you were referring to struct resource
(which has IORESOURCE_IRQ_* flags). But unlike platform_device,
spi_device has no struct resource * to replace the need of struct
plat_max3110.

OTOH your suggestion can replace this piece of code:

@@ -68,6 +69,7 @@ struct uart_max3110 {
         u8 clock;
         u8 parity, word_7bits;
         u16 irq;
+       u16 irq_edge_triggered;

         unsigned long uart_flags;

I'll check again the patch and possibly make the changes.

Thanks,

David Cohen
