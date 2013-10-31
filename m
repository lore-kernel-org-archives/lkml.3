Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3JaTfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 15:35:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab3JaTfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 15:35:36 -0400
Date: Thu, 31 Oct 2013 20:35:33 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3.5 29/64] fs: buffer: move allocation failure loop into
 the allocator
Message-ID: <20131031193533.GA10524@quack.suse.cz>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
 <1382971703-17393-30-git-send-email-luis.henriques@canonical.com>
 <20131031140008.GB14054@cmpxchg.org>
 <20131031144848.GA3275@quack.suse.cz>
 <20131031090353.a67265bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031090353.a67265bf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 31-10-13 09:03:53, Andrew Morton wrote:
> On Thu, 31 Oct 2013 15:48:48 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > On Thu 31-10-13 10:00:08, Johannes Weiner wrote:
> > > On Mon, Oct 28, 2013 at 02:47:48PM +0000, Luis Henriques wrote:
> > > > 3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Johannes Weiner <hannes@cmpxchg.org>
> > > > 
> > > > commit 84235de394d9775bfaa7fa9762a59d91fef0c1fc upstream.
> > > > 
> > > > Buffer allocation has a very crude indefinite loop around waking the
> > > > flusher threads and performing global NOFS direct reclaim because it can
> > > > not handle allocation failures.
> > > > 
> > > > The most immediate problem with this is that the allocation may fail due
> > > > to a memory cgroup limit, where flushers + direct reclaim might not make
> > > > any progress towards resolving the situation at all.  Because unlike the
> > > > global case, a memory cgroup may not have any cache at all, only
> > > > anonymous pages but no swap.  This situation will lead to a reclaim
> > > > livelock with insane IO from waking the flushers and thrashing unrelated
> > > > filesystem cache in a tight loop.
> > > > 
> > > > Use __GFP_NOFAIL allocations for buffers for now.  This makes sure that
> > > > any looping happens in the page allocator, which knows how to
> > > > orchestrate kswapd, direct reclaim, and the flushers sensibly.  It also
> > > > allows memory cgroups to detect allocations that can't handle failure
> > > > and will allow them to ultimately bypass the limit if reclaim can not
> > > > make progress.
> >   So I was under the impression that __GFP_NOFAIL is going away, doesn't
> > it? At least about an year ago there was some effort to remove its users so
> > we ended up creating loops like the above one (and similar ones for
> > jbd/jbd2) in cases where handling the failure wasn't easily possible. And now
> > it seems we are going in the opposite direction... At least we have a
> > steady flow of patches guaranteed :)
> 
> Argh.  The whole point behind __GFP_NOFAIL was to centralise the
> open-coded infinite-retry loops into the MM core.  So they can be
> easily located and fixed up.
> 
> Yes, __GFP_NOFAIL *should* go away, once all those infinite-retry loops
> are fixed to handle allocation failures.  But it sounds like this
> "effort" was just undoing
> 
> : commit f3615244f15c8bee5783fcf032717ffdfd56e219
> : Author:     akpm <akpm>
> : AuthorDate: Sun Apr 20 21:28:12 2003 +0000
> : Commit:     akpm <akpm>
> : CommitDate: Sun Apr 20 21:28:12 2003 +0000
> : 
> :     [PATCH] implement __GFP_REPEAT, __GFP_NOFAIL, __GFP_NORETRY
> 
> and thereby hiding the bad code from grep again :(
  So I also looked into history trying to find out why we opencoded the
allocation loops. It seems originally the patch set described and
referenced in http://lwn.net/Articles/401915/ from David Rientjes in 2010
triggered the discussion. You actually opposed to that series so I didn't
merge the jbd patch. But jbd2 change got merged by Ted. Then an year later
I've noticed jbd2 is avoiding __GFP_NOFAIL and forgot you were opposing
that change and copied the change over to jbd. So I'll back out the jbd
change. I'll also look into removing the retry loop from jbd2 (there the
change actually made some sense because in some cases we can deal with
allocation failure).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
