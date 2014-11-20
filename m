Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbaKTMg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:36:58 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52637 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaKTMg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:36:56 -0500
Message-ID: <546DE065.3090502@plexistor.com>
Date: Thu, 20 Nov 2014 14:36:53 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Boaz Harrosh <boaz@plexistor.com>
CC: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 2/2] {block|char}_dev: remove inode->i_devices
References: <20141113220927.GF2598@htj.dyndns.org> <20141113221139.GG2598@htj.dyndns.org> <546DC5AD.3040606@plexistor.com> <20141120115052.GA32237@htj.dyndns.org>
In-Reply-To: <20141120115052.GA32237@htj.dyndns.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 01:50 PM, Tejun Heo wrote:
> Hello, Boaz.
> 
> On Thu, Nov 20, 2014 at 12:42:53PM +0200, Boaz Harrosh wrote:
>> if I understand correctly the motivation here is that the allocation
>> of the internal element is done GFP_KERNEL at this call
>>
>> Then the add() below can be under the spin_lock.
>>
>> So why don't you just return an element here to caller and give it to
>> add below. No Preemption-disable, no percpu variable, simple. Like:
> 
> Hmmm... mostly because preloading is more convenient and but also
> because it provides better separation from internal implementation
> details.  e.g. This may be implemented using a different data
> structure (e.g. bonsai tree) 

Two things:
1. This can be easily hidden by returning a none defined type
   which internals are only known to the implementation so
   even if you change the implementation users need not change.
   Like just a (void *) but it is better to be type-full
   like:
   struct pset_new;
   struct pset_new *pset_preload()

   And the internals of struct pset_new is only known to implementation
2. Obfuscation: Currently this is the proposed implementation if jugging
   by the previous imp it is good for 15 years.
   Else since when are we afraid to change two users?

> which may require differing number of new
> elements even on success.  With the scheme you're describing, the
> operation would be constantly allocating and freeing memory areas
> (which may be multiple) unnecessarily.

  Actually with my proposed change to "the code you submitted here"
  there are *less* unnecessary allocations. In both our imp we have a
  waste when element already exist in the tree, and your imp already
  waists an allocation in every pset_preload()

  And again you are talking about a future undefined "what if", let
  us look at the very sound imp you proposed here with rbtree and
  do the best we can with that one.

> 
> One thing which is debatable is how to handle preloading errors.  We
> can have the preload fail and then assume that the later insertion
> won't fail with -ENOMEM (often through BUG/WARN_ON()); however, it
> often, but not always, is that those insertion operations may fail
> with different error codes too and requires error handling anyway, 

  Again Theoretical. With your current code the only failing I see
  from add() is allocation, so with my imp it will never fail. One
  thing good with embedded list_heads is the void returning add.
  And so with my proposition: void returning add.

  When some new imp will be needed we can cross the bridge then.

  For now you have convinced me that an rbtree is good, and I want to
  solve the preemption-disable, none interrupt ugliness, per-cpu vars,
  as well as the double alloc in the normal lots-of-free-memory case.

> so
> overall it seems better to defer the allocation error to the actual
> insertion point.  

That one I did not understand.

> It also makes conceptual sense.  The preloading
> simply upgrades the allocation mask the insertion operation uses.
> 

How is "upgrades", better then "always have the best mask"

> Thanks.
> 

Thanks
Boaz

