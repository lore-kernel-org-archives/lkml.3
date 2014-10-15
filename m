Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaJOUFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:05:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaJOUFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:05:44 -0400
Date: Wed, 15 Oct 2014 13:05:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jamie Liu <jamieliu@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: count only dirty pages as congested
Message-Id: <20141015130544.380aca0acfcb1413459520b0@linux-foundation.org>
In-Reply-To: <1413403115-1551-1-git-send-email-jamieliu@google.com>
References: <1413403115-1551-1-git-send-email-jamieliu@google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014 12:58:35 -0700 Jamie Liu <jamieliu@google.com> wrote:

> shrink_page_list() counts all pages with a mapping, including clean
> pages, toward nr_congested if they're on a write-congested BDI.
> shrink_inactive_list() then sets ZONE_CONGESTED if nr_dirty ==
> nr_congested. Fix this apples-to-oranges comparison by only counting
> pages for nr_congested if they count for nr_dirty.
> 
> ...
>
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -875,7 +875,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  		 * end of the LRU a second time.
>  		 */
>  		mapping = page_mapping(page);
> -		if ((mapping && bdi_write_congested(mapping->backing_dev_info)) ||
> +		if (((dirty || writeback) && mapping &&
> +		     bdi_write_congested(mapping->backing_dev_info)) ||
>  		    (writeback && PageReclaim(page)))
>  			nr_congested++;

What are the observed runtime effects of this change?
