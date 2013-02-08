Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947187Ab3BHVRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:17:41 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39729 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947139Ab3BHVRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:17:39 -0500
Date: Fri, 8 Feb 2013 13:17:35 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130208211735.GG27179@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
 <20130208144408.GY2875@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208144408.GY2875@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 06:44:08AM -0800, Tejun Heo wrote:
> (cc'ing Andrew)
> 
> On Wed, Dec 26, 2012 at 06:00:02PM -0800, Kent Overstreet wrote:
> > This implements a refcount with similar semantics to
> > atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
> > but dynamically switches to per cpu refcounting when the rate of
> > gets/puts becomes too high.
> > 
> > It also implements two stage shutdown, as we need it to tear down the
> > percpu counts. Before dropping the initial refcount, you must call
> > percpu_ref_kill(); this puts the refcount in "shutting down mode" and
> > switches back to a single atomic refcount with the appropriate barriers
> > (synchronize_rcu()).
> > 
> > It's also legal to call percpu_ref_kill() multiple times - it only
> > returns true once, so callers don't have to reimplement shutdown
> > synchronization.
> > 
> > For the sake of simplicity/efficiency, the heuristic is pretty simple -
> > it just switches to percpu refcounting if there are more than x gets
> > in one second (completely arbitrarily, 4096).
> > 
> > It'd be more correct to count the number of cache misses or something
> > else more profile driven, but doing so would require accessing the
> > shared ref twice per get - by just counting the number of gets(), we can
> > stick that counter in the high bits of the refcount and increment both
> > with a single atomic64_add(). But I expect this'll be good enough in
> > practice.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> 
> What's the status of this series?  The percpu-refcnt part is still
> going through review and the merge window is opening up pretty soon.
> Kent, Andrew?

I don't think the percpu-refcount stuff should be blocking, the existing
code in Andrew's tree isn't ideal w.r.t. the api but it is stable and
tested.

I have patches on top of that that incorporate most of your ideas and
are definite improvements, I've just been holding off on them because I
want to come up with a good torture test (mainly because of the bias
mechanism for teardown).
