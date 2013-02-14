Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653Ab3BNUj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:39:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab3BNUj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:39:28 -0500
Date: Thu, 14 Feb 2013 12:39:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Rob van der Heij <rvdheij@gmail.com>, Hugh Dickins <hughd@google.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: fadvise: Drain all pagevecs if POSIX_FADV_DONTNEED
 fails to discard all pages
Message-Id: <20130214123926.599fcef8.akpm@linux-foundation.org>
In-Reply-To: <20130214120349.GD7367@suse.de>
References: <20130214120349.GD7367@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2013 12:03:49 +0000
Mel Gorman <mgorman@suse.de> wrote:

> Rob van der Heij reported the following (paraphrased) on private mail.
> 
> 	The scenario is that I want to avoid backups to fill up the page
> 	cache and purge stuff that is more likely to be used again (this is
> 	with s390x Linux on z/VM, so I don't give it as much memory that
> 	we don't care anymore). So I have something with LD_PRELOAD that
> 	intercepts the close() call (from tar, in this case) and issues
> 	a posix_fadvise() just before closing the file.
> 
> 	This mostly works, except for small files (less than 14 pages)
> 	that remains in page cache after the face.

Sigh.  We've had the "my backups swamp pagecache" thing for 15 years
and it's still happening.

It should be possible nowadays to toss your backup application into a
container to constrain its pagecache usage.  So we can type

	run-in-a-memcg -m 200MB /my/backup/program

and voila.  Does such a script exist and work?

> --- a/mm/fadvise.c
> +++ b/mm/fadvise.c
> @@ -17,6 +17,7 @@
>  #include <linux/fadvise.h>
>  #include <linux/writeback.h>
>  #include <linux/syscalls.h>
> +#include <linux/swap.h>
>  
>  #include <asm/unistd.h>
>  
> @@ -120,9 +121,22 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>  		start_index = (offset+(PAGE_CACHE_SIZE-1)) >> PAGE_CACHE_SHIFT;
>  		end_index = (endbyte >> PAGE_CACHE_SHIFT);
>  
> -		if (end_index >= start_index)
> -			invalidate_mapping_pages(mapping, start_index,
> +		if (end_index >= start_index) {
> +			unsigned long count = invalidate_mapping_pages(mapping,
> +						start_index, end_index);
> +
> +			/*
> +			 * If fewer pages were invalidated than expected then
> +			 * it is possible that some of the pages were on
> +			 * a per-cpu pagevec for a remote CPU. Drain all
> +			 * pagevecs and try again.
> +			 */
> +			if (count < (end_index - start_index + 1)) {
> +				lru_add_drain_all();
> +				invalidate_mapping_pages(mapping, start_index,
>  						end_index);
> +			}
> +		}
>  		break;
>  	default:
>  		ret = -EINVAL;

Those LRU pagevecs are a right pain.  They provided useful gains way
back when I first inflicted them upon Linux, but it would be nice to
confirm whether they're still worthwhile and if so, whether the
benefits can be replicated with some less intrusive scheme.

