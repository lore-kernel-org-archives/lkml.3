Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbaJ2Msk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:48:40 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:44504 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbaJ2Msi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:48:38 -0400
Date: Wed, 29 Oct 2014 12:48:34 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Will Auld <will.auld@intel.com>, Tejun Heo <tj@kernel.org>,
        Vikas Shivappa <vikas.shivappa@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141029124834.GQ12020@console-pimps.org>
References: <1413485050.28564.14.camel@vshiva-Udesk>
 <20141020161855.GF12020@console-pimps.org>
 <20141024105306.GI12706@worktop.programming.kicks-ass.net>
 <20141028232215.GO12020@console-pimps.org>
 <20141029081640.GT3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029081640.GT3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct, at 09:16:40AM, Peter Zijlstra wrote:
> 
> Ah, so one way around that is to only assign a (whats the CQE equivalent
> of RMIDs again?) once you stick a task in.
 
I think you're after "Class of Service" (CLOS) ID.

Yeah we can do the CLOS ID assignment on-demand but what we can't do
on-demand is the cache bitmask assignment, i.e. how we carve up the LLC.
These need to persist irrespective of which task is running. And it's
the cache bitmask that I'm specifically talking about not allowing
arbitrarly deep nesting.

So if I create a cgroup directory with a mask of 0x3 in the root cgroup
directory for CAT (meow). Then, create two sub-directories, and split my
0x3 bitmask into 0x2 and 0x1, it's impossible to nest any further, i.e.

                    /sys/fs/cgroup/cacheqe           0xffffffff
                              |
                              |
                            meow                     0x3
                           /    \
                          /      \
                        sub1    sub2                 0x1, 0x2

Of course the pathological case is creating a cgroup directory with
bitmask 0x1, so you can't have sub-directories because you can't split
the cache allocation at all.

Does this fly in the face of "full hierarchies"? Or is this a reasonable
limitation?

> But basically it means you need to allow things like:
> 
> root/virt/more/crap/hostA
>                    /hostB
>     /sanityA
>     /random/other/yunk
> 
> Now, the root will have the entire bitmask set, any child, say
> virt/more/crap can also have them all set, and you can maybe only start
> differentiating in the /host[AB] bits.
> 
> Whether or not it makes sense, libvirt likes to create these pointless
> deep hierarchies, as do a lot of other people for that matter.

OK, this is something I hadn't considered; that you may *not* want to
split the cache bitmask as you move down the hierarchy.

I think that's something we could do without too much pain, though
actually programming that from a user perspective makes my head hurt.

-- 
Matt Fleming, Intel Open Source Technology Center
