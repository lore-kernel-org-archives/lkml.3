Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab3HGKdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:33:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43120 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757269Ab3HGKdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:33:35 -0400
Message-ID: <1375871614.2424.103.camel@joe-AO722>
Subject: Re: [PATCH] bitops: move BITS() macro to the bitops file
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Akinobu Mita <mita@miraclelinux.com>
Date: Wed, 07 Aug 2013 03:33:34 -0700
In-Reply-To: <1375866379-27504-1-git-send-email-linus.walleij@linaro.org>
References: <1375866379-27504-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 11:06 +0200, Linus Walleij wrote:
> This macro was invented by Mattias Nilsson for the usecase
> where you want to set a sequence of bits inside a n-bit
> word, while leaving the head and tail of the sequence all
> zeroes. For example:
> 
>   #include <linux/bitops.h>

BITS is a name that's not easily reused because it's
already in use in a few other places.

There are a few conflicts.

$ git grep -E "^\s*#\s*define\s+\bBITS\b"
arch/arc/include/asm/disasm.h:#define BITS(word, s, e)  (((word) >> (s)) & (~((-2) << ((e) - (s)))))
drivers/input/keyboard/tnetv107x-keypad.c:#define BITS(x)                       (BIT(x) - 1)
drivers/mfd/dbx500-prcmu-regs.h:#define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))
drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h:#define BITS(nb) (BIT(nb) - 1)
fs/select.c:#define BITS(fds, n)        (*FDS_IN(fds, n)|*FDS_OUT(fds, n)|*FDS_EX(fds, n))
lib/zlib_inflate/inflate.c:#define BITS(n) \
sound/core/oss/rate.c:#define BITS      (1<<SHIFT)

>   u16 mask = BITS(4, 12);
> 
> Yields a mask like this:
> 
>   0001111111110000
[]
> diff --git a/drivers/mfd/dbx500-prcmu-regs.h b/drivers/mfd/dbx500-prcmu-regs.h
[]
> @@ -13,8 +13,6 @@
[]
> -#define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))

> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
[]
> @@ -6,6 +6,7 @@
[]
> +#define BITS(_start, _end)	((BIT(_end) - BIT(_start)) + BIT(_end))

Maybe use a statement expression to make sure
the start and end accesses are done only once.

#define BITS(start, end)				\
({							\
	unsigned long high = BIT(end);			\
	unsigned long low = BIT(start);			\
	unsigned long rtn = high + (high - low);	\
	rtn;						\
})

I suggest | instead of + too.

Maybe add a WARN when low > high too.
Maybe make it a function to consolidate
any WARN instead of inline expansion.


