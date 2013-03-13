Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817Ab3CMP5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:57:31 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:55167 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab3CMP5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:57:30 -0400
Message-ID: <5140A1C0.8060503@linux.vnet.ibm.com>
Date: Wed, 13 Mar 2013 10:56:48 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>, minchan@kernel.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Bob Liu <lliubbo@gmail.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: zsmalloc limitations and related topics
References: <0efe9610-1aa5-4aa9-bde9-227acfa969ca@default> <20130313151359.GA3130@linux.vnet.ibm.com> <51409C65.1040207@linux.vnet.ibm.com>
In-Reply-To: <51409C65.1040207@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031315-0260-0000-0000-000002A99BD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 10:33 AM, Seth Jennings wrote:
> The periodic writeback that Rob mentions would go something like this
> for zswap:
> 
> ---
>  mm/filemap.c |    3 +--
>  mm/zswap.c   |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 59 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 83efee7..fe63e95 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -735,12 +735,11 @@ repeat:
>  	if (page && !radix_tree_exception(page)) {
>  		lock_page(page);
>  		/* Has the page been truncated? */
> -		if (unlikely(page->mapping != mapping)) {
> +		if (unlikely(page_mapping(page) != mapping)) {
>  			unlock_page(page);
>  			page_cache_release(page);
>  			goto repeat;
>  		}
> -		VM_BUG_ON(page->index != offset);

A little followup here, previously we were using find_get_page() in
zswap_get_swap_cache_page() and if the page was already in the swap
cache, then we aborted the writeback of that entry.  However, if we do
wish to write the page back, as is the case in periodic writeback, we
must find _and_ lock it which suggests using find_lock_page() instead.

My first attempt to just do a s/find_get_page/find_lock_page/ failed
because, for entries that were already in the swap cache, we would hang
in the repeat loop of find_lock_page() forever because page->mapping of
pages in the swap cache is not set to &swapper_space.

However, there is logic in the page_mapping() function to handle swap
cache entries, hence the change here.

Also page->index != offset for swap cache pages so I just took out the
VM_BUG_ON().

Another solution would be to just set the mapping and index fields of
swap cache pages, if those fields (or fields in the same union) aren't
being used already.

Seth

