Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaBQITU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:19:20 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:13311 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956AbaBQITT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:19:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjQKAP3EAVN5LJYe/2dsb2JhbABZgwa6doVQgRkXdIIlAQEEATocIwULCAMYCSUPBSUDIROHfQfLQRcWjmsHhDgEmCuSJINBKA
Date: Mon, 17 Feb 2014 19:19:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, hch@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, zab@redhat.com, jack@suse.cz, luto@amacapital.net,
        mszeredi@suse.cz
Subject: Re: [PATCH 00/13] cross rename v4
Message-ID: <20140217081911.GZ13647@dastard>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <20140210105145.GW13997@dastard>
 <20140211160141.GD8204@tucsk.piliscsaba.szeredi.hu>
 <20140212171852.GA4026@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212171852.GA4026@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 06:18:52PM +0100, Miklos Szeredi wrote:
> On Tue, Feb 11, 2014 at 05:01:41PM +0100, Miklos Szeredi wrote:
> > On Mon, Feb 10, 2014 at 09:51:45PM +1100, Dave Chinner wrote:
> 
> > > Miklos, can you please write an xfstest for this new API? That way
> > > we can verify that the behaviour is as documented, and we can ensure
> > > that when we implement it on other filesystems it works exactly the
> > > same on all filesystems?
> 
> This is a standalone testprog, but I guess it's trivial to integrate into
> xfstests.

Same problem with integrating any standalone test program into
xfstests - we end up with a standalone pass/fail test instead of a
bunch of components we can reuse and refactor for other tests.  But
we can work around that for the moment.

[ FWIW, the normal way to write an xfstest like this is to write a
small helper program that just does the renameat2() syscall (we
often use xfs_io to provide this) and everything is just shell
scripts to drive the helper program in the necessary way. We don't
directly check that mode, size, destination of a file is correct -
just stat(1) on the expected destinations is sufficient to capture
this information. stdout is captured by the test harness and used to match
against a golden output. If the match fails, the test fails.

This would allow us to use the same test infrastructure for testing
a coreutils binary that implemented renameat2 when that comes
along... ]

> Please let me know what you think.

We need to be able to test whether the syscall exists so we
add a function like:

_requires_renameat2(
{
	[ -x src/renameat2_test ] || _notrun "renameat2_test not found."
	src/renameat2_test -t || _notrun "kernel does not support renameat2"
}

to gracefully avoid the test on kernels that don't support the
syscall. Indeed, the test needs to be able to be built on kernels
that don't have the right header files that define the syscall
number, either, so there's going to need to be some #ifndef
__NR_renameat2 type clauses in there as well...

And finally, it needs comments to explain what the test is actually
testing - if you don't document what the test is supposed to be
checking, how do we know that it is testing is actually correct?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
