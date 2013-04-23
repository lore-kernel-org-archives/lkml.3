Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab3DWHHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:07:01 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:37383 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3DWHHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:07:00 -0400
MIME-Version: 1.0
In-Reply-To: <5175F56B.5040200@freescale.com>
References: <1366616878-29481-1-git-send-email-b32955@freescale.com>
	<1366616878-29481-4-git-send-email-b32955@freescale.com>
	<CAN8TOE_xOBTv7weAqYinFMmTStXgY93KanV-jDAqFnY=CEfkdQ@mail.gmail.com>
	<5175F56B.5040200@freescale.com>
Date: Tue, 23 Apr 2013 00:06:59 -0700
Message-ID: <CAN8TOE8uAi3=4MOG76Y7atAR1YjmssmXmOgu7Y=T8EjQtNx2Cw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] mtd: get the ECC info from the Extended Parameter Page
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 7:43 PM, Huang Shijie <b32955@freescale.com> wrote:
> 于 2013年04月23日 05:22, Brian Norris 写道:
>
>> On Mon, Apr 22, 2013 at 12:47 AM, Huang Shijie<b32955@freescale.com>
>> wrote:
>>>
>>> Since the ONFI 2.1, the onfi spec adds the Extended Parameter Page
>>> to store the ECC info.
>>>
>>> The onfi spec tells us that if the nand chip's recommended ECC codeword
>>> size is not 512 bytes, then the @ecc_bits is 0xff. The host _SHOULD_ then
>>> read the Extended ECC information that is part of the extended parameter
>>> page to retrieve the ECC requirements for this device.
>>>
>>> This patch implement the reading of the Extended Parameter Page, and
>>> parses
>>> the sections for ECC type, and get the ECC info from the ECC section.
>>>
>>> Tested this patch with Micron MT29F64G08CBABAWP.
>>>
>>> Signed-off-by: Huang Shijie<b32955@freescale.com>
>>> ---
>>>   drivers/mtd/nand/nand_base.c |   54
>>> ++++++++++++++++++++++++++++++++++++++++++
>>>   1 files changed, 54 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
>>> index beff911..48ff097 100644
>>> --- a/drivers/mtd/nand/nand_base.c
>>> +++ b/drivers/mtd/nand/nand_base.c
>>> @@ -2846,6 +2846,56 @@ static u16 onfi_crc16(u16 crc, u8 const *p, size_t
>>> len)
>>>          return crc;
>>>   }
>>>
>>> +/* Parse the Extended Parameter Page. */
>>> +static void nand_flash_detect_ext_param_page(struct mtd_info *mtd,
>>> +               struct nand_chip *chip, struct nand_onfi_params *p, int
>>> last)
>>> +{
>>
>> I think we want a return code (int) for this function. It obviously
>> can fail, and the caller needs to know this.
>
> I not sure who will uses ecc_strength/ecc_size, except the gpmi.
> So i ignore the return value.

Well, that's the dangerous part of this patch series: that it is
written entirely from the point of view of a specific use case (gpmi).
It can be improved a little to make it more generically useful.

> If you think we should add it, i will add it.

Well, the code doesn't clearly show what happens to
ecc_strength/ecc_size if (1) we are out of memory (but we are hosed in
this case anyway...) or (2) the extended parameter page is corrupted
and/or not present. In either case, the caller may want to zero out
the the parameters, set them to -1, or whatever else we decide for the
null case.

>> The "last" parameter is not very obvious until you read the whole
>> function, where you see that this function assumes a lot about the
>> caller. Please address the comments below and/or fully document the
>> parameters and calling context for this function.
>>
> ok. I can add more comments.
>
>
>>> +       struct onfi_ext_param_page *ep;
>>> +       struct onfi_ext_section *s;
>>> +       struct onfi_ext_ecc_info *ecc;
>>> +       uint8_t *cursor;
>>> +       int len;
>>> +       int i;
>>> +
>>> +       len = le16_to_cpu(p->ext_param_page_length) * 16;
>>> +       ep = kcalloc(1, max_t(int, len, sizeof(*p)), GFP_KERNEL);

Does this need to be zeroed out? We will overwrite it before using it
anyway. I'd just recommend kmalloc.

>>> +       if (!ep)
>>> +               goto ext_out;
>>> +
>>> +       /*
>>> +        * Skip the ONFI Parameter Pages.
>>> +        * The Change Read Columm command may does not works here.
>>
>> Why not?
>>
> You can give me a fix patch which bases on my patch set.
> I can test it. :)
>
> I tried to use the Change-read-columm command, but failed.

I believe the behavior here will really depend on the driver used. My
driver, for instance, intercepts these commands and sends them to the
controller in a different form. So my patches won't necessarily help
you if your driver is broken :)

>>> +        */
>>> +       for (i = last + 1; i<  p->num_of_param_pages; i++)
>>> +               chip->read_buf(mtd, (uint8_t *)ep, sizeof(*p));
>>
>> You never sent a command to the chip. How can you expect to read from it?
>
> we have sent a command in the nand_flash_detect_onfi().

Right, I understand. But it's not very clean code if it makes this
assumption w/o documenting it.

>> It seems that you are writing this function with the assumption of a
>> particular calling context (a context in which the last command was
>> CMD_PARAM). IMO, it would make a lot more sense that this function
>> actually send its own CMD_PARAM followed by either X bytes of skipped
>> read_buf() or a change read column command. Then it doesn't need the
>> "last" argument, and its usage makes much more sense.
>>
> I added the "last" argument just because the Change-read-column command did
> not works.

Brian
