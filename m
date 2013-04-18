Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966781Ab3DRQsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:48:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132Ab3DRQsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:48:10 -0400
Date: Thu, 18 Apr 2013 12:47:42 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        dm-crypt@saout.de, Christian Schmidt <schmidt@digadd.de>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Milan Broz <gmazyland@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
Message-ID: <20130418164742.GA8254@redhat.com>
References: <20130410192427.GA14911@redhat.com>
 <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org>
 <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org>
 <20130411200005.GB11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304121340350.3359@file.rdu.redhat.com>
 <20130412182941.GF11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304150827480.1859@file.rdu.redhat.com>
 <20130416172418.GB2874@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416172418.GB2874@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16 2013 at  1:24pm -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hey,
> 
> On Mon, Apr 15, 2013 at 09:02:06AM -0400, Mikulas Patocka wrote:
> > The patch is not bug-prone, because we already must make sure that the 
> > cloned bio has shorter lifetime than the master bio - so the patch doesn't 
> > introduce any new possibilities to make bugs.
> 
> The whole world isn't composed of only your code.  As I said
> repeatedly, you're introducing an API which is misleading and can
> easily cause subtle bugs which are very difficult to reproduce.
> 
> Imagine it being used to tag a metatdata or checksum update bio being
> sent down while processing another bio and used to "clone" the context
> of the original bio.  It'll work most of the time even if the original
> bio gets completed first but it'll break when it gets really unlucky -
> e.g. racing with other operations which can put the base css ref, and
> it'll be hellish to reproduce and everyone would have to pay for your
> silly hack.
> 
> > > Do the two really look the same to you?  The page refs are much more
> > > expensive, mostly contained in and the main focus of dm.  ioc/css refs
> > > aren't that expensive to begin with, css refcnting is widely scattered
> > 
> > ioc is per-task, so it is likely to be cached (but there are processors 
> > that have slow atomic operations even on cached data - on Pentium 4 it 
> > takes about 100 cycles). But css is shared between tasks and produces the 
> > cache ping-pong effect.
> 
> For $DIETY's sake, how many times do I have to tell you to use per-cpu
> reference count?  Why do I have to repeat the same story over and over
> again?  What part of "make the reference count per-cpu" don't you get?
> It's not a complicated message.
> 
> At this point, I can't even understand why or what the hell you're
> arguing.  There's a clearly better way to do it and you're just
> repeating yourself like a broken record that your hack in itself isn't
> broken.
> 
> So, if you wanna continue that way for whatever reason, you have my
> firm nack and I'm outta this thread.
> 
> Bye bye.

Hey Tejun,

I see you nack and raise you with: please reconsider in the near term.

Your point about not wanting to introduce a generic block interface that
isn't "safe" for all users noted.  But as Mikulas has repeatedly said DM
does _not_ ever need to do the refcounting.  So it seems a bit absurd to
introduce the requirement that DM should stand up an interface that uses
percpu.  That is a fair amount of churn that DM will never have a need
to take advantage of.

So why not introduce __bio_copy_association(bio1, bio2) and add a BUG_ON
in it if bio2 isn't a clone of bio1?

When there is a need for async IO to have more scalable refcounting that
would be the time to introduce bio_copy_association that uses per-cpu
refcounting (and yes we could then even nuke __bio_copy_association).

It just seems to me a bit burdensome to ask Mikulas to add this
infrastructure when DM really doesn't need it at all.  But again I do
understand your desire for others to be stearing the kernel where it
needs to be to benefit future use-cases.  But I think in general it best
to introduce complexity when there is an actual need.

Your insights are amazingly helpful and I think it is unfortunate that
this refcounting issue overshadowed the positive advancements of
dm-crypt scaling.  I'm just looking to see if we can carry on with a
temporary intermediate step with __bio_copy_association.

Thanks,
Mike
