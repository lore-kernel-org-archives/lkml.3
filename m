Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbaJXSui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 14:50:38 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:55406 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891AbaJXSuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 14:50:35 -0400
Message-ID: <544A9F6F.4090607@gmail.com>
Date: Fri, 24 Oct 2014 20:50:23 +0200
From: Corentin LABBE <clabbe.montjoie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        grant.likely@linaro.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, joe@perches.com, mchehab@osg.samsung.com,
        crope@iki.fi, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [linux-sunxi] Re: [PATCH v5 4/4] crypto: Add Allwinner Security
 System crypto accelerator
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com> <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com> <2751026.4HEPlZfN7W@wuerfel>
In-Reply-To: <2751026.4HEPlZfN7W@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 22/10/2014 11:00, Arnd Bergmann a écrit :
> On Sunday 19 October 2014 16:16:22 LABBE Corentin wrote:
>> Add support for the Security System included in Allwinner SoC A20.
>> The Security System is a hardware cryptographic accelerator that support AES/MD5/SHA1/DES/3DES/PRNG algorithms.
>>
>> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> 
> Please wrap lines in the changelog after about 70 characters.
> 

Oups I just see the corresponding part in submittingpatches.txt
Sorry

>> --- /dev/null
>> +++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
>> @@ -0,0 +1,489 @@
> 
>> +#include "sunxi-ss.h"
>> +
>> +extern struct sunxi_ss_ctx *ss;
> 
> 'extern' declarations belong into header files, not .c files. It would
> be even better to avoid this completely and carry the pointer to the
> context in an object that gets passed around. In general we want drivers
> to be written in a way that allows having multiple instances of the
> device, which the global pointer prevents.
> 

As I already said I think the driver will never be used with multiple instance.
But since many people want this pointer dead, I will work on it.

>> +
>> +	src32 = (u32 *)src_addr;
>> +	dst32 = (u32 *)dst_addr;
> 
> 
> You appear to be missing '__iomem' annotations for the mmio pointers.
> Please always run your code through the 'sparse' checker using 'make C=1'
> to catch and fix this and other erros.
> 

Ok, but with which version of sparse do you have such a warning. I use the 0.5.0 version and I got no warning at all.

>> +	ileft = areq->nbytes / 4;
>> +	oleft = areq->nbytes / 4;
>> +	i = 0;
>> +	do {
>> +		if (ileft > 0 && rx_cnt > 0) {
>> +			todo = min(rx_cnt, ileft);
>> +			ileft -= todo;
>> +			do {
>> +				writel_relaxed(*src32++,
>> +						ss->base +
>> +						SS_RXFIFO);
>> +				todo--;
>> +			} while (todo > 0);
>> +		}
> 
> This looks like it should be using writesl() instead of the 
> writel_relaxed() loop. That should not only be faster but it will
> also change the byte ordering if you are running a big-endian
> kernel.
> 
> Since this is a FIFO register, the ordering that writesl uses
> is likely the correct one.

Great, the code is much cleaner with it. (with up to 10% speed gain)

Thanks

Corentin


