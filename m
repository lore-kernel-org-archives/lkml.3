Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbaGaDQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 23:16:18 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:51549 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756062AbaGaDQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 23:16:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsMACW02VN5LHOdPGdsb2JhbABZgw6BKYInhQinegEBAQEBAQajGwGBChcFAQEBATg2BIQAAQU6HCMQCAMOCgklDwUlAwcaE4hBvjwXGIVkiVAHhEoFlz6EJZgvKy8
Date: Thu, 31 Jul 2014 13:16:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Zach Brown <zab@redhat.com>, Abhijith Das <adas@redhat.com>,
        linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Subject: Re: [RFC] readdirplus implementations: xgetdents vs dirreadahead
 syscalls
Message-ID: <20140731031601.GO26465@dastard>
References: <1106785262.13440918.1406308542921.JavaMail.zimbra@redhat.com>
 <1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com>
 <20140725175257.GK17798@lenny.home.zabbo.net>
 <20140726003859.GF20518@dastard>
 <4356C960-C548-42AC-876E-106A1DAA85EE@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4356C960-C548-42AC-876E-106A1DAA85EE@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 03:21:20PM -0600, Andreas Dilger wrote:
> On Jul 25, 2014, at 6:38 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Jul 25, 2014 at 10:52:57AM -0700, Zach Brown wrote:
> >> On Fri, Jul 25, 2014 at 01:37:19PM -0400, Abhijith Das wrote:
> >>> Hi all,
> >>> 
> >>> The topic of a readdirplus-like syscall had come up for discussion at last year's
> >>> LSF/MM collab summit. I wrote a couple of syscalls with their GFS2 implementations
> >>> to get at a directory's entries as well as stat() info on the individual inodes.
> >>> I'm presenting these patches and some early test results on a single-node GFS2
> >>> filesystem.
> >>> 
> >>> 1. dirreadahead() - This patchset is very simple compared to the xgetdents() system
> >>> call below and scales very well for large directories in GFS2. dirreadahead() is
> >>> designed to be called prior to getdents+stat operations.
> >> 
> >> Hmm.  Have you tried plumbing these read-ahead calls in under the normal
> >> getdents() syscalls?
> > 
> > The issue is not directory block readahead (which some filesystems
> > like XFS already have), but issuing inode readahead during the
> > getdents() syscall.
> > 
> > It's the semi-random, interleaved inode IO that is being optimised
> > here (i.e. queued, ordered, issued, cached), not the directory
> > blocks themselves.
> 
> Sure.
> 
> > As such, why does this need to be done in the
> > kernel?  This can all be done in userspace, and even hidden within
> > the readdir() or ftw/ntfw() implementations themselves so it's OS,
> > kernel and filesystem independent......
> 
> That assumes sorting by inode number maps to sorting by disk order.
> That isn't always true.

That's true, but it's a fair bet that roughly ascending inode number
ordering is going to be better than random ordering for most
filesystems.

Besides, ordering isn't the real problem - the real problem is the
latency caused by having to do the inode IO synchronously one stat()
at a time. Just multithread the damn thing in userspace so the
stat()s can be done asynchronously and hence be more optimally
ordered by the IO scheduler and completed before the application
blocks on the IO.

It doesn't even need completion synchronisation - the stat()
issued by the application will block until the async stat()
completes the process of bringing the inode into the kernel cache...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
