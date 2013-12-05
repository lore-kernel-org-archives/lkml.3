Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3LEFuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 00:50:13 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:37765 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3LEFuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 00:50:10 -0500
Message-ID: <52A015E1.50005@linux.vnet.ibm.com>
Date: Thu, 05 Dec 2013 11:27:53 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC] mm readahead: Fix the readahead fail in case of empty
 numa node
References: <1386066977-17368-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20131203143841.11b71e387dc1db3a8ab0974c@linux-foundation.org> <529EE811.5050306@linux.vnet.ibm.com> <20131204004125.a06f7dfc.akpm@linux-foundation.org> <529EF0FB.2050808@linux.vnet.ibm.com> <20131204134838.a048880a1db9e9acd14a39e4@linux-foundation.org>
In-Reply-To: <20131204134838.a048880a1db9e9acd14a39e4@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120505-4790-0000-0000-00000BA84CA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 03:18 AM, Andrew Morton wrote:
> On Wed, 04 Dec 2013 14:38:11 +0530 Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
>
>> On 12/04/2013 02:11 PM, Andrew Morton wrote:
> :
> :     This patch takes it all out and applies the same upper limit as is used in
> :     sys_readahead() - half the inactive list.
> :
> : +/*
> : + * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
> : + * sensible upper limit.
> : + */
> : +unsigned long max_sane_readahead(unsigned long nr)
> : +{
> : +       unsigned long active;
> : +       unsigned long inactive;
> : +
> : +       get_zone_counts(&active, &inactive);
> : +       return min(nr, inactive / 2);
> : +}
>

Hi Andrew, Thanks for digging out. So it seems like earlier we had not
even considered free pages?

> And one would need to go back further still to understand the rationale
> for the sys_readahead() decision and that even predates the BK repo.
>
> iirc the thinking was that we need _some_ limit on readahead size so
> the user can't go and do ridiculously large amounts of readahead via
> sys_readahead().  But that doesn't make a lot of sense because the user
> could do the same thing with plain old read().
>

True.

> So for argument's sake I'm thinking we just kill it altogether and
> permit arbitrarily large readahead:
>
> --- a/mm/readahead.c~a
> +++ a/mm/readahead.c
> @@ -238,13 +238,12 @@ int force_page_cache_readahead(struct ad
>   }
>
>   /*
> - * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
> - * sensible upper limit.
> + * max_sane_readahead() is disabled.  It can later be removed altogether, but
> + * let's keep a skeleton in place for now, in case disabling was the wrong call.
>    */
>   unsigned long max_sane_readahead(unsigned long nr)
>   {
> -	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
> -		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
> +	return nr;
>   }
>

I had something like below in mind for posting.  But it looks
simple now with your patch.


  unsigned long max_sane_readahead(unsigned long nr)
  {
	int nid;
	unsigned long free_page = 0;

	for_each_node_state(nid, N_MEMORY)
		free_page += node_page_state(nid, NR_INACTIVE_FILE)
				+ node_page_state(nid, NR_FREE_PAGES);

	/*
	 * Readahead onto remote memory is better than no readahead when local
	 * numa node does not have memory. We sanitize readahead size depending
	 * on potential free memory in the whole system.
	 */
	return min(nr, free_page / (2 * nr_node_ids));

Or if we wanted to avoid iteration on nodes simply returning

something like nr/8  or something like that for remote numa fault cases.


