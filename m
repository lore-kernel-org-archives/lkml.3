Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3JaQGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:06:21 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33847 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab3JaQGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:06:20 -0400
Date: Thu, 31 Oct 2013 12:03:37 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jan Kara <jack@suse.cz>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3.5 29/64] fs: buffer: move allocation failure loop into
 the allocator
Message-ID: <20131031160337.GF14054@cmpxchg.org>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
 <1382971703-17393-30-git-send-email-luis.henriques@canonical.com>
 <20131031140008.GB14054@cmpxchg.org>
 <20131031144848.GA3275@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031144848.GA3275@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 03:48:48PM +0100, Jan Kara wrote:
> On Thu 31-10-13 10:00:08, Johannes Weiner wrote:
> > On Mon, Oct 28, 2013 at 02:47:48PM +0000, Luis Henriques wrote:
> > > 3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Johannes Weiner <hannes@cmpxchg.org>
> > > 
> > > commit 84235de394d9775bfaa7fa9762a59d91fef0c1fc upstream.
> > > 
> > > Buffer allocation has a very crude indefinite loop around waking the
> > > flusher threads and performing global NOFS direct reclaim because it can
> > > not handle allocation failures.
> > > 
> > > The most immediate problem with this is that the allocation may fail due
> > > to a memory cgroup limit, where flushers + direct reclaim might not make
> > > any progress towards resolving the situation at all.  Because unlike the
> > > global case, a memory cgroup may not have any cache at all, only
> > > anonymous pages but no swap.  This situation will lead to a reclaim
> > > livelock with insane IO from waking the flushers and thrashing unrelated
> > > filesystem cache in a tight loop.
> > > 
> > > Use __GFP_NOFAIL allocations for buffers for now.  This makes sure that
> > > any looping happens in the page allocator, which knows how to
> > > orchestrate kswapd, direct reclaim, and the flushers sensibly.  It also
> > > allows memory cgroups to detect allocations that can't handle failure
> > > and will allow them to ultimately bypass the limit if reclaim can not
> > > make progress.
>   So I was under the impression that __GFP_NOFAIL is going away, doesn't
> it? At least about an year ago there was some effort to remove its users so
> we ended up creating loops like the above one (and similar ones for
> jbd/jbd2) in cases where handling the failure wasn't easily possible. And now
> it seems we are going in the opposite direction... At least we have a
> steady flow of patches guaranteed :)

Lol.

I would assume that people had a problem with allocations that can not
fail, rather than __GFP_NOFAIL.  As long as we do have callsites that
can't deal with failure, I'd much prefer __GFP_NOFAIL over open-coded
looping.  The page allocator is much better equipped to make forward
progress and the problematic sites are immediately apparent/greppable.

In order of preference, this is how allocation sites should deal with
errors:

1. Gracefully abort current operation and move on
2. Stab eyes with fork
3. Use __GFP_NOFAIL

... but never loop around the allocation, please.
