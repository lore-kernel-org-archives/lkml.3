Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaB0Gmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 01:42:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49972 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB0Gmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 01:42:50 -0500
Message-ID: <530EDE41.1000809@ti.com>
Date: Thu, 27 Feb 2014 12:12:09 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Loc Ho <lho@apm.com>
CC: Tejun Heo <tj@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>,
        "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>,
        Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH RESEND v10 3/4] PHY: add APM X-Gene SoC 15Gbps Multi-purpose
 PHY driver
References: <1393308882-3964-1-git-send-email-lho@apm.com> <1393308882-3964-2-git-send-email-lho@apm.com> <1393308882-3964-3-git-send-email-lho@apm.com> <1393308882-3964-4-git-send-email-lho@apm.com> <530DB713.6000701@ti.com> <CAPw-ZT=eLbxt3wPL7hrZFtxTP9vGxbRyBY2Yoh77pq9ypphCaw@mail.gmail.com> <530ED4EF.1060000@ti.com> <CAPw-ZTnLYbUjQTm7QhJO5EMNqN5+dtWndSRUZn_bgMGvmNEu0Q@mail.gmail.com> <530EDC65.8060106@ti.com>
In-Reply-To: <530EDC65.8060106@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014 12:04 PM, Kishon Vijay Abraham I wrote:
> On Thursday 27 February 2014 11:55 AM, Loc Ho wrote:
>> Hi,
>>
>>>>>> +
>>>>>> +static void sds_wr(void __iomem *csr_base, u32 indirect_cmd_reg,
>>>>>> +                  u32 indirect_data_reg, u32 addr, u32 data)
>>>>>> +{
>>>>>> +       u32 val;
>>>>>> +       u32 cmd;
>>>>>> +
>>>>>> +       cmd = CFG_IND_WR_CMD_MASK | CFG_IND_CMD_DONE_MASK;
>>>>>> +       cmd = CFG_IND_ADDR_SET(cmd, addr);
>>>>>
>>>>>
>>>>>
>>>>> This looks hacky. If 'CFG_IND_WR_CMD_MASK | CFG_IND_CMD_DONE_MASK'
>>>>> should
>>>>> be set then it should be part of the second argument. From the macro
>>>>> 'CFG_IND_ADDR_SET' the first argument should be more like the
>>>>> current value
>>>>> present in the register right? I feel the macro (CFG_IND_ADDR_SET)
>>>>> is not
>>>>> used in the way it is intended to.
>>>>
>>>>
>>>> The macro XXX_SET is intended to update an field within the register.
>>>> The update field is returned. The first assignment lines are setting
>>>> another field. Those two lines can be written as:
>>>>
>>>> cmd = 0;
>>>> cmd |= CFG_IND_WR_CMD_MASK;            ==> Set the CMD bit
>>>> cmd |= CFG_IND_CMD_DONE_MASK;        ==> Set the DONE bit
>>>> cmd = CFG_IND_ADDR_SET(cmd, addr);    ===> Set the field ADDR
>>>
>>>
>>> #define  CFG_IND_ADDR_SET(dst, src) \
>>>                  (((dst) & ~0x003ffff0) | (((u32)(src)<<4) &
>>> 0x003ffff0))
>>>
>>>  From this macro the first argument should be the present value in that
>>> register. Here you reset the address bits and write the new address
>>> bits.
>>
>> Yes.. This is correct. I am clearing x number of bit and then set new
>> value.
>>
>>> IMO the first argument should be the value in 'csr_base +
>>> indirect_cmd_reg'.
>>> So it resets the address bits in 'csr_base + indirect_cmd_reg' and write
>>> down the new address bits.
>>
>> Yes.. The above code does just that. In addition, I am also setting
>> the bits CFG_IND_WR_CMD_MASK and CFG_IND_CMD_DONE_MASK with the two
>> previous statement. Think of the code flow as follow:
>>
>> val = readl(some void * address); /* read the register */
>
> Where are you reading the register in your code (before CFG_IND_ADDR_SET)?
>> val = XXXX_SET(val, 0x1);            /* set bit 0  - assuming XXXX set
>> bit 0 only */
> If you want to set other bits (other than address) don't use
> CFG_IND_ADDR_SET macro. That looks hacky to me.

huh.. looked it again and I think only the readl is missing. If you can 
add that, it should be fine.

How about something like this

val = readl(csr_base + indirect_cmd_reg);
val = CFG_IND_ADDR_SET(val, addr);
val |= CFG_IND_WR_CMD_MASK | CFG_IND_CMD_DONE_MASK;
writel(val, csr_base + indirect_cmd_reg);

Cheers
Kishon
