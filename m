Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab3BTKk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:40:29 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35207 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759136Ab3BTKk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:40:27 -0500
Message-ID: <1361356823.2581.43.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] [SCSI] aacraid: silence two GCC warnings
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Feb 2013 10:40:23 +0000
In-Reply-To: <1360440561.1350.27.camel@x61.thuisdomein>
References: <1360440561.1350.27.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-09 at 21:09 +0100, Paul Bolle wrote:
> Compiling src.o for a 32 bit system triggers two GCC warnings:
>     drivers/scsi/aacraid/src.c: In function ‘aac_src_deliver_message’:
>     drivers/scsi/aacraid/src.c:410:3: warning: right shift count >= width of type [enabled by default]
>     drivers/scsi/aacraid/src.c:434:2: warning: right shift count >= width of type [enabled by default]
> 
> Silence these warnings by casting the 'address' variable (of type
> dma_addr_t) to u64 on those two lines.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Compile tested only.
> 
> 1) Changing '0L' to 'OUL' might be a bit of cargo cult programming. I
> doubt it's necessary. Members of that cult might also change
> '0xffffffff' to '0xffffffffUL', but I didn't.
> 
>  drivers/scsi/aacraid/src.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index 3b021ec..dfa8a37 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -407,7 +407,7 @@ static int aac_src_deliver_message(struct fib *fib)
>  		fib->hw_fib_va->header.StructType = FIB_MAGIC2;
>  		fib->hw_fib_va->header.SenderFibAddress = (u32)address;
>  		fib->hw_fib_va->header.u.TimeStamp = 0;
> -		BUG_ON((u32)(address >> 32) != 0L);
> +		BUG_ON(((u64)address >> 32) != 0UL);

Actually, this isn't the right way to do this.  The correct way would be
address >> 16 >> 16, but no-one is expected to remember this, so we have
it macroised in kernel.h as upper_32_bits().

So this should become

BUG_ON(upper_32_bits(address) != 0L);

and a similar change for the below.

James

>  		address |= fibsize;
>  	} else {
>  		/* Calculate the amount to the fibsize bits */
> @@ -431,7 +431,7 @@ static int aac_src_deliver_message(struct fib *fib)
>  		address |= fibsize;
>  	}
>  
> -	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
> +	src_writel(dev, MUnit.IQ_H, ((u64)address >> 32) & 0xffffffff);
>  	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
>  
>  	return 0;


