Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3AWOgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:36:21 -0500
Received: from mx2.parallels.com ([64.131.90.16]:47957 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab3AWOgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:36:19 -0500
Message-ID: <50FFF571.8080506@parallels.com>
Date: Wed, 23 Jan 2013 18:36:33 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>, <xfs@oss.sgi.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC, PATCH 00/19] Numa aware LRU lists and shrinkers
References: <1354058086-27937-1-git-send-email-david@fromorbit.com> <50FD6815.90900@parallels.com> <20130121232121.GG2498@dastard>
In-Reply-To: <20130121232121.GG2498@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 03:21 AM, Dave Chinner wrote:
> On Mon, Jan 21, 2013 at 08:08:53PM +0400, Glauber Costa wrote:
>> On 11/28/2012 03:14 AM, Dave Chinner wrote:
>>> [PATCH 09/19] list_lru: per-node list infrastructure
>>>
>>> This makes the generic LRU list much more scalable by changing it to
>>> a {list,lock,count} tuple per node. There are no external API
>>> changes to this changeover, so is transparent to current users.
>>>
>>> [PATCH 10/19] shrinker: add node awareness
>>> [PATCH 11/19] fs: convert inode and dentry shrinking to be node
>>>
>>> Adds a nodemask to the struct shrink_control for callers of
>>> shrink_slab to set appropriately for their reclaim context. This
>>> nodemask is then passed by the inode and dentry cache reclaim code
>>> to the generic LRU list code to implement node aware shrinking.
>>
>> I have a follow up question that popped up from a discussion between me
>> and my very American friend Johnny Wheeler, also known as Johannes
>> Weiner (CC'd). I actually remember we discussing this, but don't fully
>> remember the outcome. And since I can't find it anywhere, it must have
>> been in a media other than e-mail. So I thought it would do no harm in
>> at least documenting it...
>>
>> Why are we doing this per-node, instead of per-zone?
>>
>> It seems to me that the goal is to collapse all zones of a node into a
>> single list, but since the number of zones is not terribly larger than
>> the number of nodes, and zones is where the pressure comes from, what do
>> we really gain from this?
> 
> The number is quite a bit higher - there are platforms with 5 zones
> to a node. The reality is, though, for most platforms slab
> allocations come from a single zone - they never come from ZONE_DMA,
> ZONE_HIGHMEM or ZONE_MOVEABLE, so there is there is no good reason
> for having cache LRUs for these zones. So, two zones at most.
> 
Yes, but one would expect that most of those special zones would be
present only in the first node, no? (correct me if I am wrong here).

Over that, things should be pretty much addressable.

