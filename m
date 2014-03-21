Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbaCUQmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:42:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46069 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaCUQmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:42:16 -0400
Message-ID: <532C6BE2.2010808@infradead.org>
Date: Fri, 21 Mar 2014 09:42:10 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
CC: Mark Brown <broonie@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-spi@vger.kernel.org, Wenyou Yang <wenyou.yang@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: rfc: vsprintf and phys_addr_t and dma_addr_t via %pa (was Re:
 [PATCH] spi: fix spi-atmel.c printk format warnings)
References: <532C6085.9070203@infradead.org> <1395419839.7776.108.camel@joe-AO722>
In-Reply-To: <1395419839.7776.108.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 09:37 AM, Joe Perches wrote:
> (Adding Stepan Moskovchenko who added %pa to vsprintf)
> 
> On Fri, 2014-03-21 at 08:53 -0700, Randy Dunlap wrote:
>> Fix printk format warning by using %p extension 'ad' for dma_addr_t.
> 
> Hey Randy, Stepan and everyone else as well.
> 
> One of the things I'd like to get straightened out
> before too many of these dma_addr_t conversions are
> done is whether or not it should be prefixed by 0x.
> 
> %pad is not a direct replacement for %08x or %016x.
> It changes the output.
> 
> Right now, all phys_addr_t and dma_addr_t types emitted
> using %pa[pd] are "SPECIAL", meaning these are prefixed
> with "0x".
> 
> No other pointer/address types have that "0x" prefix.
> 
> I'd prefer to remove the "SPECIAL" from the %pa extension
> so that the output form of pointer/address types are
> consistent.

I agree.

for Joe's patch:
Acked-by: Randy Dunlap <rdunlap@infradead.org>

> This would change several output lines already using %pa.
> 
> I don't think that's bad, but maybe others do.
> 
> Thoughts?
> 
> ---
>  lib/vsprintf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 185b6d3..28fee91 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1161,18 +1161,18 @@ char *address_val(char *buf, char *end, const void *addr,
>  {
>  	unsigned long long num;
>  
> -	spec.flags |= SPECIAL | SMALL | ZEROPAD;
> +	spec.flags |= SMALL | ZEROPAD;
>  	spec.base = 16;
>  
>  	switch (fmt[1]) {
>  	case 'd':
>  		num = *(const dma_addr_t *)addr;
> -		spec.field_width = sizeof(dma_addr_t) * 2 + 2;
> +		spec.field_width = sizeof(dma_addr_t) * 2;
>  		break;
>  	case 'p':
>  	default:
>  		num = *(const phys_addr_t *)addr;
> -		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
> +		spec.field_width = sizeof(phys_addr_t) * 2;
>  		break;
>  	}
>  
> 
> 
>> drivers/spi/spi-atmel.c:1228:3: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]
>> drivers/spi/spi-atmel.c:1228:3: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Wenyou Yang <wenyou.yang@atmel.com>
>> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  drivers/spi/spi-atmel.c |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> I thought that a patch for this was already posted but I can't find it...
>> Applies to mainline.
>>
>> --- linux-next-20140321.orig/drivers/spi/spi-atmel.c
>> +++ linux-next-20140321/drivers/spi/spi-atmel.c
>> @@ -1226,10 +1226,10 @@ static int atmel_spi_transfer_one_messag
>>  
>>  	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
>>  		dev_dbg(&spi->dev,
>> -			"  xfer %p: len %u tx %p/%08x rx %p/%08x\n",
>> +			"  xfer %p: len %u tx %p/%pad rx %p/%pad\n",
>>  			xfer, xfer->len,
>> -			xfer->tx_buf, xfer->tx_dma,
>> -			xfer->rx_buf, xfer->rx_dma);
>> +			xfer->tx_buf, &xfer->tx_dma,
>> +			xfer->rx_buf, &xfer->rx_dma);
>>  	}
> 
> 
> --


-- 
~Randy
