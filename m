Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbaFSC0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:26:44 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:36867 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbaFSC0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:26:42 -0400
MIME-Version: 1.0
In-Reply-To: <53A23FC4.5010302@gmx.de>
References: <1403128945-28298-1-git-send-email-xypron.glpk@gmx.de>
	<CAGXu5jKLoRkKuu8T=im6oEhn3WmXjZPwFXEbaPT6SeL29XrS0g@mail.gmail.com>
	<53A23FC4.5010302@gmx.de>
Date: Wed, 18 Jun 2014 19:26:41 -0700
X-Google-Sender-Auth: Mw8KtWZnS1xoRdbZ24FxQPNZB2o
Message-ID: <CAGXu5jLJGpPhycff9OSMGu6wduLGQWhsu2mkGeM7R0O9CQZ7pg@mail.gmail.com>
Subject: Re: [PATCH 1/1] media: dib9000: avoid out of bound access
From: Kees Cook <keescook@chromium.org>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 6:41 PM, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> On 19.06.2014 01:50, Kees Cook wrote:
>>
>> On Wed, Jun 18, 2014 at 3:02 PM, Heinrich Schuchardt <xypron.glpk@gmx.de>
>> wrote:
>>>
>>> The current test to avoid out of bound access to mb[] is insufficient.
>>> For len = 19 non-existent mb[10] will be accessed.
>>>
>>> A check in the for loop is insufficient to avoid out of bound access in
>>> dib9000_mbx_send_attr.
>>>
>>> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
>>> ---
>>>   drivers/media/dvb-frontends/dib9000.c | 5 ++++-
>>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/dvb-frontends/dib9000.c
>>> b/drivers/media/dvb-frontends/dib9000.c
>>> index e540cfb..6a71917 100644
>>> --- a/drivers/media/dvb-frontends/dib9000.c
>>> +++ b/drivers/media/dvb-frontends/dib9000.c
>>> @@ -1040,10 +1040,13 @@ static int dib9000_risc_apb_access_write(struct
>>> dib9000_state *state, u32 addres
>>>          if (address >= 1024 || !state->platform.risc.fw_is_running)
>>>                  return -EINVAL;
>>>
>>> +       if (len > 18)
>>> +               return -EINVAL;
>>> +
>>>          /* dprintk( "APB access thru wr fw %d %x", address, attribute);
>>> */
>>>
>>>          mb[0] = (unsigned short)address;
>>> -       for (i = 0; i < len && i < 20; i += 2)
>>> +       for (i = 0; i < len; i += 2)
>>>                  mb[1 + (i / 2)] = (b[i] << 8 | b[i + 1]);
>>
>>
>> Good catch on the mb[] access! However, I think there is still more to
>> fix since b[i + 1] can read past the end of b: Say b is defined as "u8
>> b[3]". Passing len 3 means the second loop, with i==2 will access b[2]
>> and b[3], the latter is out of range.
>
>
> b[] and len are provided by the caller of dib9000_risc_apb_access_write.
> dib9000_risc_apb_access_write cannot verify if the length of b[] matches len
> at all.
>
> Currently dib9000_risc_apb_access_write cannot handle odd values of len.
> This holds even true if b[] has been padded with zero to an even length: For
> odd values of len the last byte is not passed to dib9000_mbx_send_attr.
>
> What is left unclear is how odd values of len should be handled correctly:
>
> Should the caller provide a b[] padded with 0 to the next even number of
> bytes,
> or should dib9000_risc_apb_access_write take care not to read more then len
> bytes,
> or should odd values of len cause an error EINVAL.
>
> From what I read in the coding one source of the value of len is
> tuner_attach(), which is called from outside the dib9000 driver.

How about:

for (i = 0; i < len; i += 2) {
    u16 val = b[i] << 8;
    if (i + 1 < len)
         val |= b[i + 1];
    mb[1 + (i / 2)] = val;

That's defensive, and would have the same effect of callers doing the padding.

-Kees

>
> Heinrich
>
>
>>
>> -Kees
>>
>>>
>>>          dib9000_mbx_send_attr(state, OUT_MSG_BRIDGE_APB_W, mb, 1 + len /
>>> 2, attribute);
>>> --
>>> 2.0.0
>>>
>>
>>
>>
>



-- 
Kees Cook
Chrome OS Security
