Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbaDBSHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:07:21 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58126 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514AbaDBSHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:07:17 -0400
Date: Wed, 2 Apr 2014 14:07:07 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Dave Hansen <dave@sr71.net>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Volatile Ranges (v12) & LSF-MM discussion fodder
Message-ID: <20140402180707.GT14688@cmpxchg.org>
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org>
 <20140401212102.GM4407@cmpxchg.org>
 <533B8C2D.9010108@linaro.org>
 <20140402163013.GP14688@cmpxchg.org>
 <533C3BB4.8020904@zytor.com>
 <533C3CDD.9090400@zytor.com>
 <20140402171812.GR14688@cmpxchg.org>
 <533C4B7E.6030807@sr71.net>
 <CALAqxLUR4ucQ_zOp5i3Y0+WpCWiwm2oR6Dp7aeD2XN1pjiELEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLUR4ucQ_zOp5i3Y0+WpCWiwm2oR6Dp7aeD2XN1pjiELEQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 10:48:03AM -0700, John Stultz wrote:
> On Wed, Apr 2, 2014 at 10:40 AM, Dave Hansen <dave@sr71.net> wrote:
> > On 04/02/2014 10:18 AM, Johannes Weiner wrote:
> >> Hence my follow-up question in the other mail about how large we
> >> expect such code caches to become in practice in relationship to
> >> overall system memory.  Are code caches interesting reclaim candidates
> >> to begin with?  Are they big enough to make the machine thrash/swap
> >> otherwise?
> >
> > A big chunk of the use cases here are for swapless systems anyway, so
> > this is the *only* way for them to reclaim anonymous memory.  Their
> > choices are either to be constantly throwing away and rebuilding these
> > objects, or to leave them in memory effectively pinned.
> >
> > In practice I did see ashmem (the Android thing that we're trying to
> > replace) get used a lot by the Android web browser when I was playing
> > with it.  John said that it got used for storing decompressed copies of
> > images.
> 
> Although images are a simpler case where its easier to not touch
> volatile pages. I think Johannes is mostly concerned about cases where
> volatile pages are being accessed while they are volatile, which the
> Mozilla folks are so far the only viable case (in my mind... folks may
> have others) where they intentionally want to access pages while
> they're volatile and thus require SIGBUS semantics.

Yes, absolutely, that is my only concern.  Compressed images as in
Android can easily be marked non-volatile before they are accessed
again.

Code caches are harder because control is handed off to the CPU, but
I'm not entirely sure yet whether these are in fact interesting
reclaim candidates.

> I suspect handling the SIGBUS and patching up the purged page you
> trapped on is likely much to complicated for most use cases. But I do
> think SIGBUS is preferable to zero-fill on purged page access, just
> because its likely to be easier to debug applications.

Fully agreed, but it seems a bit overkill to add a separate syscall, a
range-tree on top of shmem address_spaces, and an essentially new
programming model based on SIGBUS userspace fault handling (incl. all
the complexities and confusion this inevitably will bring when people
DO end up passing these pointers into kernel space) just to be a bit
nicer about use-after-free bugs in applications.
