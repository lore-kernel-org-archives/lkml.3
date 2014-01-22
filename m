Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbaAVJoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:44:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbaAVJoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:44:01 -0500
Subject: Re: [PATCH 17/24] GFS2: Use RCU/hlist_bl based hash for quotas
From: Steven Whitehouse <swhiteho@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, Abhijith Das <adas@redhat.com>
In-Reply-To: <52DF5FE9.9020508@oracle.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
	 <1390220627-1571-18-git-send-email-swhiteho@redhat.com>
	 <20140122053248.GX10038@linux.vnet.ibm.com>  <52DF5FE9.9020508@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 22 Jan 2014 09:43:09 +0000
Message-ID: <1390383789.2742.13.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2014-01-22 at 01:06 -0500, Sasha Levin wrote:
> On 01/22/2014 12:32 AM, Paul E. McKenney wrote:
> > On Mon, Jan 20, 2014 at 12:23:40PM +0000, Steven Whitehouse wrote:
> >> >Prior to this patch, GFS2 kept all the quotas for each
> >> >super block in a single linked list. This is rather slow
> >> >when there are large numbers of quotas.
> >> >
> >> >This patch introduces a hlist_bl based hash table, similar
> >> >to the one used for glocks. The initial look up of the quota
> >> >is now lockless in the case where it is already cached,
> >> >although we still have to take the per quota spinlock in
> >> >order to bump the ref count. Either way though, this is a
> >> >big improvement on what was there before.
> >> >
> >> >The qd_lock and the per super block list is preserved, for
> >> >the time being. However it is intended that since this is no
> >> >longer used for its original role, it should be possible to
> >> >shrink the number of items on that list in due course and
> >> >remove the requirement to take qd_lock in qd_get.
> >> >
> >> >Signed-off-by: Steven Whitehouse<swhiteho@redhat.com>
> >> >Cc: Abhijith Das<adas@redhat.com>
> >> >Cc: Paul E. McKenney<paulmck@linux.vnet.ibm.com>
> > Interesting!  I thought that Sasha Levin had a hash table in the works,
> > but I don't see it, so CCing him.
> 
> Indeed, there is a hlist based hashtable at include/linux/hashtable.h for couple kernel
> versions now. However, there's no hlist_bl one.
> 
> If there is a plan on adding a hlist_bl hashtable for whatever reason, it should probably
> be done by expanding hashtable.h so that more places that use hlist_bl would benefit from it (yes,
> there are couple more places that do hlist_bl hashtable).
> 
> Also, do we really want to use hlist_bl here? It doesn't seem like it's being done to conserve on
> memory, and that's the only reason it should be used for. Doing a single spinlock per bucket is
> much more efficient than using the bit locking scheme that hlist_bl does.
> 
> 
> Thanks,
> Sasha

So this will probably make a bit more sense with a bit of history to
explain how we got here... The recent addition of the quota hash table
is modeled upon the one we are using for glocks at the moment. The glock
hash table at one stage, had one lock per bucket, and was then expanded
so that we had more buckets, but the same number of locks - to conserve
memory. It was then expanded again when we moved to hlist_bl a little
while ago. At each stage we gained performance so the changes seemed to
be a good thing.

Really the max number of glocks depends on the size of the memory, so
that we should really try to scale the hash table with increasing memory
size, however a simpler static table has worked reasonably well for now.
If we could use a tree (or forest) instead of a hash table that would be
even better, but still a bit of a pain to do with RCU I think, which is
why I've not gone that extra step yet.

Now the quota hash table has been modeled as a smaller version of the
glock hash table for the time being. The question is how large it should
be?... any more than a single hash list head is an improvement on the
previous code, and maybe the table should be larger than I've made it
currently. We'll see whether anybody runs into issues if they have large
number of quotas in due course.

So perhaps the memory saving is not the most important thing with the
quota hash table, but at least it matches in form the glock hash table
which has been proven over many releases as being effective. However, if
we can make use of some generic code that solves many of the problems
for us, then I can certainly look into that.

The changes in the quota code are not complete yet, and with a bit of
luck we'll have a further set of changes ready for the next merge window
too,

Steve.


