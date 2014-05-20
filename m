Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbaETGDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:03:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaETGDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 02:03:32 -0400
Date: Mon, 19 May 2014 23:03:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] mm/vmscan: Do not block forever at
 shrink_inactive_list().
Message-Id: <20140519230311.583f762c.akpm@linux-foundation.org>
In-Reply-To: <20140519225915.3370328d.akpm@linux-foundation.org>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
	<20140520004449.GE18954@dastard>
	<20140519225915.3370328d.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 22:59:15 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 20 May 2014 10:44:49 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > @@ -258,14 +258,23 @@ xfs_bmapi_allocate_worker(
> >  	struct xfs_bmalloca	*args = container_of(work,
> >  						struct xfs_bmalloca, work);
> >  	unsigned long		pflags;
> > +	unsigned long		new_pflags = PF_FSTRANS;
> >  
> > -	/* we are in a transaction context here */
> > -	current_set_flags_nested(&pflags, PF_FSTRANS);
> > +	/*
> > +	 * we are in a transaction context here, but may also be doing work
> > +	 * in kswapd context, and hence we may need to inherit that state
> > +	 * temporarily to ensure that we don't block waiting for memory reclaim
> > +	 * in any way.
> > +	 */
> > +	if (args->kswapd)
> > +		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
> 
> So current_is_kswapd() returns true for a thread which is not kswapd. 
> That's a bit smelly.
> 
> Should this thread really be incrementing KSWAPD_INODESTEAL instead of
> PGINODESTEAL, for example?  current_is_kswapd() does a range of things,
> only one(?) of which you actually want.
> 
> It would be cleaner to create a new PF_ flag to select just that
> behavior.  That's a better model than telling the world "I am magic and
> special".

Or a new __GFP_FLAG.

> But we're awfully close to running out of PF_ space and I don't know if
> this ugly justifies consuming a flag.
> 
