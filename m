Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab3EHUga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:36:30 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:39432 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330Ab3EHUg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:36:28 -0400
Message-ID: <518AB74B.50401@inktank.com>
Date: Wed, 08 May 2013 15:36:27 -0500
From: Alex Elder <elder@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rbd: Use min_t() to fix comparison of distinct pointer
 types warning
References: <1368043353-21896-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1368043353-21896-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 03:02 PM, Geert Uytterhoeven wrote:
> drivers/block/rbd.c: In function ‘zero_pages’:
> drivers/block/rbd.c:1102: warning: comparison of distinct pointer types lacks a cast
> 
> Remove the hackish casts and use min_t() to fix this.

Looks good to me.  I'm not sure why I didn't use that to
begin with.

I'll pull this into the ceph tree.  Thanks a lot.

Reviewed-by: Alex Elder <elder@inktank.com>

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/block/rbd.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 22ffd5d..1318c6b 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1098,8 +1098,8 @@ static void zero_pages(struct page **pages, u64 offset, u64 end)
>  		unsigned long flags;
>  		void *kaddr;
>  
> -		page_offset = (size_t)(offset & ~PAGE_MASK);
> -		length = min(PAGE_SIZE - page_offset, (size_t)(end - offset));
> +		page_offset = offset & ~PAGE_MASK;
> +		length = min_t(size_t, PAGE_SIZE - page_offset, end - offset);
>  		local_irq_save(flags);
>  		kaddr = kmap_atomic(*page);
>  		memset(kaddr + page_offset, 0, length);
> 

