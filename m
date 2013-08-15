Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab3HOAEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 20:04:24 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:56409 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3HOAEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 20:04:22 -0400
Date: Wed, 14 Aug 2013 17:04:27 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] idr: Document ida tree sections
Message-ID: <20130815000427.GB6427@kmo-pixel>
References: <20130807205117.GC11612@kmo-pixel>
 <20130809145756.GL20515@mtj.dyndns.org>
 <20130813221308.GA11980@kmo-pixel>
 <20130813221928.GE28996@mtj.dyndns.org>
 <20130813222759.GA12069@kmo-pixel>
 <20130813224428.GG28996@mtj.dyndns.org>
 <20130813225927.GA2000@kmo-pixel>
 <20130813232211.GI28996@mtj.dyndns.org>
 <20130813235133.GA3807@kmo-pixel>
 <20130813235947.GL28996@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813235947.GL28996@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 07:59:47PM -0400, Tejun Heo wrote:
> Hey, Kent.
> 
> On Tue, Aug 13, 2013 at 04:51:33PM -0700, Kent Overstreet wrote:
> > Should probably be almost as good, yeah... in theory, but the space
> > efficiency still isn't going to be as good, and it'll probably be more
> > code... and at this point I really just don't want to futz with it more.
> > At this point unless there's something really wrong with this code I
> > just want to move onto something else :P
> 
> I think it probably would be okay in most cases but don't feel
> confident about acking as it's making trade-offs which are unnecessary
> and unusual.  So, ummm, I really don't know.  Maybe it's better enough
> than what we have now but at the same time if you want to reimplement
> the whole thing you should be persistent / reliable enough to see it
> through this time around too, right?

I was just telling you how I felt :) Regardless of that, IMO what I've
got now is superior to any radix tree based approach for what ida/idr
are supposed to do. I could of course be wrong, but I'm not convinced...

Re: caching the last allocation with a radix tree based implementation.
I thought about that more last night, I don't think that would be viable
for using ida underneath the percpu ida allocator.

Reason being percpu ida has to heavily optimize for the case where
almost all of the id space is allocated, and after awhile the id space
is going to be fragmented - so caching the last allocated id is going to
be useless.

This is also why I implemented the ganged allocation bit, to amortize
the bitmap tree traversal. So we'd lose out on that going back to a
radix tree, or have to reimplement it (and it'll be slower due to
pointer chasing).

Which is all not the end of the world, but it means that if we punt on
the ida/idr rewrites for now or change our minds about them - we _do_
have quite a bit of stuff waiting on the percpu ida allocator, so for
that to go in separate I'll have to change it back to using a stack of
integers for the global freelist - which does use significantly more
memory.
