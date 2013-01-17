Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab3AQAf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 19:35:27 -0500
Received: from mx2.parallels.com ([64.131.90.16]:50502 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757751Ab3AQAf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 19:35:26 -0500
Message-ID: <50F7475F.90609@parallels.com>
Date: Wed, 16 Jan 2013 16:35:43 -0800
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>, <xfs@oss.sgi.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 09/19] list_lru: per-node list infrastructure
References: <1354058086-27937-1-git-send-email-david@fromorbit.com> <1354058086-27937-10-git-send-email-david@fromorbit.com> <50F6FDC8.5020909@parallels.com> <20130116225521.GF2498@dastard>
In-Reply-To: <20130116225521.GF2498@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.239.55.193]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> The superblocks only, are present by the dozens even in a small system,
>> and I believe the whole goal of this API is to get more users to switch
>> to it. This can easily use up a respectable bunch of megs.
>>
>> Isn't it a bit too much ?
> 
> Maybe, but for active superblocks it only takes a handful of cached
> inodes to make this 16k look like noise, so I didn't care. Indeed, a
> typical active filesystem could be consuming gigabytes of memory in
> the slab, so 16k is a tiny amount of overhead to track this amount
> of memory more efficiently.
> 
> Most other LRU/shrinkers are tracking large objects and only have a
> single LRU instance machine wide. Hence the numbers arguments don't
> play out well in favour of a more complex, dynamic solution for
> them, either. Sometimes dumb and simple is the best approach ;)
> 

Being dumb and simple myself, I'm of course forced to agree.
Let me give you more context so you can understand my deepest fears better:

>> I am wondering if we can't do better in here and at least allocate+grow
>> according to the actual number of nodes.
> 
> We could add hotplug notifiers and grow/shrink the node array as
> they get hot plugged, but that seems unnecessarily complex given
> how rare such operations are.
> 
> If superblock proliferation is the main concern here, then doing
> somethign as simple as allowing filesystems to specify they want
> numa aware LRU lists via a mount_bdev() flag would solve this
> problem. If the flag is set, then full numa lists are created.
> Otherwise the LRU list simply has a "single node" and collapses all node
> IDs down to 0 and ignores all NUMA optimisations...
> 
> That way the low item count virtual filesystems like proc, sys,
> hugetlbfs, etc won't use up memory, but filesytems that actually
> make use of NUMA awareness still get the more expensive, scalable
> implementation. Indeed, any subsystem that is not performance or
> location sensitive can use the simple single list version, so we can
> avoid overhead in that manner system wide...
> 

Deepest fears:

1) snakes.

2) It won't surprise you to know that I am adapting your work, which
provides a very sane and helpful API, to memcg shrinking.

The dumb and simple approach in there is to copy all lrus that are
marked memcg aware at memcg creation time. The API is kept the same,
but when you do something like list_lru_add(lru, obj), for instance, we
derive the memcg context from obj and relay it to the right list.

Statically allocating those arrays for all possible combinations is
basically our way to guarantee that the lookups will be cheap.
Otherwise, we always need to ask the question: "is dentries from this
superblock currently billed to this memcg?", and if yes, allocate memory
in list_lru_add or other steady state operations.

But of course, if we copy all the per node stuff as well, we are
basically talking about that amount of memory per memcg, which means
each memcg will now have an extra overhead of some megs, which is way
too big.

Using online nodes+grow was one of the approaches we considered.
Making the memcg list single-noded while keeping the global lists
node-aware also works for us.
Your current suggestion of going per-node only in the performance
critical filesystems could also possibly work, provided this count is
expected to be small.
