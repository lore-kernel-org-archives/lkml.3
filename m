Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaLEM2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:28:19 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:63522 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaLEM2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:28:17 -0500
Message-ID: <5481A4DE.8040803@cogentembedded.com>
Date: Fri, 05 Dec 2014 15:28:14 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC][PATCH 07/13] iov_iter.c: get rid of bvec_copy_page_{to,from}_iter()
References: <20141204202011.GO29748@ZenIV.linux.org.uk> <1417724597-17099-7-git-send-email-viro@ZenIV.linux.org.uk>
In-Reply-To: <1417724597-17099-7-git-send-email-viro@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/4/2014 11:23 PM, Al Viro wrote:

    Looks like you've erred in the subject as you seem to be getting rid of 
copy_page_{to|from}_iter_bvec() instead of bvec_copy_page_{to|from}_iter()...

> From: Al Viro <viro@zeniv.linux.org.uk>

> Just have copy_page_{to,from}_iter() fall back to kmap_atomic +
> copy_{to,from}_iter() + kunmap_atomic() in ITER_BVEC case.  As
> the matter of fact, that's what we want to do for any iov_iter
> kind that isn't blocking - e.g. ITER_KVEC will also go that way
> once we recognize it on iov_iter.c primitives level

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>   mm/iov_iter.c | 60 ++++++++++++++++++++++++-----------------------------------
>   1 file changed, 24 insertions(+), 36 deletions(-)

> diff --git a/mm/iov_iter.c b/mm/iov_iter.c
> index 39ad713..17b7144 100644
> --- a/mm/iov_iter.c
> +++ b/mm/iov_iter.c
> @@ -486,30 +486,33 @@ static size_t copy_from_iter_bvec(void *to, size_t bytes, struct iov_iter *i)
>   	return wanted;
>   }
>
> -static size_t copy_page_to_iter_bvec(struct page *page, size_t offset,
> -					size_t bytes, struct iov_iter *i)
> +size_t copy_to_iter(void *addr, size_t bytes, struct iov_iter *i)
>   {
> -	void *kaddr = kmap_atomic(page);
> -	size_t wanted = copy_to_iter_bvec(kaddr + offset, bytes, i);
> -	kunmap_atomic(kaddr);
> -	return wanted;
> +	if (i->type & ITER_BVEC)
> +		return copy_to_iter_bvec(addr, bytes, i);
> +	else
> +		return copy_to_iter_iovec(addr, bytes, i);
>   }
> +EXPORT_SYMBOL(copy_to_iter);
>
> -static size_t copy_page_from_iter_bvec(struct page *page, size_t offset,
> -					size_t bytes, struct iov_iter *i)
> +size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
>   {
> -	void *kaddr = kmap_atomic(page);
> -	size_t wanted = copy_from_iter_bvec(kaddr + offset, bytes, i);
> -	kunmap_atomic(kaddr);
> -	return wanted;
> +	if (i->type & ITER_BVEC)
> +		return copy_from_iter_bvec(addr, bytes, i);
> +	else
> +		return copy_from_iter_iovec(addr, bytes, i);
>   }
> +EXPORT_SYMBOL(copy_from_iter);
[...]

WBR, Sergei

