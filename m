Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaDWNOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:14:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaDWNOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:14:08 -0400
Date: Wed, 23 Apr 2014 14:14:04 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Weijie Yang <weijieut@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] swap: use separate priority list for available
 swap_infos
Message-ID: <20140423131404.GI23991@suse.de>
References: <alpine.LSU.2.11.1402232344280.1890@eggly.anvils>
 <1397336454-13855-1-git-send-email-ddstreet@ieee.org>
 <1397336454-13855-3-git-send-email-ddstreet@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1397336454-13855-3-git-send-email-ddstreet@ieee.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 05:00:54PM -0400, Dan Streetman wrote:
> Originally get_swap_page() started iterating through the singly-linked
> list of swap_info_structs using swap_list.next or highest_priority_index,
> which both were intended to point to the highest priority active swap
> target that was not full.  The previous patch in this series changed the
> singly-linked list to a doubly-linked list, and removed the logic to start
> at the highest priority non-full entry; it starts scanning at the highest
> priority entry each time, even if the entry is full.
> 
> Add a new list, also priority ordered, to track only swap_info_structs
> that are available, i.e. active and not full.  Use a new spinlock so that
> entries can be added/removed outside of get_swap_page; that wasn't possible
> previously because the main list is protected by swap_lock, which can't be
> taken when holding a swap_info_struct->lock because of locking order.
> The get_swap_page() logic now does not need to hold the swap_lock, and it
> iterates only through swap_info_structs that are available.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
> ---
>  include/linux/swap.h |   1 +
>  mm/swapfile.c        | 128 ++++++++++++++++++++++++++++++++++-----------------
>  2 files changed, 87 insertions(+), 42 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 96662d8..d9263db 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -214,6 +214,7 @@ struct percpu_cluster {
>  struct swap_info_struct {
>  	unsigned long	flags;		/* SWP_USED etc: see above */
>  	signed short	prio;		/* swap priority of this type */
> +	struct list_head prio_list;	/* entry in priority list */
>  	struct list_head list;		/* entry in swap list */
>  	signed char	type;		/* strange name for an index */
>  	unsigned int	max;		/* extent of the swap_map */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index b958645..3c38461 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -57,9 +57,13 @@ static const char Unused_file[] = "Unused swap file entry ";
>  static const char Bad_offset[] = "Bad swap offset entry ";
>  static const char Unused_offset[] = "Unused swap offset entry ";
>  
> -/* all active swap_info */
> +/* all active swap_info; protected with swap_lock */
>  LIST_HEAD(swap_list_head);
>  
> +/* all available (active, not full) swap_info, priority ordered */
> +static LIST_HEAD(prio_head);
> +static DEFINE_SPINLOCK(prio_lock);
> +

I get why you maintain two lists with separate locking but it's code that
is specific to swap and in many respects, it's very similar to a plist. Is
there a reason why plist was not used at least for prio_head? They're used
for futex's so presumably the performance is reasonable. It might reduce
the size of swapfile.c further.

It is the case that plist does not have the equivalent of rotate which
you need to recycle the entries of equal priority but you could add a
plist_shuffle helper that "rotates the list left if the next entry is of
equal priority".

I was going to suggest that you could then get rid of swap_list_head but
it's a relatively big change. swapoff wouldn't care but frontswap would
suffer if it had to walk all of swap_info[] to find all active swap
files.

>  struct swap_info_struct *swap_info[MAX_SWAPFILES];
>  
>  static DEFINE_MUTEX(swapon_mutex);
> @@ -73,6 +77,27 @@ static inline unsigned char swap_count(unsigned char ent)
>  	return ent & ~SWAP_HAS_CACHE;	/* may include SWAP_HAS_CONT flag */
>  }
>  
> +/*
> + * add, in priority order, swap_info (p)->(le) list_head to list (lh)
> + * this list-generic function is needed because both swap_list_head
> + * and prio_head need to be priority ordered:
> + * swap_list_head in swapoff to adjust lower negative prio swap_infos
> + * prio_list in get_swap_page to scan highest prio swap_info first
> + */
> +#define swap_info_list_add(p, lh, le) do {			\
> +	struct swap_info_struct *_si;				\
> +	BUG_ON(!list_empty(&(p)->le));				\
> +	list_for_each_entry(_si, (lh), le) {			\
> +		if ((p)->prio >= _si->prio) {			\
> +			list_add_tail(&(p)->le, &_si->le);	\
> +			break;					\
> +		}						\
> +	}							\
> +	/* lh empty, or p lowest prio */			\
> +	if (list_empty(&(p)->le))				\
> +		list_add_tail(&(p)->le, (lh));			\
> +} while (0)
> +

Why is this a #define instead of a static uninlined function?

That aside, it's again very similar to what a plist does with some
minor structure modifications.

-- 
Mel Gorman
SUSE Labs
