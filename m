Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab3E3Oks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:40:48 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:49757 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932733Ab3E3Okp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:40:45 -0400
Date: Thu, 30 May 2013 15:40:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: majianpeng <majianpeng@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] mm/kmemleak.c: Use list_for_each_entry_safe to
 reconstruct function scan_gray_list
Message-ID: <20130530144028.GF23631@arm.com>
References: <519224D8.5090704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519224D8.5090704@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 12:49:44PM +0100, majianpeng wrote:
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  mm/kmemleak.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index b1525db..f0ece93 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -1225,22 +1225,16 @@ static void scan_gray_list(void)
>  	 * from inside the loop. The kmemleak objects cannot be freed from
>  	 * outside the loop because their use_count was incremented.
>  	 */
> -	object = list_entry(gray_list.next, typeof(*object), gray_list);
> -	while (&object->gray_list != &gray_list) {
> +	list_for_each_entry_safe(object, tmp, &gray_list, gray_list) {
>  		cond_resched();
>  
>  		/* may add new objects to the list */
>  		if (!scan_should_stop())
>  			scan_object(object);
>  
> -		tmp = list_entry(object->gray_list.next, typeof(*object),
> -				 gray_list);
> -
>  		/* remove the object from the list and release it */
>  		list_del(&object->gray_list);
>  		put_object(object);
> -
> -		object = tmp;
>  	}
>  	WARN_ON(!list_empty(&gray_list));

I tried this patch for a few days and I hit the WARN_ON after the loop.
During scanning, new entries may be added at the end of the loop but we
need to loop until all the entries have been removed. I probably had a
reason why I had the 'while' loop.

The key difference is that list_for_each_entry_safe() gets the next
entry (n or tmp above) before scan_object() and it may hit the end of
the list. However, scan_object() may do a list_add_tail(&gray_list)
hence we need to get the next entry after this function.

Basically list_for_each_entry_safe() is not safe with tail additions.
I'll revert this patch (hasn't reached mainline anyway).

Thanks.

-- 
Catalin
