Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaB0GlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 01:41:21 -0500
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:54683 "HELO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750952AbaB0GlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 01:41:20 -0500
MIME-Version: 1.0
In-Reply-To: <530EDC65.8060106@ti.com>
References: <1393308882-3964-1-git-send-email-lho@apm.com>
	<1393308882-3964-2-git-send-email-lho@apm.com>
	<1393308882-3964-3-git-send-email-lho@apm.com>
	<1393308882-3964-4-git-send-email-lho@apm.com>
	<530DB713.6000701@ti.com>
	<CAPw-ZT=eLbxt3wPL7hrZFtxTP9vGxbRyBY2Yoh77pq9ypphCaw@mail.gmail.com>
	<530ED4EF.1060000@ti.com>
	<CAPw-ZTnLYbUjQTm7QhJO5EMNqN5+dtWndSRUZn_bgMGvmNEu0Q@mail.gmail.com>
	<530EDC65.8060106@ti.com>
Date: Wed, 26 Feb 2014 22:41:18 -0800
Message-ID: <CAPw-ZTn=za14-x9fjnDfcY419i5nuFPqsQp_r-75zjyHf11E4w@mail.gmail.com>
Subject: Re: [PATCH RESEND v10 3/4] PHY: add APM X-Gene SoC 15Gbps
 Multi-purpose PHY driver
From: Loc Ho <lho@apm.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Tejun Heo <tj@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>,
        "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>,
        Suman Tripathi <stripathi@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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
>>>>>
>>>>> This looks hacky. If 'CFG_IND_WR_CMD_MASK | CFG_IND_CMD_DONE_MASK'
>>>>> should
>>>>> be set then it should be part of the second argument. From the macro
>>>>> 'CFG_IND_ADDR_SET' the first argument should be more like the current
>>>>> value
>>>>> present in the register right? I feel the macro (CFG_IND_ADDR_SET) is
>>>>> not
>>>>> used in the way it is intended to.
>>>>
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
>>>
>>> #define  CFG_IND_ADDR_SET(dst, src) \
>>>                  (((dst) & ~0x003ffff0) | (((u32)(src)<<4) & 0x003ffff0))
>>>
>>>  From this macro the first argument should be the present value in that
>>> register. Here you reset the address bits and write the new address bits.
>>
>>
>> Yes.. This is correct. I am clearing x number of bit and then set new
>> value.
>>
>>> IMO the first argument should be the value in 'csr_base +
>>> indirect_cmd_reg'.
>>> So it resets the address bits in 'csr_base + indirect_cmd_reg' and write
>>> down the new address bits.
>>
>>
>> Yes.. The above code does just that. In addition, I am also setting
>> the bits CFG_IND_WR_CMD_MASK and CFG_IND_CMD_DONE_MASK with the two
>> previous statement. Think of the code flow as follow:
>>
>> val = readl(some void * address); /* read the register */
>
>
> Where are you reading the register in your code (before CFG_IND_ADDR_SET)?

I am not reading the register as I will be completely setting them.
This example is to show how these macro intended to be used.

>>
>> val = XXXX_SET(val, 0x1);            /* set bit 0  - assuming XXXX set
>> bit 0 only */
>
> If you want to set other bits (other than address) don't use
> CFG_IND_ADDR_SET macro. That looks hacky to me.

I am not. This example is only to show how it can be used if there are
multiple fields to be set. I need to set three fields - two 1 bit
fields and one 19 bit fields. For the one bit field, I just use the
mask. For the 19 bit field, I am using the CFG_IND_ADDR_SET macro. Any
issue before I post an update version?

>
>> val = YYYY_SET(val, 0x1);          /* set bit 1 - assuming YYYY set
>> bit 1 only */
>> val = ZZZZ_SET(val, 0x5);            /* set upper 16 bit of the
>> register to 0x5 - assuming ZZZZ set field of the upper 16 bits */
>>
>> Instead writing the above, I am replacing the above 4 lines with these
>> two lines:
>>
>> cmd = CFG_IND_WR_CMD_MASK | CFG_IND_CMD_DONE_MASK;
>> cmd = CFG_IND_ADDR_SET(cmd, addr);
>>
>> Is there clear?
>>

-Loc
