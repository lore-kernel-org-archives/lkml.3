Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbaFSBld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:41:33 -0400
Received: from mout.gmx.net ([212.227.15.15]:54568 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852AbaFSBlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:41:32 -0400
Message-ID: <53A23FC4.5010302@gmx.de>
Date: Thu, 19 Jun 2014 03:41:24 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] media: dib9000: avoid out of bound access
References: <1403128945-28298-1-git-send-email-xypron.glpk@gmx.de> <CAGXu5jKLoRkKuu8T=im6oEhn3WmXjZPwFXEbaPT6SeL29XrS0g@mail.gmail.com>
In-Reply-To: <CAGXu5jKLoRkKuu8T=im6oEhn3WmXjZPwFXEbaPT6SeL29XrS0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:H99dLimYBi1LHXBokFzV8athswujEoo6HEuLwRkGF1i6tZ41FYe
 metKowBT2yP/v2IBXyAKxy2VciyzVkb3FFCDHGnJhfRUWRe7LDH16PBo1qpw6AaOU+zrENh
 ceUVNLaxiPIIa/9TfJetqtnk0M3apqxJSPHnKXoeWxLVAnzr9Vw59SRE3rCaJrJXwUGHI+H
 xpMy/hN4/sFUWMKlwOOHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.06.2014 01:50, Kees Cook wrote:
> On Wed, Jun 18, 2014 at 3:02 PM, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
>> The current test to avoid out of bound access to mb[] is insufficient.
>> For len = 19 non-existent mb[10] will be accessed.
>>
>> A check in the for loop is insufficient to avoid out of bound access in
>> dib9000_mbx_send_attr.
>>
>> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
>> ---
>>   drivers/media/dvb-frontends/dib9000.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
>> index e540cfb..6a71917 100644
>> --- a/drivers/media/dvb-frontends/dib9000.c
>> +++ b/drivers/media/dvb-frontends/dib9000.c
>> @@ -1040,10 +1040,13 @@ static int dib9000_risc_apb_access_write(struct dib9000_state *state, u32 addres
>>          if (address >= 1024 || !state->platform.risc.fw_is_running)
>>                  return -EINVAL;
>>
>> +       if (len > 18)
>> +               return -EINVAL;
>> +
>>          /* dprintk( "APB access thru wr fw %d %x", address, attribute); */
>>
>>          mb[0] = (unsigned short)address;
>> -       for (i = 0; i < len && i < 20; i += 2)
>> +       for (i = 0; i < len; i += 2)
>>                  mb[1 + (i / 2)] = (b[i] << 8 | b[i + 1]);
>
> Good catch on the mb[] access! However, I think there is still more to
> fix since b[i + 1] can read past the end of b: Say b is defined as "u8
> b[3]". Passing len 3 means the second loop, with i==2 will access b[2]
> and b[3], the latter is out of range.

b[] and len are provided by the caller of dib9000_risc_apb_access_write.
dib9000_risc_apb_access_write cannot verify if the length of b[] matches 
len at all.

Currently dib9000_risc_apb_access_write cannot handle odd values of len. 
This holds even true if b[] has been padded with zero to an even length: 
For odd values of len the last byte is not passed to dib9000_mbx_send_attr.

What is left unclear is how odd values of len should be handled correctly:

Should the caller provide a b[] padded with 0 to the next even number of 
bytes,
or should dib9000_risc_apb_access_write take care not to read more then 
len bytes,
or should odd values of len cause an error EINVAL.

 From what I read in the coding one source of the value of len is 
tuner_attach(), which is called from outside the dib9000 driver.

Heinrich

>
> -Kees
>
>>
>>          dib9000_mbx_send_attr(state, OUT_MSG_BRIDGE_APB_W, mb, 1 + len / 2, attribute);
>> --
>> 2.0.0
>>
>
>
>

