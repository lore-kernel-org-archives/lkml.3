Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab3AXVUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:20:20 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46001 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3AXVSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:18:54 -0500
Date: Thu, 24 Jan 2013 13:18:50 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Valdis.Kletnieks@vt.edu
Cc: Hillf Danton <dhillf@gmail.com>, Benjamin LaHaise <bcrl@kvack.org>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org, zab@zabbo.net,
        akpm@linux-foundation.org
Subject: Re: next-20130117 - kernel BUG with aio
Message-ID: <20130124211850.GH26407@google.com>
References: <3544.1358774694@turing-police.cc.vt.edu>
 <CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com>
 <2553.1358890098@turing-police.cc.vt.edu>
 <CAJd=RBCHRDzyjY_hOZCj6rHBXzb3f5wWxdqXYuLbQXLe2n4JeA@mail.gmail.com>
 <13450.1359048141@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13450.1359048141@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 12:22:21PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 23 Jan 2013 20:10:03 +0800, Hillf Danton said:
> 
> > Try again?
> > ---
> >
> > --- a/fs/aio.c	Tue Jan 22 21:37:54 2013
> > +++ b/fs/aio.c	Wed Jan 23 20:06:14 2013
> 
> Now seeing this:
> 
> [ 2941.495370] ------------[ cut here ]------------
> [ 2941.495379] WARNING: at fs/aio.c:336 put_ioctx+0x1cb/0x252()
> 
> Same warn location, but different traceback?

Finally reproduced it (thanks to Zach Brown for the idea - using a
loopback device) - it's triggered when there's outstanding kiocbs when
we're trying to tear down the kioctx.

Found a couple bugs once I was able to reproduce it. Besides the null
pointer deref that Hillf posted a patch for, cancellation was fubar -
kiocb_cancel() shouldn't be marking the kiocb as cancelled if it didn't
have a cancel callback.

The other two bugs I found were both a result of the fact that
aio_run_iocb() touches the kiocb after passing it off to a method that
may call aio_complete() on it - which is something I originally missed.

Digression: When I was refactoring, I was hoping to be able to change
the kiocb refcounting so that the refcount's just initialized to one,
and the initial refcount is dropped when aio_complete() is called - and
since nothing outside of the aio code messes with the kiocb refcount, it
might be possible to get rid of the kiocb refcount entirely if I can
figure out how to deal with cancellation.

Anyways - that didn't work out, or at least it's going to take more
work. The two bugs that resulted from that were:

 - The "aio: kill ki_retry" patch dropped the second kiocb ref that
   io_submit_one drops when it returns. But aio_rw_vect_retry() touches
   the kiocb after passing it off to f_op->aio_(read|write) which will
   call aio_complete(), so this is a use after free.

 - The "aio: smoosh struct kiocb" patch assumed that some of the fields
   in struct kiocb aren't needed after aio_complete() has been called.
   This is _almost_ true, but again aio_rw_vect_retry() looks at those
   fields which ends up determining whether aio_run_iocb() calls
   aio_complete() itself.

   This seems _ridiculously_ sketchy to me, or at least convoluted...
   but it'll take awhile to figure out how to clean that up and I'm not
   in a great hurry to do so.


So, Andrew - that "smoosh struct kiocb" patch should just be dropped,
even if I fixed that issue clearly the idea is a lot less safe than I
thought. I've got patches for the other stuff I'm going to mail out
momentarily.

Ben, Zach - the cancellation stuff (both the fix and the
other changes) need more review, and we need a saner way of testing
cancellation. Maybe it'd be worth implementing cancellation for regular
block devices just so that we have a way of testing it :/
