Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3CPOsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 10:48:51 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16043 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab3CPOsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 10:48:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 16 Mar 2013 07:41:56 -0700
Message-ID: <514485D2.6000806@nvidia.com>
Date: Sat, 16 Mar 2013 20:16:42 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 RESEND 1/2] regmap: irq: Add support for interrupt
 type
References: <1362673997-6762-1-git-send-email-ldewangan@nvidia.com> <1362673997-6762-2-git-send-email-ldewangan@nvidia.com> <20130312195546.GH19942@opensource.wolfsonmicro.com>
In-Reply-To: <20130312195546.GH19942@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 March 2013 01:25 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Mar 07, 2013 at 10:03:17PM +0530, Laxman Dewangan wrote:
>
>>   /**
>> + * The Regmap IRQ type Index
>> + * REGMAP_IRQ_TYPE_NONE is used for setting inital value for clearing type.
>> + */
>> +enum {
>> +	REGMAP_IRQ_TYPE_NONE,
>> +	REGMAP_IRQ_TYPE_RISING,
>> +	REGMAP_IRQ_TYPE_FALLING,
>> +	REGMAP_IRQ_TYPE_BOTH,
>> +	REGMAP_IRQ_TYPE_LEVEL_HIGH,
>> +	REGMAP_IRQ_TYPE_LEVEL_LOW,
>> +
>> +	/* Last entry to get maximum index */
>> +	REGMAP_IRQ_TYPE_NR,
> Why can't we just use the normal IRQ_TYPE macros?

IRQ_TYPE is bit wise allocated and I wanted to have on serieal index to 
assign value on array indexed with type.

>
>> + * @type_reg_sub_offset: Suboffset for type register if type mask are
>> + *              accomodated in the multiple register.
>> + * @type_supported_flags: Supported interrupt type as per interrupt.h.
>> + *             All supported flags are ORed.
>> + * type_mask: Type mask for getting related register bits.
>> + * @type_value: The type value in array form to set value for a given flag.
> This is making my head hurt, it's a bit confusing - I'm having to think
> too hard to understand what all these different fields do and how they
> interact.  Especially type_reg_sub_offset which feels like it must be
> part of a wider feature to support a greater range of register layouts.
>
> Can you clarify a bit please?
>

Sorry for complicating the things.
When I added this feature I was working on two PMICs, Max77660/MAX77663 
and the Palmas. I also consider how it is possible to handle in the 
tps65910 but seems not possible.
All this driver uses the regmap-irq. (MAX77660 is not in mainline and 
working on upstreaming this)
On Max77660/Max77663, the interrupt support is having 2 level, one top 
level for main interrupt like GPIO, RTC interrupt and second level in the
sub module like for RTC submodule: alram or timer in RTC interrupt 
mask/status, for GPIO submodule: gpio control and gpio interrupt status.
GPIO sub module of MAX77660/MAX77663 is as follows:
- Top level interrupt for gpio module.
- GPIO  module have GPIOx_CNTRL where bit6:5 shows the rising/falling 
edge interrupt and GPIO_INT_STATUS shows the interrupt status.
GPIO0_CNTL(0x20): bit 6:5: rising/falling edge of gpio0
GPIO1_CNTL(0x21): bit 65:5 rising/falling edge of gpio1
::::::::::::::::::::::::::::
GPIO7_CNTRL(0x27): bit 65:5 rising/falling edge of gpio7

GPIO_INT_STATUS: bit 0 for gpio0, bit 1 for gpio1, bit 2 for gpio2 etc.

There is no separate mask register here.


For palmas: All interrupts are on same level, there is no two level of 
interrupts.
There is 4 interrupt mask/status interrupt.

INT4_MASK/STATUS: bit 0 for gpio0, bit 1 for gpio1, bit 2 for gpio2 etc.
INT4_EDGE1_REG: bit 1:0 for gpio0 rising/falling, bit 3:2 for gpio1 
rising falling...
INT4_EDGE2_REG: bit 1:0 for gpio4 rising/falling, bit 3:2 for gpio5 
rising falling...

It has mask, interrupt status, edge1, edg2 as part of set of register. 
For other interrups also there is same sets but edge1 and edge2 are  
reserved.


To support rising/falling through regmap, I consider above two type of 
register set. Here as we can have more than 2 register for edge 
configuration,
I make register_sub_offset with type_register to address edge1 and edge2 
register.

Now, Palmas series have multiple PMICs and currently I am wokring on 
tps65913 and tps80036.
It is easy to support interrupt through regmap-irq for tps65913 but not 
possible to tps80036.
In tps65913, there is 4 int status/mask sets properly address spaced.
INT1_STATUS 0x0, INT2_STATUS 0x5, INT3_STATUS 0xA, INT4_STATUS 0xF
But tps80036 added few more interrupts and so INT5_STATUS which is not 
at 0x14 but it is at different 0x15 and INT6_STATUS 0x1A.
So using regmap-irq for tps80036 is not possible.


So given above limitation on palma, I think I should not complicate type 
support, only add register_type and drop the register_type_offset, 
typically to support the MAX77660.

let me know your opinion.



