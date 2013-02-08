Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947265Ab3BHV1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:27:14 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:47691 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947146Ab3BHV1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:27:10 -0500
Date: Fri, 8 Feb 2013 13:27:06 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, zab@redhat.com,
        bcrl@kvack.org, jmoyer@redhat.com, viro@zeniv.linux.org.uk,
        tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130208212706.GH27179@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
 <20130208144408.GY2875@htj.dyndns.org>
 <20130208144902.GQ15092@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208144902.GQ15092@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 03:49:02PM +0100, Jens Axboe wrote:
> On Fri, Feb 08 2013, Tejun Heo wrote:
> > (cc'ing Andrew)
> > 
> > On Wed, Dec 26, 2012 at 06:00:02PM -0800, Kent Overstreet wrote:
> > > This implements a refcount with similar semantics to
> > > atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
> > > but dynamically switches to per cpu refcounting when the rate of
> > > gets/puts becomes too high.
> > > 
> > > It also implements two stage shutdown, as we need it to tear down the
> > > percpu counts. Before dropping the initial refcount, you must call
> > > percpu_ref_kill(); this puts the refcount in "shutting down mode" and
> > > switches back to a single atomic refcount with the appropriate barriers
> > > (synchronize_rcu()).
> > > 
> > > It's also legal to call percpu_ref_kill() multiple times - it only
> > > returns true once, so callers don't have to reimplement shutdown
> > > synchronization.
> > > 
> > > For the sake of simplicity/efficiency, the heuristic is pretty simple -
> > > it just switches to percpu refcounting if there are more than x gets
> > > in one second (completely arbitrarily, 4096).
> > > 
> > > It'd be more correct to count the number of cache misses or something
> > > else more profile driven, but doing so would require accessing the
> > > shared ref twice per get - by just counting the number of gets(), we can
> > > stick that counter in the high bits of the refcount and increment both
> > > with a single atomic64_add(). But I expect this'll be good enough in
> > > practice.
> > > 
> > > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > 
> > What's the status of this series?  The percpu-refcnt part is still
> > going through review and the merge window is opening up pretty soon.
> > Kent, Andrew?
> 
> I'd feel a lot better deferring the whole aio/dio performance series for
> one merge window. There's very little point in rushing it, and I don't
> think it's been reviewed/tested enough yet.

It could probably use more review, but it has been sitting in linux-next
and the issues that showed up there are all fixed. You going to help
review it? :)

I'm not really set on it going in this merge cycle, but testing wise I
do think it's in pretty good shape and I'm not sure where we're going to
get more testing from before it goes in.

And Andrew - apologies for not getting you the benchmarks you asked for,
getting hardware for it has turned out to be more troublesome than I
expected. Still don't know what's going on with that.

(It turned out though that when I readded that second kiocb refcount
that io_submit_one() owns, that was a real performance regression. So
I've got a patch that refactors aio_rw_vect_retry() so it can safely be
dropped, and I'm going to _try_ to refactor cancellation so that I can
get rid of kiocb refcounting entirely. But I'm not really in a big hurry
to pile more stuff into this patch series, I'd prefer to get what I've
got in...)
