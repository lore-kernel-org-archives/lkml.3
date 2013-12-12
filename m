Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3LLJqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:46:39 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:8908 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120Ab3LLJqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:46:32 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz17326ah8275dh1de097h186068hz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h1155h)
Message-ID: <52A985E6.2040403@freescale.com>
Date: Thu, 12 Dec 2013 17:46:14 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DTS: DMA: Fix DMA3 interrupts
References: <1385712446-28221-1-git-send-email-hongbo.zhang@freescale.com>	 <1386357684.7375.124.camel@snotra.buserror.net>	 <52A6EDE8.5060903@freescale.com> <1386700403.10013.109.camel@snotra.buserror.net>
In-Reply-To: <1386700403.10013.109.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/11/2013 02:33 AM, Scott Wood wrote:
> On Tue, 2013-12-10 at 18:33 +0800, Hongbo Zhang wrote:
>> Scott,
>> This issue is due to the non-continuous MPIC register, I think there is
>> two ways to fix it.
>>
>> The first one is as what we are discussing, in fact the Bman/Qman DT
>> author had introduced this way, and I had to follow it, it is a trick,
>> adding 208 is a bit ugly I think, and even difficult to explain it to
>> customers etc, but this way changes less codes.
>>
>> The second one is editing MPIC related codes without adding 208 to high
>> interrupts. The point of translate interrupt number to MPIC register
>> address is a so called 'isu' mechanism, we can do like the following
>> example codes, then the tricky adding 208 isn't needed any more.
>>
>> Which one do you prefer?
>> In fact I myself prefer the second, if the idea is acceptable, I will
>> send a patch instead of this one. (and also alone with the internal
>> patch decreasing 208 for the Bman/Qman)
>>
>> void __init corenet_ds_pic_init(void)
>> {
>>       ......
>>
>>       mpic = mpic_alloc(NULL, 0, flags, 0, 512, "OpenPIC");
>>       BUG_ON(mpic == NULL);
>>
>> // Add this start
>>       for (i = 0; i < 17; i++) {
>>           if (i < 11)
>>               addr_off = 0x10000 + 0x20 * 16 * i;
>>           else
>>               addr_off = 0x13000 + 0x20 * 16 * (i - 11);  /* scape the
>> address not for interrupts */
>>           mpic_assign_isu(mpic, i, mpic->paddr + addr_off);
>>       }
>> // Add this end
>>
>>       mpic_init(mpic);
>> }
> NACK
>
> We already have a binding that states that the interrupt number is based
> on the register offset, rather than whatever arbitrary numbers hardware
> documenters decide to use next week.
>
> While I'm not terribly happy with the usability of this, especially now
> that it's not a simple "add 16", redefining the existing binding is not
> OK (and in any case the code above seems obfuscatory).  If we decide to
> do something other than continue with register offset divided by 32,
> then we need to define a new interrupt type (similar to current defined
> types of error interrupt, timer, and IPI) for the new numberspace -- and
> it should be handled when decoding that type of interrupt specifier,
> rather than with the isu mechanism.
>
> -Scott
>
>
Scott,
Thanks for your comments. Since the second way isn't so good, let's 
choose the original one.
But we meet a small accident now.
My patch is based on the http://patchwork.ozlabs.org/patch/291553/, 
which had been superseded, so this thread can be closed now.

And Shenzhou has already sent a complete dma3 dtsi patch including 
correct interrupt numbers, http://patchwork.ozlabs.org/patch/300026/, so 
let's focus on this patch, and I will forward your first comments of my 
patch there.

Thanks.



