Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761404Ab3BNAHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 19:07:38 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:49317 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771Ab3BNAHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 19:07:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiEbAKgpHFF5LPNV/2dsb2JhbABFulqFEQECgQMXc4IfAQEEATocIwULCAMUAQMJJQ8FJQMhE4gMBQ2/WhWNGguBAA+DOwOWI4EeiDmGfYMagV4
Date: Thu, 14 Feb 2013 11:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>,
        CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com
Subject: Re: [ 68/89] xfs: fix _xfs_buf_find oops on blocks beyond the
 filesystem end
Message-ID: <20130214000730.GI26694@dastard>
References: <20130201130207.444989281@linuxfoundation.org>
 <20130201130212.381996681@linuxfoundation.org>
 <511BB198.1080609@redhat.com>
 <20130213161845.GA20916@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213161845.GA20916@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc xfs@oss.sgi.com]

On Wed, Feb 13, 2013 at 08:18:45AM -0800, Greg Kroah-Hartman wrote:
> On Wed, Feb 13, 2013 at 04:30:32PM +0100, Paolo Bonzini wrote:
> > Il 01/02/2013 14:08, Greg Kroah-Hartman ha scritto:
> > > 3.7-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > commit eb178619f930fa2ba2348de332a1ff1c66a31424 upstream.
> > > 
> > > When _xfs_buf_find is passed an out of range address, it will fail
> > > to find a relevant struct xfs_perag and oops with a null
> > > dereference. This can happen when trying to walk a filesystem with a
> > > metadata inode that has a partially corrupted extent map (i.e. the
> > > block number returned is corrupt, but is otherwise intact) and we
> > > try to read from the corrupted block address.
> > > 
> > > In this case, just fail the lookup. If it is readahead being issued,
> > > it will simply not be done, but if it is real read that fails we
> > > will get an error being reported.  Ideally this case should result
> > > in an EFSCORRUPTED error being reported, but we cannot return an
> > > error through xfs_buf_read() or xfs_buf_get() so this lookup failure
> > > may result in ENOMEM or EIO errors being reported instead.
> > 
> > It looks like this breaks xfs_growfs.  See
> > http://bugzilla.redhat.com/show_bug.cgi?id=909602.

Entirely possible, as the filesystem size is not updated until after
all the new metadata is written to disk. in 3.8, there's this commit:

commit fd23683c3b1ab905cba61ea2981c156f4bf52845
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Nov 12 22:53:59 2012 +1100

    xfs: growfs: use uncached buffers for new headers
    
    When writing the new AG headers to disk, we can't attach write
    verifiers because they have a dependency on the struct xfs-perag
    being attached to the buffer to be fully initialised and growfs
    can't fully initialise them until later in the process.
    
    The simplest way to avoid this problem is to use uncached buffers
    for writing the new headers. These buffers don't have the xfs-perag
    attached to them, so it's simple to detect in the write verifier and
    be able to skip the checks that need the xfs-perag.
    
    This enables us to attach the appropriate buffer ops to the buffer
    and henc calculate CRCs on the way to disk. IT also means that the
    buffer is torn down immediately, and so the first access to the AG
    headers will re-read the header from disk and perform full
    verification of the buffer. This way we also can catch corruptions
    due to problems that went undetected in growfs.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by Rich Johnston <rjohnston@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

As part of the metadata verifier feature. It means that growfs no
longer uses cached buffers, and hence does not pass through
_xfs_buf_find() and hence will not trigger the beyond-EOFS that the
above commit adds.

> Ick, not good.
> 
> Dave, any thoughts here?  Should I drop this from the 3.7-stable queue?

Yeah, drop it.

But what I'm now wondering is how this patch got proposed for
3.7-stable. I don't recall seeing anything about this being
proposed.

<trolls email archives>

Oh, it happened while I was at LCA and didn't have any access to Red
Hat email and there was a private thread about it. By the time I
read it the stable kernel was already released and so it immediately
dropped from my attention.

XFS Maintainers: Major process fail. Patches that are being proposed
for backports need to be posted to the XFS list, reviewed and tested
before saying they are OK to go.  We have several growfs tests in
xfstests would have failed if this was actually tested.

Stable folk: This is the reason why I, quite frankly, don't want to
support stable kernels *at all*. The overhead of backporting and
testing a patch to a single kernel target to ensure there are no
unintended regressions is significant, and there are so many stable
kernels no it's just a waste of developer time to try to support
them. And in this case, the process simply wasn't executed and an
unintended regression that is >this close< to causing filesystem
corruption slipped through to the stable series.....

Red Hat/Fedora folk: please report upstream XFS
bugs/regressions to xfs@oss.sgi.com or #xfs on freednode so we know
about them immediately and can triage problems quickly via email.
Sure, point us to the BZ you've raised, but tell us about the
problem ASAP. That way when users ask us about a problem, we are not
completely clueless...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
