Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbaFCO50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:57:26 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33946 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbaFCO5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:57:25 -0400
Date: Tue, 3 Jun 2014 10:57:10 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@sr71.net>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] Volatile Ranges (v14 - madvise reborn edition!)
Message-ID: <20140603145710.GQ2878@cmpxchg.org>
References: <1398806483-19122-1-git-send-email-john.stultz@linaro.org>
 <536BBB08.3000503@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536BBB08.3000503@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 10:12:40AM -0700, John Stultz wrote:
> On 04/29/2014 02:21 PM, John Stultz wrote:
> > Another few weeks and another volatile ranges patchset...
> >
> > After getting the sense that the a major objection to the earlier
> > patches was the introduction of a new syscall (and its somewhat
> > strange dual length/purged-bit return values), I spent some time
> > trying to rework the vma manipulations so we can be we won't fail
> > mid-way through changing volatility (basically making it atomic).
> > I think I have it working, and thus, there is no longer the
> > need for a new syscall, and we can go back to using madvise()
> > to set and unset pages as volatile.
> 
> Johannes: To get some feedback, maybe I'll needle you directly here a
> bit. :)
> 
> Does moving this interface to madvise help reduce your objections?  I
> feel like your cleaning-the-dirty-bit idea didn't work out, but I was
> hoping that by reworking the vma manipulations to be atomic, we could
> move to madvise and still avoid the new syscall that you seemed bothered
> by. But I've not really heard much from you recently so I worry your
> concerns on this were actually elsewhere, and I'm just churning the
> patch needlessly.

My objection was not the syscall.

>From a reclaim perspective, using the dirty state to denote whether a
swap-backed page needs writeback before reclaim is quite natural and I
much prefer Minchan's changes to the reclaim code over yours.

>From an interface point of view, I would prefer the simplicity of
cleaning dirty bits to invalidate pages, and a default of zero-filling
invalidated pages instead of sending SIGBUS.  This also is quite
natural when you think of anon/shmem mappings as cache pages on top of
/dev/zero (see mmap_zero() and shmem_zero_setup()).  And it translates
well to tmpfs.

At the same time, I acknowledge that there are usecases that want
SIGBUS delivery for more than just convenience in order to implement
userspace fault handling, and this is the only place where I see a
real divergence in actual functionality from Minchan's code.

That, however, truly is a separate virtual memory feature.  Would it
be possible for you to take MADV_FREE and MADV_REVIVE as a base and
implement an madvise op that switches the no-page behavior of a VMA
from zero-filling to SIGBUS delivery?
