Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaGaDZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 23:25:43 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:5086 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756009AbaGaDZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 23:25:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4MAKK22VN5LHOdPGdsb2JhbABZgw6BKYInhQinewEBAQEBAQajGwGBChcFAQEBATg2BIN/AQEEATocFgoDBQcECAMOAwQBAQEJJQ8FJQMHDA4TiDoHvj8XGIVkiQdJBwaERAWXPoQlmC8rL4EE
Date: Thu, 31 Jul 2014 13:25:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: Abhijith Das <adas@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Subject: Re: [RFC] readdirplus implementations: xgetdents vs dirreadahead
 syscalls
Message-ID: <20140731032536.GP26465@dastard>
References: <1106785262.13440918.1406308542921.JavaMail.zimbra@redhat.com>
 <1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com>
 <20140725175257.GK17798@lenny.home.zabbo.net>
 <20140726003859.GF20518@dastard>
 <308078610.14129388.1406550142526.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <308078610.14129388.1406550142526.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 08:22:22AM -0400, Abhijith Das wrote:
> 
> 
> ----- Original Message -----
> > From: "Dave Chinner" <david@fromorbit.com>
> > To: "Zach Brown" <zab@redhat.com>
> > Cc: "Abhijith Das" <adas@redhat.com>, linux-kernel@vger.kernel.org, "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
> > "cluster-devel" <cluster-devel@redhat.com>
> > Sent: Friday, July 25, 2014 7:38:59 PM
> > Subject: Re: [RFC] readdirplus implementations: xgetdents vs dirreadahead syscalls
> > 
> > On Fri, Jul 25, 2014 at 10:52:57AM -0700, Zach Brown wrote:
> > > On Fri, Jul 25, 2014 at 01:37:19PM -0400, Abhijith Das wrote:
> > > > Hi all,
> > > > 
> > > > The topic of a readdirplus-like syscall had come up for discussion at
> > > > last year's
> > > > LSF/MM collab summit. I wrote a couple of syscalls with their GFS2
> > > > implementations
> > > > to get at a directory's entries as well as stat() info on the individual
> > > > inodes.
> > > > I'm presenting these patches and some early test results on a single-node
> > > > GFS2
> > > > filesystem.
> > > > 
> > > > 1. dirreadahead() - This patchset is very simple compared to the
> > > > xgetdents() system
> > > > call below and scales very well for large directories in GFS2.
> > > > dirreadahead() is
> > > > designed to be called prior to getdents+stat operations.
> > > 
> > > Hmm.  Have you tried plumbing these read-ahead calls in under the normal
> > > getdents() syscalls?
> > 
> > The issue is not directory block readahead (which some filesystems
> > like XFS already have), but issuing inode readahead during the
> > getdents() syscall.
> > 
> > It's the semi-random, interleaved inode IO that is being optimised
> > here (i.e. queued, ordered, issued, cached), not the directory
> > blocks themselves. As such, why does this need to be done in the
> > kernel?  This can all be done in userspace, and even hidden within
> > the readdir() or ftw/ntfw() implementations themselves so it's OS,
> > kernel and filesystem independent......
> > 
> 
> I don't see how the sorting of the inode reads in disk block order can be
> accomplished in userland without knowing the fs-specific topology.

I didn't say anything about doing "disk block ordering" in
userspace. disk block ordering can be done by the IO scheduler and
that's simple enough to do by multithreading and dispatch a few tens
of stat() calls at once....

> From my
> observations, I've seen that the performance gain is the most when we can
> order the reads such that seek times are minimized on rotational media.

Yup, which is done by ensuring that we drive deep IO queues rather
than issuing a single IO at a time and waiting for completion before
issuing the next one. This can easily be done from userspace.

> I have not tested my patches against SSDs, but my guess would be that the
> performance impact would be minimal, if any.

Depends. if the overhead of executing readahead is higher than the time spent
waiting for IO completion, then it will reduce performance. i.e. the
faster the underlying storage, the less CPU time we want to spend on
IO. Readahead generally increases CPU time per object that needs to
be retrieved from disk, and so on high IOP devices there's a really
good chance we don't want readahead like this at all.

i.e. this is yet another reason directory traversal readahead should
be driven from userspace so the policy can be easily controlled by
the application and/or user....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
