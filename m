Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaKRVlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:41:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaKRVlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:41:12 -0500
Date: Tue, 18 Nov 2014 13:41:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: konrad.wilk@oracle.com, "'Seth Jennings'" <sjennings@variantweb.net>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Minchan Kim'" <minchan@kernel.org>, "'Bob Liu'" <bob.liu@oracle.com>,
        xfishcoder@gmail.com, "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: frontswap: invalidate expired data on a dup-store
 failure
Message-Id: <20141118134110.d5e17eec0ff90ff8c957fffd@linux-foundation.org>
In-Reply-To: <000001d0030d$0505aaa0$0f10ffe0$%yang@samsung.com>
References: <000001d0030d$0505aaa0$0f10ffe0$%yang@samsung.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 16:51:36 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:

> If a frontswap dup-store failed, it should invalidate the expired page
> in the backend, or it could trigger some data corruption issue.
> Such as:
> 1. use zswap as the frontswap backend with writeback feature
> 2. store a swap page(version_1) to entry A, success
> 3. dup-store a newer page(version_2) to the same entry A, fail
> 4. use __swap_writepage() write version_2 page to swapfile, success
> 5. zswap do shrink, writeback version_1 page to swapfile
> 6. version_2 page is overwrited by version_1, data corrupt.
> 
> This patch fixes this issue by invalidating expired data immediately
> when meet a dup-store failure.
> 
> ...
>
> --- a/mm/frontswap.c
> +++ b/mm/frontswap.c
> @@ -244,8 +244,10 @@ int __frontswap_store(struct page *page)
>  		  the (older) page from frontswap
>  		 */
>  		inc_frontswap_failed_stores();
> -		if (dup)
> +		if (dup) {
>  			__frontswap_clear(sis, offset);
> +			frontswap_ops->invalidate_page(type, offset);
> +		}
>  	}
>  	if (frontswap_writethrough_enabled)
>  		/* report failure so swap also writes to swap device */

I tagged this for backporting into -stable kernels.  Please shout at me
if you think that was inappropriate.

