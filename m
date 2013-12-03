Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3LCMQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:16:23 -0500
Received: from relay.parallels.com ([195.214.232.42]:54989 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3LCMQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:16:22 -0500
Message-ID: <529DCB7D.10205@parallels.com>
Date: Tue, 3 Dec 2013 16:15:57 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <dchinner@redhat.com>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, <devel@openvz.org>,
        <glommer@openvz.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v12 09/18] vmscan: shrink slab on memcg pressure
References: <cover.1385974612.git.vdavydov@parallels.com> <be01fd9afeedb7d5c7979347f4d6ddaf67c9082d.1385974612.git.vdavydov@parallels.com> <20131203104849.GD8803@dastard>
In-Reply-To: <20131203104849.GD8803@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 02:48 PM, Dave Chinner wrote:
>> @@ -236,11 +236,17 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
>>  		return 0;
>>  
>>  	/*
>> -	 * copy the current shrinker scan count into a local variable
>> -	 * and zero it so that other concurrent shrinker invocations
>> -	 * don't also do this scanning work.
>> +	 * Do not touch global counter of deferred objects on memcg pressure to
>> +	 * avoid isolation issues. Ideally the counter should be per-memcg.
>>  	 */
>> -	nr = atomic_long_xchg(&shrinker->nr_deferred[nid], 0);
>> +	if (!shrinkctl->target_mem_cgroup) {
>> +		/*
>> +		 * copy the current shrinker scan count into a local variable
>> +		 * and zero it so that other concurrent shrinker invocations
>> +		 * don't also do this scanning work.
>> +		 */
>> +		nr = atomic_long_xchg(&shrinker->nr_deferred[nid], 0);
>> +	}
> That's ugly. Effectively it means that memcg reclaim is going to be
> completely ineffective when large numbers of allocations and hence
> reclaim attempts are done under GFP_NOFS context.
>
> The only thing that keeps filesystem caches in balance when there is
> lots of filesystem work going on (i.e. lots of GFP_NOFS allocations)
> is the deferal of reclaim work to a context that can do something
> about it.

Imagine the situation: a memcg issues a GFP_NOFS allocation and goes to
shrink_slab() where it defers them to the global counter; then another
memcg issues a GFP_KERNEL allocation, also goes to shrink_slab() where
it sees a huge number of deferred objects and starts shrinking them,
which is not good IMHO. I understand that nr_deferred is necessary, but
I think it should be per-memcg. What do you think about moving it to
list_lru?

>>  	total_scan = nr;
>>  	delta = (4 * fraction) / shrinker->seeks;
>> @@ -296,21 +302,46 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
>>  		cond_resched();
>>  	}
>>  
>> -	/*
>> -	 * move the unused scan count back into the shrinker in a
>> -	 * manner that handles concurrent updates. If we exhausted the
>> -	 * scan, there is no need to do an update.
>> -	 */
>> -	if (total_scan > 0)
>> -		new_nr = atomic_long_add_return(total_scan,
>> +	if (!shrinkctl->target_mem_cgroup) {
>> +		/*
>> +		 * move the unused scan count back into the shrinker in a
>> +		 * manner that handles concurrent updates. If we exhausted the
>> +		 * scan, there is no need to do an update.
>> +		 */
>> +		if (total_scan > 0)
>> +			new_nr = atomic_long_add_return(total_scan,
>>  						&shrinker->nr_deferred[nid]);
>> -	else
>> -		new_nr = atomic_long_read(&shrinker->nr_deferred[nid]);
>> +		else
>> +			new_nr = atomic_long_read(&shrinker->nr_deferred[nid]);
>> +	}
> So, if the memcg can't make progress, why wouldn't you defer the
> work to the global scan? Or can't a global scan trim memcg LRUs?
> And if it can't, then isn't that a major design flaw? Why not just
> allow kswapd to walk memcg LRUs in the background?
>
> /me just looked at patch 13
>
> Yeah, this goes some way to explaining why something like patch 13
> is necessary - slab shrinkers are not keeping up with page cache
> reclaim because of GFP_NOFS allocations, and so the page cache
> empties only leaving slab caches to be trimmed....
>
>
>> +static unsigned long
>> +shrink_slab_memcg(struct shrink_control *shrinkctl, struct shrinker *shrinker,
>> +		  unsigned long fraction, unsigned long denominator)
> what's this function got to do with memcgs? Why did you rename it
> from the self explanitory shrink_slab_one() name that Glauber gave
> it?

When I sent the previous version, Johannes Weiner disliked the name that
was why I renamed it, now you don't like the new name and ask for the
old one :-) But why do you think that shrink_slab_one() is
self-explanatory while shrink_slab_memcg() is not? I mean
shrink_slab_memcg() means "shrink slab accounted to a memcg" just like
shrink_slab_node() means "shrink slab on the node" while seeing
shrink_slab_one() I would ask "one what?".

>> +{
>> +	unsigned long freed = 0;
>> +
>> +	if (shrinkctl->memcg && !memcg_kmem_is_active(shrinkctl->memcg))
>> +		return 0;
> Why here? why not check that in the caller where memcg's are being
> iterated?

No problem, I'll move it.

>> +
>> +	for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
>> +		if (!node_online(shrinkctl->nid))
>> +			continue;
>> +
>> +		if (!(shrinker->flags & SHRINKER_NUMA_AWARE) &&
>> +		    (shrinkctl->nid != 0))
>> +			break;
> Hmmm - this looks broken. Nothing guarantees that node 0 in
> shrinkctl->nodes_to_scan is ever set, so non-numa aware shrinkers
> will do nothing when the first node in the mask is not set. For non-numa
> aware shrinkers, the shrinker should always be called once with a
> node id of 0.

That's how it operates now - this patch simply moved this piece from
shrink_slab(). I'll fix this.

> That's what earlier versions of the numa aware shrinker patch set
> did, and it seems to have been lost along the way.  Yeah, there's
> the last version from Glauber's tree that I saw:
>
> static unsigned long
> shrink_slab_one(struct shrink_control *shrinkctl, struct shrinker *shrinker,
>                unsigned long nr_pages_scanned, unsigned long lru_pages)
> {
>        unsigned long freed = 0;
>
>        if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
>                shrinkctl->nid = 0;
>
>                return shrink_slab_node(shrinkctl, shrinker,
>                         nr_pages_scanned, lru_pages,
>                         &shrinker->nr_deferred);
>        }
>
>        for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan)
>
>                if (!node_online(shrinkctl->nid))
>                        continue;
>
>                freed += shrink_slab_node(shrinkctl, shrinker,
>                         nr_pages_scanned, lru_pages,
> 			 &shrinker->nr_deferred_node[shrinkctl->nid]);
>        }
>
>        return freed;
> }
>
> So, that's likely to be another reason that all the non-numa slab
> caches are not being shrunk appropriately and need to be hit with a
> bit hammer...
>
>> @@ -352,18 +383,23 @@ unsigned long shrink_slab(struct shrink_control *shrinkctl,
>>  	}
>>  
>>  	list_for_each_entry(shrinker, &shrinker_list, list) {
>> -		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
>> -			if (!node_online(shrinkctl->nid))
>> -				continue;
>> -
>> -			if (!(shrinker->flags & SHRINKER_NUMA_AWARE) &&
>> -			    (shrinkctl->nid != 0))
>> +		shrinkctl->memcg = shrinkctl->target_mem_cgroup;
>> +		do {
>> +			if (!(shrinker->flags & SHRINKER_MEMCG_AWARE) &&
>> +			    (shrinkctl->memcg != NULL)) {
>> +				mem_cgroup_iter_break(
>> +						shrinkctl->target_mem_cgroup,
>> +						shrinkctl->memcg);
>>  				break;
>> +			}
>>  
>> -			freed += shrink_slab_node(shrinkctl, shrinker,
>> -						  fraction, denominator);
>> +			freed += shrink_slab_memcg(shrinkctl, shrinker,
>> +						   fraction, denominator);
>> +			shrinkctl->memcg = mem_cgroup_iter(
>> +						shrinkctl->target_mem_cgroup,
>> +						shrinkctl->memcg, NULL);
>> +		} while (shrinkctl->memcg);
> Glauber's tree also had a bunch of comments explaining what was
> going on here. I've got no idea what the hell this code is doing,
> and why the hell we are iterating memcgs here and how and why the
> normal, non-memcg scan and shrinkers still worked.

I found this code straightforward, just like the shrink_zone(), which
also lacks comments, but I admit I was wrong and I'll try to improve.

> This is now just a bunch of memcg gobbledegook with no explanations
> to tell us what it is supposed to be doing. Comments are important -
> you might not think they are necessary, but seeing comments like
> this:
>
> +               /*
> +                * In a hierarchical chain, it might be that not all memcgs are
> +                * kmem active. kmemcg design mandates that when one memcg is
> +                * active, its children will be active as well. But it is
> +                * perfectly possible that its parent is not.
> +                *
> +                * We also need to make sure we scan at least once, for the
> +                * global case. So if we don't have a target memcg (saved in
> +                * root), we proceed normally and expect to break in the next
> +                * round.
> +                */
>
> in Glauber's tree helped an awful lot to explain the mess that the
> memcg stuff was making of the code...
>
> I'm liking this patch set less and less as I work my way through
> it...

Will try to improve.

Thanks.
