Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3BEQsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:48:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572Ab3BEQs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:48:27 -0500
Date: Tue, 5 Feb 2013 16:48:23 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/11] ksm: reorganize ksm_check_stable_tree
Message-ID: <20130205164823.GJ21389@suse.de>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils>
 <alpine.LNX.2.00.1301251758190.29196@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1301251758190.29196@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 05:59:35PM -0800, Hugh Dickins wrote:
> Memory hotremove's ksm_check_stable_tree() is pitifully inefficient
> (restarting whenever it finds a stale node to remove), but rearrange
> so that at least it does not needlessly restart from nid 0 each time.
> And add a couple of comments: here is why we keep pfn instead of page.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
>  mm/ksm.c |   38 ++++++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 16 deletions(-)
> 
> --- mmotm.orig/mm/ksm.c	2013-01-25 14:36:52.152205940 -0800
> +++ mmotm/mm/ksm.c	2013-01-25 14:36:53.244205966 -0800
> @@ -1830,31 +1830,36 @@ void ksm_migrate_page(struct page *newpa
>  #endif /* CONFIG_MIGRATION */
>  
>  #ifdef CONFIG_MEMORY_HOTREMOVE
> -static struct stable_node *ksm_check_stable_tree(unsigned long start_pfn,
> -						 unsigned long end_pfn)
> +static void ksm_check_stable_tree(unsigned long start_pfn,
> +				  unsigned long end_pfn)
>  {
> +	struct stable_node *stable_node;
>  	struct rb_node *node;
>  	int nid;
>  
> -	for (nid = 0; nid < nr_node_ids; nid++)
> -		for (node = rb_first(&root_stable_tree[nid]); node;
> -				node = rb_next(node)) {
> -			struct stable_node *stable_node;
> -
> +	for (nid = 0; nid < nr_node_ids; nid++) {
> +		node = rb_first(&root_stable_tree[nid]);
> +		while (node) {

This is not your fault, the old code is wrong too. It is assuming that all
nodes are populated in numeric orders with no holes. It won't work if just
two nodes 0 and 4 are online. It should be using for_each_online_node().

-- 
Mel Gorman
SUSE Labs
