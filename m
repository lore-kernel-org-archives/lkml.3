Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab3A1AHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 19:07:35 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46211 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab3A1AHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 19:07:24 -0500
Date: Mon, 28 Jan 2013 08:07:05 +0800
From: Shaohua Li <shli@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Shaohua Li <shli@fusionio.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] swap: add per-partition lock for swapfile fix
Message-ID: <20130128000705.GA1306@kernel.org>
References: <5101FFF5.6030503@oracle.com>
 <20130125042512.GA32017@kernel.org>
 <alpine.LNX.2.00.1301261754530.7300@eggly.anvils>
 <20130127141253.GA27019@kernel.org>
 <alpine.LNX.2.00.1301271341030.16981@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1301271341030.16981@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 01:47:01PM -0800, Hugh Dickins wrote:
> I had all cpus spinning in swap_info_get(), for the lock on an area
> being swapped off: probably because get_swap_page() forgot to unlock.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Good catch. Thanks!

> ---
> 
>  mm/swapfile.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> --- mmotm.orig/mm/swapfile.c	2013-01-23 17:55:39.132447115 -0800
> +++ mmotm/mm/swapfile.c	2013-01-27 10:41:45.000000000 -0800
> @@ -470,10 +470,9 @@ swp_entry_t get_swap_page(void)
>  		spin_unlock(&swap_lock);
>  		/* This is called for allocating swap entry for cache */
>  		offset = scan_swap_map(si, SWAP_HAS_CACHE);
> -		if (offset) {
> -			spin_unlock(&si->lock);
> +		spin_unlock(&si->lock);
> +		if (offset)
>  			return swp_entry(type, offset);
> -		}
>  		spin_lock(&swap_lock);
>  		next = swap_list.next;
>  	}
