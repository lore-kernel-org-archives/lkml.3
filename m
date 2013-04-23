Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3DWCmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 22:42:20 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:5476 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890Ab3DWCmT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 22:42:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z616jz98dI9371Ic89bh1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kz8dhz8275bhz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1155h)
Message-ID: <5175F56B.5040200@freescale.com>
Date: Tue, 23 Apr 2013 10:43:55 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: <dwmw2@infradead.org>, <dedekind1@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/8] mtd: get the ECC info from the Extended Parameter
 Page
References: <1366616878-29481-1-git-send-email-b32955@freescale.com>	<1366616878-29481-4-git-send-email-b32955@freescale.com> <CAN8TOE_xOBTv7weAqYinFMmTStXgY93KanV-jDAqFnY=CEfkdQ@mail.gmail.com>
In-Reply-To: <CAN8TOE_xOBTv7weAqYinFMmTStXgY93KanV-jDAqFnY=CEfkdQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年04月23日 05:22, Brian Norris 写道:
> On Mon, Apr 22, 2013 at 12:47 AM, Huang Shijie<b32955@freescale.com>  wrote:
>> Since the ONFI 2.1, the onfi spec adds the Extended Parameter Page
>> to store the ECC info.
>>
>> The onfi spec tells us that if the nand chip's recommended ECC codeword
>> size is not 512 bytes, then the @ecc_bits is 0xff. The host _SHOULD_ then
>> read the Extended ECC information that is part of the extended parameter
>> page to retrieve the ECC requirements for this device.
>>
>> This patch implement the reading of the Extended Parameter Page, and parses
>> the sections for ECC type, and get the ECC info from the ECC section.
>>
>> Tested this patch with Micron MT29F64G08CBABAWP.
>>
>> Signed-off-by: Huang Shijie<b32955@freescale.com>
>> ---
>>   drivers/mtd/nand/nand_base.c |   54 ++++++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 54 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
>> index beff911..48ff097 100644
>> --- a/drivers/mtd/nand/nand_base.c
>> +++ b/drivers/mtd/nand/nand_base.c
>> @@ -2846,6 +2846,56 @@ static u16 onfi_crc16(u16 crc, u8 const *p, size_t len)
>>          return crc;
>>   }
>>
>> +/* Parse the Extended Parameter Page. */
>> +static void nand_flash_detect_ext_param_page(struct mtd_info *mtd,
>> +               struct nand_chip *chip, struct nand_onfi_params *p, int last)
>> +{
> I think we want a return code (int) for this function. It obviously
> can fail, and the caller needs to know this.
I not sure who will uses ecc_strength/ecc_size, except the gpmi.
So i ignore the return value.

If you think we should add it, i will add it.
> The "last" parameter is not very obvious until you read the whole
> function, where you see that this function assumes a lot about the
> caller. Please address the comments below and/or fully document the
> parameters and calling context for this function.
>
ok. I can add more comments.

>> +       struct onfi_ext_param_page *ep;
>> +       struct onfi_ext_section *s;
>> +       struct onfi_ext_ecc_info *ecc;
>> +       uint8_t *cursor;
>> +       int len;
>> +       int i;
>> +
>> +       len = le16_to_cpu(p->ext_param_page_length) * 16;
>> +       ep = kcalloc(1, max_t(int, len, sizeof(*p)), GFP_KERNEL);
>> +       if (!ep)
>> +               goto ext_out;
>> +
>> +       /*
>> +        * Skip the ONFI Parameter Pages.
>> +        * The Change Read Columm command may does not works here.
> Why not?
>
You can give me a fix patch which bases on my patch set.
I can test it. :)

I tried to use the Change-read-columm command, but failed.

>> +        */
>> +       for (i = last + 1; i<  p->num_of_param_pages; i++)
>> +               chip->read_buf(mtd, (uint8_t *)ep, sizeof(*p));
> You never sent a command to the chip. How can you expect to read from it?
we have sent a command in the nand_flash_detect_onfi().
> It seems that you are writing this function with the assumption of a
> particular calling context (a context in which the last command was
> CMD_PARAM). IMO, it would make a lot more sense that this function
> actually send its own CMD_PARAM followed by either X bytes of skipped
> read_buf() or a change read column command. Then it doesn't need the
> "last" argument, and its usage makes much more sense.
>
I added the "last" argument just because the Change-read-column command 
did not works.


thanks
Huang Shijie


