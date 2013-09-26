Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3IZWQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:16:43 -0400
Received: from www.sr71.net ([198.145.64.142]:38671 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab3IZWQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:16:39 -0400
Message-ID: <5244B22C.9020503@sr71.net>
Date: Thu, 26 Sep 2013 15:16:12 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, mgorman@suse.de, hannes@cmpxchg.org,
        tony.luck@intel.com, matthew.garrett@nebula.com, riel@redhat.com,
        arjan@linux.intel.com, srinivas.pandruvada@linux.intel.com,
        willy@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org,
        rjw@sisk.pl
CC: gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 06/40] mm: Demarcate and maintain pageblocks in
 region-order in the zones' freelists
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com> <20130925231454.26184.19783.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231454.26184.19783.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 04:14 PM, Srivatsa S. Bhat wrote:
> @@ -605,16 +713,22 @@ static inline void __free_one_page(struct page *page,
>  		buddy_idx = __find_buddy_index(combined_idx, order + 1);
>  		higher_buddy = higher_page + (buddy_idx - combined_idx);
>  		if (page_is_buddy(higher_page, higher_buddy, order + 1)) {
> -			list_add_tail(&page->lru,
> -				&zone->free_area[order].free_list[migratetype].list);
> +
> +			/*
> +			 * Implementing an add_to_freelist_tail() won't be
> +			 * very useful because both of them (almost) add to
> +			 * the tail within the region. So we could potentially
> +			 * switch off this entire "is next-higher buddy free?"
> +			 * logic when memory regions are used.
> +			 */
> +			add_to_freelist(page, &area->free_list[migratetype]);
>  			goto out;
>  		}
>  	}

Commit 6dda9d55b says that this had some discrete performance gains.
It's a bummer that this deoptimizes it, and I think that (expected)
performance degredation at least needs to be referenced _somewhere_.

I also find it very hard to take code seriously which stuff like this:

> +#ifdef CONFIG_DEBUG_PAGEALLOC
> +		WARN(region->nr_free == 0, "%s: nr_free messed up\n", __func__);
> +#endif

nine times.
