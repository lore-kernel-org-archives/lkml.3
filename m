Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab3GRDSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 23:18:06 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:52860 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756545Ab3GRDSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 23:18:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsPABhd51F5LK4r/2dsb2JhbABagwa8D4UvBAGBEhd0giMBAQQBOhwjBQsIAxIGCSUPBSUDDRQTG4dvBbZmFo5HgR0Hg3sDl1uRToMkKg
Date: Thu, 18 Jul 2013 13:17:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Myers <bpm@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, xfs@oss.sgi.com
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130718031759.GN11674@dastard>
References: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
 <20130716060351.GE11674@dastard>
 <20130716193332.GB3572@sgi.com>
 <CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
 <20130716204335.GH11674@dastard>
 <CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
 <20130717040616.GI11674@dastard>
 <CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
 <20130717055103.GK11674@dastard>
 <CA+55aFxdqzMY5VJoYaLmL=+=f2s1cbHHV-TjC3=taXpF-xov1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxdqzMY5VJoYaLmL=+=f2s1cbHHV-TjC3=taXpF-xov1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 09:03:11AM -0700, Linus Torvalds wrote:
> On Tue, Jul 16, 2013 at 10:51 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > But When i say "stale data" I mean that the data being returned
> > might not have originally belonged to the underlying file you are
> > reading.
> 
> We're still talking at cross purposes then.
> 
> How the hell do you handle mmap() and page faulting?

We cross our fingers and hope. Always have. Races are rare as
historically there have been only a handful of applications that do
the necessary operations to trigger them. However, with holepunch
now a generic fallocate() operation....

> Because if you return *that* kind of stale data, than you're horribly
> horribly buggy. And you cannot *possibly* blame
> generic_file_splice_read() on that.

Right, it's horribly buggy and I'm not blaming
generic_file_splice_read().

I'm saying that the page cache architecture does not providing
mechanisms to avoid the problem. i.e. that we can't synchronise
multi-page operations against a single page operation that only uses
the page lock for serialisation without some form of filesystem
specific locking. And that the i_mutex/i_iolock/mmap_sem inversion
problems essentially prevent us from beign able to fix it in a
filesystem specific manner.

We've hacked around this read vs invalidation race condition for
truncate() by putting ordered operations in place to avoid
refaulting after invalidation by read operations. i.e. truncate was
optimised to avoid extra locking, but now the realisation is that
truncate is just a degenerate case of hole punching and that hole
punching cannot make use of the same "beyond EOF" optimisations to
avoid race conditions with other IO.

We (XFS developers) have known about this for years, but we've
always been told when it's been raised that it's "just a wacky XFS
problem".  Now that other filesystems are actually implementing the
same functionality that XFS has had since day zero, they are also
seeing the same architectural deficiencies in the generic code. i.e.
they are not actually "whacky XFS problems".  That's why we were
talking about a range-locking solution to this problem at LSF/MM
this year - to find a generic solution to the issue...

FWIW, this problem is not just associated with splice reads - it's a
problem for the direct IO code, too. The direct IO layer has lots of
hacky invalidation code that tries to work around the fact that
mmap() page faults cannot be synchronised against direct IO in
progress. Hence it invalidates caches before and after direct IO is
done in the hope that we don't have a page fault that races and
leaves us with out-of-date data being exposed to userspace via mmap.
Indeed, we have a regression test that demonstrates how this often
fails - xfstests:generic/263 uses fsx with direct IO and mmap on the
same file and will fail with data corruption on XFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
