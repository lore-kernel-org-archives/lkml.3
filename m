Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaDYNvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:51:55 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55279 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaDYNvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:51:51 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <535A6873.9020404@roeck-us.net>
Date: Fri, 25 Apr 2014 06:51:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: monstr@monstr.eu
CC: linux-kernel@vger.kernel.org
Subject: Re: Microblaze image hanging in qemu with 3.15-rc
References: <20140422172356.GA15672@roeck-us.net> <53575074.6010602@monstr.eu> <5357C246.7050604@roeck-us.net> <5357CA6B.1070101@monstr.eu> <20140423154533.GA15644@roeck-us.net> <5358AC50.7020308@monstr.eu> <535913E1.70509@roeck-us.net> <535A0DD7.4080204@monstr.eu> <535A631F.5020208@roeck-us.net>
In-Reply-To: <535A631F.5020208@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 06:29 AM, Guenter Roeck wrote:
> On 04/25/2014 12:25 AM, Michal Simek wrote:
> [ ... ]
>
>>
>> It should be pretty easy to fix it in timer_write function like this.
>>
>> diff --git a/hw/timer/xilinx_timer.c b/hw/timer/xilinx_timer.c
>> index 6113b97..3ff1da9 100644
>> --- a/hw/timer/xilinx_timer.c
>> +++ b/hw/timer/xilinx_timer.c
>> @@ -169,7 +169,7 @@ timer_write(void *opaque, hwaddr addr,
>>               if (value & TCSR_TINT)
>>                   value &= ~TCSR_TINT;
>>
>> -            xt->regs[addr] = value;
>> +            xt->regs[addr] = value & 0x7ff;
>>               if (value & TCSR_ENT)
>>                   timer_enable(xt);
>>               break;
>>
>
> Hi Michal,
>
> that fixes endianness detection, but the image is still hanging.
>
> Here is the log:
>
> NR_IRQS:33
> /plb@0/interrupt-controller@81800000: num_irq=4, edge=0xa
> ERROR: CPU CCF input clock not found
> Reading TCSR0 returned 0x0, expected 0x1
> Switch to big endian mode
> /plb@0/timer@83c00000: irq=1
> ERROR: timer CCF input clock not found
> ERROR: Using CPU clock frequency
> xilinx_timer_set_mode: shutdown
> xilinx_timer_set_mode: periodic
> sched_clock: 32 bits at 62MHz, resolution 16ns, wraps every 68719476720ns
> Calibrating delay loop... QEMU: Terminated
>
> I added a couple of log messages to make sure that the mode is detected correctly.
> Any idea what else might be wrong ?
>

Never mind, I found it. Same problem with interrupt handler.
Can you give me the valid bit mask for intc_baseaddr + MER ?

Thanks,
Guenter

