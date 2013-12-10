Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3LJKdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:33:40 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:8862
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab3LJKdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:33:38 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h1155h)
Message-ID: <52A6EDE8.5060903@freescale.com>
Date: Tue, 10 Dec 2013 18:33:12 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DTS: DMA: Fix DMA3 interrupts
References: <1385712446-28221-1-git-send-email-hongbo.zhang@freescale.com> <1386357684.7375.124.camel@snotra.buserror.net>
In-Reply-To: <1386357684.7375.124.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott,
This issue is due to the non-continuous MPIC register, I think there is 
two ways to fix it.

The first one is as what we are discussing, in fact the Bman/Qman DT 
author had introduced this way, and I had to follow it, it is a trick, 
adding 208 is a bit ugly I think, and even difficult to explain it to 
customers etc, but this way changes less codes.

The second one is editing MPIC related codes without adding 208 to high 
interrupts. The point of translate interrupt number to MPIC register 
address is a so called 'isu' mechanism, we can do like the following 
example codes, then the tricky adding 208 isn't needed any more.

Which one do you prefer?
In fact I myself prefer the second, if the idea is acceptable, I will 
send a patch instead of this one. (and also alone with the internal 
patch decreasing 208 for the Bman/Qman)

void __init corenet_ds_pic_init(void)
{
     ......

     mpic = mpic_alloc(NULL, 0, flags, 0, 512, "OpenPIC");
     BUG_ON(mpic == NULL);

// Add this start
     for (i = 0; i < 17; i++) {
         if (i < 11)
             addr_off = 0x10000 + 0x20 * 16 * i;
         else
             addr_off = 0x13000 + 0x20 * 16 * (i - 11);  /* scape the 
address not for interrupts */
         mpic_assign_isu(mpic, i, mpic->paddr + addr_off);
     }
// Add this end

     mpic_init(mpic);
}

On 12/07/2013 03:21 AM, Scott Wood wrote:
> On Fri, 2013-11-29 at 16:07 +0800, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> MPIC registers for internal interrupts is non-continous in address, any
>> internal interrupt number greater than 159 should be added (16+208) to work.
>> 16 is due to external interrupts as usual, 208 is due to the non-continous MPIC
>> register space.
>> Tested on T4240 rev2 with SRIO2 disabled.
>>
>> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
>> ---
>>   arch/powerpc/boot/dts/fsl/elo3-dma-2.dtsi |   16 ++++++++--------
>>   1 file changed, 8 insertions(+), 8 deletions(-)
> The FSL MPIC binding should be updated to point out how this works.
>
> Technically it's not a change to the binding itself, since it's defined
> in terms of register offset, but the explanatory text says "So interrupt
> 0 is at offset 0x0, interrupt 1 is at offset 0x20, and so on." which is
> not accurate for these new high interrupt numbers.
>
> -Scott
>
>
>



