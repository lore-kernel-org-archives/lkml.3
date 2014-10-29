Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbaJ2Npe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:45:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:43011 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746AbaJ2Npd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:45:33 -0400
Date: Wed, 29 Oct 2014 14:45:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Will Auld <will.auld@intel.com>, Tejun Heo <tj@kernel.org>,
        Vikas Shivappa <vikas.shivappa@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141029134526.GC3337@twins.programming.kicks-ass.net>
References: <1413485050.28564.14.camel@vshiva-Udesk>
 <20141020161855.GF12020@console-pimps.org>
 <20141024105306.GI12706@worktop.programming.kicks-ass.net>
 <20141028232215.GO12020@console-pimps.org>
 <20141029081640.GT3337@twins.programming.kicks-ass.net>
 <20141029124834.GQ12020@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029124834.GQ12020@console-pimps.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 12:48:34PM +0000, Matt Fleming wrote:
> On Wed, 29 Oct, at 09:16:40AM, Peter Zijlstra wrote:
> > 
> > Ah, so one way around that is to only assign a (whats the CQE equivalent
> > of RMIDs again?) once you stick a task in.
>  
> I think you're after "Class of Service" (CLOS) ID.
> 
> Yeah we can do the CLOS ID assignment on-demand but what we can't do
> on-demand is the cache bitmask assignment, i.e. how we carve up the LLC.
> These need to persist irrespective of which task is running. And it's
> the cache bitmask that I'm specifically talking about not allowing
> arbitrarly deep nesting.
> 
> So if I create a cgroup directory with a mask of 0x3 in the root cgroup
> directory for CAT (meow).

All we now need is a DOG to go woof :-) and they can have a party.

> Then, create two sub-directories, and split my
> 0x3 bitmask into 0x2 and 0x1, it's impossible to nest any further, i.e.
> 
>                     /sys/fs/cgroup/cacheqe           0xffffffff
>                               |
>                               |
>                             meow                     0x3
>                            /    \
>                           /      \
>                         sub1    sub2                 0x1, 0x2
> 
> Of course the pathological case is creating a cgroup directory with
> bitmask 0x1, so you can't have sub-directories because you can't split
> the cache allocation at all.
> 
> Does this fly in the face of "full hierarchies"? Or is this a reasonable
> limitation?

I don't see a reason why we should not allow further children of sub1,
they'll all have to have 0x1, but that should be fine, pointless
perhaps, but perfectly consistent.

> > But basically it means you need to allow things like:
> > 
> > root/virt/more/crap/hostA
> >                    /hostB
> >     /sanityA
> >     /random/other/yunk
> > 
> > Now, the root will have the entire bitmask set, any child, say
> > virt/more/crap can also have them all set, and you can maybe only start
> > differentiating in the /host[AB] bits.
> > 
> > Whether or not it makes sense, libvirt likes to create these pointless
> > deep hierarchies, as do a lot of other people for that matter.
> 
> OK, this is something I hadn't considered; that you may *not* want to
> split the cache bitmask as you move down the hierarchy.
> 
> I think that's something we could do without too much pain, though
> actually programming that from a user perspective makes my head hurt.

Right, also note that in the libvirt case, most of the intermediate
groups are empty (of tasks) and would thus not actually instantiate a
CLOS thingy.
