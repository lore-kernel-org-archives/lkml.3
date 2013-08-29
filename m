Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3H2F4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 01:56:08 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:60246 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab3H2F4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 01:56:06 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Joern Rennecke" <joern.rennecke@embecosm.com>,
        joe perches <joe@perches.com>
Subject: Re: [PATCH] ARC: Fix __udelay parentheses
Thread-Topic: [PATCH] ARC: Fix __udelay parentheses
Thread-Index: AQHOpByfrbiZ1kbBskyi3sxdeiKfdQ==
Date: Thu, 29 Aug 2013 05:55:11 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075140F26@IN01WEMBXA.internal.synopsys.com>
References: <1377714588-2144-1-git-send-email-mjonker@synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 12:00 AM, Mischa Jonker wrote:
> Make sure that usecs is casted to long long, to ensure that the
> (usecs * 4295 * HZ) multiplication is 64 bit.
>
> Initially, the (usecs * 4295 * HZ) part was done as a 32 bit
> multiplication, with the result casted to 64 bit. This led to some bits
> falling off.
>
> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
> ---
>  arch/arc/include/asm/delay.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arc/include/asm/delay.h b/arch/arc/include/asm/delay.h
> index 442ce5d..8d35fe1 100644
> --- a/arch/arc/include/asm/delay.h
> +++ b/arch/arc/include/asm/delay.h
> @@ -56,8 +56,8 @@ static inline void __udelay(unsigned long usecs)
>  	/* (long long) cast ensures 64 bit MPY - real or emulated
>  	 * HZ * 4295 is pre-evaluated by gcc - hence only 2 mpy ops
>  	 */
> -	loops = ((long long)(usecs * 4295 * HZ) *
> -		 (long long)(loops_per_jiffy)) >> 32;
> +	loops = (((long long) usecs) * 4295 * HZ *
> +		  (long long) loops_per_jiffy) >> 32;
>  
>  	__delay(loops);
>  }

The intent of writing orig code was to generate only 1 MPYHU insn (32*32 =
high-part-64) for the whole math, at any optimization level whatsoever. If the
first MPY is overflowing, u r likely spinning for > 10,000 usec (10ms) which is 1
scheduling tick on ARC - not good - presumably for hardware debug. It would be
better to use a tight loop there and throw it out later.

The API abuse would only be caught for const @usecs case. Maybe we need to add a
WARN_ON() there.

OTOH, if we really want to fix this, it would be cleaner to rewrite this as
    loops = ((u64)usecs * 4295 * HZ * loops_per_jiffy) >> 32;

Since one factor is upcasted, all are promoted to 64 bit. And we leave the
optimizations to whims of gcc.

@Joern, I would assume that long long vs u64 (or unsigned long long) doesn't
matter in this particular case.

-Vineet
