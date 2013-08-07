Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab3HGKMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:12:50 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:57515 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab3HGKMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:12:49 -0400
MIME-Version: 1.0
In-Reply-To: <1375866379-27504-1-git-send-email-linus.walleij@linaro.org>
References: <1375866379-27504-1-git-send-email-linus.walleij@linaro.org>
Date: Wed, 7 Aug 2013 15:42:48 +0530
Message-ID: <CAK7N6vrG0Ztio1oyfuG3qShOus7oz_ec8sGTtQ2E10uO3Bxn3Q@mail.gmail.com>
Subject: Re: [PATCH] bitops: move BITS() macro to the bitops file
From: anish singh <anish198519851985@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>,
        Akinobu Mita <mita@miraclelinux.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 2:36 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> This macro was invented by Mattias Nilsson for the usecase
> where you want to set a sequence of bits inside a n-bit
> word, while leaving the head and tail of the sequence all
> zeroes. For example:
>
>   #include <linux/bitops.h>
>
>   u16 mask = BITS(4, 12);

nice.I don't have anything against this patch but couldn't understand
how this works.So i wrote what i knew as below:

#include <stdio.h>

#define BIT(nr)                        (1UL << (nr))
#define BITS(_start, _end)     ((BIT(_end) - BIT(_start)) + BIT(_end))
#define BITS_MY(_start, _end) (((BIT(_end-_start+1))-1)<<_start)
int main()
{
        printf("%x\n", BITS(4,12));
        printf("%x\n", BITS_MY(4,12));
        return 0;
}

>
> Yields a mask like this:
>
>   0001111111110000
>
> This patch moves the construct out of the MFD PRCMU driver
> and make it available for common use, after noticing in a
> review or two that it would be useful for others.
>
> Cc: Akinobu Mita <mita@miraclelinux.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/dbx500-prcmu-regs.h | 2 --
>  include/linux/bitops.h          | 1 +
>  2 files changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/mfd/dbx500-prcmu-regs.h b/drivers/mfd/dbx500-prcmu-regs.h
> index 4f6f0fa..906e75e 100644
> --- a/drivers/mfd/dbx500-prcmu-regs.h
> +++ b/drivers/mfd/dbx500-prcmu-regs.h
> @@ -13,8 +13,6 @@
>  #ifndef __DB8500_PRCMU_REGS_H
>  #define __DB8500_PRCMU_REGS_H
>
> -#define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))
> -
>  #define PRCM_ACLK_MGT          (0x004)
>  #define PRCM_SVAMMCSPCLK_MGT   (0x008)
>  #define PRCM_SIAMMDSPCLK_MGT   (0x00C)
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index a3b6b82..1f9d78b 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -6,6 +6,7 @@
>  #define BIT(nr)                        (1UL << (nr))
>  #define BIT_MASK(nr)           (1UL << ((nr) % BITS_PER_LONG))
>  #define BIT_WORD(nr)           ((nr) / BITS_PER_LONG)
> +#define BITS(_start, _end)     ((BIT(_end) - BIT(_start)) + BIT(_end))

Shouldn't there be compile time check here for checking _end > _start?
BUILD_BUG_ON(_end<_start);

>  #define BITS_PER_BYTE          8
>  #define BITS_TO_LONGS(nr)      DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
>  #endif
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
