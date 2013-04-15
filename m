Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934716Ab3DONCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:02:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab3DONCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:02:37 -0400
Date: Mon, 15 Apr 2013 09:02:06 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Tejun Heo <tj@kernel.org>
cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
In-Reply-To: <20130412182941.GF11956@mtj.dyndns.org>
Message-ID: <Pine.LNX.4.64.1304150827480.1859@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com> <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com> <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org> <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org> <20130411200005.GB11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304121340350.3359@file.rdu.redhat.com>
 <20130412182941.GF11956@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Apr 2013, Tejun Heo wrote:

> On Fri, Apr 12, 2013 at 02:01:08PM -0400, Mikulas Patocka wrote:
> > So if you think that reference counts should be incremented by every clone 
> > of the original bio, what kind of bug should it protect against? If we 
> > don't increment reference counts for pages, why should we do it for cgroup 
> > pointers?
> 
> These things are called trade-offs.  You look at the overhead of the
> things and how complex / fragile things get when certain shortcuts are
> taken and how well contained and easy to verify / debug when things go
> wrong and then make your choice.

So what we are here trading for what?


The patch eliminates the atomic references when passing the bio down the 
stack of bio drivers.


The patch adds a flag BIO_DROP_CGROUP_REFCOUNT, modifies it at two places 
and tests it on two places - that is not big.

The flag BIO_DROP_CGROUP_REFCOUNT is never supposed to be used outside bio 
cgroup functions, so it doesn't complicate interface to other subsystems.

The patch is not bug-prone, because we already must make sure that the 
cloned bio has shorter lifetime than the master bio - so the patch doesn't 
introduce any new possibilities to make bugs.


> Do the two really look the same to you?  The page refs are much more
> expensive, mostly contained in and the main focus of dm.  ioc/css refs
> aren't that expensive to begin with, css refcnting is widely scattered

ioc is per-task, so it is likely to be cached (but there are processors 
that have slow atomic operations even on cached data - on Pentium 4 it 
takes about 100 cycles). But css is shared between tasks and produces the 
cache ping-pong effect.

> across the kernel, the association interface is likely to be used by
> any entity issuing IOs asynchronously soonish, and there is much saner
> way to improve it - which would be beneficial not only to block / dm
> but everyone else using it.
> 
> Something being done in one place doesn't automatically make it okay
> everywhere else.  We can and do use hackery but *with* discretion.
>
> If you still can't understand, I'm not sure what more I can tell you.
> 
> -- 
> tejun

I don't know what's wrong with 4 lines of code to manipulate a flag.

I understand that you don't want to do something complicated and bug-prone 
to improve performance. But the patch is neither complicated nor 
bug-prone.

Mikulas
