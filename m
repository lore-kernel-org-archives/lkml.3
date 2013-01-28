Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab3A1SSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:18:49 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:45724 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab3A1SSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:18:46 -0500
Date: Mon, 28 Jan 2013 10:18:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        srivatsa.bhat@linux.vnet.ibm.com, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130128181839.GB22465@mtj.dyndns.org>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
 <20130125005136.GE2373@mtj.dyndns.org>
 <20130125011345.GT26407@google.com>
 <20130125020340.GG2373@mtj.dyndns.org>
 <20130125020943.GH2373@mtj.dyndns.org>
 <20130128174858.GW26407@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128174858.GW26407@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Mon, Jan 28, 2013 at 09:48:58AM -0800, Kent Overstreet wrote:
> > Ooh, I forgot one thing.  We might not gain much by replacing file
> > refcnt w/ this.  You can't really get cheaper than fget_light().
> 
> I've seen fget() show up when profiling the aio code - it's not high
> enough to be a big concern when not doing stupid stuff, but high enough
> that making it percpu would be worth it if it was easy. Which it's not,
> for plenty of reasons.

Yeah, aio wouldn't be able to use fget_light().

> > So, I'm now back to "do we need dynamic allocation".  What else do we
> > have to convert?
> 
> I dunno. There's a lot of random refcounts scattered around, though.
> 
> The way I see it, if it's always percpu when joe random dev needs a
> refcount, he's going to weigh whether the overhead of a percpu refcount
> is worth it.
> 
> With dynamic allocation, it's 16 bytes if you don't need it to be
> percpu, vs. 4 for an atomic_t - so you never need to think about it, you
> can just always use this for your refcounts and never have to think
> about if it's going to be a fast path thing or not.

Yes, that is an appealing thought and it would actually improve
something unlike kref silliness.  One concern is that when not
converted to percpu, there will be overhead for extra bookkeeping.  It
probably can be offset by flipping to percpu mode earlier.  Anyways,
it would be great if both the percpu and non-percpu fast paths light.

Thanks.

-- 
tejun
