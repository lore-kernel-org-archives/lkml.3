Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3JHRPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:15:53 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57458 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3JHRPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:15:50 -0400
Message-ID: <1381252547.12191.58.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] core: Catch overflows in do_div() function
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, rdunlap@infradead.org
Date: Tue, 08 Oct 2013 10:15:47 -0700
In-Reply-To: <1381248622-27809-1-git-send-email-anatol.pomozov@gmail.com>
References: <CAOMFOmXfw2DkesOYip9VFDdUQgVN48qbJfuertPaSCz5aGdaeA@mail.gmail.com>
	 <1381248622-27809-1-git-send-email-anatol.pomozov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 09:10 -0700, Anatol Pomozov wrote:
> If second parameter passed to this function was 64 then it silently
> truncates to 32 bits. Catch such situation.
> 
> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
> ---
>  include/asm-generic/div64.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/asm-generic/div64.h b/include/asm-generic/div64.h
> index 8f4e319..84339a0 100644
> --- a/include/asm-generic/div64.h
> +++ b/include/asm-generic/div64.h
> @@ -17,6 +17,7 @@
>   *       beware of side effects!
>   */
>  
> +#include <linux/bug.h>
>  #include <linux/types.h>
>  #include <linux/compiler.h>
>  
> @@ -25,6 +26,7 @@
>  # define do_div(n,base) ({					\
>  	uint32_t __base = (base);				\
>  	uint32_t __rem;						\
> +	BUG_ON(sizeof(base) > 4 && base >= (1UL<<32));		\

Problem is about

uint32_t __base = (base);

This was designed to avoid "base" being evaluated twice, as in

do_div(X, ++Y);

So I guess you need something to keep this in place.

 


