Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaAVHBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 02:01:21 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37761 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaAVHBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 02:01:19 -0500
Date: Tue, 21 Jan 2014 23:00:44 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jamie Liu <jamieliu@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@fusionio.com>,
        Minchan Kim <minchan@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swap: do not skip lowest_bit in scan_swap_map() scan
 loop
In-Reply-To: <1390357276-16521-1-git-send-email-jamieliu@google.com>
Message-ID: <alpine.LSU.2.11.1401212251310.1001@eggly.anvils>
References: <1390357276-16521-1-git-send-email-jamieliu@google.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014, Jamie Liu wrote:

> In the second half of scan_swap_map()'s scan loop, offset is set to
> si->lowest_bit and then incremented before entering the loop for the
> first time, causing si->swap_map[si->lowest_bit] to be skipped.
> 
> Signed-off-by: Jamie Liu <jamieliu@google.com>

Acked-by: Hugh Dickins <hughd@google.com>

Good catch.  At first I was puzzled that this off-by-one could have
gone unnoticed for so long (ever since 2.6.29); but now I think that
almost always we have a good amount of slack, in those pages duplicated
between swap and swapcache, which can be reclaimed at the vm_swap_full()
check, and so conceal this loss of a single slot.

> ---
>  mm/swapfile.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 612a7c9..6635081 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -616,7 +616,7 @@ scan:
>  		}
>  	}
>  	offset = si->lowest_bit;
> -	while (++offset < scan_base) {
> +	while (offset < scan_base) {
>  		if (!si->swap_map[offset]) {
>  			spin_lock(&si->lock);
>  			goto checks;
> @@ -629,6 +629,7 @@ scan:
>  			cond_resched();
>  			latency_ration = LATENCY_LIMIT;
>  		}
> +		offset++;
>  	}
>  	spin_lock(&si->lock);
>  
> -- 
> 1.8.5.3
> 
> 
